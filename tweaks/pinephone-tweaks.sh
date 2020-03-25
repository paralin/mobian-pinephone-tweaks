#!/bin/sh

# Fix Qt applications
export QT_QPA_PLATFORM=wayland
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1

# Fix Firefox
export MOZ_ENABLE_WAYLAND=1

# Use custom feedbackd theme
export FEEDBACK_THEME=/usr/share/feedbackd/themes/pinephone.json
