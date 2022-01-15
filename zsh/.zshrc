#
# zsh configuration file
# ~/.zshrc
#

################################################################################
##                             Script functions                               ##
################################################################################
# Load version control information
setopt PROMPT_SUBST
autoload -Uz vcs_info
precmd() {
  vcs_info
}
zstyle ':vcs_info:git:*' formats ' %F{magenta}  %b'


################################################################################
##                            User Configuration                              ##
################################################################################
# Configure the history
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

# Change directory by just typing its name
setopt autocd

# Extend globbing (wildcards)
setopt extendedglob

# Make the shell silent
unsetopt beep nomatch notify

# Set some environment variables
source "$HOME/.zsh/environments.zsh"

# Set some aliases
source "$HOME/.zsh/aliases.zsh"

PROMPT="%(?.%F{green}.%F{red}%? )%f%F{green}%n%F{yellow}@%F{green}%m%f %F{cyan}%B%~ %b%F{orange}$ %f%b"
RPROMPT='%F{green}[%*]${vcs_info_msg_0_}'

# Display welcome text on startup
RED="$(tput setaf 1)"
ORANGE="$(tput setaf 3)"
CYAN="$(tput setaf 6)"
echo -e "${CYAN}Welcome to ${ORANGE}ArchLinux${RED}!$CYAN Running ${ORANGE}$(pacman -Q linux)${RED}!"
echo -e "${CYAN}You are currently logged in as: ${ORANGE}$(whoami)${RED}!"

################################################################################
##                                  Plugins                                   ##
################################################################################
# Enables autocompletion
zstyle :compinstall filename "$HOME/.zshrc"
autoload -Uz compinit
compinit

# Enables more usable keys (downloaded from https://github.com/ohmyzsh/ohmyzsh)
source "$HOME/.zsh/key-bindings.zsh"
# Autosuggestions (arch package: zsh-autosuggestions)
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# syntax highlighting (arch packages: zsh-syntax-highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

