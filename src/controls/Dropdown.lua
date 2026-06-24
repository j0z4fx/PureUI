local TweenService = game:GetService("TweenService")
local Lucide = require("../icons/Lucide")

local Dropdown = {}
Dropdown.__index = Dropdown
local TWEEN = TweenInfo.new(0.14, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local ROW_HEIGHT = 26
local MAX_VISIBLE = 5

function Dropdown.new(parent, config)
	config = config or {}

	local root = Instance.new("Frame")
	root.Name = config.Name or "Dropdown"
	root.Size = UDim2.new(1, 0, 0, 38)
	root.BackgroundTransparency = 1
	root.ClipsDescendants = true
	root.Parent = parent

	local label = Instance.new("TextLabel")
	label.Position = UDim2.fromOffset(8, 0)
	label.Size = UDim2.new(0.4, -8, 0, 38)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.Gotham
	label.Text = config.Name or "Dropdown"
	label.TextColor3 = Color3.fromRGB(220, 223, 228)
	label.TextSize = 13
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = root

	local selectButton = Instance.new("TextButton")
	selectButton.AnchorPoint = Vector2.new(1, 0)
	selectButton.Position = UDim2.new(1, -8, 0, 7)
	selectButton.Size = UDim2.new(0.45, -8, 0, 24)
	selectButton.BackgroundColor3 = Color3.fromRGB(45, 48, 57)
	selectButton.BorderSizePixel = 0
	selectButton.AutoButtonColor = false
	selectButton.Font = Enum.Font.Gotham
	selectButton.TextColor3 = Color3.fromRGB(235, 237, 240)
	selectButton.TextSize = 12
	selectButton.TextXAlignment = Enum.TextXAlignment.Left
	selectButton.Parent = root

	local buttonPadding = Instance.new("UIPadding")
	buttonPadding.PaddingLeft = UDim.new(0, 7)
	buttonPadding.PaddingRight = UDim.new(0, 22)
	buttonPadding.Parent = selectButton

	local arrowAsset = Lucide.GetAsset("chevron-down")
	local arrow = Instance.new("ImageLabel")
	arrow.AnchorPoint = Vector2.new(1, 0.5)
	arrow.Position = UDim2.new(1, -15, 0, 19)
	arrow.Size = UDim2.fromOffset(12, 12)
	arrow.BackgroundTransparency = 1
	arrow.Image = arrowAsset.Url
	arrow.ImageRectOffset = arrowAsset.ImageRectOffset
	arrow.ImageRectSize = arrowAsset.ImageRectSize
	arrow.ImageColor3 = Color3.fromRGB(155, 160, 172)
	arrow.Parent = root

	local list = Instance.new("ScrollingFrame")
	list.Position = UDim2.fromOffset(8, 38)
	list.Size = UDim2.new(1, -16, 0, 0)
	list.BackgroundColor3 = Color3.fromRGB(35, 38, 46)
	list.BorderSizePixel = 0
	list.CanvasSize = UDim2.fromOffset(0, 0)
	list.AutomaticCanvasSize = Enum.AutomaticSize.Y
	list.ScrollBarThickness = 0
	list.ScrollingDirection = Enum.ScrollingDirection.Y
	list.Parent = root

	local listLayout = Instance.new("UIListLayout")
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Parent = list

	local dropdown = setmetatable({
		Root = root,
		Button = selectButton,
		Arrow = arrow,
		List = list,
		Options = {},
		OptionButtons = {},
		Value = nil,
		Callback = config.Callback,
		Open = false,
		Connections = {},
	}, Dropdown)

	table.insert(dropdown.Connections, selectButton.MouseButton1Click:Connect(function()
		dropdown:SetOpen(not dropdown.Open)
	end))

	dropdown:SetOptions(config.Options or {})
	if config.Default ~= nil then
		dropdown:SetValue(config.Default, true)
	elseif dropdown.Options[1] ~= nil then
		dropdown:SetValue(dropdown.Options[1], true)
	else
		selectButton.Text = config.Placeholder or "Select"
	end

	return dropdown
end

function Dropdown:SetOpen(open)
	self.Open = open
	local height = if open then math.min(#self.Options, MAX_VISIBLE) * ROW_HEIGHT else 0
	TweenService:Create(self.Root, TWEEN, { Size = UDim2.new(1, 0, 0, 38 + height) }):Play()
	TweenService:Create(self.List, TWEEN, { Size = UDim2.new(1, -16, 0, height) }):Play()
	TweenService:Create(self.Arrow, TWEEN, { Rotation = if open then 180 else 0 }):Play()
	TweenService:Create(self.Button, TWEEN, {
		BackgroundColor3 = if open then Color3.fromRGB(58, 62, 73) else Color3.fromRGB(45, 48, 57),
	}):Play()
end

function Dropdown:SetValue(value, silent)
	local found = false
	for _, option in ipairs(self.Options) do
		if option == value then
			found = true
			break
		end
	end
	assert(found, "PureUI dropdown value is not in Options")

	self.Value = value
	self.Button.Text = tostring(value)
	self:SetOpen(false)

	for option, optionButton in pairs(self.OptionButtons) do
		optionButton.BackgroundColor3 = if option == value then Color3.fromRGB(58, 62, 73) else Color3.fromRGB(35, 38, 46)
	end

	if not silent and type(self.Callback) == "function" then
		task.spawn(self.Callback, value)
	end
	return self
end

function Dropdown:GetValue()
	return self.Value
end

function Dropdown:SetOptions(options)
	assert(type(options) == "table", "PureUI dropdown Options must be a table")
	for _, connection in ipairs(self.OptionConnections or {}) do connection:Disconnect() end
	self.OptionConnections = {}
	for _, optionButton in pairs(self.OptionButtons) do optionButton:Destroy() end
	self.OptionButtons = {}
	self.Options = options

	for index, option in ipairs(options) do
		local optionButton = Instance.new("TextButton")
		optionButton.Name = tostring(option)
		optionButton.LayoutOrder = index
		optionButton.Size = UDim2.new(1, 0, 0, ROW_HEIGHT)
		optionButton.BackgroundColor3 = Color3.fromRGB(35, 38, 46)
		optionButton.BorderSizePixel = 0
		optionButton.AutoButtonColor = false
		optionButton.Font = Enum.Font.Gotham
		optionButton.Text = tostring(option)
		optionButton.TextColor3 = Color3.fromRGB(220, 223, 228)
		optionButton.TextSize = 12
		optionButton.Parent = self.List
		self.OptionButtons[option] = optionButton

		table.insert(self.OptionConnections, optionButton.MouseEnter:Connect(function()
			TweenService:Create(optionButton, TWEEN, { BackgroundColor3 = Color3.fromRGB(58, 62, 73) }):Play()
		end))
		table.insert(self.OptionConnections, optionButton.MouseLeave:Connect(function()
			TweenService:Create(optionButton, TWEEN, {
				BackgroundColor3 = if self.Value == option then Color3.fromRGB(58, 62, 73) else Color3.fromRGB(35, 38, 46),
			}):Play()
		end))
		table.insert(self.OptionConnections, optionButton.MouseButton1Click:Connect(function()
			self:SetValue(option)
		end))
	end

	if self.Value ~= nil and self.OptionButtons[self.Value] == nil then
		self.Value = nil
		self.Button.Text = "Select"
	end
	self:SetOpen(false)
	return self
end

function Dropdown:Destroy()
	for _, connection in ipairs(self.Connections) do connection:Disconnect() end
	for _, connection in ipairs(self.OptionConnections) do connection:Disconnect() end
	self.Root:Destroy()
end

return Dropdown
