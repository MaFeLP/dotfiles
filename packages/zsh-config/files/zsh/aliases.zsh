################################################################################
##                                 Aliases                                    ##
################################################################################
# Enable colors
alias pacman="pacman --color=auto"
alias ls='ls --color=auto'
alias exa='exa --icons --color=auto'

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

alias teamviewer='sudo systemctl start teamviewerd && teamviewer'
alias obs-prep='sudo modprobe v4l2loopback card_label="OBS Virtual Camera" && sudo modprobe videodev'

alias comma2dot="xmodmap -e 'keycode 91 = greater period greater period'"
alias getkeyinfo="xev | awk -F'[ )]+' '/^KeyPress/ { a[NR+2] } NR in a { printf \"%-3s %s\\n\", \$5, \$8 }'"
alias ll='exa -lbh --icons --color=auto --group-directories-first'
alias tree='exa --icons --color=auto --tree'
alias cl='buildaur --clear && sudo pacman -Sc && sudo journalctl --rotate && sudo journalctl --vacuum-time=10s'
alias docker-cleanup="docker image ls | grep '<none>' | cut -c 33-44 | xargs docker image rm"
alias buildaur-install="fd --no-ignore --glob '*.pkg.tar.zst' .cache/buildaur/build --exec-batch sudo pacman -U {} \;"
alias webp-convert='parallel convert {} {.}.webp \; rm {} ::: *.jpeg'

alias vpn="sudo openvpn /home/max/Desktop/OvpnConfigs/Maxs-Arch.ovpn"
alias joplin="/usr/bin/joplin; /usr/bin/joplin sync"

if which upower &> /dev/null;then
  alias battery="upower -i `upower -e | grep 'BAT'` | grep 'percentage' | sed -e 's/    percentage:          //g'"
fi

alias restart_plasma="kquitapp5 plasmashell && kstart5 plasmashell"

alias iserv-mount='sudo mount https://webdav.gym-meiendorf.de'
alias iserv-unmount='sudo umount /mnt/IServ/'
alias cloud-mount='sudo mount //192.168.178.21/max && sudo mount //192.168.178.21/Public'
alias cloud-unmount='sudo umount /mnt/WDMyCloudMirror/max && sudo umount /mnt/WDMyCloudMirror/Public'
