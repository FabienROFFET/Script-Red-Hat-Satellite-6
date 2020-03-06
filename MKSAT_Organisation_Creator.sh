#!/bin/bash

###################################################################
#Script Name    :MKSAT_Organisation_Creator.sh
#Description    :CREATE ORGANISATION,VIEWS AND KEYS
#Args           :-o -m -v -c
#Author         :Fabien Roffet
#Email          :fabien.roffet@gmail.com
###################################################################

####################
# FONCTION
####################

usage(){
echo "Exemple : $0 -o ORG_UFLEX3_ABC -m /root/manifest/manifest_ORG_ABC_20191126T123456Z.zip -v 6.5 -c no" 1>&2
exit 1
}

###################
# MENU
###################
while getopts ":o:m:v:c:" x; do
    case "${x}" in
        o)
            o=${OPTARG}
            SET_ORG=$o
            ;;
        m)
            m=${OPTARG}
            SET_PATH_MANIFEST=$m
            ;;
        v)
            v=${OPTARG}
            SET_SAT_VER=$v
            ;;
        c)
            c=${OPTARG}
            SET_CAPSULE=$c
            ;;
        *) usage ;;
    esac
done

shift $((OPTIND-1))

#if [ -z "${o}" ] || [ -z "${m}" ] || [ -z "${v}" || [ -z "${c}" ]
#    then
#         usage
#fi

####################
# MAIN SCRIPT
####################

# Create a New Org
echo "CREATE : ORGANISATION"
hammer organization create --name "$SET_ORG" --description "$SET_ORG"
hammer organization list | grep $SET_ORG >> /dev/null
if [ $? -eq 0 ]
    then
        echo "ADD : ORGANISATION : OKAY"
    else
        echo "ADD : ORGANISATION : ERROR"
fi

# Add Sub. manifest
echo "ADD : MANIFEST"
hammer subscription upload --organization "$SET_ORG" --file $SET_PATH_MANIFEST 2> /dev/null
if [ $? -eq 0 ]
    then
        echo "ADD : MANIFEST : OKAY"
    else
        echo "ADD : MANIFEST : ERROR"
fi

echo "#################################################"
echo "# START CREATE THE ORGANISATION     "
echo "#################################################"

echo $SET_CAPSULE

if [ $SET_CAPSULE == "no" ]
    then

#Add Classic Red Hat Repo RHEL 6 and RHEL 7 :
echo "CHECK : hammer repository-set list --organization" $SET_ORG

#RHEL 7 :
echo "ADD : REPO RHEL 7"
hammer repository-set enable --organization "$SET_ORG" --product "Red Hat Enterprise Linux Server" --basearch="x86_64" --releasever="7Server" --name "Red Hat Enterprise Linux 7 Server (RPMs)"
hammer repository-set enable --organization "$SET_ORG" --product "Red Hat Enterprise Linux Server" --basearch="x86_64" --releasever="7Server" --name "Red Hat Enterprise Linux 7 Server - Optional (RPMs)"
hammer repository-set enable --organization "$SET_ORG" --product "Red Hat Enterprise Linux Server" --basearch="x86_64" --releasever="7Server" --name "Red Hat Enterprise Linux 7 Server - Extras (RPMs)"
hammer repository-set enable --organization "$SET_ORG" --product "Red Hat Enterprise Linux Server" --basearch="x86_64" --releasever="7Server" --name "Red Hat Satellite Tools $SET_SAT_VER (for RHEL 7 Server) (RPMs)"
hammer repository-set enable --organization "$SET_ORG" --product "Red Hat Enterprise Linux Server" --basearch="x86_64" --releasever="7Server" --name "Red Hat Enterprise Linux 7 Server - Supplementary (RPMs)"

#RHEL 6 :
echo "ADD : REPO RHEL 6"
hammer repository-set enable --organization "$SET_ORG" --product "Red Hat Enterprise Linux Server" --basearch="x86_64" --releasever="6Server" --name "Red Hat Enterprise Linux 6 Server (RPMs)"
hammer repository-set enable --organization "$SET_ORG" --product "Red Hat Enterprise Linux Server" --basearch="x86_64" --releasever="6Server" --name "Red Hat Enterprise Linux 6 Server - Optional (RPMs)"
hammer repository-set enable --organization "$SET_ORG" --product "Red Hat Enterprise Linux Server" --basearch="x86_64" --releasever="6Server" --name "Red Hat Enterprise Linux 6 Server - Extras (RPMs)"
hammer repository-set enable --organization "$SET_ORG" --product "Red Hat Enterprise Linux Server" --basearch="x86_64" --releasever="6Server" --name "Red Hat Satellite Tools $SET_SAT_VER (for RHEL 6 Server) (RPMs)"
hammer repository-set enable --organization "$SET_ORG" --product "Red Hat Enterprise Linux Server" --basearch="x86_64" --releasever="6Server" --name "Red Hat Enterprise Linux 6 Server - Supplementary (RPMs)"

