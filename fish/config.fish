# Remove greeting message.
set fish_greeting

# Default editor.
set -gx EDITOR nvim
set -gx VISUAL $EDITOR

# GPG fix.
set -gx GPG_TTY (tty)

# Init Starship.
starship init fish | source

# Init Atuin.
atuin init fish | source

# Bun.
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# Cargo bin.
set PATH $PATH ~/.cargo/bin

# Rosé Pine Moon theme. 
# syntax highlighting variables
set -l fish_color_normal e0def4
set -l fish_color_command c4a7e7
set -l fish_color_keyword 9ccfd8
set -l fish_color_quote f6c177
set -l fish_color_redirection 3e8fb0
set -l fish_color_end 908caa
set -l fish_color_error eb6f92
set -l fish_color_param ea9a97
set -l fish_color_comment 908caa
set -l fish_color_selection --reverse
set -l fish_color_operator e0def4
set -l fish_color_escape 3e8fb0
set -l fish_color_autosuggestion 908caa
set -l fish_color_cwd ea9a97
set -l fish_color_user f6c177
set -l fish_color_host 9ccfd8
set -l fish_color_host_remote c4a7e7
set -l fish_color_cancel e0def4
set -l fish_color_search_match --background=232136
set -l fish_color_valid_path
# pager color variables
set -l fish_pager_color_progress ea9a97
set -l fish_pager_color_background --background=2a273f
set -l fish_pager_color_prefix 9ccfd8
set -l fish_pager_color_completion 908caa
set -l fish_pager_color_description 908caa
set -l fish_pager_color_secondary_background
set -l fish_pager_color_secondary_prefix
set -l fish_pager_color_secondary_completion
set -l fish_pager_color_secondary_description
set -l fish_pager_color_selected_background --background=393552
set -l fish_pager_color_selected_prefix 9ccfd8
set -l fish_pager_color_selected_completion e0def4
set -l fish_pager_color_selected_description e0def4

# Autostart Zellij on shell creation.
if set -q ZELLIJ
else
  zellij
end
