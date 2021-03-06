# Colors
TMUX_ACTIVE='fg=colour232, bg=colour130'
TMUX_INACTIVE='fg=colour248, bg=colour235'
TMUX_INACTIVE_STATUS='fg=colour243, bg=colour0'
TMUX_CLOCK_COLOR='colour130'

# Formats
TMUX_PANE_BORDER='#{pane_current_path} [#{pane_current_command}]'
TMUX_WINDOW_STATUS='#[fg=colour208,bg=colour0]#{?client_prefix,#[reverse],} #I:#W #[default]'
# TMUX_WINDOW_STATUS_RIGHT='\
# #[fg=colour208]CPU:#[default] #{cpu_bg_color}#{cpu_icon} #{cpu_percentage}#[default] \
# #[fg=colour208]Batt:#[default] #{battery_status_bg}#{battery_icon} #{battery_percentage} #{battery_remain}#[default] \
# #[fg=colour208]%H:%M:%S | %m/%d %a#[default] \
# '
TMUX_WINDOW_STATUS_RIGHT='#[fg=colour208]%H:%M:%S | %m/%d %a#[default]'

# Othres
TMUX_DISPLAY_TIME=1500
TMUX_STATUS_RIGHT_LENGTH=90
