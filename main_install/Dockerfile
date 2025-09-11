# Dockerfile-main
FROM ubuntu:18.04

WORKDIR /home

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Sao_Paulo
ENV LD_PRELOAD=/usr/lib/libcurl.so.3

# Mirrors
RUN sed -ri 's|http://archive.ubuntu.com/ubuntu|http://ubuntu.c3sl.ufpr.br/ubuntu|g; s|http://security.ubuntu.com/ubuntu|http://ubuntu.c3sl.ufpr.br/ubuntu|g' /etc/apt/sources.list \
 && printf 'Acquire::Retries "10";\nAcquire::http::Timeout "45";\nAcquire::https::Timeout "45";\nAcquire::ForceIPv4 "true";\nAcquire::http::Pipeline-Depth "0";\nAcquire::http::No-Cache "true";\n' > /etc/apt/apt.conf.d/99net-tuning

# User
RUN useradd --system --no-create-home --home-dir /home/xtreamcodes --shell /bin/false --user-group xtreamcodes \
 && mkdir -p /home/xtreamcodes/iptv_xtream_codes /home/utils \
 && chown -R xtreamcodes:xtreamcodes /home/xtreamcodes /home/utils \
 && usermod -aG sudo xtreamcodes

# Repos
RUN apt-get update \
 && apt-get install -y software-properties-common ca-certificates gnupg dirmngr curl \
 && mkdir -p /root/.gnupg \
 && chmod 700 /root/.gnupg \
 && printf 'keyserver hkps://keyserver.ubuntu.com:443\nkeyserver hkps://keys.openpgp.org\n' > /root/.gnupg/dirmngr.conf \
 && add-apt-repository -y ppa:ondrej/php \
 && add-apt-repository -y ppa:deadsnakes/ppa \
 && add-apt-repository -y ppa:ondrej/nginx \
 && add-apt-repository -y ppa:maxmind/ppa \
 && apt-get update \
 && apt-get install -y libcurl4 libcurl4-openssl-dev \
 && ln -sf /usr/lib/x86_64-linux-gnu/libcurl.so.4 /usr/lib/libcurl.so.3 \
 && ldconfig \
 && apt-get upgrade -y \
 && apt-get dist-upgrade -y

