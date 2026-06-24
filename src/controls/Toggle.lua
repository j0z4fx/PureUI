local Toggle = {}
Toggle.__index = Toggle
local TweenService = game:GetService("TweenService")
local TWEEN = TweenInfo.new(0.16, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

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
	track.Size = UDim2.fromOffset(18, 18)
	track.BorderSizePixel = 0
	track.Parent = row

	local knob = Instance.new("Frame")
	knob.AnchorPoint = Vector2.new(0.5, 0.5)
	knob.Position = UDim2.fromScale(0.5, 0.5)
	knob.Size = UDim2.fromOffset(10, 10)
	knob.BorderSizePixel = 0
	knob.Parent = track

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
	self.Knob.BackgroundColor3 = Color3.fromRGB(245, 246, 248)

	TweenService:Create(self.Track, TWEEN, {
		BackgroundColor3 = if value then Color3.fromRGB(88, 130, 255) else Color3.fromRGB(61, 65, 76),
	}):Play()
	TweenService:Create(self.Knob, TWEEN, {
		Size = if value then UDim2.fromOffset(10, 10) else UDim2.fromOffset(0, 0),
	}):Play()

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
