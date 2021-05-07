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
}
