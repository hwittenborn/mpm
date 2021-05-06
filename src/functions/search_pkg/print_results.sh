aur_print_results() {
  PKGNUM=1
  for pkg in $(echo ${aur_search_results} | jq -r '.results[].Name'); do
    echo
    echo "$(echo ${aur_search_results} | jq -r '.results[].Name' | awk NR==${PKGNUM})/$(echo ${aur_search_results} | jq -r '.results[].Version' | awk NR==${PKGNUM})  AUR"
    echo "  Description: $(echo ${aur_search_results} | jq -r '.results[].Description' | awk NR==${PKGNUM})"
    echo "  Votes: $(echo ${aur_search_results} | jq -r '.results[].NumVotes' | awk NR==${PKGNUM})"

    MAINTAINER="$(echo ${aur_search_results} | jq -r '.results[].Maintainer' | awk NR==${PKGNUM})"
    if [[ "${MAINTAINER}" == "null" ]]; then
      MAINTAINER="ORPHANED"
    fi
    echo "  Maintainer: ${MAINTAINER}"

    OUTOFDATE="$(echo ${aur_search_results} | jq -r '.results[].OutOfDate' | awk NR==${PKGNUM})"
    if [[ "${OUTOFDATE}" == "null" ]]; then
      OUTOFDATE="N/A"
    else
      OUTOFDATE=$(date -d "@$(echo ${aur_search_results} | jq -r '.results[].OutOfDate' | awk NR==${PKGNUM})" +%m-%d-%Y)
    fi
    echo "  Out Of Date: ${OUTOFDATE}"

    LASTMODIFIED="$(date -d @$(echo ${aur_search_results} | jq -r '.results[].LastModified' | awk NR==${PKGNUM}) +%m-%d-%Y)"
    echo "  Last Modified: ${LASTMODIFIED}"

    PKGNUM=$((${PKGNUM} + 1))
  done

}

arch_repository_print_results() {
  PKGNUM=1

  while [[ ${PKGNUM} -le $(echo ${arch_repository_search_results} | \
             grep pkgname | \
             sed 's|"||g' | \
             sed 's|pkgname: ||g' | \
             sed 's|,||g' | \
             sed 's| ||g' | \
             wc -w) ]]; do

    printf "\n$( echo ${arch_repository_search_results} | jq -r .results[].pkgname | awk NR==${PKGNUM} )"
    if [[ $( echo ${arch_repository_search_results} | jq -r .results[].epoch | awk NR==${PKGNUM} ) != "1" ]]; then
      printf "$( echo ${arch_repository_search_results} | jq -r .results[].pkgver | awk NR==${PKGNUM} ):"
    fi
    printf "/$( echo ${arch_repository_search_results} | jq -r .results[].pkgver | awk NR==${PKGNUM} )"
    printf -- "-$( echo ${arch_repository_search_results} | jq -r .results[].pkgrel | awk NR==${PKGNUM} )"
    printf "  Arch Repositories"

    printf "\n  Description: $( echo ${arch_repository_search_results} | jq -r .results[].pkgdesc | awk NR==${PKGNUM} )"

    # This might produce janky output if a package has multiple licenses - will
    # check when reported or when I can find a package with multiple licenses.
    printf "\n  License: $( echo ${arch_repository_search_results} | jq -r .results[].licenses[] | awk NR==${PKGNUM} )"
    printf "\n"

    PKGNUM=$(( ${PKGNUM} + 1 ))
  done
}
