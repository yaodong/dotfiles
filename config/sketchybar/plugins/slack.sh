#!/bin/sh

SLACK_STATUS=$(lsappinfo info -only StatusLabel "Slack" | grep -o '"label"="[^"]*"' | sed 's/"label"="\(.*\)"/\1/')

# Check if Slack is running and get its workspace
SLACK_WORKSPACE=""
if pgrep -f "Slack" > /dev/null; then
    # Try to find Slack's current workspace using aerospace
    SLACK_WORKSPACE=$(aerospace list-windows --all --format '%{workspace} | %{app-name}' | grep -i "| Slack" | head -1 | cut -d'|' -f1 | xargs)
fi

if [[ $SLACK_STATUS == "" ]]; then
    ICON_COLOR="0xffa6da95"
elif [[ $SLACK_STATUS == "•" ]]; then
    ICON_COLOR="0xffeed49f"
elif [[ $SLACK_STATUS =~ ^[0-9]+$ ]]; then
    ICON_COLOR="0xffed8796"
else
    exit 0
fi

# Set the label and color, and update click script based on workspace
if [[ -n $SLACK_WORKSPACE ]]; then
    # If Slack is running, switch to its workspace
    sketchybar --set slack label="${SLACK_STATUS}" icon.color=${ICON_COLOR} click_script="aerospace workspace ${SLACK_WORKSPACE}"
else
    # If Slack is not running, open it and switch to workspace S
    sketchybar --set slack label="${SLACK_STATUS}" icon.color=${ICON_COLOR} click_script="aerospace workspace S && sleep 0.5 && open -a Slack"
fi
