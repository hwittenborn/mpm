## Overview ##
mpm is a package manager for [makedeb](https://github.com/hwittenborn/makedeb), allowing for installation and updates of packages from the AUR

## Installation ##
Hosting is provided by [Gemfury](https://gemfury.com/)

To install, run the following commands:
```sh
echo "deb [trusted=yes] https://apt.fury.io/hwittenborn/ /" | sudo tee /etc/apt/sources.list.d/hwittenborn.list
sudo apt update
sudo apt install mpm -y
```

## Usage ##
Instructions can be found after installation with `mpm --help`

## Other Notes ##
- mpm will only update packages itself has installed. Likewise, if there's any AUR packages you've installed with makedeb that you'd like to to update with mpm, uninstall them and then reinstall them with mpm.
