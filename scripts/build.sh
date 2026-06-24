#!/usr/bin/env sh
set -eu

cd "$(dirname "$0")/.."
mkdir -p dist
darklua process src/init.lua dist/PureUI.lua --config build/darklua.json5

if grep -Eq 'require[[:space:]]*\(' dist/PureUI.lua; then
	echo "build failed: runtime require found" >&2
	exit 1
fi

mkdir -p Server
cp dist/PureUI.lua Server/PureUI.lua
shasum -a 256 dist/PureUI.lua | awk '{ print $1 }' > Server/version.txt
