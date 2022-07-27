########################################################################
# 07.18.2022 : Creation
########################################################################

########################################################################
#Create Product
########################################################################
ORG=test_org

########################################################################
# sync-plan :
########################################################################
hammer sync-plan create --name "SYNC_$ORG" --enabled=true --interval daily --organization "$ORG" --sync-date "$(date "+%Y-%m-%d") 00:00:00"

########################################################################
# lifecycle-environment  :
########################################################################
hammer lifecycle-environment create --organization "$ORG" --description 'Development' --name 'Non-Prod' --label development --prior Library
hammer lifecycle-environment create --organization "$ORG" --description 'Production' --name 'Prod' --label production --prior 'Non-Prod'
hammer lifecycle-environment create --organization "$ORG" --description 'Latest packages without staging' --name 'UnStaged' --label unstaged --prior Library

########################################################################
# Repositories
########################################################################
hammer repository-set enable --organization "$ORG" --product "Red Hat Enterprise Linux Server" --basearch="x86_64" --releasever="7Server" --name "Red Hat Enterprise Linux 7 Server (RPMs)"
hammer repository-set enable --organization "$ORG" --product "Red Hat Enterprise Linux Server" --basearch="x86_64" --releasever="7Server" --name "Red Hat Enterprise Linux 7 Server - Optional (RPMs)"
hammer repository-set enable --organization "$ORG" --product "Red Hat Enterprise Linux Server" --basearch="x86_64" --releasever="7Server" --name "Red Hat Enterprise Linux 7 Server - Extras (RPMs)"
hammer repository-set enable --organization "$ORG" --product "Red Hat Enterprise Linux Server" --basearch="x86_64" --releasever="7Server" --name "Red Hat Enterprise Linux 7 Server - Supplementary (RPMs)"

########################################################################
# Force download policy to "immediate" for all Org and all Prod
########################################################################
echo "SET : DOWNLOAD POLICY TO IMMEDIATE"
foreman-rake katello:change_download_policy DOWNLOAD_POLICY=immediate

########################################################################
# Add Sync
########################################################################
hammer product set-sync-plan --organization-label "$ORG" --name "Red Hat Enterprise Linux Server" --sync-plan $SYNC_$ORG


########################################################################
# Repository Synchronize
########################################################################
echo "syncro :Red Hat Enterprise Linux 7 Server RPMs x86_64 7Server"
hammer repository synchronize --organization "$ORG" --product 'Red Hat Enterprise Linux Server'  --name  'Red Hat Enterprise Linux 7 Server RPMs x86_64 7Server' ;

echo "Syncro : Red Hat Enterprise Linux 7 Server - Supplementary (RPMs)"
hammer repository synchronize --organization "$ORG" --product 'Red Hat Enterprise Linux Server'  --name 'Red Hat Enterprise Linux 7 Server - Supplementary (RPMs)' ;

echo "Syncro :Red Hat Enterprise Linux 7 Server - Extras (RPMs)"
hammer repository synchronize --organization "$ORG" --product 'Red Hat Enterprise Linux Server'  --name 'Red Hat Enterprise Linux 7 Server - Extras (RPMs)' ;

echo "Syncro : Red Hat Enterprise Linux 7 Server - Optional (RPMs)"
hammer repository synchronize --organization "$ORG" --product 'Red Hat Enterprise Linux Server'  --name 'Red Hat Enterprise Linux 7 Server - Optional (RPMs)' ;


###########################################
# Check if repository synchronize is done
###########################################
echo " "
echo "Waitting for tasks to finish"
echo " "

while  [ "$(hammer --csv task list --search "Synchronize repository" --search "running" | grep -v "ID,Action")" != "" ]
        do
        echo "Tasks still running"; sleep 30
done

echo "Moving to the next step"


########################################################################
# Content-View
########################################################################
echo "CREATE : CONTENT VIEW BASE - RHEL 7"
hammer content-view create --organization "$ORG" --name "CV-RHEL7-Base" --label CV-RHEL7-Base --description "Base RHEL 7"
hammer content-view add-repository --organization "$ORG" --name "CV-RHEL7-Base" --product "Red Hat Enterprise Linux Server" --repository "Red Hat Enterprise Linux 7 Server RPMs x86_64 7Server"

hammer content-view create --organization "$ORG" --name "CV-RHEL7-Optional" --label CV-RHEL7-Optional --description "Base RHEL 7"
hammer content-view add-repository --organization "$ORG" --name "CV-RHEL7-Optional" --product "Red Hat Enterprise Linux Server" --repository "Red Hat Enterprise Linux 7 Server - Optional RPMs x86_64 7Server"

hammer content-view create --organization "$ORG" --name "CV-RHEL7-Extras" --label CV-RHEL7-Extras --description "Base RHEL 7"
hammer content-view add-repository --organization "$ORG" --name "CV-RHEL7-Extras" --product "Red Hat Enterprise Linux Server" --repository "Red Hat Enterprise Linux 7 Server - Extras RPMs x86_64"

hammer content-view create --organization "$ORG" --name "CV-RHEL7-Supplementary" --label CV-RHEL7-Supplementary --description "Base RHEL 7"
hammer content-view add-repository --organization "$ORG" --name "CV-RHEL7-Supplementary" --product "Red Hat Enterprise Linux Server" --repository "Red Hat Enterprise Linux 7 Server - Supplementary RPMs x86_64 7Server"