# Software Collections RHEL 7
echo "ADD : REPO SOFTWARE COLLECTION 7"
hammer repository-set enable --organization "$SET_ORG" --product "Red Hat Software Collections for RHEL Server" --basearch="x86_64" --releasever "7Server" --name "Red Hat Software Collections RPMs for Red Hat Enterprise Linux 7 Server"

# Software Collections RHEL 6
echo "ADD : REPO SOFTWARE COLLECTION 6"
hammer repository-set enable --organization "$SET_ORG" --product "Red Hat Software Collections for RHEL Server" --basearch="x86_64" --releasever "6Server" --name "Red Hat Software Collections RPMs for Red Hat Enterprise Linux 6 Server"

#Add EPEL 7 - 6 :
echo "ADD : REPO EPEL 6/7"
hammer product create --name="EPEL" --organization=$SET_ORG
hammer repository create --name="EPEL 7 - x86_64" --organization=$SET_ORG --product="EPEL" --content-type="yum" --publish-via-http=true --url=http://dl.fedoraproject.org/pub/epel/7/x86_64/
hammer repository create --name="EPEL 6 - x86_64" --organization=$SET_ORG --product="EPEL" --content-type="yum" --publish-via-http=true --url=http://dl.fedoraproject.org/pub/epel/6/x86_64/

#Add Oracle Linux 7 :
echo "ADD : REPO ORACLE LINUX 7"
hammer product create --name="Oracle Linux" --organization=$SET_ORG
hammer repository create --name="OL 7 - x86_64" --organization=$SET_ORG --product="Oracle Linux" --content-type="yum" --publish-via-http=true --url=http://yum.oracle.com/repo/OracleLinux/OL7/latest/x86_64
hammer repository create --name="OL7 UEKR5 - x86_64" --organization=$SET_ORG --product="Oracle Linux" --content-type="yum" --publish-via-http=true --url=https://yum.oracle.com/repo/OracleLinux/OL7/UEKR5/x86_64

#Add Centos Linux 7 - 6 :
echo "ADD : REPO CENTOS 6/7"
hammer product create --name="Centos" --organization=$SET_ORG
hammer repository create --name="Centos 7 - x86_64" --organization=$SET_ORG --product="Centos" --content-type="yum" --publish-via-http=true --url=http://centos.mirror.root.lu/7/os/x86_64/
hammer repository create --name="Centos 6 - x86_64" --organization=$SET_ORG --product="Centos" --content-type="yum" --publish-via-http=true --url=http://centos.mirror.root.lu/6/os/x86_64/

# Katello For Centos
echo "ADD : REPO KATELLO CENTOS 6/7"
hammer product create --name="Katello for Centos" --organization=$SET_ORG
hammer repository create --name="Katello 7 - x86_64" --organization=$SET_ORG --product="Katello for Centos" --content-type="yum" --publish-via-http=true --url=https://fedorapeople.org/groups/katello/releases/yum/latest/client/el7/x86_64/

#Force Changing download policy to "immediate" for all Org and all Prod
echo "SET : DOWNLOAD POLICY TO IMMEDIATE"
foreman-rake katello:change_download_policy DOWNLOAD_POLICY=immediate

#Create Sync Plan :
echo "CREATE : SYNC PLAN"
hammer sync-plan create --name "SYNC_$SET_ORG" --enabled=true --interval daily --organization "$SET_ORG" --sync-date "$(date "+%Y-%m-%d") 00:00:00"

#Add Sync :
hammer product set-sync-plan --organization-label "$SET_ORG" --name "Red Hat Enterprise Linux Server" --sync-plan SYNC_$SET_ORG
hammer product set-sync-plan --organization-label "$SET_ORG" --name "Red Hat Software Collections for RHEL Server" --sync-plan SYNC_$SET_ORG
hammer product set-sync-plan --organization-label "$SET_ORG" --name "EPEL" --sync-plan SYNC_$SET_ORG
hammer product set-sync-plan --organization-label "$SET_ORG" --name "Oracle Linux" --sync-plan SYNC_$SET_ORG
hammer product set-sync-plan --organization-label "$SET_ORG" --name "Centos" --sync-plan SYNC_$SET_ORG
hammer product set-sync-plan --organization-label "$SET_ORG" --name "Katello for Centos" --sync-plan SYNC_$SET_ORG

