build_arch_packages() {
  for i in ${arch_repository_packages}; do
      build_package "${i}" "arch_repository"
  done
}
