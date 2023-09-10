---@type uv
local uv = require("uv")
local scan = require("plenary.scandir")

local M = {}
-- TODO: handle links and stuff

---@param starting_position string some path primarily buffer location
---@param patterns string[] | string what file dir or dir to consider a root
---@return string | nil root
M.get_root = function(starting_position, patterns)
	patterns = vim.tbl_flatten({ patterns })
	local root = vim.fs.find(function(name, path)
		for _, pattern in ipairs(patterns) do
			local file = path .. name
			return file:match(pattern)
		end
	end, { path = starting_position, limit = 1, upward = true, stop = uv.os_homedir() })
	return vim.fs.normalize(root[1])
end

---@param filename string
---@return string
M.read_file = function(filename)
	local fd = assert(io.open(filename, "r"))
	local source = fd:read("*a")
	fd:close()
	return source
end

---@type uv_fs_poll_t[]
M._fs_handles = {}

local SCAN_INTERVAL = 3000
---@alias fs_callback fun(type : fs_event, file : string)

---@alias fs_event
---| '"NEW"'
---| '"CHANGED"'
---| '"REMOVED"'

---@enum fstate
local fstate = {
	RECENT = 0,
	OLD = 1,
}

---@type table<string, fstate?>
local files = {}

---@param path string
---@param callback fs_callback
M.watch_folder = function(path, callback)
	local stat = assert(uv.fs_lstat(path))
	if stat.type ~= "directory" then
		error("trying to watch not a directory")
	end
	-- for first iteration
	local prev_stat = { mtime = { sec = 0 } }

	local timer = assert(uv.new_timer())
	timer:start(0, SCAN_INTERVAL, function()
		local curr_stat = assert(uv.fs_lstat(path))

		if prev_stat.mtime.sec < curr_stat.mtime.sec then
			scan.scan_dir(path, {
				hidden = false,
				respect_gitignore = true,
				depth = math.huge,
				on_insert = function(entry)
					if not files[entry] then
						callback("NEW", entry)
					else
						local file_stat = assert(uv.fs_lstat(entry))
						if file_stat.mtime.sec > prev_stat.mtime.sec then
							callback("CHANGED", entry)
						end
					end
					files[entry] = fstate.RECENT
				end,
			})
			for file, state in pairs(files) do
				if state == fstate.OLD then
					callback("REMOVED", file)
					files[file] = nil
				else
					files[file] = fstate.OLD
				end
			end
		end
		prev_stat = curr_stat
	end)
end

M.encode = function (name, )
  
end

return M