echo "########################################"
echo "# CREATION ORGANISATION $SET_ORG DONE  "
echo "########################################"


# Need to use more Variable for the name of content

# Creation Composite View BASE
echo "CREATE : CONTENT VIEW BASE - RHEL 7"
hammer content-view create --organization "$SET_ORG" --name "Content_RHEL7_Base" --label Content_RHEL7_Base --description "Base RHEL 7"
hammer content-view add-repository --organization "$SET_ORG" --name "Content_RHEL7_Base" --product "Red Hat Enterprise Linux Server" --repository "Red Hat Enterprise Linux 7 Server RPMs x86_64 7Server"
hammer content-view add-repository --organization "$SET_ORG" --name "Content_RHEL7_Base" --product "Red Hat Enterprise Linux Server" --repository "Red Hat Enterprise Linux 7 Server - Optional RPMs x86_64 7Server"
hammer content-view add-repository --organization "$SET_ORG" --name "Content_RHEL7_Base" --product "Red Hat Enterprise Linux Server" --repository "Red Hat Enterprise Linux 7 Server - Extras RPMs x86_64 7Server"
hammer content-view add-repository --organization "$SET_ORG" --name "Content_RHEL7_Base" --product "Red Hat Enterprise Linux Server" --repository "Red Hat Enterprise Linux 7 Server - Supplementary RPMs x86_64 7Server"

echo "CREATE : CONTENT VIEW BASE - RHEL 6"
hammer content-view create --organization "$SET_ORG" --name "Content_RHEL6_Base" --label Content_RHEL6_Base --description "Base RHEL 6"
hammer content-view add-repository --organization "$SET_ORG" --name "Content_RHEL6_Base" --product "Red Hat Enterprise Linux Server" --repository "Red Hat Enterprise Linux 6 Server RPMs x86_64 6Server"
hammer content-view add-repository --organization "$SET_ORG" --name "Content_RHEL6_Base" --product "Red Hat Enterprise Linux Server" --repository "Red Hat Enterprise Linux 6 Server - Optional RPMs x86_64 6Server"
hammer content-view add-repository --organization "$SET_ORG" --name "Content_RHEL6_Base" --product "Red Hat Enterprise Linux Server" --repository "Red Hat Enterprise Linux 6 Server - Extras RPMs x86_64 6Server"
hammer content-view add-repository --organization "$SET_ORG" --name "Content_RHEL6_Base" --product "Red Hat Enterprise Linux Server" --repository "Red Hat Enterprise Linux 6 Server - Supplementary RPMs x86_64 6Server"

# Creation Composite View SATELLITE
echo "CREATE : CONTENT VIEW BASE - RHEL7 SATELLITE " $SET_SAT_VER
hammer content-view create --organization "$SET_ORG" --name "Content_RHEL7_Satellite_tools" --label Content_RHEL7_Satellite_tools --description "Satellite Tools RHEL 7"
hammer content-view add-repository --organization "$SET_ORG" --name "Content_RHEL7_Satellite_tools" --product "Red Hat Enterprise Linux Server" --repository "Red Hat Satellite Tools $SET_SAT_VER for RHEL 7 Server RPMs x86_64 7Server"

echo "CREATE : CONTENT VIEW BASE - RHEL6 SATELLITE " $SET_SAT_VER
hammer content-view create --organization "$SET_ORG" --name "Content_RHEL6_Satellite_tools" --label Content_RHEL6_Satellite_tools --description "Satellite Tools RHEL 6"
hammer content-view add-repository --organization "$SET_ORG" --name "Content_RHEL6_Satellite_tools" --product "Red Hat Enterprise Linux Server" --repository "Red Hat Satellite Tools $SET_SAT_VER for RHEL 6 Server RPMs x86_64 6Server"

# PUBLISH
echo "PUBLISH : LAST CONTENT VIEW"
hammer content-view publish --organization "$SET_ORG" --name Content_RHEL7_Base --description "Initial Publishing"
hammer content-view publish --organization "$SET_ORG" --name Content_RHEL6_Base --description "Initial Publishing"
hammer content-view publish --organization "$SET_ORG" --name Content_RHEL7_Satellite_tools --description "Initial Publishing"
hammer content-view publish --organization "$SET_ORG" --name Content_RHEL6_Satellite_tools --description "Initial Publishing"

