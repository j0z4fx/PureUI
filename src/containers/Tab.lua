local Button = require("../controls/Button")
local Groupbox = require("./Groupbox")

local Tab = {}
Tab.__index = Tab

function Tab.new(window, config)
	config = config or {}

	local button = Instance.new("TextButton")
	button.Name = config.Name or "Tab"
	button.BackgroundColor3 = Color3.fromRGB(31, 34, 41)
	button.BorderSizePixel = 0
	button.AutoButtonColor = false
	button.Font = Enum.Font.GothamMedium
	button.Text = config.Name or "Tab"
	button.TextColor3 = Color3.fromRGB(145, 149, 160)
	button.TextSize = 13
	button.Parent = window.TabBar

	local content = Instance.new("Frame")
	content.Name = button.Name .. "Content"
	content.Position = UDim2.fromOffset(0, 60)
	content.Size = UDim2.new(1, 0, 1, -60)
	content.BackgroundTransparency = 1
	content.Visible = false
	content.Parent = window.Panel

	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 8)
	padding.PaddingBottom = UDim.new(0, 8)
	padding.PaddingLeft = UDim.new(0, 8)
	padding.PaddingRight = UDim.new(0, 8)
	padding.Parent = content

	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Horizontal
	layout.Padding = UDim.new(0, 8)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = content

	local columns = {}
	local names = { "Left", "Center", "Right" }
	for index = 1, 3 do
		local column = Instance.new("ScrollingFrame")
		column.Name = names[index]
		column.LayoutOrder = index
		column.Size = UDim2.new(1 / 3, -16 / 3, 1, 0)
		column.BackgroundTransparency = 1
		column.BorderSizePixel = 0
		column.AutomaticCanvasSize = Enum.AutomaticSize.Y
		column.CanvasSize = UDim2.fromOffset(0, 0)
		column.ScrollingDirection = Enum.ScrollingDirection.Y
		column.ElasticBehavior = Enum.ElasticBehavior.Always
		column.ScrollBarThickness = 1
		column.ScrollBarImageTransparency = 1
		column.Parent = content

		local columnLayout = Instance.new("UIListLayout")
		columnLayout.Padding = UDim.new(0, 8)
		columnLayout.SortOrder = Enum.SortOrder.LayoutOrder
		columnLayout.Parent = column

		columns[names[index]] = column
	end

	local tab = setmetatable({
		Window = window,
		Button = button,
		Content = content,
		Columns = columns,
		Groupboxes = {},
		Connection = nil,
	}, Tab)

	tab.Connection = button.MouseButton1Click:Connect(function()
		window:SelectTab(tab)
	end)

	table.insert(window.Tabs, tab)
	if #window.Tabs == 1 then
		window:SelectTab(tab)
	end

	return tab
end

function Tab:CreateButton(_config)
	return Button.new()
end

function Tab:CreateGroupbox(config)
	config = config or {}
	local column = self.Columns[config.Column or "Left"]
	assert(column, "PureUI groupbox Column must be Left, Center, or Right")
	local groupbox = Groupbox.new(column, config)
	table.insert(self.Groupboxes, groupbox)
	return groupbox
end

function Tab:SetActive(active)
	self.Content.Visible = active
	self.Button.BackgroundColor3 = if active then Color3.fromRGB(42, 46, 55) else Color3.fromRGB(31, 34, 41)
	self.Button.TextColor3 = if active then Color3.fromRGB(240, 242, 245) else Color3.fromRGB(145, 149, 160)
end

function Tab:Destroy()
	for _, groupbox in ipairs(self.Groupboxes) do
		groupbox:Destroy()
	end
	self.Connection:Disconnect()
	self.Button:Destroy()
	self.Content:Destroy()
end

return Tab
