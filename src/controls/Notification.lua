local TweenService = game:GetService("TweenService")
local _FORCE_REBUILD = 1

local NOTIF_WIDTH = 280
local NOTIF_HEIGHT = 56
local ACCENT_WIDTH = 4
local TIMER_HEIGHT = 2
local PADDING = 8
local GAP = 8

local TWEEN_IN = TweenInfo.new(0.16, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local TWEEN_OUT = TweenInfo.new(0.12, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

local Notification = {}
Notification.__index = Notification

function Notification.new(container, config)
	config = config or {}
	local side = config.Side or "Left"
	local isLeft = side == "Left"

	local frame = Instance.new("Frame")
	frame.Name = "Notification"
	frame.Size = UDim2.fromOffset(NOTIF_WIDTH, NOTIF_HEIGHT)
	frame.BackgroundColor3 = Color3.fromRGB(27, 30, 36)
	frame.BorderSizePixel = 0
	frame.BackgroundTransparency = 1
	frame.ClipsDescendants = true
	frame.Parent = container

	local accent = Instance.new("Frame")
	accent.Name = "Accent"
	if isLeft then
		accent.Position = UDim2.fromOffset(0, 0)
	else
		accent.Position = UDim2.new(1, -ACCENT_WIDTH, 0, 0)
	end
	accent.Size = UDim2.fromOffset(ACCENT_WIDTH, NOTIF_HEIGHT)
	accent.BackgroundColor3 = Color3.fromRGB(88, 130, 255)
	accent.BorderSizePixel = 0
	accent.Parent = frame

	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Position = UDim2.fromOffset(PADDING + ACCENT_WIDTH + 4, PADDING)
	title.Size = UDim2.new(1, -(PADDING * 2 + ACCENT_WIDTH + 28), 0, 20)
	title.BackgroundTransparency = 1
	title.Font = Enum.Font.GothamMedium
	title.Text = config.Title or ""
	title.TextColor3 = Color3.fromRGB(235, 237, 240)
	title.TextSize = 13
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.TextTruncate = Enum.TextTruncate.AtEnd
	title.Parent = frame

	local hasMessage = config.Message and config.Message ~= ""
	local message = nil
	if hasMessage then
		message = Instance.new("TextLabel")
		message.Name = "Message"
		message.Position = UDim2.fromOffset(PADDING + ACCENT_WIDTH + 4, PADDING + 22)
		message.Size = UDim2.new(1, -(PADDING * 2 + ACCENT_WIDTH + 8), 0, 16)
		message.BackgroundTransparency = 1
		message.Font = Enum.Font.Gotham
		message.Text = config.Message
		message.TextColor3 = Color3.fromRGB(220, 223, 228)
		message.TextSize = 12
		message.TextXAlignment = Enum.TextXAlignment.Left
		message.TextTruncate = Enum.TextTruncate.AtEnd
		message.Parent = frame
	end

	local close = Instance.new("TextButton")
	close.Name = "Close"
	close.Size = UDim2.fromOffset(20, 20)
	if isLeft then
		close.Position = UDim2.new(1, -(PADDING + 4), 0, PADDING - 2)
	else
		close.Position = UDim2.fromOffset(PADDING + ACCENT_WIDTH + 4, PADDING - 2)
	end
	close.BackgroundTransparency = 1
	close.BorderSizePixel = 0
	close.AutoButtonColor = false
	close.Font = Enum.Font.Gotham
	close.Text = "x"
	close.TextColor3 = Color3.fromRGB(155, 160, 172)
	close.TextSize = 14
	close.Parent = frame

	local timer = Instance.new("Frame")
	timer.Name = "Timer"
	timer.AnchorPoint = Vector2.new(0, 1)
	timer.Position = UDim2.new(0, 0, 1, 0)
	timer.Size = UDim2.new(1, 0, 0, TIMER_HEIGHT)
	timer.BackgroundColor3 = Color3.fromRGB(88, 130, 255)
	timer.BorderSizePixel = 0
	timer.Parent = frame

	local self = setmetatable({
		Frame = frame,
		Title = title,
		Message = message,
		Close = close,
		Timer = timer,
		Side = side,
		Connections = {},
	}, Notification)

	self.CloseConn = close.MouseButton1Click:Connect(function()
		self:Dismiss()
	end)
	self.HoverConn = close.MouseEnter:Connect(function()
		TweenService:Create(close, TWEEN_IN, { TextColor3 = Color3.fromRGB(248, 249, 251) }):Play()
	end)
	self.LeaveConn = close.MouseLeave:Connect(function()
		TweenService:Create(close, TWEEN_IN, { TextColor3 = Color3.fromRGB(155, 160, 172) }):Play()
	end)

	local entryOffset = -NOTIF_WIDTH
	if not isLeft then
		entryOffset = NOTIF_WIDTH
	end
	frame.Position = UDim2.fromOffset(entryOffset, 0)
	TweenService:Create(frame, TWEEN_IN, {
		BackgroundTransparency = 0,
		Position = UDim2.fromOffset(0, 0),
	}):Play()

	local duration = config.Duration
	if duration == nil then
		duration = 5
	end
	if duration > 0 then
		local timerTween = TweenService:Create(timer, TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 0, 0, TIMER_HEIGHT),
		})
		timerTween:Play()

		self.DismissConn = timerTween.Completed:Connect(function()
			if self.Frame and self.Frame.Parent then
				self:Dismiss()
			end
		end)
	end

	return self
end

function Notification:Dismiss()
	if self.Dismissed then
		return
	end
	self.Dismissed = true

	local exitOffset = -NOTIF_WIDTH
	if self.Side ~= "Left" then
		exitOffset = NOTIF_WIDTH
	end
	local baseX = self.Frame.Position.X.Offset
	local baseY = self.Frame.Position.Y.Offset

	local tween = TweenService:Create(self.Frame, TWEEN_OUT, {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(baseX + exitOffset, baseY),
	})
	tween.Completed:Connect(function()
		self:Destroy()
	end)
	tween:Play()
end

function Notification:Destroy()
	if self.DismissConn then
		self.DismissConn:Disconnect()
	end
	if self.CloseConn then
		self.CloseConn:Disconnect()
	end
	if self.HoverConn then
		self.HoverConn:Disconnect()
	end
	if self.LeaveConn then
		self.LeaveConn:Disconnect()
	end
	if self.Frame then
		self.Frame:Destroy()
		self.Frame = nil
	end
end

function Notification:SetY(offset)
	self.Frame.Position = UDim2.fromOffset(self.Frame.Position.X.Offset, offset)
end

return Notification
