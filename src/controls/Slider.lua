local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Slider = {}
Slider.__index = Slider

function Slider.new(parent, config)
	config = config or {}
	local minimum = config.Min or 0
	local maximum = config.Max or 100
	local step = config.Step or 1
	assert(maximum > minimum, "PureUI slider Max must be greater than Min")
	assert(step > 0, "PureUI slider Step must be positive")

	local row = Instance.new("Frame")
	row.Name = config.Name or "Slider"
	row.Size = UDim2.new(1, 0, 0, 46)
	row.BackgroundTransparency = 1
	row.Parent = parent

	local label = Instance.new("TextLabel")
	label.Position = UDim2.fromOffset(8, 0)
	label.Size = UDim2.new(1, -56, 0, 24)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.Gotham
	label.Text = config.Name or "Slider"
	label.TextColor3 = Color3.fromRGB(220, 223, 228)
	label.TextSize = 13
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = row

	local valueLabel = Instance.new("TextLabel")
	valueLabel.AnchorPoint = Vector2.new(1, 0)
	valueLabel.Position = UDim2.new(1, -8, 0, 0)
	valueLabel.Size = UDim2.fromOffset(44, 24)
	valueLabel.BackgroundTransparency = 1
	valueLabel.Font = Enum.Font.GothamMedium
	valueLabel.TextColor3 = Color3.fromRGB(155, 160, 172)
	valueLabel.TextSize = 12
	valueLabel.TextXAlignment = Enum.TextXAlignment.Right
	valueLabel.Parent = row

	local track = Instance.new("TextButton")
	track.Position = UDim2.fromOffset(8, 28)
	track.Size = UDim2.new(1, -16, 0, 8)
	track.BackgroundColor3 = Color3.fromRGB(45, 48, 57)
	track.BorderSizePixel = 0
	track.AutoButtonColor = false
	track.Text = ""
	track.Parent = row

	local fill = Instance.new("Frame")
	fill.Size = UDim2.fromScale(0, 1)
	fill.BackgroundColor3 = Color3.fromRGB(88, 130, 255)
	fill.BorderSizePixel = 0
	fill.Parent = track

	local slider = setmetatable({
		Row = row,
		Track = track,
		Fill = fill,
		ValueLabel = valueLabel,
		Min = minimum,
		Max = maximum,
		Step = step,
		Value = minimum,
		TargetValue = minimum,
		DisplayValue = minimum,
		Callback = config.Callback,
		Dragging = false,
	}, Slider)

	local function update(input)
		local ratio = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
		slider:SetValue(minimum + (maximum - minimum) * ratio)
	end

	slider.BeginConnection = track.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch
		then
			slider.Dragging = true
			slider.DragInput = input.UserInputType == Enum.UserInputType.Touch and input or nil
			update(input)
		end
	end)
	slider.ChangeConnection = UserInputService.InputChanged:Connect(function(input)
		if slider.Dragging
			and ((slider.DragInput and input == slider.DragInput)
				or (not slider.DragInput and input.UserInputType == Enum.UserInputType.MouseMovement))
		then
			update(input)
		end
	end)
	slider.EndConnection = UserInputService.InputEnded:Connect(function(input)
		if slider.Dragging
			and ((slider.DragInput and input == slider.DragInput)
				or (not slider.DragInput and input.UserInputType == Enum.UserInputType.MouseButton1))
		then
			slider.Dragging = false
			slider.DragInput = nil
		end
	end)
	slider.RenderConnection = RunService.RenderStepped:Connect(function(deltaTime)
		local difference = slider.TargetValue - slider.DisplayValue
		if math.abs(difference) < slider.Step * 0.01 then
			slider.DisplayValue = slider.TargetValue
		else
			slider.DisplayValue += difference * (1 - math.exp(-4 * deltaTime))
		end

		local ratio = (slider.DisplayValue - minimum) / (maximum - minimum)
		slider.Fill.Size = UDim2.fromScale(ratio, 1)
		slider.ValueLabel.Text = tostring(math.round(slider.DisplayValue / step) * step)
	end)

	slider:SetValue(config.Default or minimum, true, true)
	return slider
end

function Slider:SetValue(value, silent, instant)
	value = math.clamp(self.Min + math.round((value - self.Min) / self.Step) * self.Step, self.Min, self.Max)
	self.Value = value
	self.TargetValue = value
	if instant then
		self.DisplayValue = value
		self.Fill.Size = UDim2.fromScale((value - self.Min) / (self.Max - self.Min), 1)
		self.ValueLabel.Text = tostring(value)
	end

	if not silent and type(self.Callback) == "function" then
		task.spawn(self.Callback, value)
	end
	return self
end

function Slider:GetValue()
	return self.Value
end

function Slider:Destroy()
	self.BeginConnection:Disconnect()
	self.ChangeConnection:Disconnect()
	self.EndConnection:Disconnect()
	self.RenderConnection:Disconnect()
	self.Row:Destroy()
end

return Slider
