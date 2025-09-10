FROM ubuntu:18.04

WORKDIR /

ENV DEBIAN_FRONTEND=noninteractive

RUN sed -ri 's|http://archive.ubuntu.com/ubuntu|http://ubuntu.c3sl.ufpr.br/ubuntu|g; s|http://security.ubuntu.com/ubuntu|http://ubuntu.c3sl.ufpr.br/ubuntu|g' /etc/apt/sources.list && printf 'Acquire::Retries "10";\nAcquire::http::Timeout "45";\nAcquire::https::Timeout "45";\nAcquire::ForceIPv4 "true";\nAcquire::http::Pipeline-Depth "0";\nAcquire::http::No-Cache "true";\n' > /etc/apt/apt.conf.d/99net-tuning

RUN useradd --system \
    --no-create-home \
    --home-dir /home/xtreamcodes \
    --shell /bin/false \
    --user-group xtreamcodes

RUN apt-get update \
 && apt-get install -y software-properties-common ca-certificates gnupg dirmngr curl \
 && mkdir -p /root/.gnupg \
 && chmod 700 /root/.gnupg \
 && printf 'keyserver hkps://keyserver.ubuntu.com:443\nkeyserver hkps://keys.openpgp.org\n' > /root/.gnupg/dirmngr.conf \
 && for p in ppa:ondrej/php ppa:deadsnakes/ppa ppa:ondrej/nginx ppa:maxmind/ppa; do for i in 1 2 3; do add-apt-repository -y "$p" && break || sleep 5; done; done \
 && apt-get update \
 && apt-get install -y libcurl4 libcurl4-openssl-dev \
 && ln -sf /usr/lib/x86_64-linux-gnu/libcurl.so.4 /usr/lib/libcurl.so.3 \
 && ldconfig \
 && apt-get upgrade -y \
 && apt-get dist-upgrade -y

ENV LD_PRELOAD=/usr/lib/libcurl.so.3

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

RUN wget -qO /tmp/libpng12.deb \
     http://ubuntu.c3sl.ufpr.br/ubuntu/pool/main/libp/libpng/libpng12-0_1.2.54-1ubuntu1_amd64.deb \
 && dpkg -i /tmp/libpng12.deb \
 && rm /tmp/libpng12.deb

RUN echo "iptables-persistent iptables-persistent/autosave_v4 boolean true" | debconf-set-selections \
 && echo "iptables-persistent iptables-persistent/autosave_v6 boolean true" | debconf-set-selections \
 && apt-get update \
 && apt-get install -y iptables-persistent \
 && rm -rf /var/lib/apt/lists/*

COPY xtreamui.cron /etc/cron.d/xtreamui
COPY service /home/xtreamcodes/iptv_xtream_codes/service
COPY starter.sh /starter.sh

RUN set -eux; dos2unix /starter.sh /home/xtreamcodes/iptv_xtream_codes/service /etc/cron.d/xtreamui
RUN set -eux; chmod 0777 /starter.sh /home/xtreamcodes/iptv_xtream_codes/service /home/xtreamcodes/iptv_xtream_codes/start_services.sh
RUN set -eux; chown root:root /etc/cron.d/xtreamui
RUN set -eux; chmod 644 /etc/cron.d/xtreamui
RUN set -eux; sed -i -e '$a\' /etc/cron.d/xtreamui

RUN printf "xtreamcodes ALL=(ALL) NOPASSWD:ALL\n" > /etc/sudoers.d/90-xtreamcodes \
 && chmod 0440 /etc/sudoers.d/90-xtreamcodes

RUN sudo chown xtreamcodes:xtreamcodes -Rf /home/xtreamcodes

RUN sudo usermod -aG sudo xtreamcodes

VOLUME ["/home/xtreamcodes/iptv_xtream_codes","/home/xtreamcodes_utils"]

EXPOSE 8880 1935 8443

ENTRYPOINT ["/starter.sh"]
