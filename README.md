# Personal Settings (Arch Linux)
This repository contains information about my current configuration.

**It is only tested in Arch Linux Rolling!**

These dotfiles are managed with
[GNU Stow](https://www.gnu.org/software/stow/).

To apply the configuration run:

```bash
stow -v $(cat .stows)
```

## Table of contents
- [Scripts](#scripts)
  - [ghdl](#ghdl)
- [Infos](#infos)
  - [neovim](#neovim)
  - [ZSH](#zsh)

---

## Scripts
### `ghdl`
`ghdl` is a simple shell script that can download assets from GitHub release
pages using the GitHub cli.

<u>Dependencies</u>:

- [GitHub CLI](https://github.com/cli/cli/blob/trunk/docs/install_linux.md#arch-linux)
- [libnewt](https://archlinux.org/packages/community/x86_64/libnewt/)

---

## Infos
### neovim
Additional Dependencies:

- [python-pynvim](https://archlinux.org/packages/community/any/python-pynvim/)

At first startup ignore the error message by pressing enter. Then run
`:PlugInstall` to install the plugins.

### ZSH
- The file [zsh/.zsh/key-bindings.zsh](./zsh/.zsh/key-bindings.zsh)
  is copied from [Oh My ZSH's GitHub](
  https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/lib/key-bindings.zsh)

