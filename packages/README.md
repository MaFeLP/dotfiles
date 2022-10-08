# Packages
## Building a package
### Non-meta packages
Before building any package, ensure coreutils, 'sd' and 'tar' are installed is
installed as a dependency. Then you can run the following one-liner, in each
directory, the package you want to install, to prepare the source .tar.gz file
with the needed configuration files:

```bash
sd 'sha256sums=\(".*"\)' "sha256sums=(\"$(tar czf files.tar.gz files/ && sha256sum files.tar.gz | cut -d' ' -f1)\")" PKGBUILD
```

Afterwards build and install the package with:

```bash
makepkg -fsci
rm -v files.tar.gz *.tar.zst
```

### Meta Packages
Just run this command, in the directory of the meta package

```bash
makepkg -fsci
rm -v *.tar.zst
```

## Packages
### utils-meta
A Metapackage (no files, just dependencies) for useful tools I use.

### ZSH-config
My personal configurations for zsh:

- environment configurations
- starship configuration
- aliases
- fuck
- other useful functions
