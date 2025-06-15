# Dotfiles

- Crossplatform: MacOS/Linux/WSL
- Easy to use and modify
- Uses [**GNU Stow**](https://www.gnu.org/software/stow/)

## Quick setup

- clone this repo:

```bash
git clone https://github.com/mrpeabody/dotfiles
```

- run the `setup.sh` script:

```
./scripts/setup.sh --nvm --zsh --gui --fonts
```

That's it! This way, all required packages and fonts will be installed, config files are linked
to corresponding places in `$HOME`. Settings then are now synced with this repository.

##### Optional flags:

- `--nvm`: install, and enable [NVM](https://github.com/nvm-sh/nvm?tab=readme-ov-file#intro). 
  Comes with the current LTS version of [Node.js](https://nodejs.org/en/).
- `--zsh`: install, configure, and enable [ZSH](https://en.wikipedia.org/wiki/Z_shell) shell. 
  Comes with [oh-my-zsh](https://ohmyz.sh/) and [direnv](https://direnv.net/) enabled.
- `--gui`: install, and configure apps: 
  - [**Kitty**](https://sw.kovidgoyal.net/kitty/) (GPU-accelerated crossplatform terminal emulator)
  - [**Flameshot**](https://flameshot.org/) (best screenshot tool)
  - [**MPV player**](https://mpv.io/) (GPU-accelerated crossplatform video/audio/YouTube/streaming player)
- `--fonts`: install, and configure terminal/VIM fonts: 
  - [**FiraCode**](https://www.programmingfonts.org/#firacode) Based on Mozilla's Fira font, includes NerdFont symbols.
  - [**CascadiaCode**](https://www.programmingfonts.org/#cascadia-code) A fun, new monospaced font that includes
    programming ligatures and is designed to enhance the modern look and feel of the Windows Terminal.
    Used by default in the `kitty` configuration of this dotfiles repo.


**Bonus**: Arch users get [Paru](https://github.com/Morganamilo/paru) fully set up and configured for effortless AUR. 
It makes sense to clone and run the script in chroot after installing Arch, before rebooting into the installed system.

**Bonus**: MacOS users get [Homebrew](https://brew.sh/) -- The Missing Package Manager for macOS.


---
### Semi-automatic setup

You can run individual scripts if you don't need the whole shebang. Available scripts are:

- `scripts/install.sh` -- installs packages, such as dev dependencies, Python3, TMUX, and so on.
  - For each distro/OS, there's a corresponding intallation script, for example: `scripts/arch.sh`
- `scripts/link.sh` -- links configuration files to proper locations in the home directory, including `~/.bashrc` or `~/.zshrc`.
- `scripts/fonts.sh` -- copies and enables coding fonts in the user directory.

**link\.sh** and **install\.sh** scripts support optional flags:

- `--nvm` -- install, and enable [NVM](https://github.com/nvm-sh/nvm?tab=readme-ov-file#intro). 
  Comes with the current LTS version of [Node.js](https://nodejs.org/en/).
- `--zsh` -- install, configure, and enable [ZSH](https://en.wikipedia.org/wiki/Z_shell) shell. 
  Comes with [oh-my-zsh](https://ohmyz.sh/) and [direnv](https://direnv.net/) enabled.
- `--gui` -- install, and configure GUI apps, such as [Kitty](https://sw.kovidgoyal.net/kitty/),
  [Flameshot](https://flameshot.org/), and [MPV](https://mpv.io/)
- `--fonts`: install, and configure terminal/VIM fonts -- [**FiraCode**](https://www.programmingfonts.org/#firacode) and
  [**CascadiaCode**](https://www.programmingfonts.org/#cascadia-code) (recommended).

**link\.sh** will do the following:

- Link `.bashrc` or `.zshrc` to your home (`~`) directory
  - Notice: `~/.bashrc.local` or `~/.zshrc.local` will be loaded if it exists so that's a great place
    to add your own aliases/functions/paths, etc
- Link `.tmux.conf` to your home (`~`) directory and setup `tmux`
- If the `--gui` flag is used:
  - Link appplication settings to the `~/.config` directory
  - *For Linux distros*: create improved application launchers in `~/.local/share/applications`
  - *For Arch-based Linux distros*: chromium/electron app flags will be copied to `~/.config`

Below you can find more details about each step, and instructions on how to do these steps separately,
if so desired.


---
### Manual setup

##### Bash / ZSH

Link `config/home/.bashrc` or `config/home/.zshrc` (recommended):

```bash
ln -s $PWD/config/home/.zshrc ~/.zshrc
```


##### TMUX

Link `config/home/.tmux.conf`:

```bash
ln -s $PWD/config/home/.tmux.conf ~/.tmux.conf
```

Clone the TMUX package manager:

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Start `tmux` and do `Ctrl + B`, then `Shift+I` to install plugins/themes.


##### Applications

Currently, the following apps are installed and configured:

- *For MacOS*: [**Homebrew**](https://brew.sh/) (The Missing Package Manager for macOS)
- *For Arch-based Linux distros*: [**Paru**](https://github.com/Morganamilo/paru) (AUR Package manager)
- [**Kitty**](https://sw.kovidgoyal.net/kitty/) (GPU-accelerated crossplatform terminal emulator)
- [**Flameshot**](https://flameshot.org/) (best screenshot tool)
- [**MPV player**](https://mpv.io/) (GPU-accelerated crossplatform video/audio/YouTube/streaming player)

More apps will be added soon.

To install all app configs, navigate to `config` directory:

```bash
cd config
```

and link them:

```bash
stow -t ~/.config --ignore="home" .
```

In order to link just selected app configs, use the `--ignore` flag:

```bash
# this will only link kitty config
stow -t ~/.config --ignore="home|mpv|flameshot" .
```


##### Application launchers (Linux only)

There are a few improved application launchers (`.desktop` files) that improve overall experience with some apps:

- Kitty: includes a better app icon
- VIM: desktop launcher that's not available on Arch
- Bottom: launcher for the `btm` system monitor application
- SQLite3 Browser: Wayland-enabled launcher

```bash
mkdir -p ~/.local/share/applications
```

then copy launchers:

```bash
cp -r launchers/* ~/.local/share/applications/.
```
---

## I want my own thing!


##### Bash / ZSH

For extra paths, functions, aliases, and so on, add `~/.zshrc.local` (or `~/.bashrc.local`, for bash). 
The linked `.zshrc` file is configured to load `~/.zshrc.local` automatically, if it exists.

Here's an example of a `~/.bashc.local` file:

```bash
# different oh-my-bash theme
OSH_THEME="nekonight"

# global limits
ulimit -c unlimited
ulimit -n 65535

# settings
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# aliases
alias ll="ls -lh"

# paths
export GEM_HOME="$HOME/gems"
export PATH="$GEM_HOME/bin:$PATH"

# direnv
eval "$(direnv hook bash)"

# if you chose to install NVM, you'll see something like this, too
source /usr/share/nvm/init-nvm.sh
```

##### Kitty

Similar to `~/.bashrc.local`, **Kitty** supports `~/.config/kitty/user.conf`. You can override and/or add any
settings you like. 

Here's an example of a `~/.config/kitty/user.conf` file:

```lua
# Set your own theme
include themes/GruvboxDark.conf

# adjust font size
font_size 14

# make it look cool
background_blur 64
background_opacity 0.7
```

If this is not enough, fork, modify, and enjoy!
