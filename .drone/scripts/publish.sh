#!/usr/bin/env bash
set -o pipefail
set -ex

# User/Permission configuration
useradd user
chown 'user:user' * -R

# SSH configuration
rm -rf '/root/.ssh/' || true
mkdir -p '/root/.ssh/'

echo "${known_hosts}" > '/root/.ssh/known_hosts'
echo "${ssh_key}" > '/root/.ssh/DUR'

chmod 400 /root/.ssh/DUR /root/.ssh/known_hosts

printf "Host ${dur_url}\n  Hostname ${dur_url}\n  IdentityFile /root/.ssh/DUR\n" | tee /root/.ssh/config

# Git Shit
git config --global user.name "Kavplex Bot"
git config --global user.email "kavplex@hunterwittenborn.com"

git clone "ssh://dur@${dur_url}/mpm.git" "mpm-dur"
chown user:user 'mpm-dur' -R
cd 'mpm-dur'

rm -rf PKGBUILD
cp '../makedeb/PKGBUILD' './PKGBUILD'

sudo -u user makedeb --printsrcinfo | tee .SRCINFO
package_version="$(cat .SRCINFO | grep 'pkgver =' | awk -F ' = ' '{print $2}')"

git add PKGBUILD .SRCINFO
git commit -m "Updated version to ${package_version}"

git push
