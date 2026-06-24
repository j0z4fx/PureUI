local Window = require("../window/Window")
local Config = require("../config/Config")
local Lucide = require("../icons/Lucide")
local DevBridge = require("./DevBridge")

local PureUI = {}
PureUI.__index = PureUI
PureUI.Windows = {}

function PureUI:CreateWindow(_config)
	local window = Window.new()
	table.insert(self.Windows, window)
	return window
end

function PureUI:CreateConfig(options)
	return Config.new(options)
end

function PureUI:GetIcon(name)
	return Lucide.GetAsset(name)
end

function PureUI:StartDevBridge(options)
	return DevBridge.start(self, options)
end

function PureUI:Destroy()
	for _, window in ipairs(self.Windows) do
		window:Destroy()
	end
	table.clear(self.Windows)
end

PureUI.Icons = Lucide.Icons

return setmetatable({}, PureUI)
