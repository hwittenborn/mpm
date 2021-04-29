source <(cat PKGBUILD | grep -E 'pkgname=|pkgver=')

sed -i "0,/pkgname.*/{s/pkgname.*/pkgname=$pkgname-alpha/}" PKGBUILD
sed -i "0,/pkgver.*/{s/pkgver.*/pkgver=$pkgver\alpha/}" PKGBUILD
