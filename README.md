<h1 align="center">mpm</h1>
<div align="center">
<img alt="Drone CI - Stable" src="https://img.shields.io/drone/build/hwittenborn/mpm/stable?label=stable&server=https%3A%2F%2Fdrone.hunterwittenborn.com">
<img alt="Drone CI - Alpha" src="https://img.shields.io/drone/build/hwittenborn/mpm/alpha?label=alpha&server=https%3A%2F%2Fdrone.hunterwittenborn.com">
</div>

## Overview ##
mpm is a package manager for [makedeb](https://github.com/hwittenborn/makedeb), allowing for installation and updates of packages from the AUR

## Installation ##
First, set up the repository with the following commands:
```sh
sudo wget 'https://hunterwittenborn.com/keys/apt.asc' -O /etc/apt/trusted.gpg.d/hwittenborn.asc
echo 'deb [arch=all] https://repo.hunterwittenborn.com/debian/makedeb any main' | sudo tee /etc/apt/sources.list.d/makedeb.list
sudo apt update
```

Then, install mpm with one of the following commands:
- mpm (stable release):
```sh
sudo apt install mpm
```
- mpm (alpha release):
```sh
sudo apt install mpm-alpha
```

As expected, don't run the alpha release if you're expecting stability. Things could break occasionally, and you'll need to know how to get around your system when it happens.

## Usage ##
Instructions can be found after installation with `mpm --help`

Documentation on the inner working of mpm, as well as guides to contributing, are available in the [mpm wiki](https://github.com/hwittenborn/mpm/wiki).

## Other Notes ##
mpm will only update packages itself has installed. Likewise, if there's any AUR packages you've installed with makedeb that you'd like to to update with mpm, uninstall them and then reinstall them with mpm.

## Get in touch ##
A Matrix room is available at [#git:hunterwittenborn.com](https://matrix.to/#/#git:hunterwittenborn.com) for discussion of any of my projects. Feel free to hop in if you need any help.
