################################################################################
##                               Add to PATH                                  ##
################################################################################
# Adds ~/.local/bin to the path:
# contains local programs, not installed with pacman
if [ -d $HOME/.local/bin ]; then
  export PATH="$PATH:$HOME/.local/bin"
fi

# Adds gems installed with ruby to the path.
if [ -d "${HOME}/.local/share/gem/ruby/2.7.0/bin/" ]; then
  export PATH="$PATH:$HOME/.local/share/gem/ruby/2.7.0/bin/"
fi

# Adds cargo crates installed with cargo to the path.
if [ -d "${HOME}/.cargo/bin" ]; then
  export PATH="$PATH:$HOME/.cargo/bin/"
fi

# Adds go projects to the PATH
if [ -d "${HOME}/go/bin/" ]; then
  export PATH="$PATH:$HOME/go/bin/"
fi

if [ -d "${HOME}/.pub-cache/bin/" ]; then
  export PATH="$PATH:${HOME}/.pub-cache/bin"
fi


# exports the school path to current year.
export SCHOOL=/mnt/Data/Schule/Canada/

################################################################################
##                          Other useful variables                            ##
################################################################################
export today="$(date +"%Y-%m-%d")"

