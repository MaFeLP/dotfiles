################################################################################
##                                 Aliases                                    ##
################################################################################
alias pacman="pacman --color=auto"

# Make dotfiles go away
alias wget='wget --hsts-file="$XDG_DATA_HOME/wget-hsts"'
alias yarn='yarn --use-yarnrn "$XDG_CONFIG_HOME/yar/config"'

# Nice shortcuts
alias gimme='sudo pacman --color=always -S'
alias yeet='sudo pacman --color=always -Rusc'
alias shutup='shutdown +0'
alias restart='shutdown +0 --reboot'

alias gg="git gui > /dev/null &"
alias git-trust='git config --global --add safe.directory $(pwd)'

alias cl='buildaur --clear && sudo pacman -Sc && sudo journalctl --rotate && sudo journalctl --vacuum-time=10s'
alias docker-cleanup="docker image ls | grep '<none>' | cut -c 33-44 | xargs docker image rm"
alias buildaur-install="fd --no-ignore --glob '*.pkg.tar.zst' .cache/buildaur/build --exec-batch sudo pacman -U {} \;"
alias webp-convert='parallel convert {} {.}.webp \; rm {} ::: *.jpeg'

if which upower &> /dev/null;then
  alias battery="upower -i `upower -e | grep 'BAT'` | grep 'percentage' | sed -e 's/    percentage:          //g'"
fi

alias cloud-mount='sudo mount //192.168.178.21/max && sudo mount //192.168.178.21/Public'
alias cloud-unmount='sudo umount /mnt/WDMyCloudMirror/max && sudo umount /mnt/WDMyCloudMirror/Public'

if [ "$TTY" =~ \/dev\/tty[0-9]+ ];then
  # Logged in in tty
  alias eza='eza --color=auto'
  alias ll='eza -lbh --color=auto --group-directories-first --git'
  alias tree='eza --color=auto --tree'
else
  # Logged in not via tty, e.g. SSH / Desktop Environment
  alias eza='eza --icons --color=auto'
  alias ll='eza -lbh --icons --color=auto --group-directories-first --git'
  alias tree='eza --icons --color=auto --tree'
fi

