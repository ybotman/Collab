#!/bin/bash
# Opens the MasterCalendar iTerm window arrangement
# Usage: bash ~/MyDocs/Collab/scripts/open-mastercalendar.sh
# Or add alias: alias mc="bash ~/MyDocs/Collab/scripts/open-mastercalendar.sh"

osascript -e 'tell application "iTerm"
    activate
    tell application "System Events" to tell process "iTerm2"
        click menu item "MasterCalendar" of menu "Restore Window Arrangement" of menu "Window" of menu bar 1
    end tell
end tell'

echo "MasterCalendar arrangement opened"
