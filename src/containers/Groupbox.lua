local Groupbox = {}
Groupbox.__index = Groupbox

function Groupbox.new(parent, config)
	config = config or {}

	local frame = Instance.new("Frame")
	frame.Name = config.Name or "Groupbox"
	frame.Size = UDim2.new(1, 0, 0, config.Height or 120)
	frame.BackgroundColor3 = Color3.fromRGB(27, 30, 36)
	frame.BorderSizePixel = 0
	frame.Parent = parent

	local titleBar = Instance.new("Frame")
	titleBar.Name = "TitleBar"
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
	content.Position = UDim2.fromOffset(0, 25)
	content.Size = UDim2.new(1, 0, 1, -25)
	content.BackgroundTransparency = 1
	content.Parent = frame

	return setmetatable({
		Frame = frame,
		TitleBar = titleBar,
		Title = title,
		Content = content,
	}, Groupbox)
end

function Groupbox:Destroy()
	self.Frame:Destroy()
end

return Groupbox
