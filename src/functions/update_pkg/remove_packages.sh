remove_packages() {
  local sources_db_packages=$(cat /etc/mpm/sources.db | awk -F '\' '{print $1}' | xargs)

  for i in ${sources_db_packages}; do
    if [[ "${i}" == "" ]]; then
      continue
    fi

    if ! [[ $(apt list ${i} 2> /dev/null | grep "\[installed") ]]; then
      sed -i "s|${i}\\\\.*||" /etc/mpm/sources.db
    fi
  done

  local sources_db_packages=$(cat /etc/mpm/sources.db | awk -F '\' '{print $1}' | xargs)

  # Configure output for processing by 'grep'
  local new_sources_db_packages=$(echo "${sources_db_packages}" | sed 's| |\||g')
  local unneeded_packages=$(ls /etc/mpm/repo/debs | sed 's| |\n|g' | grep -Ev "${new_sources_db_packages}" | xargs)

  if [[ "${unneeded_packages}" != "" ]]; then

    echo "Removing unneded packages from local repository..."

    for i in ${unneeded_packages}; do
      sudo rm -f /etc/mpm/repo/debs/"${i}"*
    done
    
  fi
}
