local UserInputService = game:GetService("UserInputService")

local Keypicker = {}
Keypicker.__index = Keypicker

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
	button.AutomaticSize = Enum.AutomaticSize.X
	button.Size = UDim2.fromOffset(0, 18)
	button.BackgroundColor3 = Color3.fromRGB(45, 48, 57)
	button.BorderSizePixel = 0
	button.AutoButtonColor = false
	button.Font = Enum.Font.GothamMedium
	button.TextColor3 = Color3.fromRGB(220, 223, 228)
	button.TextSize = 11
	button.Parent = toggle.Row

	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 4)
	padding.PaddingRight = UDim.new(0, 4)
	padding.Parent = button

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
		button.Text = "..."
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

function Keypicker:SetKey(key, silent)
	assert(type(key) == "string" and key ~= "", "PureUI keypicker key must be a string")
	self.Key = key
	self.Button.Text = DISPLAY_NAMES[key] or key

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
	self.InputConnection:Disconnect()
	self.Button:Destroy()
end

return Keypicker
