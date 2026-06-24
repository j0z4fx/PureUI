local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Keypicker = {}
Keypicker.__index = Keypicker
local TWEEN = TweenInfo.new(0.14, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

local DISPLAY_NAMES = {
	MouseButton1 = "MB1",
	MouseButton2 = "MB2",
	MouseButton3 = "MB3",
	Insert = "INS",
	Delete = "DEL",
}

local function inputName(input)
	if input.UserInputType == Enum.UserInputType.Keyboard then
		return input.KeyCode.Name
	end
	return input.UserInputType.Name
end

function Keypicker.new(toggle, config)
	config = config or {}

	local button = Instance.new("TextButton")
	button.Name = "Keypicker"
	button.AnchorPoint = Vector2.new(1, 0.5)
	button.Position = UDim2.new(1, -52, 0.5, 0)
	button.Size = UDim2.fromOffset(28, 18)
	button.BackgroundColor3 = Color3.fromRGB(45, 48, 57)
	button.BorderSizePixel = 0
	button.AutoButtonColor = false
	button.Font = Enum.Font.GothamMedium
	button.TextColor3 = Color3.fromRGB(220, 223, 228)
	button.TextSize = 11
	button.TextXAlignment = Enum.TextXAlignment.Center
	button.TextYAlignment = Enum.TextYAlignment.Center
	button.Parent = toggle.Row

	local picker = setmetatable({
		Button = button,
		Key = config.Default or "None",
		Callback = config.Callback,
		Listening = false,
	}, Keypicker)

	picker:SetKey(picker.Key, true)
	picker.PressConnection = button.MouseButton1Down:Connect(function()
		toggle.SuppressClick = true
		task.defer(function()
			toggle.SuppressClick = false
		end)
	end)
	picker.ClickConnection = button.MouseButton1Click:Connect(function()
		picker.Listening = true
		picker:SetDisplay("...")
	end)
	picker.HoverConnection = button.MouseEnter:Connect(function()
		TweenService:Create(button, TWEEN, {
			BackgroundColor3 = Color3.fromRGB(58, 62, 73),
			TextColor3 = Color3.fromRGB(248, 249, 251),
		}):Play()
	end)
	picker.LeaveConnection = button.MouseLeave:Connect(function()
		TweenService:Create(button, TWEEN, {
			BackgroundColor3 = Color3.fromRGB(45, 48, 57),
			TextColor3 = Color3.fromRGB(220, 223, 228),
		}):Play()
	end)
	picker.InputConnection = UserInputService.InputBegan:Connect(function(input)
		if not picker.Listening then
			return
		end
		picker.Listening = false
		picker:SetKey(inputName(input))
	end)

	return picker
end

function Keypicker:SetDisplay(text)
	local fadeOut = TweenService:Create(self.Button, TWEEN, { TextTransparency = 1 })
	fadeOut:Play()
	fadeOut.Completed:Once(function()
		self.Button.Text = text
		TweenService:Create(self.Button, TWEEN, { TextTransparency = 0 }):Play()
	end)
end

function Keypicker:SetKey(key, silent)
	assert(type(key) == "string" and key ~= "", "PureUI keypicker key must be a string")
	self.Key = key
	local display = DISPLAY_NAMES[key] or key
	if silent then
		self.Button.Text = display
	else
		self:SetDisplay(display)
	end

	if not silent and type(self.Callback) == "function" then
		task.spawn(self.Callback, key)
	end

	return self
end

function Keypicker:GetKey()
	return self.Key
end

function Keypicker:Destroy()
	self.PressConnection:Disconnect()
	self.ClickConnection:Disconnect()
	self.HoverConnection:Disconnect()
	self.LeaveConnection:Disconnect()
	self.InputConnection:Disconnect()
	self.Button:Destroy()
end

return Keypicker
