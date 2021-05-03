check_versions() {

  for file in ${REPO_FILES[@]}; do
    filename=$(echo ${file} | awk -F"_" '{print $1}')
    CHECK_URL="${URL}rpc.php/rpc/?v=5&type=info&arg=${filename}"

    filever=$(echo ${file} | awk -F"_" '{print $2}')
    aurver=$(curl -s "${CHECK_URL}" | jq -r '.results[].Version')

    higher_ver=$(echo ${filever} ${aurver} | sed 's/ /\n/g' | sort -V | xargs | awk '{print $2}')

    apt list ${filename} 2> /dev/null | grep "\[installed" &> /dev/null
    if [[ ${?} != "0" ]]; then
      sudo rm /etc/mpm/repo/debs/${filename}*.deb
      continue
    fi

    if [[ "${higher_ver}" != "${filever}" ]]; then
      to_update+=" ${filename}"
    fi
  done
  to_update=$(echo "${to_update[@]}" | sed 's/ /\n/g')

  if [[ "${to_update}" == "" ]]; then
    echo "No updates available"
    exit 0
  fi

}
