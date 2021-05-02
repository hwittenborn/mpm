#!/usr/bin/env bash
set -e

# Install needed packages
echo "+ Installing needed packages"
apt update
apt install sudo wget -y

# Set up PKGBUILD
echo "+ Setting up PKGBUILD"
if [[ "${release_type}" == "stable" ]]; then
  export pkgname="mpm"
elif [[ "${release_type}" == "alpha" ]]; then
  export pkgname="mpm-alpha"
  sed -i "s/depends=.*/depends=('makedeb-alpha' 'jq')/" src/PKGBUILD
  sed -i "s/conflicts=.*/conflicts=('mpm')/" src/PKGBUILD
fi

for i in pkgname release_type FUNCTIONS_DIR REPO_DIR; do
  eval sed -i "s/\\${$i}/\${$i}/g" src/PKGBUILD
done

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
