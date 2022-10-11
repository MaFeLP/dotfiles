#!/usr/bin/env bash 

set -e

CUSTOM_PKGS=("custom-scripts" "zsh-config" "neovim-config")
META_PKGS=("utils-meta" "texlive-meta")

function heading {
  local width=$(tput cols 2> /dev/null)
  [ -z $width ] && width=50

  local text=$1
  # prints '#' for a whole line
  python3 -c "print('\033[0;2m\033[0;96m#' * ${width})"

  # centers the text
  python3 -c "print(' ' * ((${width} - ${#text}) // 2), end='')"
  echo "$text"

  # prints '#' for a whole line
  python3 -c "print('#' * ${width} + '\033[0;0m\033[0;2m')"
}

function install_buildaur {
  heading "Installing buildaur AUR helper..."

  local dir="$(mktemp -d)"
  local current="$(pwd)"

  rmdir "$dir"
  git clone https://aur.archlinux.org/buildaur-git.git "$dir"
  cd "$dir"
  makepkg --syncdeps
  sudo pacman --color=auto -U *.pkg.tar.zst --noconfirm
  cd "$current"
  rm -rf "$dir"

  sudo sd '#editor="nano"' 'editor="nvim"' /etc/buildaur/buildaur.conf
  sudo sd '#printer=None' 'printer="bat -P"' /etc/buildaur/buildaur.conf
}

function install_packages() {
  heading "Creating configuration packages..."
  for pkg in "${CUSTOM_PKGS[@]}";do
    (
      cd "packages/$pkg"
      sd 'sha256sums=\(".*"\)' "sha256sums=(\"$(tar czf files.tar.gz files/ && sha256sum files.tar.gz | cut -d' ' -f1)\")" PKGBUILD
      makepkg --force --clean --syncdeps
      rm -v files.tar.gz
    )
  done
  
  heading "Creating Metapackages..."
  for pkg in "${META_PKGS[@]}";do
    (
      cd "packages/$pkg"
      makepkg --force --clean --syncdeps
    )
  done
  
  heading "Installing packages..."
  sudo pacman --color=auto -U $(fd --no-ignore --extension=.pkg.tar.zst)
}

if [ "$SHELL" != "/usr/bin/zsh" ];then
  heading "Changing standard user shell..."
  sudo chsh -s /usr/bin/zsh "$(whoami)"
  mkdir -pv "$HOME/.config/zsh" "$HOME/.local/state/zsh"
  touch "$HOME/.config/zsh/.zshrc"
  sudo chsh -s /usr/bin/zsh root
  sudo mkdir -vp "/root/.config/zsh" "/root/.local/state/zsh"
  sudo touch "/root/.config/zsh/.zshrc"
fi

make_pkg=('git' 'sd' 'fd' 'bat' 'ttf-nerd-fonts-symbols-common' 'jre-openjdk' 'jdk-openjdk')
if ! pacman -Qi ${make_pkg[@]} &> /dev/null;then
  heading "Installing make dependencies..."
  sudo pacman -Syu --color=auto
  for pkg in ${make_pkg[@]};do
    if ! pacman -Qi "$pkg" &> /dev/null;then
      sudo pacman --color=auto --sync --asdeps --noconfirm --needed "$pkg"
    fi
  done
fi

sudo sd '#ParallelDownloads = 5' 'ParallelDownloads = 5' /etc/pacman.conf

if ! pacman -Qi buildaur-git &> /dev/null;then
  install_buildaur
fi

nvim_deps=(
  'nvim-packer-git'
  'cmake-language-server'
  'dockerfile-language-server'
  'java-language-server'
  'sql-language-server'
)
if ! pacman -Qi "${nvim_deps[@]}" &> /dev/null;then
  heading "Installing neovim dependencies from the AUR..."
  for dep in ${nvim_deps[@]};do
    if ! pacman -Qi "$dep" &> /dev/null;then
      buildaur -S "$dep"
      sudo pacman -D --asdeps "$dep"
    fi
  done
  
  echo -e "\n\n:: Cleaning Buildaur build cache..."
  yes | buildaur --clear
fi

install_packages

heading "Applying customizations..."
mkdir -pv ~/.config/zsh ~/.local/state/zsh
touch ~/.config/zsh/.zshrc
mkdir -pv ~/.config/nvim/
ln -sv /usr/share/neovim-config/init.lua ~/.config/nvim/init.lua 2> /dev/null || \
  echo "NeoVim Customizations already installed!"

heading "Important Information"
cat <<EOF
There will be an error, the first time NeoVim is started.
Please ignore the error and press 'enter' to continue.

After the plugins are installed, press 'q' and exit NeoVim with ':q'.
EOF
read -p "Press any key to continue..."
nvim "+PackerSync"

heading "Restart to apply all updates."

