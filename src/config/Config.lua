local HttpService = game:GetService("HttpService")

local Config = {}
Config.__index = Config

local function validName(value)
	return type(value) == "string" and value ~= "" and value:match("^[%w _%-]+$") ~= nil
end

local function filesystemAvailable()
	return type(isfile) == "function"
		and type(isfolder) == "function"
		and type(makefolder) == "function"
		and type(readfile) == "function"
		and type(writefile) == "function"
end

local function attempt(callback)
	local success, result = pcall(callback)
	return success, success and result or tostring(result)
end

function Config.new(options)
	options = options or {}

	local folder = options.Folder or "PureUI"
	local name = options.Name or "default"

	assert(validName(folder), "PureUI config Folder contains invalid characters")
	assert(validName(name), "PureUI config Name contains invalid characters")

	return setmetatable({
		Folder = folder,
		Name = name,
		Path = folder .. "/configs/" .. name .. ".json",
		Values = {},
		Bindings = {},
	}, Config)
end

function Config:IsSupported()
	return filesystemAvailable()
end

function Config:Register(flag, getter, setter)
	assert(validName(flag), "PureUI config flag contains invalid characters")
	assert(type(getter) == "function", "PureUI config getter must be a function")
	assert(type(setter) == "function", "PureUI config setter must be a function")

	self.Bindings[flag] = { Get = getter, Set = setter }
	return self
end

function Config:Set(flag, value)
	assert(validName(flag), "PureUI config flag contains invalid characters")
	self.Values[flag] = value
	return self
end

function Config:Get(flag, default)
	local value = self.Values[flag]
	return value == nil and default or value
end

function Config:Save()
	if not filesystemAvailable() then
		return false, "filesystem API unavailable"
	end

	local encoded
	local success, err = attempt(function()
		for flag, binding in pairs(self.Bindings) do
			self.Values[flag] = binding.Get()
		end

		encoded = HttpService:JSONEncode({
			version = 1,
			values = self.Values,
		})

		if not isfolder(self.Folder) then
			makefolder(self.Folder)
		end

		local configFolder = self.Folder .. "/configs"
		if not isfolder(configFolder) then
			makefolder(configFolder)
		end

		writefile(self.Path, encoded)
	end)

	return success, err
end

function Config:Load()
	if not filesystemAvailable() then
		return false, "filesystem API unavailable"
	end

	local decoded
	local success, err = attempt(function()
		if not isfile(self.Path) then
			error("config file does not exist", 0)
		end

		decoded = HttpService:JSONDecode(readfile(self.Path))
		if type(decoded) ~= "table" or type(decoded.values) ~= "table" then
			error("invalid config data", 0)
		end
	end)

	if not success then
		return false, err
	end

	self.Values = decoded.values
	for flag, binding in pairs(self.Bindings) do
		if self.Values[flag] ~= nil then
			local applied, applyErr = attempt(function()
				binding.Set(self.Values[flag])
			end)
			if not applied then
				return false, ("failed to apply %s: %s"):format(flag, applyErr)
			end
		end
	end

	return true, self.Values
end

function Config:Delete()
	if type(isfile) ~= "function" or type(delfile) ~= "function" then
		return false, "delete filesystem API unavailable"
	end
	if not isfile(self.Path) then
		return false, "config file does not exist"
	end

	return attempt(function()
		delfile(self.Path)
	end)
end

return Config
