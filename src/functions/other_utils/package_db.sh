package_db() {
    database_data="$(cat /var/tmp/packages-${random_string}.db)"

    if [[ "${1}" == "add" ]]; then

        if [[ "$(echo "${database_data}" | grep -o "^${2}///")" == "" ]]; then
            echo "${database_data}" | sed "s|$|\n${2}///${3}|" | sudo tee "/var/tmp/packages-${random_string}.db" &> /dev/null
        else
            echo "${database_data}" | sed "s|^${2}///.*|${2}///${3}|" | sudo tee "/var/tmp/packages-${random_string}.db" &> /dev/null
        fi

    elif [[ "${1}" == "remove" ]]; then
        echo "${database_data}" | sed "s|^${2}///.*||" | sudo tee "/var/tmp/packages-${random_string}.db"

    fi

}
