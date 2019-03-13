set -g status on

# Position
set -g status-position top
set -g status-justify centre

# Reload interval
set -g status-interval 1

# Color
set -g status-style $TMUX_INACTIVE_STATUS

# Size
set -g status-right-length $TMUX_STATUS_RIGHT_LENGTH

# Format
set -g window-status-current-format $TMUX_WINDOW_STATUS
set -g status-left ""
set -g status-right $TMUX_WINDOW_STATUS_RIGHT
