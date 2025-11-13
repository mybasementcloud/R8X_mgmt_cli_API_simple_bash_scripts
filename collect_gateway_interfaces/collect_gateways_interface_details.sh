#!/bin/bash
#
# (C) 2016-2025+ Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/R8X_mgmt_cli_API_bash_scripts
#
# ALL SCRIPTS ARE PROVIDED AS IS WITHOUT EXPRESS OR IMPLIED WARRANTY OF FUNCTION OR POTENTIAL FOR 
# DAMAGE Or ABUSE.  AUTHOR DOES NOT ACCEPT ANY RESPONSIBILITY FOR THE USE OF THESE SCRIPTS OR THE 
# RESULTS OF USING THESE SCRIPTS.  USING THESE SCRIPTS STIPULATES A CLEAR UNDERSTANDING OF RESPECTIVE
# TECHNOLOGIES AND UNDERLYING PROGRAMMING CONCEPTS AND STRUCTURES AND IMPLIES CORRECT IMPLEMENTATION
# OF RESPECTIVE BASELINE TECHNOLOGIES FOR PLATFORM UTILIZING THE SCRIPTS.  THIRD PARTY LIMITATIONS
# APPLY WITHIN THE SPECIFICS THEIR RESPECTIVE UTILIZATION AGREEMENTS AND LICENSES.  AUTHOR DOES NOT
# AUTHORIZE RESALE, LEASE, OR CHARGE FOR UTILIZATION OF THESE SCRIPTS BY ANY THIRD PARTY.
#
#
# -#- Start Making Changes Here -#- 
#

export DTGSDATE=`date +%Y-%m-%d-%H%M%S%Z`
export _CPRELEASEVERSION=$(cat /etc/cp-release | cut -d " " -f 4)
export _namevnow=${HOSTNAME}.${_CPRELEASEVERSION}.${DTGSDATE}
export _vnamenow=${_CPRELEASEVERSION}.${HOSTNAME}.${DTGSDATE}
export _nowvname=${DTGSDATE}.${_CPRELEASEVERSION}.${HOSTNAME}

export _work_folder=${_nowvname}.gateways
mkdir ${_work_folder}
pushd ${_work_folder}
echo `pwd`
echo

#export csvheader0='"gateway-uid", "name"'
#export csvfields0=${_gateway_uid}', .["name"]'
#echo 'csvheader0 =' ${csvheader0}
#echo 'csvfields0 =' ${csvfields0}
#echo

export csvheader1='"uid", "name", "type", "color", "comments", "topology", "ip-addresses"'
export csvfields1='.["uid"], .["name"], .["type"], .["color"], .["comments"], .["topology"], .["ip-addresses"]'
echo 'csvheader1 =' ${csvheader1}
echo 'csvfields1 =' ${csvfields1}
echo

export csvheader2='"uid", "name", "type", "color", "comments", "topology", "topology-manual", "topology-settings-manual"."ip-address-behind-this-interface", "topology-settings-manual"."specific-network", "topology-settings-manual"."interface-leads-to-dmz", "ipv4-address", "ipv4-mask-length", "dynamic-ip", "anti-spoofing", "anti-spoofing-settings"."action", "anti-spoofing-settings"."exclude-packets", "anti-spoofing-settings"."excluded-network-name", "anti-spoofing-settings"."spoof-tracking"'

export csvfields2='.["uid"], .["name"], .["type"], .["color"], .["comments"], .["topology"], .["topology-manual"], .["topology-settings-manual"]["ip-address-behind-this-interface"], .["topology-settings-manual"]["specific-network"], .["topology-settings-manual"]["interface-leads-to-dmz"], .["ipv4-address"], .["ipv4-mask-length"], .["dynamic-ip"], .["anti-spoofing"], .["anti-spoofing-settings"]["action"], .["anti-spoofing-settings"]["exclude-packets"], .["anti-spoofing-settings"]["excluded-network-name"], .["anti-spoofing-settings"]["spoof-tracking"]'
echo 'csvheader2 =' ${csvheader2}
echo 'csvfields2 =' ${csvfields2}
echo

