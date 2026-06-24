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

	local titleBar = Instance.new("Frame")
	titleBar.Name = "TitleBar"
	titleBar.Size = UDim2.new(1, 0, 0, 30)
	titleBar.BackgroundColor3 = Color3.fromRGB(27, 30, 36)
	titleBar.BorderSizePixel = 0
	titleBar.Parent = panel

	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.fromScale(1, 1)
	title.BackgroundTransparency = 1
	title.Font = Enum.Font.GothamMedium
	title.Text = "Pure"
	title.TextColor3 = Color3.fromRGB(235, 237, 240)
	title.TextSize = 14
	title.Parent = titleBar

	screenGui.Parent = getParent()

	return setmetatable({
		ScreenGui = screenGui,
		Panel = panel,
		TitleBar = titleBar,
		Title = title,
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
		self.TitleBar = nil
		self.Title = nil
	end
end

return Window
