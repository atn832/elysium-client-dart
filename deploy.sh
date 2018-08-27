webdev build

HOST=m.wafrat.com
DESTINATION=/var/www/html/E2

scp build/index.html root@$HOST:$DESTINATION
scp build/main.dart.js root@$HOST:$DESTINATION
scp build/styles.css root@$HOST:$DESTINATION
scp build/favicon.png root@$HOST:$DESTINATION
