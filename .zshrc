export EDITOR=nvim
export ZSH="$HOME/.oh-my-zsh"

# -----------------------------------------------------
# oh-myzsh themes: https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# -----------------------------------------------------
# ZSH_THEME=robbyrussell

plugins=(
    git
    sudo
    web-search
    archlinux
    zsh-autosuggestions
    zsh-syntax-highlighting
    fast-syntax-highlighting
    copyfile
    copybuffer
    dirhistory
)

source <(fzf --zsh)

# zsh history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# Super basic prompt
PROMPT="┌[%T]-[%n]-[%~]
└─> "

precmd() {
  # Set terminal title to "kitty [current directory]"
  print -Pn "\e]0;  %~\a"
}

preexec() {
  # Set terminal title to "kitty [current directory]"
  print -Pn "\e]0;  %~\a"
}

# -----------------------------------------------------
# ALIASES
# -----------------------------------------------------
alias c='clear'
alias ff='fastfetch'
alias ls='eza -a --icons=always'
alias ll='eza -al --icons=always'
alias lt='eza -a --tree --level=1 --icons=always'
alias shutdown='systemctl poweroff'
alias v='$EDITOR'
alias vim='$EDITOR'
alias wifi='nmtui'

# -----------------------------------------------------
# Navigation Shortcuts
# -----------------------------------------------------
 alias ..='cd ..'
 alias ...='cd ../..'
 alias .3='cd ../../..'
 alias .4='cd ../../../..'
 alias .5='cd ../../../../..'

# -----------------------------------------------------
# Window Managers
# -----------------------------------------------------
alias Qtile='startx'

# -----------------------------------------------------
# System
# -----------------------------------------------------
alias update-grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'

# -----------------------------------------------------
# Qtile
# -----------------------------------------------------
alias res1='xrandr --output DisplayPort-0 --mode 2560x1440 --rate 120'
alias res2='xrandr --output DisplayPort-0 --mode 1920x1080 --rate 120'
alias setkb='setxkbmap de;echo "Keyboard set back to de."'

# -----------------------------------------------------
# Pywal
# -----------------------------------------------------
cat ~/.cache/wal/sequences
