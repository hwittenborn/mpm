# Author: Hunter Wittenborn <git@hunterwittenborn.me>
# Maintainer: Hunter Wittenborn <git@hunterwittenborn.me>

pkgname=mpm
pkgver=1.0.4
pkgrel=1
pkgdesc="Package manager for makedeb"
arch=('any')
depends=('makedeb')
license=('GPL3')
url="https://github.com/hwittenborn/mpm"

source=("mpm.sh")
sha256sums=('SKIP')

package() {
  mkdir -p "${pkgdir}/usr/bin/"
  cp "${srcdir}/mpm.sh" "${pkgdir}/usr/bin/mpm"
  chmod +x "${pkgdir}/usr/bin/mpm"

  mkdir -p "${pkgdir}/etc/mpm/repo/debs"
}
