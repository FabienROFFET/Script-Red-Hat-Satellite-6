USER="admin"
PASSWORD="DoYouReadMyDoc"
ORGANISATION="ORG_UFLEX3_SATELLITE"
LOCATION="Luxembourg"
PROXYPORT="80"
PROXYURL="http://111.222.222.111"

echo "Satellite 6.5 :"
echo "---------------"
echo "satellite-installer --scenario satellite --foreman-initial-organization $ORGANISATION --foreman-initial-location $LOCATION --foreman-admin-username $USER --foreman-admin-password $PASSWORD --foreman-proxy-tftp false --foreman-proxy-dns false --foreman-proxy-dhcp-managed false"
echo " "

echo "Satellite 6.5 with proxy :"
echo "--------------------------"
echo "satellite-installer --scenario satellite --foreman-initial-organization $ORGANISATION --foreman-initial-location $LOCATION --foreman-admin-username $USER --foreman-admin-password $PASSWORD --foreman-proxy-tftp false --foreman-proxy-dns false --foreman-proxy-dhcp-managed false --katello-proxy-"port $PROXYPORT --katello-proxy-url $PROXYURL
echo " "

echo "Satellite 6.6 :"
echo "---------------"
echo "satellite-installer --scenario satellite --foreman-initial-organization $ORGANISATION --foreman-initial-location $LOCATION --foreman-initial-admin-username $USER --foreman-initial-admin-password $PASSWORD --foreman-proxy-tftp false --foreman-proxy-dns false --foreman-proxy-dhcp-managed false"
echo " "

echo "Satellite 6.6 with proxy :"
echo "--------------------------"
echo "satellite-installer --scenario satellite --foreman-initial-organization $ORGANISATION --foreman-initial-location $LOCATION --foreman-initial-admin-username $USER --foreman-initial-admin-password $PASSWORD --foreman-proxy-tftp false --foreman-proxy-dns false --foreman-proxy-dhcp-managed false --katello-proxy-port $PROXYPORT --katello-proxy-url $PROXYURL"
echo " "
