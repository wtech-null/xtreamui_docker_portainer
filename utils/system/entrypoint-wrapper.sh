#!/bin/sh
set -e

NOFILE_WANT=2147483584
NPROC_WANT="unlimited"

echo "[entrypoint] before: nofile=$(ulimit -n) nproc=$(ulimit -u 2>/dev/null || echo '?')"

if [ -w /proc/sys/fs/nr_open ]; then sysctl -w fs.nr_open=2147483584 || true; fi
if [ -w /proc/sys/fs/file-max ]; then sysctl -w fs.file-max=50000000 || true; fi
if [ -w /proc/sys/fs/aio-max-nr ]; then sysctl -w fs.aio-max-nr=20970800 || true; fi
if [ -w /proc/sys/vm/max_map_count ]; then sysctl -w vm.max_map_count=1048576 || true; fi
if [ -w /proc/sys/vm/overcommit_memory ]; then sysctl -w vm.overcommit_memory=1 || true; fi
if [ -w /proc/sys/vm/swappiness ]; then sysctl -w vm.swappiness=0 || true; fi

modprobe tcp_bbr 2>/dev/null || true

apply_sysctls() {
  cat <<'EOT'
net.ipv4.tcp_congestion_control|bbr
net.core.default_qdisc|fq
net.ipv4.tcp_rmem|8192 87380 134217728
net.ipv4.udp_rmem_min|16384
net.core.rmem_default|262144
net.core.rmem_max|268435456
net.ipv4.tcp_wmem|8192 65536 134217728
net.ipv4.udp_wmem_min|16384
net.core.wmem_default|262144
net.core.wmem_max|268435456
net.core.somaxconn|65535
net.core.netdev_max_backlog|250000
net.core.optmem_max|65535
net.core.netdev_budget|6000
net.core.netdev_budget_usecs|20000
net.ipv4.tcp_max_tw_buckets|1440000
net.netfilter.nf_conntrack_max|8000000
net.ipv4.tcp_max_orphans|16384
net.ipv4.tcp_max_syn_backlog|65535
net.ipv4.ip_local_port_range|1024 65000
net.ipv4.ip_forward|1
net.ipv4.tcp_no_metrics_save|1
net.ipv4.tcp_slow_start_after_idle|0
net.ipv4.tcp_fin_timeout|15
net.ipv4.tcp_keepalive_time|300
net.ipv4.tcp_keepalive_probes|5
net.ipv4.tcp_keepalive_intvl|15
net.ipv4.tcp_timestamps|1
net.ipv4.tcp_window_scaling|1
net.ipv4.tcp_mtu_probing|1
net.ipv4.route.flush|1
net.ipv6.conf.all.disable_ipv6|1
net.ipv6.conf.default.disable_ipv6|1
net.ipv6.conf.lo.disable_ipv6|1
EOT
}

apply_sysctls | while IFS='|' read -r key val; do
  sysctl -w "$key=$val" 2>/dev/null || true
done

NR_OPEN=$(cat /proc/sys/fs/nr_open 2>/dev/null || echo 1048576)
case "$NOFILE_WANT" in
  ''|*[!0-9]*) NOFILE="$NR_OPEN" ;;
  *) if [ "$NOFILE_WANT" -gt "$NR_OPEN" ] 2>/dev/null; then NOFILE="$NR_OPEN"; else NOFILE="$NOFILE_WANT"; fi ;;
esac

ulimit -n "$NOFILE" || true
ulimit -u "$NPROC_WANT" 2>/dev/null || true

echo "[entrypoint] after:  nofile=$(ulimit -n) nproc=$(ulimit -u 2>/dev/null || echo '?')"
echo "[entrypoint] kernel:  fs.nr_open=$(cat /proc/sys/fs/nr_open 2>/dev/null || echo '?') file-max=$(cat /proc/sys/fs/file-max 2>/dev/null || echo '?')"

exec /home/starter.sh "$@"
