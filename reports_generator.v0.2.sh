###################################################
# Name : reports_generator.sh version 0.2
# Description : Create report for Satellite 6.5
# Usage: ./reports_generator.sh
# Auteur: Fabien ROFFET
# Mise à jour le: 18/02/2020
####################################################

#DEFINE VARIABLE :
##################

VARORGA="MyORG"
VARDESTREP="/var/www/html/pub/reporting"
VARPREFIXFILE="report_host"
VARREPORTING_GLOBAL="147"
VARREPORTING_APPLICABLE="148"

#CREATE A COLLECT FOLDER :
##########################
mkdir -p $VARDESTREP

# CREATE HOST LIST BY ORG :
###########################

rm -f $VARDESTREP/$VARPREFIXFILE"_list.lst"
hammer host list --organization $VARORGA | awk '{print $3}' | sed '/^$/d' | grep -v "NAME" >> $VARDESTREP/$VARPREFIXFILE"_list.lst"

echo "Servers Found :" ; cat $VARDESTREP/$VARPREFIXFILE"_list.lst" | wc -l

#REMOVE OLD REPORTS :
#####################

rm -f $VARDESTREP/$VARPREFIXFILE"_*"

#CREATE GLOBAL REPORT :
#######################

echo "Create Global Report for :" $VARORGA
hammer report-template generate --id $VARREPORTING_GLOBAL > $VARDESTREP/$VARPREFIXFILE"_statuses."$VARORGA".html"

#CREATE APPLICABLE  REPORT :
############################

for host in `cat $VARDESTREP/$VARPREFIXFILE"_list.lst"`
    do
        echo "Create Report for :" $host
        eval hammer report-template generate --id $VARREPORTING_APPLICABLE --inputs hosts=$host > $VARDESTREP/$VARPREFIXFILE"_applicable."$host".html"
done

#REPORT DONE :
##############

echo "CONGRATULATION REPORT ONE" : $VARDESTREP/$VARPREFIXFILE"_statuses."$VARORGA".html"
