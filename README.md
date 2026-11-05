# .config

My Linux desktop configuration for CachyOS with the niri window manager and the Noctalia shell.

## What is tracked

| Folder | Content |
|---|---|
| `bat/` | bat config |
| `fish/` | fish config |
| `ghostty/` | Ghostty terminal config |
| `git/` | global git config and global ignore |
| `niri/` | niri config and its Noctalia colors |
| `noctalia/` | Noctalia config and the Rosé Pine palette |
| `nvim/` | Neovim config and its plugin lock file |
| `install/` | install script and package list |

The `.gitignore` ignores everything by default. It lets through each tracked file with a `!` line. To track a new file, add its `!` line.

## Set up a fresh CachyOS install

1. Turn the existing `~/.config` into a checkout of the repo. A fresh install has no SSH key yet, so fetch over HTTPS:

   ```sh
   cd ~/.config
   git init -b main
   git remote add origin https://github.com/yamafaktory/.config.git
   git fetch origin
   git checkout -f main
   ```

   `git checkout -f` replaces the installer's versions of the tracked files. After you restore `~/.ssh`, switch the remote to SSH:

   ```sh
   git remote set-url origin git@github.com:yamafaktory/.config.git
   ```

2. Preview the install, then run it:

   ```sh
   ~/.config/install/install.sh --dry-run
   ~/.config/install/install.sh
   ```

The script does four things:

- It installs the packages in `install/packages.txt` with `paru`. The list holds what I add on top of the CachyOS installer, repo and AUR packages together.
- It adds NVIDIA's GeForce NOW Flatpak remote and installs the app.
- It starts GeForce NOW on the NVIDIA GPU, through a Flatpak override.
- It enables Docker, adds my user to the `docker` group and enables the arch-update timer.

A second run changes nothing.

## Not tracked

- Secrets, tokens and private keys
- Work config, such as the git identity under `~/cf/`
- Files that apps generate themselves
