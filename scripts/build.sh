#!/usr/bin/env bash
echo "+ Setting perms on build directory"
chmod a+rwx src/ -R

echo "+ Setting variables in PKGBUILD"
{envsubst < src/PKGBUILD; } > src/PKGBUILD

echo "+ Installing needed packages"
apt install sudo wget -y

echo "+ Setting up repository"
wget 'https://hunterwittenborn.com/keys/apt.asc' -O /etc/apt/trusted.gpg.d/hwittenborn.asc
echo 'deb [arch=all] https://repo.hunterwittenborn.com/debian/makedeb any main' | tee /etc/apt/sources.list.d/makedeb.list

echo "+ Installing latest version of makedeb"
sudo apt update
sudo apt install makedeb -y

echo "+ Building package"
cd src
sudo -u nobody makedeb
