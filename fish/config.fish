source /usr/share/cachyos-fish-config/cachyos-config.fish

# Remove greeting message.
function fish_greeting
end

# Default editor.
set -gx EDITOR nvim
set -gx VISUAL $EDITOR

# GPG fix.
set -gx GPG_TTY (tty)

# Init Starship.
set -gx STARSHIP_LOG error
starship init fish | source

# Init Atuin.
atuin init fish | source

# Bun.
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# Cargo bin.
set PATH $PATH ~/.cargo/bin

# Zvm bin.
set PATH $PATH ~/.zvm/bin

# Neovim Mason bin.
set -gx PATH $HOME/.local/share/nvim/mason/bin $PATH

# Rose Pine Moon theme for fish
# https://rosepinetheme.com
# Syntax highlighting color variables
set -g fish_color_normal e0def4
set -g fish_color_command c4a7e7
set -g fish_color_keyword 9ccfd8
set -g fish_color_quote f6c177
set -g fish_color_redirection 3e8fb0
set -g fish_color_end 908caa
set -g fish_color_error eb6f92
set -g fish_color_param ea9a97
set -g fish_color_comment 908caa
set -g fish_color_selection --reverse
set -g fish_color_operator e0def4
set -g fish_color_escape 3e8fb0
set -g fish_color_autosuggestion 908caa
set -g fish_color_cwd ea9a97
set -g fish_color_user f6c177
set -g fish_color_host 9ccfd8
set -g fish_color_host_remote c4a7e7
set -g fish_color_cancel e0def4
set -g fish_color_search_match --background=232136
set -g fish_color_valid_path
# Pager color variables
set -g fish_pager_color_progress ea9a97
set -g fish_pager_color_background --background=2a273f
set -g fish_pager_color_prefix 9ccfd8
set -g fish_pager_color_completion 908caa
set -g fish_pager_color_description 908caa
set -g fish_pager_color_selected_prefix 9ccfd8
set -g fish_pager_color_selected_completion e0def4
set -g fish_pager_color_selected_description e0def4
# Custom color variables
set -g fish_color_subtle 908caa
set -g fish_color_text e0def4
set -g fish_color_love eb6f92
set -g fish_color_gold f6c177
set -g fish_color_rose ea9a97
set -g fish_color_pine 3e8fb0
set -g fish_color_foam 9ccfd8
set -g fish_color_iris c4a7e7
