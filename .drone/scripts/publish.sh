#!/usr/bin/env bash
set -ex
set -o pipefail

publish_github() {
    cd src/

    pkgbuild_pkgver="$(sudo -u user makedeb --printsrcinfo | grep 'pkgver =' | awk -F ' = ' '{print $2}')"

    curl -X 'POST' \
         -u "kavplex:${github_pat}" \
         -H 'Accept: application/vnd.github.v3+json' \
         -d "{\"tag_name\": \"v${pkgbuild_pkgver}\"}" \
         -d "{\"name\": \"v${pkgbuild_pkgver}\"}" \
         "https://api.${github_url}/repos/hwittenborn/mpm/releases"

}

# Begin Script
useradd user

rm -rf '/root/.ssh/' || true
mkdir -p '/root/.ssh/'

echo "${known_hosts}" > '/root/.ssh/known_hosts'
echo "${ssh_key}" > '/root/.ssh/dur'

chmod 400 '/root/.ssh/' -R

case "${1}" in
    github)    publish_github ;;
    dur)       publish_dur ;;
esac
