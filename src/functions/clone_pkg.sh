clone_pkg() {
  if [[ "${OUTPUT_FOLDER}" != "" ]]; then
    if ! [[ -d "${OUTPUT_FOLDER}" ]]; then
      echo "Couldn't find folder"
      exit 1

    elif ! [[ -w "${OUTPUT_FOLDER}" ]]; then
      echo "Folder isn't writable"
      exit 1
    fi

    cd "${OUTPUT_FOLDER}"
  fi

  for pkg in ${PKG}; do
    URL_SEARCH="${aur_url}rpc.php/rpc/?v=5&type=info&arg=${pkg}"
    result_count="$(curl -s ${URL_SEARCH} | jq .resultcount)"

    if [[ "${result_count}" == "0" ]]; then
      bad_pkg+=" ${pkg}"
    fi
  done

  if [[ "${bad_pkg}" != "" ]]; then
    echo "Couldn't find $(echo ${bad_pkg} | xargs | sed "s/ /, /g")"
    exit 1
  fi

  for pkg in ${PKG}; do
    echo "Cloning ${pkg}..."
    git clone "${aur_url}${pkg}.git"
  done
}
