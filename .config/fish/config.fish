set -x XDG_CONFIG_HOME ~/.config

if not set -q TMUX
	exec tmux
end

functions -e fish_greeting

fish_add_path ~/.yarn/bin
fish_add_path ~/.cargo/bin
fish_add_path ~/.local/bin

alias l 'eza --git-ignore --git --header --group --icons=auto'
alias editor vim
alias vi vim
alias vim nvim

set -x BAT_THEME "Catppuccin-mocha"
set -x LS_COLORS (vivid generate catppuccin-mocha)
set -x FZF_DEFAULT_OPTS "--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

set -x MAKEFLAGS -j (lscpu --parse=CPU | grep -v '^#' | wc -l)

if status --is-interactive
  set -x GPG_TTY (tty)
  starship init fish | source
  zoxide init fish | source
  alias cat bat
  alias top btm
  alias ll 'l -l'
  alias la 'l -a'
  alias lla 'l -la'
end
