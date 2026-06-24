local TweenService = game:GetService("TweenService")

local Input = {}
Input.__index = Input
local TWEEN = TweenInfo.new(0.14, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

function Input.new(parent, config)
	config = config or {}

	local row = Instance.new("Frame")
	row.Name = config.Name or "Input"
	row.Size = UDim2.new(1, 0, 0, 38)
	row.BackgroundTransparency = 1
	row.Parent = parent

	local label = Instance.new("TextLabel")
	label.Position = UDim2.fromOffset(8, 0)
	label.Size = UDim2.new(0.4, -8, 1, 0)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.Gotham
	label.Text = config.Name or "Input"
	label.TextColor3 = Color3.fromRGB(220, 223, 228)
	label.TextSize = 13
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = row

	local box = Instance.new("TextBox")
	box.AnchorPoint = Vector2.new(1, 0.5)
	box.Position = UDim2.new(1, -8, 0.5, 0)
	box.Size = UDim2.new(0.6, -8, 0, 24)
	box.BackgroundColor3 = Color3.fromRGB(45, 48, 57)
	box.BorderSizePixel = 0
	box.ClearTextOnFocus = false
	box.ClipsDescendants = true
	box.Font = Enum.Font.Gotham
	box.MultiLine = false
	box.PlaceholderText = config.Placeholder or ""
	box.PlaceholderColor3 = Color3.fromRGB(125, 130, 142)
	box.Text = config.Default or ""
	box.TextColor3 = Color3.fromRGB(235, 237, 240)
	box.TextSize = 12
	box.TextTruncate = Enum.TextTruncate.AtEnd
	box.TextXAlignment = Enum.TextXAlignment.Left
	box.Parent = row

	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 7)
	padding.PaddingRight = UDim.new(0, 7)
	padding.Parent = box

	local input = setmetatable({
		Row = row,
		Box = box,
		Value = box.Text,
		Callback = config.Callback,
	}, Input)

	input.FocusConnection = box.Focused:Connect(function()
		box.TextTruncate = Enum.TextTruncate.None
		box.CursorPosition = #box.Text + 1
		TweenService:Create(box, TWEEN, { BackgroundColor3 = Color3.fromRGB(58, 62, 73) }):Play()
	end)
	input.LostConnection = box.FocusLost:Connect(function()
		box.TextTruncate = Enum.TextTruncate.AtEnd
		TweenService:Create(box, TWEEN, { BackgroundColor3 = Color3.fromRGB(45, 48, 57) }):Play()
		input:SetValue(box.Text)
	end)

	return input
end

function Input:SetValue(value, silent)
	value = tostring(value)
	self.Value = value
	self.Box.Text = value
	if not silent and type(self.Callback) == "function" then
		task.spawn(self.Callback, value)
	end
	return self
end

function Input:GetValue()
	return self.Value
end

function Input:Destroy()
	self.FocusConnection:Disconnect()
	self.LostConnection:Disconnect()
	self.Row:Destroy()
end

return Input
