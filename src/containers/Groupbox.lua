local Toggle = require("../controls/Toggle")
local Keypicker = require("../controls/Keypicker")
local Slider = require("../controls/Slider")
local Input = require("../controls/Input")
local DoubleButton = require("../controls/DoubleButton")
local Colorpicker = require("../controls/Colorpicker")

local Groupbox = {}
Groupbox.__index = Groupbox

function Groupbox.new(parent, window, config)
	config = config or {}

	local frame = Instance.new("Frame")
	frame.Name = config.Name or "Groupbox"
	frame.Size = UDim2.new(1, 0, 0, config.Height or 0)
	frame.AutomaticSize = if config.Height then Enum.AutomaticSize.None else Enum.AutomaticSize.Y
	frame.BackgroundColor3 = Color3.fromRGB(27, 30, 36)
	frame.BorderSizePixel = 0
	frame.Parent = parent

	local frameLayout = Instance.new("UIListLayout")
	frameLayout.SortOrder = Enum.SortOrder.LayoutOrder
	frameLayout.Parent = frame

	local titleBar = Instance.new("Frame")
	titleBar.Name = "TitleBar"
	titleBar.LayoutOrder = 1
	titleBar.Size = UDim2.new(1, 0, 0, 25)
	titleBar.BackgroundColor3 = Color3.fromRGB(37, 40, 48)
	titleBar.BorderSizePixel = 0
	titleBar.Parent = frame

	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(1, -16, 1, 0)
	title.Position = UDim2.fromOffset(8, 0)
	title.BackgroundTransparency = 1
	title.Font = Enum.Font.GothamMedium
	title.Text = config.Name or "Groupbox"
	title.TextColor3 = Color3.fromRGB(235, 237, 240)
	title.TextSize = 13
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = titleBar

	local content = Instance.new("Frame")
	content.Name = "Content"
	content.LayoutOrder = 2
	content.Size = if config.Height then UDim2.new(1, 0, 1, -25) else UDim2.new(1, 0, 0, 0)
	content.AutomaticSize = if config.Height then Enum.AutomaticSize.None else Enum.AutomaticSize.Y
	content.BackgroundTransparency = 1
	content.Parent = frame

	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 4)
	padding.PaddingBottom = UDim.new(0, 4)
	padding.Parent = content

	local layout = Instance.new("UIListLayout")
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = content

	return setmetatable({
		Frame = frame,
		TitleBar = titleBar,
		Title = title,
		Content = content,
		Window = window,
		Toggles = {},
		Controls = {},
	}, Groupbox)
end

function Groupbox:CreateToggle(config)
	local toggle = Toggle.new(self.Content, config)
	self.Toggles[config.Name or "Toggle"] = toggle
	table.insert(self.Controls, toggle)
	return toggle
end

function Groupbox:CreateKeypicker(config)
	config = config or {}
	local toggle = self.Toggles[config.Toggle]
	assert(toggle, "PureUI keypicker Toggle must name an existing toggle in this groupbox")
	local keypicker = Keypicker.new(toggle, config)
	table.insert(self.Controls, keypicker)
	return keypicker
end

function Groupbox:CreateSlider(config)
	local slider = Slider.new(self.Content, config)
	table.insert(self.Controls, slider)
	return slider
end

function Groupbox:CreateInput(config)
	local input = Input.new(self.Content, config)
	table.insert(self.Controls, input)
	return input
end

function Groupbox:CreateDoubleButton(config)
	local buttons = DoubleButton.new(self.Content, config)
	table.insert(self.Controls, buttons)
	return buttons
end

function Groupbox:CreateColorpicker(config)
	local colorpicker = Colorpicker.new(self.Content, self.Window, config)
	table.insert(self.Controls, colorpicker)
	return colorpicker
end

function Groupbox:Destroy()
	for _, control in ipairs(self.Controls) do
		control:Destroy()
	end
	self.Frame:Destroy()
end

return Groupbox
