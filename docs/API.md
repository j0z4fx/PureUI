# PureUI API

Update this file with each API change.

## Loading

```lua
local PureUI = loadstring(game:HttpGet("RAW_URL"))()
```

## `PureUI:CreateWindow(config)`

Creates a centered `800 × 450` square-cornered background panel with a
`30px` draggable titlebar and centered `Pure` title. Dragging is clamped so
the window remains on screen. Current development build includes two demo
tabs.

```lua
local Window = PureUI:CreateWindow({})
```

Destroy it with `Window:Destroy()`, or destroy every PureUI window with
`PureUI:Destroy()`.

## `Window:CreateTab(config)`

Creates a working tab button and content frame. First tab is selected
automatically. Tabs divide the full width equally. Each tab contains three
equal scrolling columns with 8px outer padding and gaps:

```lua
Tab.Columns.Left
Tab.Columns.Center
Tab.Columns.Right
```

Scrollbars appear only when column content overflows.

```lua
local First = Window:CreateTab({ Name = "Demo 1" })
local Second = Window:CreateTab({ Name = "Demo 2" })
```

## `Tab:CreateGroupbox(config)`

Creates a full-column-width groupbox. Groupboxes stack with an 8px vertical
gap and have a separate 25px titlebar.

```lua
local Groupbox = Tab:CreateGroupbox({
	Name = "Player",
	Column = "Left",
	Height = 120,
})
```

`Column` must be `Left`, `Center`, or `Right`.

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

## Development bridge

Upload `Server/` through Vercel Drop, then start the opt-in bridge:

```lua
local Bridge = PureUI:StartDevBridge({
	Interval = 2,
	OnReload = function(NewPureUI)
		PureUI = NewPureUI
	end,
})
```

The default server is `https://pureserver.vercel.app`. Pass `BaseUrl` to
override it.

Each build copies `dist/PureUI.lua` into `Server/` and updates
`Server/version.txt`. The bridge bypasses HTTP caches, destroys the old library
when a new valid bundle loads, and places the replacement in
`getgenv().PureUI`.

Stop polling with `Bridge:Stop()`. This API is development-only.
