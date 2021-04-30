print_results() {

  for pkg in $(echo ${RESULTS} | jq -r '.results[].Name'); do
    echo
    echo "$(echo ${RESULTS} | jq -r '.results[].Name' | awk NR==${PKGNUM})/$(echo ${RESULTS} | jq -r '.results[].Version' | awk NR==${PKGNUM})"
    echo "  Description: $(echo ${RESULTS} | jq -r '.results[].Description' | awk NR==${PKGNUM})"
    echo "  Votes: $(echo ${RESULTS} | jq -r '.results[].NumVotes' | awk NR==${PKGNUM})"

    MAINTAINER="$(echo ${RESULTS} | jq -r '.results[].Maintainer' | awk NR==${PKGNUM})"
    if [[ "${MAINTAINER}" == "null" ]]; then
      MAINTAINER="ORPHANED"
    fi
    echo "  Maintainer: ${MAINTAINER}"

    OUTOFDATE="$(echo ${RESULTS} | jq -r '.results[].OutOfDate' | awk NR==${PKGNUM})"
    if [[ "${OUTOFDATE}" == "null" ]]; then
      OUTOFDATE="N/A"
    else
      OUTOFDATE=$(date -d "@$(echo ${RESULTS} | jq -r '.results[].OutOfDate' | awk NR==${PKGNUM})" +%m-%d-%Y)
    fi
    echo "  Out Of Date: ${OUTOFDATE}"

    LASTMODIFIED="$(date -d @$(echo ${RESULTS} | jq -r '.results[].LastModified' | awk NR==${PKGNUM}) +%m-%d-%Y)"
    echo "  Last Modified: ${LASTMODIFIED}"

    PKGNUM=$((${PKGNUM} + 1))
  done

}
