clone_build_files() {
  # Check if clone command is being ran. If so, add up-to-date packages to list of packages to clone.
  [[ "${clone_cmd}" == "true" ]] && { export aur_packages+=" ${aur_clone_packages}"; export arch_repository_packagses+=" ${arch_clone_packages}"; }

  if [[ ${aur_packages} != "" ]]; then
    for i in ${aur_packages} ${aur_dependency_packages}; do
      echo "Cloning ${i} from the AUR..."
      git clone "${aur_url}${i}.git" &> /dev/null
    done
  fi

  if [[ ${arch_repository_packages} != "" ]]; then
    asp update &> /dev/null
    for i in ${arch_repository_packages} ${arch_dependency_packages}; do
      # Clone PKGBUILD with asp
      echo "Cloning ${i} build files from Arch Linux repositories..."
      local asp_output=$(asp checkout "${i}" &> /dev/stdout | grep "${i} is part of package" | sed "s|==> ${i} is part of package ||")

      if [[ "${asp_output}" != "" ]]; then
        mv "${asp_output}"/trunk/* "${asp_output}"/
        rm "${asp_output}"/{repos,trunk} -rf
        mv "${asp_output}" "${i}"
      else
        mv "${i}"/trunk/* "${i}"/
        rm "${i}"/{repos,trunk} -rf
      fi
    done
  fi
}
