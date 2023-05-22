#!/bin/bash

for i in *.project.json; do
    [ -f "$i" ] || break
    name="${i%%.*}"
    rojo build $i -o $name.rbxl
    remodel run ci-scripts/sync-assets.lua $name
done