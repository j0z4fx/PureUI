local Tab = require("../containers/Tab")

local Window = {}
Window.__index = Window

function Window.new()
	return setmetatable({}, Window)
end

function Window:CreateTab(_config)
	return Tab.new()
end

return Window
