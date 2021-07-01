#!/usr/bin/env bash
set -o pipefail
set -ex

publish_github() {
    cd src/

    sudo -u user makedeb --printsrcinfo -F 'PKGBUILD.dur'
    pkgbuild_pkgver="$(sudo -u user makedeb --printsrcinfo -F 'PKGBUILD.dur' | grep 'pkgver =' | awk -F ' = ' '{print $2}')"

    curl -X 'POST' \
         -u "kavplex:${github_pat}" \
         -H 'Accept: application/vnd.github.v3+json' \
         -d "{\"tag_name\": \"v${pkgbuild_pkgver}\"}" \
         -d "{\"name\": \"v${pkgbuild_pkgver}\"}" \
         "https://api.${github_url}/repos/hwittenborn/mpm/releases"

}

# Begin Script
useradd user

chown 'user:user' * -R

rm -rf '/root/.ssh/' || true
mkdir -p '/root/.ssh/'

echo "${known_hosts}" > '/root/.ssh/known_hosts'
echo "${ssh_key}" > '/root/.ssh/dur'

chmod 400 '/root/.ssh/' -R

case "${1}" in
    github)    publish_github ;;
    dur)       publish_dur ;;
esac
