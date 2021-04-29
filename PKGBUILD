# Author: Hunter Wittenborn <git@hunterwittenborn.me>
# Maintainer: Hunter Wittenborn <git@hunterwittenborn.me>

pkgname=mpm
pkgver=1.1.0
pkgrel=6
pkgdesc="Package manager for makedeb"
arch=('any')
depends=('makedeb' 'jq')
license=('GPL3')
url="https://github.com/hwittenborn/mpm"

source=("mpm.sh")

sha256sums=("SKIP")

# Variables to pass to mpm at build time. Omit the last forward slash(/) in
# the directory name.
FUNCTIONS_DIR="/usr/local/mpm"
REPO_DIR="/etc/mpm/repo"

prepare() {
  # Alter variables to use backticks as to work properly with sed section below.
  FUNCTIONS_DIR=$(echo "${FUNCTIONS_DIR}" | sed 's;/;\\/;g')
  REPO_DIR=$(echo "${REPO_DIR}" | sed 's;/;\\/;g')

  # Configure variables in mpm.sh
  sed -i "0,/FUNCTIONS_DIR.*/{s/FUNCTIONS_DIR.*/FUNCTIONS_DIR=$FUNCTIONS_DIR/}" mpm.sh
  sed -i "0,/REPO_DIR.*/{s/REPO_DIR.*/REPO_DIR=$REPO_DIR/}" mpm.sh
}

package() {
  # Copy makedeb script
  mkdir -p "${pkgdir}/usr/bin/"
  cp "${srcdir}/mpm.sh" "${pkgdir}/usr/bin/mpm"
  chmod +x "${pkgdir}/usr/bin/mpm"

  # Copy functions
  mkdir -p "${pkgdir}"/"${FUNCTIONS_DIR}/functions"
  cp -R "${startdir}"/functions/* "${pkgdir}"/"${FUNCTIONS_DIR}/functions"

  # SET UP APT REPO
  mkdir -p "${pkgdir}/etc/mpm/repo/debs"
  mkdir -p "${pkgdir}/etc/apt/sources.list.d"
  echo "deb [trusted=yes] file://${REPO_DIR} /" | tee "${pkgdir}/etc/apt/sources.list.d/mpm.list"
}
