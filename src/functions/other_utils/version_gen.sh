version_gen() {
  source PKGBUILD
  if [[ "${epoch}" -gt "1" ]]; then
    utils_version_epoch="${epoch}:"
  fi
  echo "${utils_version_epoch}${pkgver}-${pkgrel}"
}
