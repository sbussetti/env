## clipboardpastin

# the old way:
# # unbind p
# # bind p paste-buffer
# set-option -g default-command "reattach-to-user-namespace -l $SHELL"
# bind y run "tmux save-buffer - | reattach-to-user-namespace pbcopy"
# bind-key -T copy-mode-vi v send -X begin-selection
# bind-key -T copy-mode-vi y send -X copy-pipe-and-cancel "reattach-to-user-namespace pbcopy"
# unbind -T copy-mode-vi Enter
# bind-key -T copy-mode-vi Enter send -X copy-pipe-and-cancel "reattach-to-user-namespace pbcopy"
# bind ] run "reattach-to-user-namespace pbpaste | tmux load-buffer - && tmux paste-buffer"

# the new way (requires tmux 2.6+)
bind-key -T copy-mode-vi [ send -X begin-selection
bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "pbcopy"
bind-key -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "pbcopy"

## mousey
# setw -g mode-mouse on
# setw -g mouse-select-pane on
# setw -g mouse-select-window on

