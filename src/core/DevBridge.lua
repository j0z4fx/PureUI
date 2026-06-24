local DevBridge = {}

local function fetch(url)
	return game:HttpGet(url .. "?t=" .. tostring(os.clock()))
end

function DevBridge.start(current, options)
	options = options or {}

	local baseUrl = (options.BaseUrl or "https://pureserver.vercel.app"):gsub("/+$", "")
	assert(baseUrl:match("^https://"), "PureUI dev bridge BaseUrl must use HTTPS")

	local environment = getgenv and getgenv() or _G
	local previous = environment.__PUREUI_DEV_BRIDGE
	if previous then
		previous:Stop()
	end

	local controller = {
		Current = current,
		Running = true,
		Version = nil,
	}

	function controller:Stop()
		self.Running = false
		if environment.__PUREUI_DEV_BRIDGE == self then
			environment.__PUREUI_DEV_BRIDGE = nil
		end
	end

	environment.__PUREUI_DEV_BRIDGE = controller

	task.spawn(function()
		while controller.Running do
			local versionOk, version = pcall(fetch, baseUrl .. "/version.txt")
			if versionOk and version ~= controller.Version then
				local sourceOk, source = pcall(fetch, baseUrl .. "/PureUI.lua")
				if sourceOk then
					local chunk, compileError = loadstring(source, "@PureUI-dev")
					if chunk then
						local runOk, replacement = pcall(chunk)
						if runOk and type(replacement) == "table" then
							local old = controller.Current
							if type(old.Destroy) == "function" then
								pcall(old.Destroy, old)
							end

							controller.Current = replacement
							controller.Version = version
							environment.PureUI = replacement

							if type(options.OnReload) == "function" then
								task.spawn(options.OnReload, replacement)
							end
						else
							warn("[PureUI] dev reload failed: " .. tostring(replacement))
						end
					else
						warn("[PureUI] dev compile failed: " .. tostring(compileError))
					end
				end
			end

			task.wait(options.Interval or 2)
		end
	end)

	return controller
end

return DevBridge
