# Index start from 1
setw -g base-index 1
setw -g pane-base-index 1

# Display key stroke
set -sg escape-time 1
# Escapetime
set -s escape-time 0
# Message display time
set -g display-time $TMUX_DISPLAY_TIME

# Color
set -g default-terminal screen-256color
set -g message-style $TMUX_ACTIVE
setw -g clock-mode-colour $TMUX_CLOCK_COLOR
