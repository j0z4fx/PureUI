local Button = require("../controls/Button")

local Tab = {}
Tab.__index = Tab

function Tab.new(window, config)
	config = config or {}

	local button = Instance.new("TextButton")
	button.Name = config.Name or "Tab"
	button.Size = UDim2.fromOffset(100, 30)
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

	local tab = setmetatable({
		Window = window,
		Button = button,
		Content = content,
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

function Tab:SetActive(active)
	self.Content.Visible = active
	self.Button.BackgroundColor3 = if active then Color3.fromRGB(42, 46, 55) else Color3.fromRGB(31, 34, 41)
	self.Button.TextColor3 = if active then Color3.fromRGB(240, 242, 245) else Color3.fromRGB(145, 149, 160)
end

function Tab:Destroy()
	self.Connection:Disconnect()
	self.Button:Destroy()
	self.Content:Destroy()
end

return Tab
