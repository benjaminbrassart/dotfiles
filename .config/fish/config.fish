set -x XDG_CONFIG_HOME ~/.config

functions -e fish_greeting

fish_add_path -a ~/.{yarn,cargo,local}/bin

alias l 'eza --git-ignore --git --header --group --icons=auto'
alias editor vim
alias vi vim
alias vim nvim

set -x LS_COLORS (vivid generate catppuccin-mocha)

set -x SKIM_DEFAULT_OPTIONS "--color=fg:#cdd6f4,bg:#1e1e2e,matched:#313244,matched_bg:#f2cdcd,current:#cdd6f4,current_bg:#45475a,current_match:#1e1e2e,current_match_bg:#f5e0dc,spinner:#a6e3a1,info:#cba6f7,prompt:#89b4fa,cursor:#f38ba8,selected:#eba0ac,header:#94e2d5,border:#6c7086"

set CPU_COUNT (lscpu --parse=CPU | grep -v '^#' | wc -l)
set -x MAKEFLAGS -j $CPU_COUNT

if status --is-interactive
  set -x GPG_TTY (tty)
  starship init fish | source
  zoxide init fish | source
  alias cat bat
  alias top btm
  alias ll 'l -l'
  alias la 'l -a'
  alias lla 'l -la'
  alias fzf sk
end