########################################################################
# PUBLISH : LAST CONTENT VIEW
########################################################################
hammer content-view publish --organization "$ORG" --name CV-RHEL7-Base --description "Initial Publishing"
hammer content-view publish --organization "$ORG" --name CV-RHEL7-Optional --description "Initial Publishing"
hammer content-view publish --organization "$ORG" --name CV-RHEL7-Extras --description "Initial Publishing"
hammer content-view publish --organization "$ORG" --name CV-RHEL7-Supplementary --description "Initial Publishing"

########################################################################
# PROMOTE : LAST CONTENT VIEW
########################################################################
hammer content-view version promote --organization "$ORG" --content-view CV-RHEL7-Base --to-lifecycle-environment Non-Prod --version 1 --force
hammer content-view version promote --organization "$ORG" --content-view CV-RHEL7-Base --to-lifecycle-environment Prod --version 1 --force
hammer content-view version promote --organization "$ORG" --content-view CV-RHEL7-Base --to-lifecycle-environment UnStaged --version 1 --force

hammer content-view version promote --organization "$ORG" --content-view CV-RHEL7-Optional --to-lifecycle-environment Non-Prod --version 1 --force
hammer content-view version promote --organization "$ORG" --content-view CV-RHEL7-Optional --to-lifecycle-environment Prod --version 1 --force
hammer content-view version promote --organization "$ORG" --content-view CV-RHEL7-Optional --to-lifecycle-environment UnStaged --version 1 --force

hammer content-view version promote --organization "$ORG" --content-view CV-RHEL7-Extras --to-lifecycle-environment Non-Prod --version 1 --force
hammer content-view version promote --organization "$ORG" --content-view CV-RHEL7-Extras --to-lifecycle-environment Prod --version 1 --force
hammer content-view version promote --organization "$ORG" --content-view CV-RHEL7-Extras --to-lifecycle-environment UnStaged --version 1 --force

hammer content-view version promote --organization "$ORG" --content-view CV-RHEL7-Supplementary --to-lifecycle-environment Non-Prod --version 1 --force
hammer content-view version promote --organization "$ORG" --content-view CV-RHEL7-Supplementary --to-lifecycle-environment Prod --version 1 --force
hammer content-view version promote --organization "$ORG" --content-view CV-RHEL7-Supplementary --to-lifecycle-environment UnStaged --version 1 --force

########################################################################
# CREATE : COMPOSITE VIEW
########################################################################
CV7BASE=`hammer content-view info --name "CV-RHEL7-Base" --organization "$ORG" | grep "Versions:" -A 1 | grep Id: | awk '{print $3}'`
CV7OPTIONAL=`hammer content-view info --name "CV-RHEL7-Optional" --organization "$ORG" | grep "Versions:" -A 1 | grep Id: | awk '{print $3}'`
CV7EXTRAS=`hammer content-view info --name "CV-RHEL7-Extras" --organization "$ORG" | grep "Versions:" -A 1 | grep Id: | awk '{print $3}'`
CV7SUPPLEMENTARY=`hammer content-view info --name "CV-RHEL7-Supplementary" --organization "$ORG" | grep "Versions:" -A 1 | grep Id: | awk '{print $3}'`

hammer content-view create --composite --organization "$ORG" --name "CPV-RHEL7" --label "CPV-RHEL7" --description "Composite View RHEL7 Base" --component-ids $CV7BASE,$CV7OPTIONAL,$CV7EXTRAS,$CV7SUPPLEMENTARY

########################################################################
# PUBLISH : LAST COMPOSITE VIEW
########################################################################
hammer content-view publish --organization "$ORG" --name CPV-RHEL7 --description "Initial Publishing"

########################################################################
# PROMOTE : LAST COMPOSITE VIEW
########################################################################
hammer content-view version promote --organization "$ORG" --content-view CPV-RHEL7 --to-lifecycle-environment Non-Prod
hammer content-view version promote --organization "$ORG" --content-view CPV-RHEL7 --to-lifecycle-environment Prod
hammer content-view version promote --organization "$ORG" --content-view CPV-RHEL7 --to-lifecycle-environment UnStaged

########################################################################
# CREATE : Activation Key
########################################################################
# Be sure you switch "Simple content access" to disable on access.redhat.com in the "Subscription Allocations" Section
# hammer subscription refresh-manifest --organization="$ORG"


SET_RH7_SUB_ID=`hammer --output='csv' subscription list --organization=$ORG --search='Red Hat Enterprise Linux Server with Smart Management' | tail -n+2 | head -n1 | cut -d',' -f1`

hammer activation-key create --organization="$ORG" --name='RHEL7-NON-PROD' --unlimited-hosts --lifecycle-environment='Non-Prod' --content-view='CPV-RHEL7'
hammer activation-key create --organization="$ORG" --name='RHEL7-PROD' --unlimited-hosts --lifecycle-environment='Prod' --content-view='CPV-RHEL7'
hammer activation-key create --organization="$ORG" --name='RHEL7-UnStaged' --unlimited-hosts --lifecycle-environment='UnStaged' --content-view='CPV-RHEL7'

hammer activation-key add-subscription --organization="$ORG" --name='RHEL7-NON-PROD' --subscription-id=$SET_RH7_SUB_ID
hammer activation-key add-subscription --organization="$ORG" --name='RHEL7-PROD' --subscription-id=$SET_RH7_SUB_ID
hammer activation-key add-subscription --organization="$ORG" --name='RHEL7-UnStaged' --subscription-id=$SET_RH7_SUB_ID
