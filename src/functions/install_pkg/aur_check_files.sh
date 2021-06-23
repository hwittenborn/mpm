aur_check_files() {
    for i in ${aur_packages}; do
        read -p "Look over files for '${i}'? [Y/n] " check_files_temp
        export check_files="${check_files_temp,,}"

        while [[ "${check_files:-y}" != "n" ]]; do
            nano "${i}"/PKGBUILD
            source "${i}"/PKGBUILD

            num="0"
            while [[ $(eval echo \${source[${num}]}) != "" ]]; do

                if eval echo \${source[${num}]} | grep "http" &> /dev/null; then
                    num=$(( ${num} + 1 ))
                    continue
                fi

                nano "${i}"/$(eval echo \${source[${num}]} | sed 's|[^ ]*/||')
                num=$(( ${num} + 1 ))

            done
            sleep 1

            read -p "Look over files for '${i}'? [Y/n] " check_files_temp
            export check_files="${check_files_temp,,}"
        done
        echo
    done
}
