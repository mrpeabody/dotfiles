# Dotfiles: simple edition

- crossplatform: mac/linux/wsl
- designed to be used with `stow`

## Managed settings (recommended)

This way, config files are linked to corresponding places in `$HOME`. Settings then
are updated along with this repository.

#### Bash

Link `config/home/.bashrc`:

```bash
ln -s $PWD/config/home/.bashrc ~/.bashrc
```

For extra paths, functions, aliases, and so on, add `~/.bashrc.local`. The linked `.bashrc` file
is configured to load `~/.bashrc.local` automatically, if it exists.

Here's an example of a `~/.bashrc.local` file:

```bash
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

# include NVM
source /usr/share/nvm/init-nvm.sh
```

#### Tmux

Link `config/home/.tmux.conf`:

```bash
ln -s $PWD/config/home/.tmux.conf ~/.tmux.conf
```

Clone the TMUX package manager:

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Start `tmux` and do `Ctrl + B`, then `Shift+I` to install plugins/themes.


#### Applications

Currently, the following apps' configuration are available:

- **Kitty** (terminal)
- **Flameshot** (screenshots)
- **MPV player** (hardware-accelerated videos/audios/youtube/streaming)

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


#### Application launchers (Linux only)

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
