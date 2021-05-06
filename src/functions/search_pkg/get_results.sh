get_results() {
  if [[ $(echo ${aur_search_results} | jq -r '.resultcount') != "0" ]]; then
    aur_print_results
  fi

  if [[ $(echo ${arch_repository_search_results} | jq -r '.resultcount') != "0" ]]; then
    arch_repository_print_results
    echo " "
  fi
}
