clone_pkg() {
  # Set variable so clone_build_files() knows were running the clone command.
  # Otherwise, it would skip cloning on any packages that are up to date on the local machine.
  export clone_cmd="true"
  # Make sure folder is created and writable
  if [[ "${OUTPUT_FOLDER}" != "" ]]; then
    if ! [[ -d "${OUTPUT_FOLDER}" ]]; then
      echo "Creating folder"
      mkdir "${OUTPUT_FOLDER}"

    elif ! [[ -w "${OUTPUT_FOLDER}" ]]; then
      echo "Folder isn't writable"
      exit 1
    fi

    cd "${OUTPUT_FOLDER}"
  fi

  check_build_sources
  clone_build_files

  if [[ ${arch_repository_packages} != "" ]]; then
    echo "The following packages were cloned from the Arch Linux repositories, and will"
    echo "require the '--prebuilt' flag when building with makedeb: ${arch_repository_packages}"
  fi
}
