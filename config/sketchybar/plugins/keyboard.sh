#!/bin/sh

KEYBOARD_INFO="$(defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleCurrentKeyboardLayoutInputSourceID | cut -d. -f4)"

case "$KEYBOARD_INFO" in
    "U.S."|"US") SHORT_LAYOUT="En";;
    "PinyinKeyboard") SHORT_LAYOUT="Zh";;
    "") SHORT_LAYOUT="Unknown";;
    *) SHORT_LAYOUT="${KEYBOARD_INFO:0:1}";;
esac

echo "Setting keyboard layout to $SHORT_LAYOUT"

sketchybar --set keyboard label="$SHORT_LAYOUT"
