local Toggle = {}
Toggle.__index = Toggle

function Toggle.new(parent, config)
	config = config or {}

	local row = Instance.new("TextButton")
	row.Name = config.Name or "Toggle"
	row.Size = UDim2.new(1, 0, 0, 32)
	row.BackgroundTransparency = 1
	row.BorderSizePixel = 0
	row.AutoButtonColor = false
	row.Text = ""
	row.Parent = parent

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -52, 1, 0)
	label.Position = UDim2.fromOffset(8, 0)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.Gotham
	label.Text = config.Name or "Toggle"
	label.TextColor3 = Color3.fromRGB(220, 223, 228)
	label.TextSize = 13
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = row

	local track = Instance.new("Frame")
	track.AnchorPoint = Vector2.new(1, 0.5)
	track.Position = UDim2.new(1, -8, 0.5, 0)
	track.Size = UDim2.fromOffset(36, 18)
	track.BorderSizePixel = 0
	track.Parent = row

	local trackCorner = Instance.new("UICorner")
	trackCorner.CornerRadius = UDim.new(1, 0)
	trackCorner.Parent = track

	local knob = Instance.new("Frame")
	knob.AnchorPoint = Vector2.new(0, 0.5)
	knob.Size = UDim2.fromOffset(14, 14)
	knob.BorderSizePixel = 0
	knob.Parent = track

	local knobCorner = Instance.new("UICorner")
	knobCorner.CornerRadius = UDim.new(1, 0)
	knobCorner.Parent = knob

	local toggle = setmetatable({
		Row = row,
		Track = track,
		Knob = knob,
		Value = config.Default == true,
		Callback = config.Callback,
	}, Toggle)

	toggle.Connection = row.MouseButton1Click:Connect(function()
		toggle:SetValue(not toggle.Value)
	end)

	toggle:SetValue(toggle.Value, true)
	return toggle
end

function Toggle:SetValue(value, silent)
	assert(type(value) == "boolean", "PureUI toggle value must be boolean")
	self.Value = value
	self.Track.BackgroundColor3 = if value then Color3.fromRGB(88, 130, 255) else Color3.fromRGB(61, 65, 76)
	self.Knob.BackgroundColor3 = Color3.fromRGB(245, 246, 248)
	self.Knob.Position = if value then UDim2.new(1, -16, 0.5, 0) else UDim2.fromOffset(2, 9)

	if not silent and type(self.Callback) == "function" then
		task.spawn(self.Callback, value)
	end

	return self
end

function Toggle:GetValue()
	return self.Value
end

function Toggle:Destroy()
	self.Connection:Disconnect()
	self.Row:Destroy()
end

return Toggle