# Packages
RUN apt-get update \
 && apt-get install -y \
      coreutils fuse cifs-utils nfs-common \
      cpufrequtils iproute2 net-tools \
      python python3 python3-dev python3-pip \
      dirmngr gpg-agent wget mmdb-bin \
      libmaxminddb0 libmaxminddb-dev \
      libgeoip-dev libxslt1-dev libonig-dev \
      e2fsprogs mariadb-server mariadb-client \
      sysstat alsa-utils v4l-utils mcrypt \
      certbot libjpeg-dev libpng-dev php-ssh2 \
      xz-utils zip unzip build-essential \
      manpages-dev checkinstall aria2 git cron \
      dos2unix sudo nano libfreetype6 ppa-purge \
      libcap2-bin pkg-config mtr anacron \
      gnupg apt-transport-https lsb-release \
      software-properties-common ca-certificates \
      autoconf make gcc libmnl-dev uuid-dev zlib1g-dev \
      redis-tools nscd mc libjemalloc1 snapd libcurl3 \
 && rm -rf /var/lib/apt/lists/*

# libpng12 legacy
RUN wget -qO /tmp/libpng12.deb http://ubuntu.c3sl.ufpr.br/ubuntu/pool/main/libp/libpng/libpng12-0_1.2.54-1ubuntu1_amd64.deb \
 && dpkg -i /tmp/libpng12.deb || true \
 && rm -f /tmp/libpng12.deb

# iptables-persistent
RUN echo "iptables-persistent iptables-persistent/autosave_v4 boolean true" | debconf-set-selections \
 && echo "iptables-persistent iptables-persistent/autosave_v6 boolean true" | debconf-set-selections \
 && apt-get update \
 && apt-get install -y iptables-persistent \
 && rm -rf /var/lib/apt/lists/*

# Download Files and Extract
RUN wget "main.tar.gz" --user-agent="Mozilla/5.0" -q -O "/tmp/xtreamcodes.tar.gz"
RUN tar -zxvf "/tmp/xtreamcodes.tar.gz" -C "/home/xtreamcodes/" > /dev/null
RUN wget "release_22f.zip" --user-agent="Mozilla/5.0" -q -O "/tmp/update.zip"
RUN unzip -o /tmp/update.zip -d /tmp/update/ > /dev/null && cp -rf /tmp/update/XtreamUI-master/* /home/xtreamcodes/iptv_xtream_codes/ > /dev/null && rm -rf /tmp/update/XtreamUI-master > /dev/null && rm -rf /tmp/update > /dev/null && chown -R xtreamcodes:xtreamcodes /home/xtreamcodes > /dev/null
RUN wget "newstuff.zip" --user-agent="Mozilla/5.0" -q -O "/tmp/update2.zip"
RUN unzip -o /tmp/update2.zip -d /tmp/update2/ > /dev/null && cp -rf /tmp/update2/* /home/xtreamcodes/iptv_xtream_codes/ > /dev/null && rm -rf /tmp/update2/* > /dev/null && rm -rf /tmp/update2 > /dev/null && chown -R xtreamcodes:xtreamcodes /home/xtreamcodes/ > /dev/null > /dev/null
RUN wget "xtreamuithings.zip" --user-agent="Mozilla/5.0" -q -O "/tmp/xtreamuithings.zip"
RUN unzip -o /tmp/xtreamuithings.zip -d /tmp/ > /dev/null && cp -rf /tmp/xtreamui-things-master/admin-modified/* /home/xtreamcodes/iptv_xtream_codes/admin/ > /dev/null && rm -rf /tmp/xtreamui-things-master/* > /dev/null && rm -rf /tmp/xtreamui-things-master > /dev/null && chown -R xtreamcodes:xtreamcodes /home/xtreamcodes/ > /dev/null > /dev/null

# Utils
RUN wget "https://raw.githubusercontent.com/wtech-null/xtreamui_docker_portainer/refs/heads/main/utils/xtreamui.cron" -O /etc/cron.d/xtreamui
RUN wget "" -O /home/xtreamcodes/iptv_xtream_codes/service
RUN wget "" -O /home/xtreamcodes/iptv_xtream_codes/permissions.sh
RUN wget "" -O /home/starter.sh
RUN wget "" -O /etc/sudoers.d/90-xtreamcodes
RUN wget "" -O /home/xtreamcodes/iptv_xtream_codes/config
RUN wget "" -O /home/xtreamcodes/iptv_xtream_codes/config.py
RUN wget "" -O /home/xtreamcodes/iptv_xtream_codes/nginx/conf/nginx.conf
RUN wget "" -O /home/xtreamcodes/iptv_xtream_codes/nginx/conf/dhparam.pem
RUN wget "" -O /home/xtreamcodes/iptv_xtream_codes/nginx_rtmp/conf/nginx.conf
RUN wget "" -O /home/xtreamcodes/iptv_xtream_codes/wwwdir/index.php
RUN wget "php-fpm1.conf" -O /home/xtreamcodes/iptv_xtream_codes/php/etc/1.conf
RUN wget "php-fpm2.conf" -O /home/xtreamcodes/iptv_xtream_codes/php/etc/2.conf
RUN wget "php-fpm3.conf" -O /home/xtreamcodes/iptv_xtream_codes/php/etc/3.conf
RUN wget "php-fpm4.conf" -O /home/xtreamcodes/iptv_xtream_codes/php/etc/4.conf

# Permissions
RUN chmod 0777 /home/starter.sh /home/xtreamcodes/iptv_xtream_codes/service /home/xtreamcodes/iptv_xtream_codes/start_services.sh \
 && chown xtreamcodes:xtreamcodes /etc/cron.d/xtreamui \
 && chmod 0644 /etc/cron.d/xtreamui \
 && chmod 0440 /etc/sudoers.d/90-xtreamcodes \
 && chown -R xtreamcodes:xtreamcodes /home/xtreamcodes /home/utils \
 && usermod -aG sudo xtreamcodes \ 
 && chmod 0777 /home/xtreamcodes/iptv_xtream_codes/permissions.sh \
 && chattr -f -i /home/xtreamcodes/iptv_xtream_codes/GeoLite2.mmdb > /dev/null \
 && sudo find /home/xtreamcodes/iptv_xtream_codes/admin/ -type f -exec chmod 644 {} \; \
 && sudo find /home/xtreamcodes/iptv_xtream_codes/admin/ -type d -exec chmod 755 {} \; \
 && sed -i 's|https://raw.githubusercontent.com/emre1393/xtreamui_mirror/refs/heads/master/balancer.py|https://github.com/emre1393/xtreamui_mirror/raw/master/withmariadb/balancer.py|g'  /home/xtreamcodes/iptv_xtream_codes/pytools/balancer.py
 sudo chmod +x /home/xtreamcodes/iptv_xtream_codes/nginx/sbin/nginx
 sudo chmod +x /home/xtreamcodes/iptv_xtream_codes/nginx_rtmp/sbin/nginx_rtmp
 sudo find /home/xtreamcodes/iptv_xtream_codes/wwwdir/ -type f -exec chmod 644 {} \;
 sudo find /home/xtreamcodes/iptv_xtream_codes/wwwdir/ -type d -exec chmod 755 {} \;
 chmod 0700 /home/xtreamcodes/iptv_xtream_codes/config > /dev/null

# Update files
RUN wget "" --user-agent="Mozilla/5.0" -q -O "/home/xtreamcodes/iptv_xtream_codes/nginx/sbin/nginx"
RUN wget "" --user-agent="Mozilla/5.0" -q -O "/home/xtreamcodes/iptv_xtream_codes/nginx_rtmp/sbin/nginx_rtmp"
RUN wget "" --user-agent="Mozilla/5.0" -q -O "/home/xtreamcodes/iptv_xtream_codes/crons/pid_monitor.php"
RUN wget "" --user-agent="Mozilla/5.0" -q
RUN wget "" --user-agent="Mozilla/5.0" -q
RUN wget "" --user-agent="Mozilla/5.0" -q
RUN wget "" --user-agent="Mozilla/5.0" -q

# Volumes
VOLUME ["/home/xtreamcodes/iptv_xtream_codes","/home/xtreamcodes_utils"]

# Ports
EXPOSE 80 443 1935 81

# Entrypoint
ENTRYPOINT ["/home/starter.sh"]
