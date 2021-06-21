#!/usr/bin/env bash

# Create user
useradd user

# Set perms
chmod 777 * -R

# Configure PKGBUILD
sed -i "s|(git release)|(${release_type} release)|" src/PKGBUILD
sed -i "s|pkgname=.*|pkgname=${package_name}|" src/PKGBUILD

if [[ "${release_type}" == "stable" ]]; then
    echo 'conflicts=("mpm-alpha")' | tee -a src/PKGBUILD
elif [[ "${release_type}" == "alpha" ]]; then
    echo 'conflicts=("mpm")' | tee -a src/PKGBUILD
    sed -i "s|depends=('makedeb'|depends=('makedeb-alpha'|" src/PKGBUILD
fi

# Build makedeb
cd src
sudo -u user makedeb --nodeps
