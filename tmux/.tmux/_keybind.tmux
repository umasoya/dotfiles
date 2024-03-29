# Prefix
set -g prefix C-t
unbind C-b

bind r source-file ~/.tmux.conf\; \
    display "reload $HOME/.tmux.conf"
bind C-r source-file ~/.tmux.conf\; \
    display "reload $HOME/.tmux.conf"

# Split pane
bind \\ splitw -hc "#{pane_current_path}"
bind - splitw -vc "#{pane_current_path}"
# without prefix
bind -n M-\\ splitw -hc "#{pane_current_path}"
bind -n M-- splitw -vc "#{pane_current_path}"

# Move pane like vim
bind h selectp -L
bind j selectp -D
bind k selectp -U
bind l selectp -R
# Move pane without prefix
bind -n M-h selectp -L
bind -n M-j selectp -D
bind -n M-k selectp -U
bind -n M-l selectp -R

# Swap pane
bind t swapp -D

# Clock
bind C-t clock-mode

# Resize Pane
bind -r left resizep -L 4
bind -r up resizep -U 4
bind -r down resizep -D 4
bind -r right resizep -R 4

# Copy mode
setw -g mode-keys vi
bind -T copy-mode-vi v send-keys -X begin-selection
bind -T copy-mode-vi y send-keys -X copy-selection-and-cancel
bind -T copy-mode-vi Enter send-keys -X copy-selection-and-cancel
bind -T copy-mode-vi Escape send-keys -X clear-selection

# synchronize-panes
bind -n M-s setw synchronize-panes
