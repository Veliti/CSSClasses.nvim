local io = require("CSSClasses.io")
local cssP = require("CSSClasses.parsers.css")

local path = "/home/veliti/Documents/Projects/CSSClasses.nvim/lua/CSSClasses/test/test.css"

local rulesets = cssP.parse(io.read_file(path))

local string = string.format("size: %d \n %s", #rulesets, vim.inspect(rulesets))

os.execute("echo '" .. string .. "' > ./lua/CSSClasses/test/log")