# PROMOTE
echo "PROMOTE : LAST CONTENT VIEW"
hammer content-view version promote --organization "$SET_ORG" --content-view Content_RHEL7_Base --to-lifecycle-environment Library --version 1 --force
hammer content-view version promote --organization "$SET_ORG" --content-view Content_RHEL6_Base --to-lifecycle-environment Library --version 1 --force
hammer content-view version promote --organization "$SET_ORG" --content-view Content_RHEL7_Satellite_tools --to-lifecycle-environment Library --version 1 --force
hammer content-view version promote --organization "$SET_ORG" --content-view Content_RHEL6_Satellite_tools --to-lifecycle-environment Library --version 1 --force

# The Composite view is based
CONTENTRHEL7BASE=`hammer content-view info --name "Content_RHEL7_Base" --organization "$SET_ORG" | grep "Versions:" -A 1 | grep ID: | awk '{print $3}'`
CONTENTSAT7=`hammer content-view info --name "Content_RHEL7_Satellite_tools" --organization "$SET_ORG" | grep "Versions:" -A 1 | grep ID: | awk '{print $3}'`
CONTENTRHEL6BASE=`hammer content-view info --name "Content_RHEL6_Base" --organization "$SET_ORG" | grep "Versions:" -A 1 | grep ID: | awk '{print $3}'`
CONTENTSAT6=`hammer content-view info --name "Content_RHEL6_Satellite_tools" --organization "$SET_ORG" | grep "Versions:" -A 1 | grep ID: | awk '{print $3}'`

# Create Composite RHEL7 View for the Activation Key
echo "CREATE : COMPOSITE VIEW BASE RHEL 7"
hammer content-view create --composite --organization "$SET_ORG" --name "Composite_RHEL7_BASE" --label "Composite_RHEL7_BASE" --description "Composite View RHEL7 Base" --component-ids $CONTENTRHEL7BASE,$CONTENTSAT7

echo "CREATE : COMPOSITE VIEW BASE RHEL 6"
hammer content-view create --composite --organization "$SET_ORG" --name "Composite_RHEL6_BASE" --label "Composite_RHEL6_BASE" --description "Composite View RHEL6 Base" --component-ids $CONTENTRHEL6BASE,$CONTENTSAT6

# PUBLISH
echo "PUBLISH : LAST COMPOSITE VIEW"
hammer content-view publish --organization "$SET_ORG" --name Composite_RHEL7_BASE --description "Initial Publishing"
hammer content-view publish --organization "$SET_ORG" --name Composite_RHEL6_BASE --description "Initial Publishing"

# PROMOTE
echo "PROMOTE : LAST COMPOSITE VIEW"
hammer content-view version promote --organization "$SET_ORG" --content-view Composite_RHEL7_BASE --to-lifecycle-environment Library --version 1 --force
hammer content-view version promote --organization "$SET_ORG" --content-view Composite_RHEL6_BASE --to-lifecycle-environment Library --version 1 --force

echo "########################################"
echo "# CREATION COMPOSITE VIEW $SET_ORG DONE "
echo "########################################"

hammer activation-key create --organization="$SET_ORG" --name="KEY_RHEL6_BASE" --unlimited-hosts --lifecycle-environment="Library" --content-view='Composite_RHEL6_BASE'
SET_SUB_ID=`hammer --output='csv' subscription list --organization=$SET_ORG --search='Red Hat Satellite \- Add-Ons for Providers' | tail -n+2 | head -n1 | cut -d',' -f1`
hammer activation-key add-subscription --organization="$SET_ORG" --name="KEY_RHEL6_BASE" --subscription-id=$SET_SUB_ID
hammer activation-key content-override --organization="$SET_ORG" --name="KEY_RHEL6_BASE" --content-label="rhel-6-server-rpms" --value=1
hammer activation-key content-override --organization="$SET_ORG" --name="KEY_RHEL6_BASE" --content-label="rhel-server-rhscl-6-rpms" --value=1
hammer activation-key content-override --organization="$SET_ORG" --name="KEY_RHEL6_BASE" --content-label="rhel-6-server-supplementary-rpms" --value=1
hammer activation-key content-override --organization="$SET_ORG" --name="KEY_RHEL6_BASE" --content-label="rhel-6-server-optional-rpms" --value=1
hammer activation-key content-override --organization="$SET_ORG" --name="KEY_RHEL6_BASE" --content-label="rhel-6-server-extras-rpms" --value=1
hammer activation-key content-override --organization="$SET_ORG" --name="KEY_RHEL6_BASE" --content-label="rhel-6-server-satellite-tools-6.5-rpms" --value=1

