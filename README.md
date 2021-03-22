## Overview ##
mpm is a package manager for [makedeb](https://github.com/hwittenborn/makedeb), allowing for installation and updates of packages from the AUR

## Installation ##
To install, run the following:
```sh
echo "deb [trusted=yes] https://repo.hunterwittenborn.me/apt/ /" | sudo tee /etc/apt/sources.list.d/hunterwittenborn.me.list
sudo apt update
sudo apt install mpm -y
```

## Usage ##
Instructions can be found after installation with `mpm --help`

## Other Notes ##
- mpm will only update packages itself has installed. Likewise, if there's any AUR packages you've installed with makedeb that you'd like to to update with mpm, uninstall them and then reinstall them with mpm.
