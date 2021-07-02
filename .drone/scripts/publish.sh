#!/usr/bin/env bash
set -o pipefail
set -ex

publish_github() {
    cd src/

    pkgbuild_pkgver="$(sudo -u user makedeb --printsrcinfo -F 'PKGBUILD.dur' | grep 'pkgver =' | awk -F ' = ' '{print $2}')"

    curl_output=$(curl -iX 'POST' \
                       -u "kavplex:${github_pat}" \
                       -H 'Accept: application/vnd.github.v3+json' \
                       -d "{\"tag_name\":\"v${pkgbuild_pkgver}\",\"name\":\"v${pkgbuild_pkgver}\",\"body\":\"This is an automated release. Please use the PKGBUILD on the DUR if you'd like to install.\"}" \
                       "https://api.${github_url}/repos/hwittenborn/mpm/releases")

    if [[ "$(echo "${curl_output}" | head -n 1 | grep '404')" != "" ]]; then
        exit 1
    fi
}

publish_dur() {
    git config user.name "Kavplex Bot"
    git config user.email "kavplex@hunterwittenborn.com"

    git clone "ssh://dur@${dur_url}/mpm.git" "mpm-dur"
    cd 'mpm-dur'

    rm -rf PKGBUILD
    cp '../src/PKGBUILD.dur' './PKGBUILD'

    sudo -u user makedeb --printsrcinfo | tee .SRCINFO
    package_version="$(cat .SRCINFO | grep 'pkgver =' | awk -F ' = ' '{print $2}')"

    git add PKGBUILD .SRCINFO
    git commit -m "Updated version to ${package_version}"

    git push

}
# Begin Script
useradd user

chown 'user:user' * -R

rm -rf '/root/.ssh/' || true
mkdir -p '/root/.ssh/'

echo "${known_hosts}" > '/root/.ssh/known_hosts'
echo "${ssh_key}" > '/root/.ssh/dur'

chmod 400 /root/.ssh/dur /root/.ssh/known_hosts

ssh "dur@${dur_url}"

case "${1}" in
    github)    publish_github ;;
    dur)       publish_dur ;;
esac
