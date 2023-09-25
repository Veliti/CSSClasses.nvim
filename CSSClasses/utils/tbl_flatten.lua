local function tbl_flatten(tbl)
	local result = {}
	local function _fltn(t)
		for i = 1, #t do
			if type(t[i]) == "table" then
				_fltn(t[i])
			else
				table.insert(result, t[i])
			end
		end
	end
	_fltn(tbl)
	return result
end

return tbl_flatten
