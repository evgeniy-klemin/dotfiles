# dotfiles

Personal dotfiles for macOS managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Contents

| Package | Files |
|---------|-------|
| `kitty` | `.config/kitty/kitty.conf` |

## Requirements

- [Homebrew](https://brew.sh/)
- GNU Stow: `brew install stow`

## Install

```bash
git clone https://github.com/evgeniy-klemin/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow kitty
```

## Adding new packages

Create a directory with the same structure as `$HOME`, then stow it:

```bash
mkdir -p newpkg/.config/newpkg
# add config files...
stow newpkg
```
