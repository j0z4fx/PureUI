local Window = require("../window/Window")
local Config = require("../config/Config")
local Lucide = require("../icons/Lucide")

local PureUI = {}
PureUI.__index = PureUI

function PureUI:CreateWindow(_config)
	return Window.new()
end

function PureUI:CreateConfig(options)
	return Config.new(options)
end

function PureUI:GetIcon(name)
	return Lucide.GetAsset(name)
end

PureUI.Icons = Lucide.Icons

return setmetatable({}, PureUI)
