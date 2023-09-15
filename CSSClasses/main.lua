---@type uv
local uv = require("uv")
local tcp = require("")
tcp.start(1111)

tcp.listen(function() end)

uv.run()
uv.walk(uv.close)
uv.run()
return 0
