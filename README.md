# Personal Settings (Arch Linux)
This repository contains information about my current configuration.

**It is only tested in Arch Linux Rolling!**

These dotfiles are managed with
[GNU Stow](https://www.gnu.org/software/stow/).

To apply the configuration run:

```bash
stow -v $(cat .stows)
```

## Scripts
### `ghdl`
`ghdl` is a simple shell script that can download assets from GitHub release
pages using the GitHub cli.

Dependencies:

- [GitHub CLI](https://github.com/cli/cli/blob/trunk/docs/install_linux.md)
- [newt](https://archlinux.org/packages/community/x86_64/libnewt/)

