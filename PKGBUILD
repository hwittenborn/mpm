# Author: Hunter Wittenborn <git@hunterwittenborn.me>
# Maintainer: Hunter Wittenborn <git@hunterwittenborn.me>

pkgname=mpm
pkgver=1.0.6
pkgrel=1
pkgdesc="Package manager for makedeb"
arch=('any')
depends=('makedeb' 'jq')
license=('GPL3')
url="https://github.com/hwittenborn/mpm"

source=("mpm.sh")
sha256sums=('SKIP')

package() {
  mkdir -p "${pkgdir}/usr/bin/"
  cp "${srcdir}/mpm.sh" "${pkgdir}/usr/bin/mpm"
  chmod +x "${pkgdir}/usr/bin/mpm"

  mkdir -p "${pkgdir}/etc/mpm/repo/debs"
  
  ## SET UP APT REPO ##
  mkdir -p "${pkgdir}/etc/apt/sources.list.d"
  echo "deb [trusted=yes] file:///etc/mpm/repo /" | tee "${pkgdir}/etc/apt/sources.list.d/mpm.list"
}
