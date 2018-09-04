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

# Required only once.
# scp build/packages/time_machine/data/tzdb/* root@$HOST:$DESTINATION/packages/time_machine/data/tzdb/*
