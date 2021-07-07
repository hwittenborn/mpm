check_for_mpr_control_field() {
    number=0

    string_value="$(eval echo \${control_fields[$number]})"

    while [[ "${string_value}" != "" ]]; do

        string_name="$(echo "${string_value}" | awk -F ': ' '{print $1}')"

        if [[ "${string_name}" == "MPR-Package" ]]; then
            mpr_package_field="true"
            break
        fi

        number="$(( "${number}" + 1 ))"
        string_value="$(eval echo \${control_fields[$number]})"

    done
}
