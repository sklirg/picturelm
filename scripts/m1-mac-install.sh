#!/bin/sh

set -e

rm -f bin.gz
wget --quiet https://github.com/elm/compiler/releases/download/0.19.1/binary-for-mac-64-bit.gz

gunzip --force binary-for-mac-64-bit.gz

install -m0755 binary-for-mac-64-bit node_modules/elm/bin/elm

rm -f binary-for-mac-64-bit
