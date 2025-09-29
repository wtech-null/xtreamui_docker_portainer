# Dockerfile-main-24.04
FROM ubuntu:24.04

WORKDIR /home/xtreamcodes

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Sao_Paulo
# ENV LD_PRELOAD=/usr/lib/libcurl.so.3

# Mirrors & APT tuning
RUN sed -ri 's|http://archive.ubuntu.com/ubuntu|http://ubuntu.c3sl.ufpr.br/ubuntu|g; s|http://security.ubuntu.com/ubuntu|http://ubuntu.c3sl.ufpr.br/ubuntu|g' /etc/apt/sources.list \
 && printf 'Acquire::Retries "10";\nAcquire::http::Timeout "45";\nAcquire::https::Timeout "45";\nAcquire::ForceIPv4 "true";\nAcquire::http::Pipeline-Depth "0";\nAcquire::http::No-Cache "true";\n' > /etc/apt/apt.conf.d/99net-tuning

# User
RUN useradd --system --no-create-home --home-dir /home/xtreamcodes --shell /bin/false --user-group xtreamcodes \
 && mkdir -p /home/xtreamcodes/iptv_xtream_codes /home/utils \
 && chown -R xtreamcodes:xtreamcodes /home/xtreamcodes /home/utils \
 && usermod -aG sudo xtreamcodes

# Repos
RUN apt-get update \
 && apt-get install -y software-properties-common ca-certificates gnupg dirmngr \
 && mkdir -p /root/.gnupg && chmod 700 /root/.gnupg \
 && printf 'keyserver hkps://keyserver.ubuntu.com:443\nkeyserver hkps://keys.openpgp.org\n' > /root/.gnupg/dirmngr.conf \
 && add-apt-repository -y ppa:ondrej/php \
 && add-apt-repository -y ppa:deadsnakes/ppa \
 && add-apt-repository -y ppa:ondrej/nginx \
 && add-apt-repository -y ppa:maxmind/ppa \
 && apt-get update \
 && ldconfig \
 && apt-get upgrade -y \
 && apt-get dist-upgrade -y

