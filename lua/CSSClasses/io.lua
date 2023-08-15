local uv = vim.loop
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
	return root[1]
end

---@param root string
---@param callback fs_callback
M.get_files = function(root, callback)
	scan.scan_dir_async(root, {
		add_dirs = false,
		respect_gitignore = true,
		depth = math.huge,
		on_insert = function(path)
			callback("CREATED", path)
		end,
	})
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

local FILE_POLL_INTERVAL = 2000
local DIR_POLL_INTERVAL = 8000
---@alias fs_callback fun(type : fs_event, file : string, ... : any)
---@alias poll_callback fun(err?: string, prev: uv.aliases.fs_stat_table, curr: uv.aliases.fs_stat_table)

---@alias fs_event
---| '"CREATED"' '...' is nil BUG: HAVE BUGS
---| '"CHANGED"' '...' is nil
---| '"RENAMDED"' '...' is new name TODO: NOT IMPLEMENTED
---| '"REMOVED"' '...' is nil
---| '"DEBUG"' '...' is a lot of strings

---@param func fs_callback
---@param uv_fs_poll_t uv_fs_poll_t
---@return poll_callback
local wrap_file_poll_callback = function(func, uv_fs_poll_t)
	return function(err, prev, curr)
		local filename = assert(uv_fs_poll_t:getpath())
		if err then
			-- TODO: support RENAMDED
			if err == "ENOENT" then
				func("REMOVED", filename)
			end
		end

		if curr.mtime.sec > prev.mtime.sec then
			func("CHANGED", filename)
		end
	end
end

---@param func fs_callback
---@param uv_fs_poll_t uv_fs_poll_t
---@return poll_callback
local wrap_dir_poll_callback = function(func, uv_fs_poll_t)
	return function(err, prev, curr)
		local filename = assert(uv_fs_poll_t:getpath())
		if err then
			-- TODO: support RENAMDED
			if err == "ENOENT" then
				func("REMOVED", filename)
			end
		end
		if curr.mtime.sec > prev.mtime.sec then
			--- TODO: search for new files
			scan.scan_dir_async(filename, {
				add_dirs = false,
				respect_gitignore = true,
				depth = math.huge,
				on_insert = function(path)
					local lstat = assert(uv.fs_lstat(path))
					if lstat.birthtime.sec >= prev.mtime.sec then
						-- BUG: could return already watched files because of moving tmp files by vim
						func("CREATED", path)
					end
				end,
			})
		end
	end
end

---'...' refer to fs_event
---@param path string
---@param callback fs_callback
M.poll_fs = function(path, callback)
	local lstat = assert(uv.fs_lstat(path))
	if lstat.type == "file" then
		local uv_fs_poll_t = assert(uv.new_fs_poll())
		uv_fs_poll_t:start(path, FILE_POLL_INTERVAL, wrap_file_poll_callback(callback, uv_fs_poll_t))

		if M._fs_handles[path] then
			M._fs_handles[path]:close()
		end
		M._fs_handles[path] = uv_fs_poll_t
	elseif lstat.type == "directory" then
		local uv_fs_poll_t = assert(uv.new_fs_poll())
		uv_fs_poll_t:start(path, DIR_POLL_INTERVAL, wrap_dir_poll_callback(callback, uv_fs_poll_t))

		if M._fs_handles[path] then
			M._fs_handles[path]:close()
		end
		M._fs_handles[path] = uv_fs_poll_t
	else
		error("[stat] unsupported file type at " .. path)
	end
end

return M
