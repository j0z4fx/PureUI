local TweenService = game:GetService("TweenService")

local DoubleButton = {}
DoubleButton.__index = DoubleButton
local TWEEN = TweenInfo.new(0.14, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

local function createButton(parent, name, accent, order)
	local button = Instance.new("TextButton")
	button.Name = name
	button.LayoutOrder = order
	button.Size = UDim2.new(0.5, -4, 1, 0)
	button.BackgroundColor3 = if accent then Color3.fromRGB(88, 130, 255) else Color3.fromRGB(45, 48, 57)
	button.BorderSizePixel = 0
	button.AutoButtonColor = false
	button.Font = Enum.Font.GothamMedium
	button.Text = name
	button.TextColor3 = Color3.fromRGB(240, 242, 245)
	button.TextSize = 12
	button.Parent = parent
	return button
end

function DoubleButton.new(parent, config)
	config = config or {}
	local accent = config.Accent

	local row = Instance.new("Frame")
	row.Name = config.Name or "DoubleButton"
	row.Size = UDim2.new(1, 0, 0, 36)
	row.BackgroundTransparency = 1
	row.Parent = parent

	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 8)
	padding.PaddingRight = UDim.new(0, 8)
	padding.PaddingTop = UDim.new(0, 4)
	padding.PaddingBottom = UDim.new(0, 4)
	padding.Parent = row

	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Horizontal
	layout.Padding = UDim.new(0, 8)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = row

	local left = createButton(row, config.Left or "Left", accent == "Left", 1)
	local right = createButton(row, config.Right or "Right", accent == "Right", 2)
	local control = setmetatable({ Row = row, Left = left, Right = right, Connections = {} }, DoubleButton)

	local function wire(button, callback, isAccent)
		table.insert(control.Connections, button.MouseEnter:Connect(function()
			TweenService:Create(button, TWEEN, {
				BackgroundColor3 = if isAccent then Color3.fromRGB(105, 143, 255) else Color3.fromRGB(58, 62, 73),
			}):Play()
		end))
		table.insert(control.Connections, button.MouseLeave:Connect(function()
			TweenService:Create(button, TWEEN, {
				BackgroundColor3 = if isAccent then Color3.fromRGB(88, 130, 255) else Color3.fromRGB(45, 48, 57),
			}):Play()
		end))
		table.insert(control.Connections, button.MouseButton1Click:Connect(function()
			if type(callback) == "function" then
				task.spawn(callback)
			end
		end))
	end

	wire(left, config.LeftCallback, accent == "Left")
	wire(right, config.RightCallback, accent == "Right")
	return control
end

function DoubleButton:Destroy()
	for _, connection in ipairs(self.Connections) do
		connection:Disconnect()
	end
	self.Row:Destroy()
end

return DoubleButton
