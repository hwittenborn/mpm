package_db() {
    database_data="$(cat /var/tmp/sources-${random_string}.db)"

    if [[ "${1}" == "add" ]]; then

        if [[ "$(echo "${database_data}" | grep -o "^${2}///")" == "" ]]; then
            echo "${database_data}" | sed "s|$|\n${2}///${3}" | sudo tee "/var/tmp/sources-${random_string}.db"
        else
            echo "${database_data}" | sed "s|^${2}///|${2}///${3}" | sudo tee "/var/tmp/sources-${random_string}.db"
        fi

    elif [[ "${1}" == "remove" ]]; then
        echo "${database_data}" | sed "s|^${2}///.*||"

    fi

}
