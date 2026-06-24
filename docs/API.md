# PureUI API

Update this file with each API change.

## Loading

```lua
local PureUI = loadstring(game:HttpGet("RAW_URL"))()
```

## `PureUI:CreateWindow(config)`

Creates a window object.

```lua
local Window = PureUI:CreateWindow({})
```

## `Window:CreateTab(config)`

Creates a tab object.

```lua
local Tab = Window:CreateTab({})
```

## `Tab:CreateButton(config)`

Reserved for button creation. Currently raises a not-implemented error.

```lua
local Button = Tab:CreateButton({})
```

## Icons

Icons come from
[`notpoiu/lucide-roblox-direct`](https://github.com/notpoiu/lucide-roblox-direct).

```lua
local icon = PureUI:GetIcon("settings")
local names = PureUI.Icons
```

`GetIcon` returns `nil` for an unknown name. A found icon contains `Url`,
`ImageRectSize`, and `ImageRectOffset`.

## `PureUI:CreateConfig(options)`

Creates an independent JSON config:

```lua
local Config = PureUI:CreateConfig({
	Folder = "MyHub",
	Name = "default",
})
```

Only letters, numbers, spaces, `_`, and `-` are accepted in folder, config,
and flag names.

### Values

```lua
Config:Set("accent", "blue")
print(Config:Get("accent", "red"))
```

### Control bindings

Controls can register getter/setter functions as they are implemented:

```lua
Config:Register(
	"enabled",
	function()
		return Toggle:GetValue()
	end,
	function(value)
		Toggle:SetValue(value)
	end
)
```

### Persistence

```lua
local supported = Config:IsSupported()
local saved, saveError = Config:Save()
local loaded, valuesOrError = Config:Load()
local deleted, deleteError = Config:Delete()
```

Files are stored at `<Folder>/configs/<Name>.json`. Methods return
`false, errorMessage` when filesystem access, JSON conversion, or a binding
fails.
