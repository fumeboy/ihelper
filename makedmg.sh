#!/bin/sh
# brew install create-dmg
test -f ihelper.dmg && rm ihelper.dmg
create-dmg \
  --volname "ihelper" \
  --window-pos 200 120 \
  --window-size 800 400 \
  "ihelper.dmg" \
  "./build/"
