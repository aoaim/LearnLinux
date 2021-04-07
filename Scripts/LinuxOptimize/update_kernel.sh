
#!/usr/bin/env bash
echo=echo
for cmd in echo /bin/echo; do
    $cmd >/dev/null 2>&1 || continue

    if ! $cmd -e "" | grep -qE '^-e'; then
        echo=$cmd
        break
    fi
done

echo "[警告] 僅適用於 Debian 10！"
read -p "[警告] 其他版本使用可能出現的問題本腳本是不負澤任的，民白？ [y/n]" is_continue
if [[ ${is_continue} == "n" || ${is_continue} == "N" ]]; then
    exit 0
fi

echo
echo "[信息] 更新開始"

sh -c 'printf "deb https://deb.debian.org/debian buster-backports main" > /etc/apt/sources.list.d/buster-backports.list'

apt update

apt -t buster-backports install linux-image-amd64 linux-headers-amd64 -y

update-grub

OUT_INFO "[信息] 請重啓！"
exit 0