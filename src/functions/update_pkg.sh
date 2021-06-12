  update_pkg() {
  	root_check
    get_root

    if cat /etc/mpm/sources.db &> /dev/null; then
      clean_sources_db
      remove_packages

      echo "Checking for updates..."
      check_versions
    fi


    if [[ ${to_update} == "" ]]; then
      echo "No updates available"
      exit 0
    fi

  	echo "The following packages are going to be updated:"
  	echo "${to_update[@]}"
  	echo
  	read -p "Do you want to continue? [Y/n] " continue_status_temp
    export continue_status="${continue_status_temp,,}"

    if [[ "${continue_status:-y}" != "y" ]]; then
        exit 1
    fi

  	echo "Updating packages..."
  	PKG="${to_update}"

  	install_pkg

  }
