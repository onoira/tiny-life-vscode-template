#!/usr/bin/bash
set -euo pipefail
IFS=$'\n\t'

modname=$(grep -oPm1 "(?<=<AssemblyName>)[^<]+" .vscode/mod.csproj)
version="$(git describe --tags --abbrev=0)"
filename="../../.vscode/dist/$modname-$version.zip"

if grep -qE "(Microsoft|WSL)" /proc/version &> /dev/null ; then
    LOCALAPPDATA="$(wslpath "$(cmd.exe /C "echo %LOCALAPPDATA%")" | tr -d '\r')"
fi

mkdir -p .vscode/dist
pushd .vscode/dist
rm -fv *.zip
popd

pushd ./Mod/$modname/
zip -r "$filename" .
cp -v "$filename" "$LOCALAPPDATA/Tiny Life/Mods/$modname.zip"
popd
