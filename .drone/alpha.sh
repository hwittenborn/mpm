source <(cat PKGBUILD | grep -E 'pkgname=|pkgver=')

sed "0,/pkgname.*/{pkgname.*/pkgname=$pkgname-alpha}" PKGBUILD
sed "0,/pkgver.*/{pkgver.*/pkgver=$pkgver-alpha}" PKGBUILD
