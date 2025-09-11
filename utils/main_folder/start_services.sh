#! /bin/bash
kill $(ps aux | grep 'xtreamcodes' | grep -v grep | grep -v 'start_services.sh' | awk '{print $2}') 2>/dev/null
sleep 1
kill $(ps aux | grep 'xtreamcodes' | grep -v grep | grep -v 'start_services.sh' | awk '{print $2}') 2>/dev/null
sleep 1
kill $(ps aux | grep 'xtreamcodes' | grep -v grep | grep -v 'start_services.sh' | awk '{print $2}') 2>/dev/null
sleep 4
sudo -u xtreamcodes /home/xtreamcodes/iptv_xtream_codes/php/bin/php /home/xtreamcodes/iptv_xtream_codes/crons/setup_cache.php
sudo -u xtreamcodes /home/xtreamcodes/iptv_xtream_codes/php/bin/php /home/xtreamcodes/iptv_xtream_codes/tools/signal_receiver.php >/dev/null 2>/dev/null &
sudo -u xtreamcodes /home/xtreamcodes/iptv_xtream_codes/php/bin/php /home/xtreamcodes/iptv_xtream_codes/tools/pipe_reader.php >/dev/null 2>/dev/null &
chown -R xtreamcodes:xtreamcodes /home/xtreamcodes  >/dev/null 2>/dev/null
sleep 4
chmod +x /home/xtreamcodes/iptv_xtream_codes/nginx_rtmp/sbin/nginx_rtmp
chmod +x /home/xtreamcodes/iptv_xtream_codes//nginx/sbin/nginx
/home/xtreamcodes/iptv_xtream_codes/nginx_rtmp/sbin/nginx_rtmp
/home/xtreamcodes/iptv_xtream_codes/nginx/sbin/nginx
start-stop-daemon --start --quiet --pidfile /home/xtreamcodes/iptv_xtream_codes/php/1.pid --exec /home/xtreamcodes/iptv_xtream_codes/php/sbin/php-fpm -- --daemonize --fpm-config /home/xtreamcodes/iptv_xtream_codes/php/etc/1.conf
start-stop-daemon --start --quiet --pidfile /home/xtreamcodes/iptv_xtream_codes/php/2.pid --exec /home/xtreamcodes/iptv_xtream_codes/php/sbin/php-fpm -- --daemonize --fpm-config /home/xtreamcodes/iptv_xtream_codes/php/etc/2.conf
start-stop-daemon --start --quiet --pidfile /home/xtreamcodes/iptv_xtream_codes/php/3.pid --exec /home/xtreamcodes/iptv_xtream_codes/php/sbin/php-fpm -- --daemonize --fpm-config /home/xtreamcodes/iptv_xtream_codes/php/etc/3.conf
start-stop-daemon --start --quiet --pidfile /home/xtreamcodes/iptv_xtream_codes/php/4.pid --exec /home/xtreamcodes/iptv_xtream_codes/php/sbin/php-fpm -- --daemonize --fpm-config /home/xtreamcodes/iptv_xtream_codes/php/etc/4.conf
 