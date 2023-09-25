local tap = require("tap")
local rpc = require("CSSClasses.utils.jrpc")

tap(function(test)
	test("jrpc can encode and decode messages", function(rpc)
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
	end)
end)

return tap
