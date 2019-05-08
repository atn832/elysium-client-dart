if [ "$1" == "firebase" ]; then
    HOST=elysium.wafrat.com
    SOURCE=web_firebase
    if [ "$2" == "prod" ]; then
        DESTINATION=/var/www/html
    else
        DESTINATION=/var/www/html/dev
    fi
else
    HOST=m.wafrat.com
    SOURCE=web_prod
    DESTINATION=/var/www/html/E2
fi

echo Deploying from $SOURCE to $DESTINATION...

mv web web_dev
mv $SOURCE web

webdev build

mv web $SOURCE
mv web_dev web

ssh root@$HOST "mkdir -p $DESTINATION/packages/time_machine"

scp build/index.html root@$HOST:$DESTINATION
scp build/main.dart.js root@$HOST:$DESTINATION
scp sw.dart.js root@$HOST:$DESTINATION
scp build/styles.css root@$HOST:$DESTINATION
scp build/favicon.png root@$HOST:$DESTINATION

# Transfer timezone info.
tar -zcvf timezone_info.tar.gz -C build/packages/time_machine/ .
scp timezone_info.tar.gz root@$HOST:/root/
ssh root@$HOST "tar -zxf /root/timezone_info.tar.gz -C $DESTINATION/packages/time_machine"
rm timezone_info.tar.gz
