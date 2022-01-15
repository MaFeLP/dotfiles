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

################################################################################
##                          Environment Variables                             ##
################################################################################
# Adds the standard Java classpath to the Java classpath.
CLASSPATH=/home/max/.classpath/:$CLASSPATH
export CLASSPATH

export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nano'
else
  export EDITOR='nvim'
fi

# exports the school path to current year.
export SCHOOL=/mnt/Data/Schule/10a/

# Compilation flags
export ARCHFLAGS="-arch x86_64"

# flutter environment variables
export CHROME_EXECUTABLE=/usr/bin/chromium
export ANDROID_SDK_ROOT=/mnt/Data/Android_SDK

