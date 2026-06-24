local Button = require("../controls/Button")

local Tab = {}
Tab.__index = Tab

function Tab.new()
	return setmetatable({}, Tab)
end

function Tab:CreateButton(_config)
	return Button.new()
end

return Tab
