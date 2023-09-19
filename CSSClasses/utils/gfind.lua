---return an iter for matches based on string.find
---@param source string
---@param pattern string
---@param plain boolean | nil
---@return function
local gfind = function(source, pattern, plain)
	local needle
	return function()
		local result = { source:find(pattern, needle, plain) }
		needle = result[2]
		return table.unpack(result)
	end
end

return gfind
