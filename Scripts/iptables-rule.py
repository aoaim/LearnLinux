print("這是一個簡單的 iptables 規則生成器。")

local_server_ip = input("請輸入當前服務器的主用網卡 ip，通常編號爲 eth0： ")
local_server_port = input("請輸入當前服務器的轉發端口： ")
remote_server_ip = input("請輸入目標服務器的 IP： ")
remote_server_port = input("請輸入目標服務器的被轉發端口： ")

print("\n即將輸入 iptables 規則，請複製粘貼使用：\n")
print(f"iptables -t nat -A PREROUTING -p tcp -m tcp --dport {local_server_port} -j DNAT --to-destination {remote_server_ip}:{remote_server_port}")
print(f"iptables -t nat -A PREROUTING -p udp -m udp --dport {local_server_port} -j DNAT --to-destination {remote_server_ip}:{remote_server_port}")
print(f"iptables -t nat -A POSTROUTING -d {remote_server_ip} -p tcp -m tcp --dport {remote_server_port} -j SNAT --to-source {local_server_ip}")
print(f"iptables -t nat -A POSTROUTING -d {remote_server_ip} -p udp -m udp --dport {remote_server_port} -j SNAT --to-source {local_server_ip}")