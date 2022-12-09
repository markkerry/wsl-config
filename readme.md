# WSL Configuration

This script is designed to be ran after Ubuntu in WSL is installed and the user has created their Unix name and password.

It automates the the following:

* Creates a `~/.hushlogin` if one does not exist
* Installs the latest OS and package updates for Ubuntu
* Installs Docker, Azure CLI and kubectl
* Enables the user to run docker commands without sudo
* Adds the user to the Docker group
* Creates a .vimrc file to customise VIM
* Backup and edit the .bashrc file with the following:
  * Sets the working directory to the home path (~) in case being launched by the Windows Terminal
  * Adds `sudo apt update && sudo apt upgrade -y` to the .bashrc file
  * Sets the Docker daemon to start automatically
  * Sets k as an alias for kubectl

## Installing WSL and Ubuntu

Run the following command to install WSL and Ubuntu 20.04 LTS. When complete reboot your machine.

```cmd
wsl --install -d Ubuntu-20.04
```

Once logged back in, oOpen WSL. You will be prompted to create you Unix username and password.

## Configure Ubuntu

To download and run the script, run the following from your terminal:

```bash
cd ~
wget -q https://raw.githubusercontent.com/markkerry/wsl-config/main/setup.sh -O - | /bin/bash
```

## Remove Ubuntu

If you want to re-install Ubuntu in WSL you can remove it as follows:

```bash
wsl --unregister Ubuntu-20.04
```

And then re-install it using the command above.
