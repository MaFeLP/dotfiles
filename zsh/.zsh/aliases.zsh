################################################################################
##                                 Aliases                                    ##
################################################################################
alias pacman="pacman --color=auto"
alias ls='ls --color=auto'
alias relax='python /home/max/.local/bin/update.py -pAs --force-aur=pokete-git,buildaur-git,firefox-nightly'
alias gimme='sudo pacman --color=always -S'
alias shutup='shutdown +0'
alias restart='shutdown +0 --reboot'
alias yeet='sudo pacman --color=always -Rusc'
alias pac-cleanup='bash /home/max/pac-cleanup.sh'
alias diskinfo='lsblk'
alias teamviewer='sudo systemctl start teamviewerd && teamviewer'
alias obs-prep='sudo modprobe v4l2loopback card_label="OBS Virtual Camera"'
alias iserv-mount='sudo mount https://webdav.gym-meiendorf.de'
alias iserv-unmount='sudo umount /mnt/IServ/'
alias cloud-mount='sudo mount //192.168.178.21/max && sudo mount //192.168.178.21/Public'
alias cloud-unmount='sudo umount /mnt/WDMyCloudMirror/max && sudo umount /mnt/WDMyCloudMirror/Public'
alias comma2dot="xmodmap -e 'keycode 91 = greater period greater period'"
alias getkeyinfo="xev | awk -F'[ )]+' '/^KeyPress/ { a[NR+2] } NR in a { printf \"%-3s %s\\n\", \$5, \$8 }'"
alias mirrorlist-update="bash /home/max/.local/bin/mirrorlist-update"
alias sleepdown='/home/max/.local/bin/sleepdown.sh'
alias screen-off='sleep 0.1 && qdbus org.kde.kglobalaccel /component/org_kde_powerdevil invokeShortcut "Turn Off Screen"'
alias gg="git gui > /dev/null &"
alias vpn="sudo openvpn /home/max/Desktop/OvpnConfigs/Maxs-Arch.ovpn"

