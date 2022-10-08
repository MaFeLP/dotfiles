# Personal dotfiles
## Installation
1. Boot the ISO and run the following command:

```bash
archinstall --config "https://raw.githubusercontent.com/MaFeLP/dotfiles/main/archinstall_user.json"
```

2. Configure the new user
3. Configure the disk layout you want to use (recommended with btrfs)
4. Install ArchLinux using the installer
5. Boot ArchLinux and login with your new user
6. Change the shell of the current user and re-log-in:

```bash
sudo chsh $(whoami) -s /bin/zsh
```

7. Run the `cli.yml` playbook:

```bash
ansible-playbook cli.yml
```

8. Run one of the two playbooks:
   - `KDE.yml`: Use when you want a KDE Desktop
   - `Sway.yml`: Use when you want the Sway Window Manager

```bash
ansible-playbook <PLAYBOOK>
```
