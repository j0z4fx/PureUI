local unsupported = require("../utilities/unsupported")

local Button = {}
Button.__index = Button

function Button.new()
	unsupported("Button")
end

return Button
