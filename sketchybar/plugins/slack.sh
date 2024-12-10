#!/bin/sh

SLACK_STATUS=$(lsappinfo info -only StatusLabel "Slack" | grep -o '"label"="[^"]*"' | sed 's/"label"="\(.*\)"/\1/')

if [[ $SLACK_STATUS == "" ]]; then
    ICON_COLOR="0xffa6da95"
elif [[ $SLACK_STATUS == "•" ]]; then
    ICON_COLOR="0xffeed49f"
elif [[ $SLACK_STATUS =~ ^[0-9]+$ ]]; then
    ICON_COLOR="0xffed8796"
else
    exit 0
fi

sketchybar --set slack label="${SLACK_STATUS}" icon.color=${ICON_COLOR}
