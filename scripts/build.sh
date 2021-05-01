#!/usr/bin/env bash
set -e

# Set up PKGBUILD
echo "+ Setting up PKGBUILD"
{ envsubst < src/PKGBUILD; } > src/PKGBUILD

# Install needed packages
echo "+ Installing needed packages"
apt update
apt install sudo wget -y

# Set up repository and install makedeb
echo "+ Setting up repository"
wget 'https://hunterwittenborn.com/keys/apt.asc' -O /etc/apt/trusted.gpg.d/hwittenborn.asc
echo 'deb [arch=all] https://repo.hunterwittenborn.com/debian/makedeb any main' | sudo tee /etc/apt/sources.list.d/makedeb.list

echo "+ Installing makedeb"
apt update
apt install makedeb -y

# Set folder perms and build mpm
echo "+ Setting folder perms"
chmod a+rwx src -R

echo "+ Building mpm"
cd src
sudo -u nobody makedeb