hammer activation-key create --organization="$SET_ORG" --name="KEY_RHEL7_BASE" --unlimited-hosts --lifecycle-environment="Library" --content-view='Composite_RHEL7_BASE'
SET_SUB_ID=`hammer --output='csv' subscription list --organization=$SET_ORG --search='Red Hat Satellite \- Add-Ons for Providers' | tail -n+2 | head -n1 | cut -d',' -f1`
hammer activation-key add-subscription --organization="$SET_ORG" --name="KEY_RHEL7_BASE" --subscription-id=$SET_SUB_ID
hammer activation-key content-override --organization="$SET_ORG" --name="KEY_RHEL7_BASE" --content-label="rhel-7-server-rpms" --value=1
hammer activation-key content-override --organization="$SET_ORG" --name="KEY_RHEL7_BASE" --content-label="rhel-server-rhscl-7-rpms" --value=1
hammer activation-key content-override --organization="$SET_ORG" --name="KEY_RHEL7_BASE" --content-label="rhel-7-server-supplementary-rpms" --value=1
hammer activation-key content-override --organization="$SET_ORG" --name="KEY_RHEL7_BASE" --content-label="rhel-7-server-optional-rpms" --value=1
hammer activation-key content-override --organization="$SET_ORG" --name="KEY_RHEL7_BASE" --content-label="rhel-7-server-extras-rpms" --value=1
hammer activation-key content-override --organization="$SET_ORG" --name="KEY_RHEL7_BASE" --content-label="rhel-7-server-satellite-tools-$SET_SAT_VER -rpms" --value=1

echo "########################################"
echo "# CREATION ACTIVATION KEY $SET_ORG DONE "
echo "########################################"

else

echo "########################################"
echo "# CREATION : CAPSULE                    "
echo "########################################"

if [ $SET_SAT_VER == 6.5 ] ; then

echo "CREATE : REPOSITORY SATELLITE 6.5"



echo "CHANGE : DOWNLOAD POLICY FOR ALL REPOSITORY"
foreman-rake katello:change_download_policy DOWNLOAD_POLICY=immediate

echo "CREATE : SYNC PLAN"
hammer sync-plan create --name "SYNC_$SET_ORG" --enabled=true --interval daily --organization "$SET_ORG" --sync-date "$(date "+%Y-%m-%d") 00:00:00"
hammer product set-sync-plan --organization-label "$SET_ORG" --name "Red Hat Satellite Capsule" --sync-plan SYNC_$SET_ORG

echo "CREATE : ACTIVATION KEY"
hammer activation-key create --organization="$SET_ORG" --name="KEY_$SET_ORG" --unlimited-hosts --lifecycle-environment="Library" --content-view='Default Organization View'

echo "ADD : SUBSCRIPTION TO THE ACTIVATION KEY"
SET_SUB_ID=`hammer --output='csv' subscription list --organization=$SET_ORG --search='Red Hat Satellite Infrastructure Subscription' | tail -n+2 | head -n1 | cut -d',' -f1`

hammer activation-key add-subscription --organization="$SET_ORG" --name="KEY_$SET_ORG" --subscription-id=$SET_SUB_ID
hammer activation-key content-override --organization="$SET_ORG" --name="KEY_$SET_ORG" --content-label="rhel-7-server-rpms" --value=1
hammer activation-key content-override --organization="$SET_ORG" --name="KEY_$SET_ORG" --content-label="rhel-7-server-satellite-capsule-$SET_SAT_VER-rpms" --value=1
hammer activation-key content-override --organization="$SET_ORG" --name="KEY_$SET_ORG" --content-label="rhel-server-rhscl-7-rpms" --value=1
hammer activation-key content-override --organization="$SET_ORG" --name="KEY_$SET_ORG" --content-label="rhel-7-server-satellite-maintenance-6-rpms" --value=1
hammer activation-key content-override --organization="$SET_ORG" --name="KEY_$SET_ORG" --content-label="rhel-7-server-ansible-2.6-rpms" --value=1

else

    echo "Satellite 6.6"
fi
#######################################################
fi
