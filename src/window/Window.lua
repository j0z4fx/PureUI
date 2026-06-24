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

	local tabBar = Instance.new("Frame")
	tabBar.Name = "TabBar"
	tabBar.Position = UDim2.fromOffset(0, 30)
	tabBar.Size = UDim2.new(1, 0, 0, 30)
	tabBar.BackgroundColor3 = Color3.fromRGB(24, 26, 32)
	tabBar.BorderSizePixel = 0
	tabBar.Parent = panel

	local tabLayout = Instance.new("UIGridLayout")
	tabLayout.CellPadding = UDim2.fromOffset(0, 0)
	tabLayout.CellSize = UDim2.new(1, 0, 1, 0)
	tabLayout.FillDirectionMaxCells = 1
	tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
	tabLayout.Parent = tabBar

	local bottomDragHandle = Instance.new("Frame")
	bottomDragHandle.Name = "BottomDragHandle"
	bottomDragHandle.AnchorPoint = Vector2.new(0.5, 0)
	bottomDragHandle.Position = UDim2.new(0.5, 0, 1, 4)
	bottomDragHandle.Size = UDim2.fromOffset(160, 4)
	bottomDragHandle.BackgroundColor3 = Color3.fromRGB(120, 124, 136)
	bottomDragHandle.BackgroundTransparency = 0.35
	bottomDragHandle.BorderSizePixel = 0
	bottomDragHandle.Active = true
	bottomDragHandle.Parent = panel

	local resizeHandle = Instance.new("Frame")
	resizeHandle.Name = "ResizeHandle"
	resizeHandle.AnchorPoint = Vector2.new(0.5, 0.5)
	resizeHandle.Position = UDim2.fromScale(1, 1)
	resizeHandle.Size = UDim2.fromOffset(14, 14)
	resizeHandle.BackgroundColor3 = Color3.fromRGB(120, 124, 136)
	resizeHandle.BackgroundTransparency = 0.35
	resizeHandle.BorderSizePixel = 0
	resizeHandle.Active = true
	resizeHandle.ZIndex = 20
	resizeHandle.Parent = panel

	local connections = {}
	local dragging = false
	local dragStart
	local startPosition
	local targetPosition = panel.Position
	local resizing = false
	local resizeStart
	local startSize

	local function clampToScreen(position)
		local viewport = screenGui.AbsoluteSize
		local size = panel.AbsoluteSize
		local halfWidth = size.X * panel.AnchorPoint.X
		local halfHeight = size.Y * panel.AnchorPoint.Y
		local x = position.X.Offset + viewport.X * position.X.Scale
		local y = position.Y.Offset + viewport.Y * position.Y.Scale

		return UDim2.fromOffset(
			if size.X > viewport.X then viewport.X / 2 else math.clamp(x, halfWidth, viewport.X - (size.X - halfWidth)),
			if size.Y > viewport.Y then viewport.Y / 2 else math.clamp(y, halfHeight, viewport.Y - (size.Y - halfHeight))
		)
	end

	local function beginDrag(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1
			and input.UserInputType ~= Enum.UserInputType.Touch
		then
			return
		end

		dragging = true
		dragStart = input.Position
		startPosition = panel.Position
		targetPosition = panel.Position
	end

	table.insert(connections, titleBar.InputBegan:Connect(beginDrag))
	table.insert(connections, bottomDragHandle.InputBegan:Connect(beginDrag))
	table.insert(connections, resizeHandle.InputBegan:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1
			and input.UserInputType ~= Enum.UserInputType.Touch
		then
			return
		end

		resizing = true
		resizeStart = input.Position
		startSize = panel.Size
	end))

	table.insert(connections, UserInputService.InputEnded:Connect(function(input)
		if dragging
			and (input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch)
		then
			dragging = false
			targetPosition = panel.Position
		end
		if resizing
			and (input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch)
		then
			resizing = false
		end
	end))

	table.insert(connections, UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseMovement
			and input.UserInputType ~= Enum.UserInputType.Touch
		then
			return
		end

		if dragging then
			local delta = input.Position - dragStart
			targetPosition = clampToScreen(UDim2.new(
				startPosition.X.Scale,
				startPosition.X.Offset + delta.X,
				startPosition.Y.Scale,
				startPosition.Y.Offset + delta.Y
			))
		end

		if resizing then
			local delta = input.Position - resizeStart
			local viewport = screenGui.AbsoluteSize
			local maxWidth = math.max(560, math.min(850, viewport.X))
			local maxHeight = math.max(350, math.min(560, viewport.Y))
			panel.Size = UDim2.fromOffset(
				math.clamp(startSize.X.Offset + delta.X * 2, 560, maxWidth),
				math.clamp(startSize.Y.Offset + delta.Y * 2, 350, maxHeight)
			)
			targetPosition = clampToScreen(panel.Position)
		end
	end))

	table.insert(connections, RunService.RenderStepped:Connect(function(deltaTime)
		if not dragging then
			return
		end

		targetPosition = clampToScreen(targetPosition)
		local x = targetPosition.X.Offset - panel.Position.X.Offset
		local y = targetPosition.Y.Offset - panel.Position.Y.Offset
		if x * x + y * y < 0.25 then
			panel.Position = targetPosition
			return
		end

		panel.Position = panel.Position:Lerp(targetPosition, 1 - math.exp(-6 * deltaTime))
	end))

	screenGui.Parent = getParent()

	local window = setmetatable({
		ScreenGui = screenGui,
		Panel = panel,
		TitleBar = titleBar,
		Title = title,
		TabBar = tabBar,
		BottomDragHandle = bottomDragHandle,
		ResizeHandle = resizeHandle,
		Tabs = {},
		Connections = connections,
	}, Window)

	Tab.new(window, { Name = "Demo 1" })
	Tab.new(window, { Name = "Demo 2" })
	window:UpdateTabLayout()

	local controls = window.Tabs[1]:CreateGroupbox({ Name = "Controls", Column = "Left", Height = 70 })
	controls:CreateToggle({ Name = "Demo Toggle" })
	controls:CreateKeypicker({ Toggle = "Demo Toggle", Default = "K" })

	return window
end

function Window:CreateTab(config)
	local tab = Tab.new(self, config)
	self:UpdateTabLayout()
	return tab
end

function Window:UpdateTabLayout()
	local count = #self.Tabs
	self.TabBar.UIGridLayout.FillDirectionMaxCells = count
	self.TabBar.UIGridLayout.CellSize = UDim2.new(1 / count, 0, 1, 0)
end

function Window:SelectTab(selected)
	for _, tab in ipairs(self.Tabs) do
		tab:SetActive(tab == selected)
	end
	self.SelectedTab = selected
end

function Window:Destroy()
	for _, connection in ipairs(self.Connections) do
		connection:Disconnect()
	end
	table.clear(self.Connections)

	for _, tab in ipairs(self.Tabs) do
		tab:Destroy()
	end
	table.clear(self.Tabs)

	if self.ScreenGui then
		self.ScreenGui:Destroy()
		self.ScreenGui = nil
		self.Panel = nil
		self.TitleBar = nil
		self.Title = nil
		self.TabBar = nil
		self.BottomDragHandle = nil
		self.ResizeHandle = nil
		self.SelectedTab = nil
	end
end

return Window
