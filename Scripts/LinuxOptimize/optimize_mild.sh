#!/usr/bin/env bash
echo=echo
for cmd in echo /bin/echo; do
    $cmd >/dev/null 2>&1 || continue

    if ! $cmd -e "" | grep -qE '^-e'; then
        echo=$cmd
        break
    fi
done

clear
echo "-------------------------------------------------------"
echo "Thanks to:"
echo
echo "          Jamchoi"
echo "          Poka Leo"
echo "          d7fb"
echo "          xiye"
echo
echo "Solutions integrated from the Internet. Thanks to all!"
echo "-------------------------------------------------------"
echo

echo "[警告] 僅推薦 Debian10/Ubuntu20.04/CentOS8 版本及更高版本使用!"
read -p "[警告] 其他版本使用可能出現的問題本腳本是不負澤任的，民白？ [y/n]" is_continue
if [[ ${is_continue} == "n" || ${is_continue} == "N" ]]; then
    exit 0
fi

echo
echo "[信息] 優化開始"

CSI=$($echo -e "\033[")
CEND="${CSI}0m"
CDGREEN="${CSI}32m"
CRED="${CSI}1;31m"
CGREEN="${CSI}1;32m"
CYELLOW="${CSI}1;33m"
CBLUE="${CSI}1;34m"
CMAGENTA="${CSI}1;35m"
CCYAN="${CSI}1;36m"

OUT_ALERT() {
    echo -e "${CYELLOW}$1${CEND}"
}

OUT_ERROR() {
    echo -e "${CRED}$1${CEND}"
}

OUT_INFO() {
    echo -e "${CCYAN}$1${CEND}"
}

if [[ -f /etc/redhat-release ]]; then
    release="centos"
elif cat /etc/issue | grep -q -E -i "debian|raspbian"; then
    release="debian"
elif cat /etc/issue | grep -q -E -i "ubuntu"; then
    release="ubuntu"
elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
    release="centos"
elif cat /proc/version | grep -q -E -i "raspbian|debian"; then
    release="debian"
elif cat /proc/version | grep -q -E -i "ubuntu"; then
    release="ubuntu"
elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
    release="centos"
else
    OUT_ERROR "[錯誤] 不支持的操作系統！"
    exit 1
fi

OUT_ALERT "[信息] 正在更新源！"
if [[ ${release} == "centos" ]]; then
    yum makecache
    yum install epel-release -y
else
    apt update
fi

OUT_ALERT "[信息] 正在安裝 haveged 增強性能中！"
if [[ ${release} == "centos" ]]; then
    yum install haveged -y
else
    apt install haveged -y
fi

OUT_ALERT "[信息] 正在配置 haveged 增強性能中！"
systemctl disable --now haveged
systemctl enable --now haveged

OUT_ALERT "[信息] 正在優化系統參數中！"
cat > /etc/sysctl.conf << EOF
net.ipv6.conf.all.accept_ra = 2
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
fs.file-max = 1000000
fs.inotify.max_user_instances = 8192
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_tw_reuse = 1
net.ipv4.ip_local_port_range = 1024 65000
net.ipv4.tcp_max_syn_backlog = 16384
net.ipv4.tcp_max_tw_buckets = 6000
net.ipv4.route.gc_timeout = 100
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_synack_retries = 1
net.core.somaxconn = 32768
net.core.netdev_max_backlog = 32768
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_max_orphans = 32768
EOF
cat > /etc/security/limits.conf << EOF
* soft nofile 512000
* hard nofile 512000
* soft nproc 512000
* hard nproc 512000
root soft nofile 512000
root hard nofile 512000
root soft nproc 512000
root hard nproc 512000
EOF
cat > /etc/systemd/journald.conf <<EOF
[Journal]
SystemMaxUse=384M
SystemMaxFileSize=128M
ForwardToSyslog=no
EOF
sysctl -p

OUT_INFO "[信息] 優化完畢！"
exit 0