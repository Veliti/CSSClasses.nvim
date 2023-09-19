local rcp = require("CSSClasses.lsp.jrcp")

rcp_test = function()
	local method = "test/testing"
	local params = {
		hello = "world",
		number = 3,
	}
	local encoded = rcp.notify(method, params)
	local decoded = rcp.decode(encoded)

	assert(decoded.method == method)
	assert(decoded.params.hello == params.hello)
	assert(decoded.params.number == params.number)
end

rcp_test()
print("rcp_test: ✅")
