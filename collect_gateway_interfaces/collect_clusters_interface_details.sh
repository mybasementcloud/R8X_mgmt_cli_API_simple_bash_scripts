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

export _work_folder=${_nowvname}.clusters
mkdir ${_work_folder}
pushd ${_work_folder}
echo `pwd`
echo

#export csvheader0='"gateway-uid", "name"'
#export csvfields0=${_cluster_uid}', .["name"]'
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

export _clusters_show_simple_clusters_json=show_simple_clusters.${_vnamenow}.json
echo '_clusters_show_simple_clusters_json=' ${_clusters_show_simple_clusters_json}
echo
mgmt_cli -r true -f json show simple-clusters details-level full > ${_clusters_show_simple_clusters_json}

export _cluster_count=$(mgmt_cli -r true -f json show simple-clusters details-level standard | ${JQ} '. | .total')
echo
echo '_cluster_count =' ${_cluster_count}
echo

for _cluster_uid in $(mgmt_cli -r true -f json show simple-clusters details-level standard | ${JQ} '.objects[] | .uid') ; do
    echo
    echo '_cluster_uid =' ${_cluster_uid}
    echo
    
    export _cluster_name=$(mgmt_cli -r true -f json show simple-cluster uid ${_cluster_uid} details-level standard | ${JQ} -r '. | .name')
    echo '_cluster_name =' ${_cluster_name}
    echo
    
    export _cluster_show_simple_cluster_json=show_simple_cluster.${_cluster_name}.${_vnamenow}.json
    echo '_cluster_show_simple_cluster_json=' ${_cluster_show_simple_cluster_json}
    echo
    mgmt_cli -r true -f json show simple-cluster uid ${_cluster_uid} details-level full > ${_cluster_show_simple_cluster_json}
    
    export _cluster_show_interfaces_file=${_cluster_name}.show_interfaces.${DTGSDATE}.csv
    echo '_cluster_show_interfaces_file =' ${_cluster_show_interfaces_file}
    echo
    
    echo
    echo ${csvheader1} > ${_cluster_show_interfaces_file}
    mgmt_cli -r true -f json show interfaces gateway-uid ${_cluster_uid} details-level full | ${JQ} -r '.objects[] | [ '"${csvfields1}"' ] | @csv' >> ${_cluster_show_interfaces_file}
    cat ${_cluster_show_interfaces_file}
    echo
    
    export _cluster_show_interfaces_json=show_interfaces.${_cluster_name}.${_vnamenow}.json
    echo '_cluster_show_interfaces_json=' ${_cluster_show_interfaces_json}
    echo
    mgmt_cli -r true -f json show interfaces gateway-uid ${_cluster_uid} details-level full > ${_cluster_show_interfaces_json}
    
    export _cluster_uid_interfaces_names_file=${_cluster_name}.cluster_uid_interface_names.csv
    echo '_cluster_uid_interfaces_names_file =' ${_cluster_uid_interfaces_names_file}
    echo
    
    export csvheader0='"gateway-uid", "name"'
    export csvfields0=${_cluster_uid}', .["name"]'
    echo 'csvheader0 =' ${csvheader0}
    echo 'csvfields0 =' ${csvfields0}
    echo
    
    echo ${csvheader0} > ${_cluster_uid_interfaces_names_file}
    mgmt_cli -r true -f json show interfaces gateway-uid ${_cluster_uid} details-level full | ${JQ} -r '.objects[] | [ '"${csvfields0}"' ] | @csv' >> ${_cluster_uid_interfaces_names_file}
    cat ${_cluster_uid_interfaces_names_file}
    echo
    
    export _cluster_show_interface_json=show_interface.${_cluster_name}.${_vnamenow}.json
    echo '_cluster_show_interface_json=' ${_cluster_show_interface_json}
    echo
    mgmt_cli -r true -f json show interface --batch ${_cluster_uid_interfaces_names_file} details-level full > ${_cluster_show_interface_json}
    
    export _cluster_show_interface_file=${_cluster_name}.show_interface.${DTGSDATE}.csv
    echo '_cluster_show_interface_file =' ${_cluster_show_interface_file}
    echo
    
    echo
    echo ${csvheader2} > ${_cluster_show_interface_file}
    mgmt_cli -r true -f json show interface --batch ${_cluster_uid_interfaces_names_file} details-level full | ${JQ} -r '.response[] | [ '"${csvfields2}"' ] | @csv' >> ${_cluster_show_interface_file}
    cat ${_cluster_show_interface_file}
    echo
    
    done

popd
echo `pwd`
echo

ls -l --color=auto ${_work_folder}

echo
