local Tab = require("../containers/Tab")

local Window = {}
Window.__index = Window

local function getParent()
	if type(gethui) == "function" then
		return gethui()
	end

	return game:GetService("CoreGui")
end

function Window.new()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "PureUI"
	screenGui.IgnoreGuiInset = true
	screenGui.ResetOnSpawn = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	local panel = Instance.new("Frame")
	panel.Name = "Background"
	panel.AnchorPoint = Vector2.new(0.5, 0.5)
	panel.Position = UDim2.fromScale(0.5, 0.5)
	panel.Size = UDim2.fromOffset(800, 450)
	panel.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
	panel.BorderSizePixel = 0
	panel.Parent = screenGui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = panel

	screenGui.Parent = getParent()

	return setmetatable({
		ScreenGui = screenGui,
		Panel = panel,
	}, Window)
end

function Window:CreateTab(_config)
	return Tab.new()
end

function Window:Destroy()
	if self.ScreenGui then
		self.ScreenGui:Destroy()
		self.ScreenGui = nil
		self.Panel = nil
	end
end

return Window