export _gateway_show_simple_gateways_json=show_simple_gateways.${_vnamenow}.json
echo '_gateway_show_simple_gateways_json=' ${_gateway_show_simple_gateways_json}
echo
mgmt_cli -r true -f json show simple-gateways details-level full > ${_gateway_show_simple_gateways_json}

export _gateway_count=$(mgmt_cli -r true -f json show simple-gateways details-level standard | ${JQ} '. | .total')
echo
echo '_gateway_count =' ${_gateway_count}
echo

for _gateway_uid in $(mgmt_cli -r true -f json show simple-gateways details-level standard | ${JQ} '.objects[] | .uid') ; do
    echo
    echo '_gateway_uid =' ${_gateway_uid}
    echo
    
    export _gateway_name=$(mgmt_cli -r true -f json show simple-gateway uid ${_gateway_uid} details-level standard | ${JQ} -r '. | .name')
    echo '_gateway_name =' ${_gateway_name}
    echo
    
    export _gateway_show_simple_gateway_json=show_simple_gateway.${_gateway_name}.${_vnamenow}.json
    echo '_gateway_show_simple_gateway_json=' ${_gateway_show_simple_gateway_json}
    echo
    mgmt_cli -r true -f json show simple-gateway uid ${_gateway_uid} details-level full > ${_gateway_show_simple_gateway_json}
    
    export _gw_show_interfaces_file=${_gateway_name}.show_interfaces.${DTGSDATE}.csv
    echo '_gw_show_interfaces_file =' ${_gw_show_interfaces_file}
    echo
    
    echo
    echo ${csvheader1} > ${_gw_show_interfaces_file}
    mgmt_cli -r true -f json show interfaces gateway-uid ${_gateway_uid} details-level full | ${JQ} -r '.objects[] | [ '"${csvfields1}"' ] | @csv' >> ${_gw_show_interfaces_file}
    cat ${_gw_show_interfaces_file}
    echo
    
    export _gateway_show_interfaces_json=show_interfaces.${_gateway_name}.${_vnamenow}.json
    echo '_gateway_show_interfaces_json=' ${_gateway_show_interfaces_json}
    echo
    mgmt_cli -r true -f json show interfaces gateway-uid ${_gateway_uid} details-level full > ${_gateway_show_interfaces_json}
    
    export _gw_uid_interfaces_names_file=${_gateway_name}.gw_uid_interface_names.csv
    echo '_gw_uid_interfaces_names_file =' ${_gw_uid_interfaces_names_file}
    echo
    
    export csvheader0='"gateway-uid", "name"'
    export csvfields0=${_gateway_uid}', .["name"]'
    echo 'csvheader0 =' ${csvheader0}
    echo 'csvfields0 =' ${csvfields0}
    echo
    
    echo ${csvheader0} > ${_gw_uid_interfaces_names_file}
    mgmt_cli -r true -f json show interfaces gateway-uid ${_gateway_uid} details-level full | ${JQ} -r '.objects[] | [ '"${csvfields0}"' ] | @csv' >> ${_gw_uid_interfaces_names_file}
    cat ${_gw_uid_interfaces_names_file}
    echo
    
    export _gateway_show_interface_json=show_interface.${_gateway_name}.${_vnamenow}.json
    echo '_gateway_show_interface_json=' ${_gateway_show_interface_json}
    echo
    mgmt_cli -r true -f json show interface --batch ${_gw_uid_interfaces_names_file} details-level full > ${_gateway_show_interface_json}
    
    export _gw_show_interface_file=${_gateway_name}.show_interface.${DTGSDATE}.csv
    echo '_gw_show_interface_file =' ${_gw_show_interface_file}
    echo
    
    echo
    echo ${csvheader2} > ${_gw_show_interface_file}
    mgmt_cli -r true -f json show interface --batch ${_gw_uid_interfaces_names_file} details-level full | ${JQ} -r '.response[] | [ '"${csvfields2}"' ] | @csv' >> ${_gw_show_interface_file}
    cat ${_gw_show_interface_file}
    echo
    
    done

popd
echo `pwd`
echo

ls -l --color=auto ${_work_folder}

echo