# Packages
RUN apt-get update \
 && apt-get install -y \
      coreutils fuse cifs-utils nfs-common \
      cpufrequtils iproute2 net-tools \
      python3 python3-dev python3-pip python3-paramiko python-is-python3 \
      dirmngr gpg-agent wget mmdb-bin \
      libmaxminddb0 libmaxminddb-dev \
      libgeoip-dev libxslt1-dev libonig-dev e2fsprogs \
      sysstat alsa-utils v4l-utils mcrypt \
      certbot libjpeg-dev php-ssh2 \
      xz-utils zip unzip build-essential \
      manpages-dev checkinstall aria2 git cron \
      dos2unix sudo nano libfreetype6 ppa-purge \
      libcap2-bin pkg-config mtr traceroute anacron \
      gnupg apt-transport-https lsb-release \
      software-properties-common ca-certificates \
      autoconf make gcc libmnl-dev uuid-dev zlib1g-dev \
      redis-tools nscd mc libjemalloc2 snapd openssl \
      libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6 \
      libc6-dev libbz2-dev libffi-dev curl iputils-ping libpcre3 \
 && rm -rf /var/lib/apt/lists/*

# libpng12 (compat)
RUN set -eux; \
  apt-get update; apt-get install -y --no-install-recommends wget ca-certificates; \
  cd /tmp; \
  wget -O libpng12.deb \
    http://ubuntu.c3sl.ufpr.br/ubuntu/pool/main/libp/libpng/libpng12-0_1.2.54-1ubuntu1_amd64.deb; \
  dpkg-deb -x libpng12.deb /tmp/png12; \
  install -Dm644 /tmp/png12/lib/x86_64-linux-gnu/libpng12.so.0.54.0 \
                  /usr/lib/x86_64-linux-gnu/libpng12.so.0.54.0; \
  ln -sf libpng12.so.0.54.0 /usr/lib/x86_64-linux-gnu/libpng12.so.0; \
  ldconfig; \
  ldconfig -p | grep -q 'libpng12\.so\.0'; \
  rm -rf /tmp/png12 /tmp/libpng12.deb

# libssl1.1 (compat) para binários legados que pedem *.so.1.1
RUN set -eux; \
  apt-get update; apt-get install -y --no-install-recommends wget ca-certificates; \
  cd /tmp; \
  wget -O libssl1.1.deb \
    http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_amd64.deb; \
  dpkg-deb -x libssl1.1.deb /tmp/ssl11; \
  install -Dm644 /tmp/ssl11/usr/lib/x86_64-linux-gnu/libcrypto.so.1.1 \
                 /usr/lib/x86_64-linux-gnu/libcrypto.so.1.1; \
  install -Dm644 /tmp/ssl11/usr/lib/x86_64-linux-gnu/libssl.so.1.1 \
                 /usr/lib/x86_64-linux-gnu/libssl.so.1.1; \
  ldconfig; \
  ldconfig -p | grep -E 'lib(crypto|ssl)\.so\.1\.1'; \
  rm -rf /tmp/ssl11 /tmp/libssl1.1.deb

# libzip5 (compat) para binários que pedem *.so.5
RUN set -eux; \
  cd /tmp; \
  wget -O libzip5.deb \
    http://archive.ubuntu.com/ubuntu/pool/universe/libz/libzip/libzip5_1.5.1-0ubuntu1_amd64.deb; \
  dpkg-deb -x libzip5.deb ./zip5; \
  dest="/usr/lib/x86_64-linux-gnu"; \
  mkdir -p "$dest"; \
  # Copia qualquer variante fornecida pelo .deb (ex: libzip.so.5.0, 5.0.1, etc.)
  if [ -d ./zip5/usr/lib/x86_64-linux-gnu ]; then \
    cp -av ./zip5/usr/lib/x86_64-linux-gnu/libzip.so* "$dest/"; \
  else \
    cp -av ./zip5/lib/x86_64-linux-gnu/libzip.so* "$dest/"; \
  fi; \
  # Garante o link da SONAME
  real="$(basename "$(ls -1 $dest/libzip.so.5.* 2>/dev/null | head -n1 || true)")"; \
  if [ -n "$real" ]; then ln -sf "$real" "$dest/libzip.so.5"; fi; \
  ldconfig; \
  ldconfig -p | grep libzip || true; \
  rm -rf /tmp/zip5 /tmp/libzip5.deb

# python2
RUN wget -qO /tmp/Python-2.7.18.tgz https://www.python.org/ftp/python/2.7.18/Python-2.7.18.tgz \
 && tar xzf /tmp/Python-2.7.18.tgz -C /tmp \
 && cd /tmp/Python-2.7.18 \
 && ./configure --enable-optimizations \
 && make altinstall

# pip2
 RUN curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output /tmp/get-pip.py \
 && python2.7 /tmp/get-pip.py

# paramiko
 RUN pip2.7 install paramiko

# iptables-persistent (preseed)
RUN echo "iptables-persistent iptables-persistent/autosave_v4 boolean true" | debconf-set-selections \
 && echo "iptables-persistent iptables-persistent/autosave_v6 boolean true" | debconf-set-selections \
 && apt-get update \
 && apt-get install -y iptables-persistent \
 && rm -rf /var/lib/apt/lists/*

# Folders
RUN mkdir -p \
  /home/xtreamcodes/iptv_xtream_codes/nginx/conf \
  /home/xtreamcodes/iptv_xtream_codes/nginx/sbin \
  /home/xtreamcodes/iptv_xtream_codes/nginx_rtmp/conf \
  /home/xtreamcodes/iptv_xtream_codes/nginx_rtmp/sbin \
  /home/xtreamcodes/iptv_xtream_codes/php/etc \
  /home/xtreamcodes/iptv_xtream_codes/wwwdir \
  /home/xtreamcodes/iptv_xtream_codes/crons \
  /home/xtreamcodes/iptv_xtream_codes/admin \
  /etc/security/limits.d \
  /etc/sysctl.d

# Downloads and Extracts
RUN wget -q -O /tmp/xtreamcodes.zip https://media.githubusercontent.com/media/wtech-null/xtreamui_docker_portainer/refs/heads/main/zipfiles/main_xui_masoudgb.zip \
 && unzip -o /tmp/xtreamcodes.zip -d /home/xtreamcodes/ >/dev/null \
 && rm -f /tmp/xtreamcodes.zip

RUN wget -q -O /tmp/update.zip https://media.githubusercontent.com/media/wtech-null/xtreamui_docker_portainer/refs/heads/main/zipfiles/release_22f_masoudgb.zip \
 && unzip -o /tmp/update.zip -d /tmp/update/ >/dev/null \
 && cp -rf /tmp/update/XtreamUI-master/* /home/xtreamcodes/iptv_xtream_codes/ >/dev/null \
 && rm -rf /tmp/update /tmp/update.zip \
 && chown -R xtreamcodes:xtreamcodes /home/xtreamcodes

RUN wget -q -O /tmp/update2.zip https://media.githubusercontent.com/media/wtech-null/xtreamui_docker_portainer/refs/heads/main/zipfiles/update_masoudgb.zip \
 && unzip -o /tmp/update2.zip -d /tmp/update2/ >/dev/null \
 && cp -rf /tmp/update2/XtreamUI-master/* /home/xtreamcodes/iptv_xtream_codes/ >/dev/null \
 && rm -rf /tmp/update2 /tmp/update2.zip \
 && chown -R xtreamcodes:xtreamcodes /home/xtreamcodes

# Utils & configs
RUN wget -q -O /etc/cron.d/xtreamui https://raw.githubusercontent.com/wtech-null/xtreamui_docker_portainer/main/utils/crons/xtreamui.cron
RUN wget -q -O /home/xtreamcodes/iptv_xtream_codes/service https://raw.githubusercontent.com/wtech-null/xtreamui_docker_portainer/main/utils/main_folder/service
RUN wget -q -O /home/xtreamcodes/iptv_xtream_codes/permissions.sh https://raw.githubusercontent.com/wtech-null/xtreamui_docker_portainer/main/utils/main_folder/permissions.sh
RUN wget -q -O /home/starter.sh https://raw.githubusercontent.com/wtech-null/xtreamui_docker_portainer/main/utils/system/starter.sh
RUN wget -q -O /home/xtreamcodes/iptv_xtream_codes/config https://raw.githubusercontent.com/wtech-null/xtreamui_docker_portainer/main/utils/main_folder/config
RUN wget -q -O /home/xtreamcodes/iptv_xtream_codes/config.py https://raw.githubusercontent.com/wtech-null/xtreamui_docker_portainer/main/utils/main_folder/config.py
RUN wget -q -O /home/xtreamcodes/iptv_xtream_codes/nginx/conf/nginx.conf https://raw.githubusercontent.com/wtech-null/xtreamui_docker_portainer/main/utils/nginx/nginx.conf
RUN wget -q -O /home/xtreamcodes/iptv_xtream_codes/nginx/conf/dhparam.pem https://raw.githubusercontent.com/wtech-null/xtreamui_docker_portainer/main/utils/nginx/dhparam.pem
RUN wget -q -O /home/xtreamcodes/iptv_xtream_codes/nginx_rtmp/conf/nginx.conf https://raw.githubusercontent.com/wtech-null/xtreamui_docker_portainer/main/utils/nginx/nginx_rtmp.conf
RUN wget -q -O /home/xtreamcodes/iptv_xtream_codes/wwwdir/index.html https://raw.githubusercontent.com/wtech-null/xtreamui_docker_portainer/main/utils/www/index.html
RUN wget -q -O /home/xtreamcodes/iptv_xtream_codes/nginx/conf/balance.conf https://raw.githubusercontent.com/wtech-null/xtreamui_docker_portainer/main/utils/nginx/balance.conf
RUN wget -q -O /home/xtreamcodes/iptv_xtream_codes/php/etc/1.conf https://raw.githubusercontent.com/wtech-null/xtreamui_docker_portainer/main/utils/php/php-fpm1.conf
RUN wget -q -O /home/xtreamcodes/iptv_xtream_codes/php/etc/2.conf https://raw.githubusercontent.com/wtech-null/xtreamui_docker_portainer/main/utils/php/php-fpm2.conf
RUN wget -q -O /home/xtreamcodes/iptv_xtream_codes/php/etc/3.conf https://raw.githubusercontent.com/wtech-null/xtreamui_docker_portainer/main/utils/php/php-fpm3.conf
RUN wget -q -O /home/xtreamcodes/iptv_xtream_codes/php/etc/4.conf https://raw.githubusercontent.com/wtech-null/xtreamui_docker_portainer/main/utils/php/php-fpm4.conf
RUN wget -q -O /home/xtreamcodes/iptv_xtream_codes/start_services.sh https://raw.githubusercontent.com/wtech-null/xtreamui_docker_portainer/main/utils/main_folder/start_services.sh
RUN wget -q -O /home/xtreamcodes/iptv_xtream_codes/pytools/balancer.py https://raw.githubusercontent.com/emre1393/xtreamui_mirror/refs/heads/master/withmariadb/balancer.py
RUN wget -q -O /etc/security/limits.d/99-nofile.conf https://raw.githubusercontent.com/wtech-null/xtreamui_docker_portainer/refs/heads/main/utils/system/99-nofile.conf
RUN wget -q -O /etc/sysctl.d/99-xtreamui.conf https://raw.githubusercontent.com/wtech-null/xtreamui_docker_portainer/refs/heads/main/utils/system/sysctl.conf
RUN wget -q -O /home/entrypoint-wrapper.sh https://raw.githubusercontent.com/wtech-null/xtreamui_docker_portainer/refs/heads/main/utils/system/entrypoint-wrapper.sh

# Sudoers
RUN printf 'xtreamcodes ALL=(root) NOPASSWD: /sbin/iptables, /usr/bin/chattr\n' > /etc/sudoers.d/90-xtreamcodes \
    && chown root:root /etc/sudoers.d/90-xtreamcodes \
    && chmod 0440 /etc/sudoers.d/90-xtreamcodes

# Permissions
RUN dos2unix /home/starter.sh /home/xtreamcodes/iptv_xtream_codes/service /etc/cron.d/xtreamui || true \
 && chmod 0777 /home/starter.sh /home/entrypoint-wrapper.sh /home/xtreamcodes/iptv_xtream_codes/service /home/xtreamcodes/iptv_xtream_codes/start_services.sh \
 && chown root:root /etc/cron.d/xtreamui \
 && chmod 0644 /etc/cron.d/xtreamui \
 && chown -R xtreamcodes:xtreamcodes /home/xtreamcodes /home/utils \
 && usermod -aG sudo xtreamcodes \
 && chmod 0777 /home/xtreamcodes/iptv_xtream_codes/permissions.sh \
 && chattr -f -i /home/xtreamcodes/iptv_xtream_codes/GeoLite2.mmdb >/dev/null 2>&1 || true \
 && find /home/xtreamcodes/iptv_xtream_codes/admin/ -type f -exec chmod 644 {} \; \
 && find /home/xtreamcodes/iptv_xtream_codes/admin/ -type d -exec chmod 755 {} \; \
 && chmod 0777 /home/xtreamcodes/iptv_xtream_codes/pytools/balancer.py \
 && chmod +x /home/xtreamcodes/iptv_xtream_codes/nginx/sbin/nginx || true \
 && chmod +x /home/xtreamcodes/iptv_xtream_codes/nginx_rtmp/sbin/nginx_rtmp || true \
 && find /home/xtreamcodes/iptv_xtream_codes/wwwdir/ -type f -exec chmod 644 {} \; \
 && find /home/xtreamcodes/iptv_xtream_codes/wwwdir/ -type d -exec chmod 755 {} \; \
 && chmod 0700 /home/xtreamcodes/iptv_xtream_codes/config || true

# Finish
RUN apt-get update \
 && apt-get install -f -y \
 && apt-get upgrade -y \
 && apt-get dist-upgrade -y

# Volumes
VOLUME ["/home/xtreamcodes/iptv_xtream_codes", "/home/utils"]

# Ports
EXPOSE 80 443 1935 2095 2096

# Entrypoint
ENTRYPOINT ["/home/entrypoint-wrapper.sh"]
