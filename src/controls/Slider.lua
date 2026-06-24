local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Slider = {}
Slider.__index = Slider

local function quantize(value, minimum, maximum, step)
	return math.clamp(minimum + math.round((value - minimum) / step) * step, minimum, maximum)
end

local function approach(current, target, deltaTime)
	local difference = target - current
	if math.abs(difference) < 0.01 then
		return target
	end
	return current + difference * (1 - math.exp(-4 * deltaTime))
end

function Slider.new(parent, config)
	config = config or {}
	local variant = config.Variant or "Default"
	assert(variant == "Default" or variant == "Centered" or variant == "Range", "PureUI slider Variant is invalid")

	local minimum = config.Min
	local maximum = config.Max
	if variant == "Centered" then
		minimum = minimum or -100
		maximum = maximum or 100
	else
		minimum = minimum or 0
		maximum = maximum or 100
	end
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
	label.Size = UDim2.new(1, -88, 0, 24)
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
	valueLabel.Size = UDim2.fromOffset(76, 24)
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
	fill.BackgroundColor3 = Color3.fromRGB(88, 130, 255)
	fill.BorderSizePixel = 0
	fill.Parent = track

	local lowKnob
	local highKnob
	if variant == "Range" then
		for index = 1, 2 do
			local knob = Instance.new("Frame")
			knob.Name = if index == 1 then "Low" else "High"
			knob.AnchorPoint = Vector2.new(0.5, 0.5)
			knob.Size = UDim2.fromOffset(6, 14)
			knob.BackgroundColor3 = Color3.fromRGB(240, 242, 245)
			knob.BorderSizePixel = 0
			knob.ZIndex = 2
			knob.Parent = track
			if index == 1 then lowKnob = knob else highKnob = knob end
		end
	end

	local slider = setmetatable({
		Row = row,
		Track = track,
		Fill = fill,
		LowKnob = lowKnob,
		HighKnob = highKnob,
		ValueLabel = valueLabel,
		Variant = variant,
		Min = minimum,
		Max = maximum,
		Step = step,
		Callback = config.Callback,
		Dragging = false,
	}, Slider)

	local function ratioToValue(input)
		local ratio = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
		return quantize(minimum + (maximum - minimum) * ratio, minimum, maximum, step)
	end

	local function update(input)
		local value = ratioToValue(input)
		if variant == "Range" then
			if slider.ActiveHandle == "Low" then
				slider:SetValue({ Min = math.min(value, slider.High), Max = slider.High })
			else
				slider:SetValue({ Min = slider.Low, Max = math.max(value, slider.Low) })
			end
		else
			slider:SetValue(value)
		end
	end

	slider.BeginConnection = track.InputBegan:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1
			and input.UserInputType ~= Enum.UserInputType.Touch
		then
			return
		end

		slider.Dragging = true
		slider.DragInput = input.UserInputType == Enum.UserInputType.Touch and input or nil
		if variant == "Range" then
			local value = ratioToValue(input)
			slider.ActiveHandle = if math.abs(value - slider.Low) <= math.abs(value - slider.High) then "Low" else "High"
		end
		update(input)
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
			slider.ActiveHandle = nil
		end
	end)
	slider.RenderConnection = RunService.RenderStepped:Connect(function(deltaTime)
		if variant == "Range" then
			slider.DisplayLow = approach(slider.DisplayLow, slider.Low, deltaTime)
			slider.DisplayHigh = approach(slider.DisplayHigh, slider.High, deltaTime)
			local lowRatio = (slider.DisplayLow - minimum) / (maximum - minimum)
			local highRatio = (slider.DisplayHigh - minimum) / (maximum - minimum)
			fill.Position = UDim2.fromScale(lowRatio, 0)
			fill.Size = UDim2.fromScale(highRatio - lowRatio, 1)
			lowKnob.Position = UDim2.fromScale(lowRatio, 0.5)
			highKnob.Position = UDim2.fromScale(highRatio, 0.5)
			valueLabel.Text = ("%s – %s"):format(slider.Low, slider.High)
		else
			slider.DisplayValue = approach(slider.DisplayValue, slider.Value, deltaTime)
			local ratio = (slider.DisplayValue - minimum) / (maximum - minimum)
			if variant == "Centered" then
				local center = (0 - minimum) / (maximum - minimum)
				fill.Position = UDim2.fromScale(math.min(center, ratio), 0)
				fill.Size = UDim2.fromScale(math.abs(ratio - center), 1)
			else
				fill.Position = UDim2.fromScale(0, 0)
				fill.Size = UDim2.fromScale(ratio, 1)
			end
			valueLabel.Text = tostring(slider.Value)
		end
	end)

	if variant == "Range" then
		local default = config.Default or { Min = minimum, Max = maximum }
		slider:SetValue(default, true, true)
	else
		local default = config.Default
		if default == nil then default = if variant == "Centered" then 0 else minimum end
		slider:SetValue(default, true, true)
	end
	return slider
end

function Slider:SetValue(value, silent, instant)
	if self.Variant == "Range" then
		assert(type(value) == "table", "PureUI range slider value must be a table")
		local low = quantize(value.Min or value[1], self.Min, self.Max, self.Step)
		local high = quantize(value.Max or value[2], self.Min, self.Max, self.Step)
		assert(low <= high, "PureUI range slider Min cannot exceed Max")
		self.Low = low
		self.High = high
		if instant then
			self.DisplayLow = low
			self.DisplayHigh = high
			local lowRatio = (low - self.Min) / (self.Max - self.Min)
			local highRatio = (high - self.Min) / (self.Max - self.Min)
			self.Fill.Position = UDim2.fromScale(lowRatio, 0)
			self.Fill.Size = UDim2.fromScale(highRatio - lowRatio, 1)
			self.LowKnob.Position = UDim2.fromScale(lowRatio, 0.5)
			self.HighKnob.Position = UDim2.fromScale(highRatio, 0.5)
			self.ValueLabel.Text = ("%s – %s"):format(low, high)
		end
		if not silent and type(self.Callback) == "function" then
			task.spawn(self.Callback, { Min = low, Max = high })
		end
	else
		value = quantize(value, self.Min, self.Max, self.Step)
		self.Value = value
		if instant then
			self.DisplayValue = value
			local ratio = (value - self.Min) / (self.Max - self.Min)
			if self.Variant == "Centered" then
				local center = (0 - self.Min) / (self.Max - self.Min)
				self.Fill.Position = UDim2.fromScale(math.min(center, ratio), 0)
				self.Fill.Size = UDim2.fromScale(math.abs(ratio - center), 1)
			else
				self.Fill.Position = UDim2.fromScale(0, 0)
				self.Fill.Size = UDim2.fromScale(ratio, 1)
			end
			self.ValueLabel.Text = tostring(value)
		end
		if not silent and type(self.Callback) == "function" then
			task.spawn(self.Callback, value)
		end
	end
	return self
end

function Slider:GetValue()
	if self.Variant == "Range" then
		return { Min = self.Low, Max = self.High }
	end
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
