local rpc = require("CSSClasses.lsp.jrpc")

local rcp_test = function()
	local msg = {
		method = "test/testing",
		params = {
			hello = "world",
			number = 3,
		},
	}
	local encoded = rpc.encode(msg)
	local decoded = rpc.decode(encoded)

	assert(decoded.method == msg.method)
	assert(decoded.params.hello == msg.params.hello)
	assert(decoded.params.number == msg.params.number)
end

rcp_test()
