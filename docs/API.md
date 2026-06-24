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
tabs. The titlebar moves the window. The corner-shaped bottom-right handle
resizes it from a minimum of `560 × 350` up to the viewport size.

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

Columns scroll only when content overflows. Scrollbars are hidden and native
elastic overscroll provides spring feedback on touch devices.

```lua
local First = Window:CreateTab({ Name = "Demo 1" })
local Second = Window:CreateTab({ Name = "Demo 2" })
```

## `Tab:CreateGroupbox(config)`

Creates a full-column-width groupbox. Groupboxes stack with an 8px vertical
gap and have a separate 25px titlebar. Height fits controls automatically;
pass `Height` only to force a fixed height.

```lua
local Groupbox = Tab:CreateGroupbox({
	Name = "Player",
	Column = "Left",
})
```

`Column` must be `Left`, `Center`, or `Right`.

## `Groupbox:CreateToggle(config)`

Creates a boolean toggle switch.

```lua
local Toggle = Groupbox:CreateToggle({
	Name = "Enabled",
	Default = false,
	Callback = function(value)
		print(value)
	end,
})

Toggle:SetValue(true)
print(Toggle:GetValue())
```

Toggle labels fade lighter on hover.

## `Groupbox:CreateKeypicker(config)`

Attaches a keypicker to an existing toggle by its name.

```lua
local Keypicker = Groupbox:CreateKeypicker({
	Toggle = "Enabled",
	Default = "K",
	Callback = function(key)
		print(key)
	end,
})

Keypicker:SetKey("RightShift")
print(Keypicker:GetKey())
```

## `Groupbox:CreateSlider(config)`

```lua
local Slider = Groupbox:CreateSlider({
	Name = "Speed",
	Min = 0,
	Max = 100,
	Step = 1,
	Default = 50,
	Callback = function(value) print(value) end,
})

Slider:SetValue(75)
print(Slider:GetValue())
```

Slider movement uses heavy smoothing while its stored value and callback stay
current.

## `Groupbox:CreateInput(config)`

```lua
local Input = Groupbox:CreateInput({
	Name = "Message",
	Placeholder = "Enter text",
	Default = "",
	Callback = function(text) print(text) end,
})

Input:SetValue("Hello")
print(Input:GetValue())
```

## `Groupbox:CreateDoubleButton(config)`

Creates two equal buttons in one row. `Accent` accepts `"Left"` or `"Right"`.
Both buttons animate on press.

```lua
Groupbox:CreateDoubleButton({
	Left = "Cancel",
	Right = "Apply",
	Accent = "Right",
	LeftCallback = function() end,
	RightCallback = function() end,
})
```

## `Groupbox:CreateColorpicker(config)`

Opens a modal saturation/value and hue picker. Changes apply only after
pressing `Apply`.

```lua
local Colorpicker = Groupbox:CreateColorpicker({
	Name = "Accent",
	Default = Color3.fromRGB(88, 130, 255),
	Callback = function(color) print(color) end,
})

Colorpicker:SetValue(Color3.fromRGB(255, 80, 80))
print(Colorpicker:GetValue())
```

## `Groupbox:CreateDropdown(config)`

Creates an animated single-select dropdown. Lists over five items scroll.

```lua
local Dropdown = Groupbox:CreateDropdown({
	Name = "Mode",
	Options = { "One", "Two", "Three" },
	Default = "One",
	Callback = function(value) print(value) end,
})

Dropdown:SetValue("Two")
Dropdown:SetOptions({ "A", "B", "C" })
print(Dropdown:GetValue())
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
