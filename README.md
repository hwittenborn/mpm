![Build Status](https://webhooks.hunterwittenborn.me/static/GitHub/mpm/build-status.svg)

## Overview ##
mpm is a package manager for [makedeb](https://github.com/hwittenborn/makedeb), allowing for installation and updates of packages from the AUR

## Installation ##
To install, run the following commands:
```sh
sudo wget 'https://hunterwittenborn.com/keys/apt.asc' -O /etc/apt/trusted.gpg.d/hwittenborn.asc
echo 'deb [arch=all] https://repo.hunterwittenborn.com/debian/makedeb any main' | sudo tee /etc/apt/sources.list.d/makedeb.list
sudo apt update
sudo apt install mpm
```

## Usage ##
Instructions can be found after installation with `mpm --help`

## Other Notes ##
- mpm will only update packages itself has installed. Likewise, if there's any AUR packages you've installed with makedeb that you'd like to to update with mpm, uninstall them and then reinstall them with mpm.

## Get in touch ##
A Matrix room is available at [#git:hunterwittenborn.com](https://matrix.to/#/#git:hunterwittenborn.com) for discussion of any of my projects. Feel free to hop in if you need any help.
