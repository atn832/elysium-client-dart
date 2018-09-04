mv web web_dev
mv web_prod web

webdev build

mv web web_prod
mv web_dev web

HOST=m.wafrat.com
DESTINATION=/var/www/html/E2

scp build/index.html root@$HOST:$DESTINATION
scp build/main.dart.js root@$HOST:$DESTINATION
scp build/styles.css root@$HOST:$DESTINATION
scp build/favicon.png root@$HOST:$DESTINATION

# Transfer timezone info.
tar -zcvf timezone_info.tar.gz -C build/packages/time_machine/ .
scp timezone_info.tar.gz root@$HOST:/root/
ssh root@$HOST "tar -zxf /root/timezone_info.tar.gz -C $DESTINATION/packages/time_machine"
rm timezone_info.tar.gz
