  update_pkg() {
  	root_check
    get_root

    clean_sources_db
    remove_packages

    echo "Checking for updates..."
    check_versions

    if [[ ${to_update} == "" ]]; then
      echo "No updates available"
      exit 0
    fi

  	echo "The following packages are going to be updated:"
  	echo "${to_update[@]}"
  	echo
  	echo "Continue?"
  	printf "Enter yes(y) or no(n): "
  	read continue_status

  	while [[ "${continue_status}" != "yes" ]] && \
  	   [[ "${continue_status}" != "y" ]] && \
  		 [[ "${continue_status}" != "no" ]] && \
  		 [[ "${continue_status}" != "n" ]]; do
  			 echo
  	  echo "Invalid option"
  		printf "Enter yes(y) or no(n): "
  		read continue_status
  	done
    if [[ "${continue_status}" == "no" ]] || \
  	   [[ "${continue_status}" == "n" ]]; then
  	  exit 0
  	fi

  	echo "Updating packages..."
  	PKG=${to_update}

  	install_pkg

  }
