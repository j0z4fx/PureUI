local Tab = require("../containers/Tab")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

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

	local connections = {}
	local dragging = false
	local dragInput
	local dragStart
	local startPosition
	local targetPosition = panel.Position

	table.insert(connections, titleBar.InputBegan:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1
			and input.UserInputType ~= Enum.UserInputType.Touch
		then
			return
		end

		dragging = true
		dragStart = input.Position
		startPosition = panel.Position
		targetPosition = panel.Position

		table.insert(connections, input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end))
	end))

	table.insert(connections, titleBar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch
		then
			dragInput = input
		end
	end))

	table.insert(connections, UserInputService.InputChanged:Connect(function(input)
		if not dragging or input ~= dragInput then
			return
		end

		local delta = input.Position - dragStart
		targetPosition = UDim2.new(
			startPosition.X.Scale,
			startPosition.X.Offset + delta.X,
			startPosition.Y.Scale,
			startPosition.Y.Offset + delta.Y
		)
	end))

	table.insert(connections, RunService.RenderStepped:Connect(function(deltaTime)
		panel.Position = panel.Position:Lerp(targetPosition, 1 - math.exp(-8 * deltaTime))
	end))

	screenGui.Parent = getParent()

	return setmetatable({
		ScreenGui = screenGui,
		Panel = panel,
		TitleBar = titleBar,
		Title = title,
		Connections = connections,
	}, Window)
end

function Window:CreateTab(_config)
	return Tab.new()
end

function Window:Destroy()
	for _, connection in ipairs(self.Connections) do
		connection:Disconnect()
	end
	table.clear(self.Connections)

	if self.ScreenGui then
		self.ScreenGui:Destroy()
		self.ScreenGui = nil
		self.Panel = nil
		self.TitleBar = nil
		self.Title = nil
	end
end

return Window
