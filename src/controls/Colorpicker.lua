local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Colorpicker = {}
Colorpicker.__index = Colorpicker
local TWEEN = TweenInfo.new(0.16, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

local function button(parent, text, position, accent)
	local value = Instance.new("TextButton")
	value.Position = position
	value.Size = UDim2.fromOffset(82, 28)
	value.BackgroundColor3 = if accent then Color3.fromRGB(88, 130, 255) else Color3.fromRGB(45, 48, 57)
	value.BorderSizePixel = 0
	value.AutoButtonColor = false
	value.Font = Enum.Font.GothamMedium
	value.Text = text
	value.TextColor3 = Color3.fromRGB(240, 242, 245)
	value.TextSize = 12
	value.ZIndex = 53
	value.Parent = parent
	return value
end

function Colorpicker.new(parent, window, config)
	config = config or {}
	local initial = config.Default or Color3.fromRGB(88, 130, 255)
	local hue, saturation, brightness = initial:ToHSV()

	local row = Instance.new("TextButton")
	row.Name = config.Name or "Colorpicker"
	row.Size = UDim2.new(1, 0, 0, 32)
	row.BackgroundTransparency = 1
	row.BorderSizePixel = 0
	row.AutoButtonColor = false
	row.Text = ""
	row.Parent = parent

	local label = Instance.new("TextLabel")
	label.Position = UDim2.fromOffset(8, 0)
	label.Size = UDim2.new(1, -56, 1, 0)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.Gotham
	label.Text = config.Name or "Color"
	label.TextColor3 = Color3.fromRGB(220, 223, 228)
	label.TextSize = 13
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = row

	local swatch = Instance.new("Frame")
	swatch.AnchorPoint = Vector2.new(1, 0.5)
	swatch.Position = UDim2.new(1, -8, 0.5, 0)
	swatch.Size = UDim2.fromOffset(36, 18)
	swatch.BackgroundColor3 = initial
	swatch.BorderSizePixel = 0
	swatch.Parent = row

	local overlay = Instance.new("TextButton")
	overlay.Name = "ColorpickerModal"
	overlay.Size = UDim2.fromScale(1, 1)
	overlay.BackgroundColor3 = Color3.new(0, 0, 0)
	overlay.BackgroundTransparency = 0.35
	overlay.BorderSizePixel = 0
	overlay.AutoButtonColor = false
	overlay.Text = ""
	overlay.Visible = false
	overlay.ZIndex = 50
	overlay.Parent = window.Panel

	local dialog = Instance.new("Frame")
	dialog.AnchorPoint = Vector2.new(0.5, 0.5)
	dialog.Position = UDim2.fromScale(0.5, 0.5)
	dialog.Size = UDim2.fromOffset(300, 250)
	dialog.BackgroundColor3 = Color3.fromRGB(27, 30, 36)
	dialog.BorderSizePixel = 0
	dialog.ZIndex = 51
	dialog.Parent = overlay

	local title = Instance.new("TextLabel")
	title.Position = UDim2.fromOffset(12, 0)
	title.Size = UDim2.new(1, -24, 0, 36)
	title.BackgroundTransparency = 1
	title.Font = Enum.Font.GothamMedium
	title.Text = config.Name or "Color"
	title.TextColor3 = Color3.fromRGB(240, 242, 245)
	title.TextSize = 14
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.ZIndex = 52
	title.Parent = dialog

	local map = Instance.new("Frame")
	map.Position = UDim2.fromOffset(12, 38)
	map.Size = UDim2.fromOffset(220, 140)
	map.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
	map.BorderSizePixel = 0
	map.ClipsDescendants = true
	map.ZIndex = 52
	map.Parent = dialog

	local white = Instance.new("Frame")
	white.Size = UDim2.fromScale(1, 1)
	white.BackgroundColor3 = Color3.new(1, 1, 1)
	white.BorderSizePixel = 0
	white.ZIndex = 53
	white.Parent = map

	local whiteGradient = Instance.new("UIGradient")
	whiteGradient.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(1, 1),
	})
	whiteGradient.Parent = white

	local black = Instance.new("Frame")
	black.Size = UDim2.fromScale(1, 1)
	black.BackgroundColor3 = Color3.new(0, 0, 0)
	black.BorderSizePixel = 0
	black.ZIndex = 54
	black.Parent = map

	local blackGradient = Instance.new("UIGradient")
	blackGradient.Rotation = 90
	blackGradient.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(1, 0),
	})
	blackGradient.Parent = black

	local mapInput = Instance.new("TextButton")
	mapInput.Size = UDim2.fromScale(1, 1)
	mapInput.BackgroundTransparency = 1
	mapInput.Text = ""
	mapInput.ZIndex = 55
	mapInput.Parent = map

	local mapCursor = Instance.new("Frame")
	mapCursor.AnchorPoint = Vector2.new(0.5, 0.5)
	mapCursor.Size = UDim2.fromOffset(8, 8)
	mapCursor.BackgroundColor3 = Color3.new(1, 1, 1)
	mapCursor.BorderColor3 = Color3.new(0, 0, 0)
	mapCursor.ZIndex = 56
	mapCursor.Parent = map

	local hueBar = Instance.new("TextButton")
	hueBar.Position = UDim2.fromOffset(242, 38)
	hueBar.Size = UDim2.fromOffset(14, 140)
	hueBar.BackgroundColor3 = Color3.new(1, 1, 1)
	hueBar.BorderSizePixel = 0
	hueBar.Text = ""
	hueBar.ZIndex = 52
	hueBar.Parent = dialog

	local hueGradient = Instance.new("UIGradient")
	hueGradient.Rotation = 90
	hueGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
		ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
		ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
		ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
		ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
	})
	hueGradient.Parent = hueBar

	local hueCursor = Instance.new("Frame")
	hueCursor.AnchorPoint = Vector2.new(0.5, 0.5)
	hueCursor.Position = UDim2.fromScale(0.5, hue)
	hueCursor.Size = UDim2.new(1, 6, 0, 2)
	hueCursor.BackgroundColor3 = Color3.new(1, 1, 1)
	hueCursor.BorderSizePixel = 0
	hueCursor.ZIndex = 56
	hueCursor.Parent = hueBar

	local preview = Instance.new("Frame")
	preview.Position = UDim2.fromOffset(12, 188)
	preview.Size = UDim2.fromOffset(88, 28)
	preview.BackgroundColor3 = initial
	preview.BorderSizePixel = 0
	preview.ZIndex = 52
	preview.Parent = dialog

	local cancel = button(dialog, "Cancel", UDim2.fromOffset(110, 188), false)
	local apply = button(dialog, "Apply", UDim2.fromOffset(200, 188), true)

	local picker = setmetatable({
		Row = row,
		Swatch = swatch,
		Overlay = overlay,
		Map = map,
		MapCursor = mapCursor,
		HueCursor = hueCursor,
		Preview = preview,
		Value = initial,
		Pending = initial,
		Hue = hue,
		Saturation = saturation,
		Brightness = brightness,
		Callback = config.Callback,
		Connections = {},
	}, Colorpicker)

	function picker:Update()
		self.Pending = Color3.fromHSV(self.Hue, self.Saturation, self.Brightness)
		map.BackgroundColor3 = Color3.fromHSV(self.Hue, 1, 1)
		mapCursor.Position = UDim2.fromScale(self.Saturation, 1 - self.Brightness)
		hueCursor.Position = UDim2.fromScale(0.5, self.Hue)
		preview.BackgroundColor3 = self.Pending
	end

	local function updateMap(input)
		picker.Saturation = math.clamp((input.Position.X - map.AbsolutePosition.X) / map.AbsoluteSize.X, 0, 1)
		picker.Brightness = 1 - math.clamp((input.Position.Y - map.AbsolutePosition.Y) / map.AbsoluteSize.Y, 0, 1)
		picker:Update()
	end

	local function updateHue(input)
		picker.Hue = math.clamp((input.Position.Y - hueBar.AbsolutePosition.Y) / hueBar.AbsoluteSize.Y, 0, 1)
		picker:Update()
	end

	local function beginDrag(target, input, callback)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1
			and input.UserInputType ~= Enum.UserInputType.Touch
		then
			return
		end
		picker.DragTarget = target
		picker.DragInput = input.UserInputType == Enum.UserInputType.Touch and input or nil
		callback(input)
	end

	table.insert(picker.Connections, mapInput.InputBegan:Connect(function(input)
		beginDrag("Map", input, updateMap)
	end))
	table.insert(picker.Connections, hueBar.InputBegan:Connect(function(input)
		beginDrag("Hue", input, updateHue)
	end))
	table.insert(picker.Connections, UserInputService.InputChanged:Connect(function(input)
		if not picker.DragTarget
			or not ((picker.DragInput and input == picker.DragInput)
				or (not picker.DragInput and input.UserInputType == Enum.UserInputType.MouseMovement))
		then
			return
		end
		if picker.DragTarget == "Map" then updateMap(input) else updateHue(input) end
	end))
	table.insert(picker.Connections, UserInputService.InputEnded:Connect(function(input)
		if (picker.DragInput and input == picker.DragInput)
			or (not picker.DragInput and input.UserInputType == Enum.UserInputType.MouseButton1)
		then
			picker.DragTarget = nil
			picker.DragInput = nil
		end
	end))
	table.insert(picker.Connections, row.MouseButton1Click:Connect(function() picker:Open() end))
	table.insert(picker.Connections, cancel.MouseButton1Click:Connect(function() picker:Close() end))
	table.insert(picker.Connections, apply.MouseButton1Click:Connect(function()
		picker:SetValue(picker.Pending)
		picker:Close()
	end))
	table.insert(picker.Connections, overlay.MouseButton1Click:Connect(function() picker:Close() end))
	table.insert(picker.Connections, dialog.InputBegan:Connect(function() end))

	picker:Update()
	return picker
end

function Colorpicker:Open()
	self.Pending = self.Value
	self.Hue, self.Saturation, self.Brightness = self.Value:ToHSV()
	self:Update()
	self.Overlay.BackgroundTransparency = 1
	self.Overlay.Visible = true
	TweenService:Create(self.Overlay, TWEEN, { BackgroundTransparency = 0.35 }):Play()
end

function Colorpicker:Close()
	local tween = TweenService:Create(self.Overlay, TWEEN, { BackgroundTransparency = 1 })
	tween:Play()
	tween.Completed:Once(function()
		self.Overlay.Visible = false
	end)
end

function Colorpicker:SetValue(color, silent)
	assert(typeof(color) == "Color3", "PureUI colorpicker value must be Color3")
	self.Value = color
	self.Pending = color
	self.Swatch.BackgroundColor3 = color
	if not silent and type(self.Callback) == "function" then
		task.spawn(self.Callback, color)
	end
	return self
end

function Colorpicker:GetValue()
	return self.Value
end

function Colorpicker:Destroy()
	for _, connection in ipairs(self.Connections) do connection:Disconnect() end
	self.Overlay:Destroy()
	self.Row:Destroy()
end

return Colorpicker
