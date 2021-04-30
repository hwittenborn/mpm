check_packages() {

  for package in ${PKG}; do
    CHECK_URL="${URL}rpc.php/rpc/?v=5&type=info&arg=${package}"
    RESULTS=$(curl -s "${CHECK_URL}" | jq)

    if [[ $(echo ${RESULTS} | jq -r '.resultcount') == "0" ]]; then
      FIND_NULL+=" ${package}"
    fi

    FIND_NULL=$(echo "${FIND_NULL}" | sed 's/ //')
    if [[ ${FIND_NULL} != "" ]]; then
      echo "Couldn't find package(s) ${FIND_NULL}"
      exit 1
    fi

  done

}
