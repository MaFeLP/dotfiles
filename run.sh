#!/usr/bin/env bash 

set -e

CUSTOM_PKGS=("custom-scripts" "zsh-config")
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
  git clone https://aur.archlinux.org/buildaur.git "$dir"
  cd "$dir"
  makepkg --syncdeps
  sudo pacman --color=auto -U *.pkg.tar.zst --noconfirm
  cd "$current"
  rm -rf "$dir"
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

heading "Installing make dependencies..."
sudo pacman -Syu --color=auto
sudo pacman --color=auto --sync --asdeps --noconfirm --needed sd fd

install_packages

install_buildaur

heading "Please restart, so the changes can take effect!"

