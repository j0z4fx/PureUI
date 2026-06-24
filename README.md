# Blank Slate

Minimal modular foundation for Roblox loadstring UI libraries.

## Build

Requires [Darklua](https://darklua.com/).

```sh
./scripts/build.sh
```

Source modules in `src/` compile into standalone `dist/PureUI.lua` with no
runtime `require()` calls.

## Load

```lua
local PureUI = loadstring(game:HttpGet("RAW_URL"))()
```

See [docs/API.md](docs/API.md) for current APIs.
