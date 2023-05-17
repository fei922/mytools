#!/bin/bash
#
# set -x

hosts=$(cat hosts.txt)

echo -e "\033[0;33m===iptable设置前的规则===\033[0m"
echo -e "\033[0;32m" 
iptables -L INPUT -n
echo -e "\033[0m"

# 放通指定端口
open_ports=(
22
80
10022
)

gpaasSecurityChain=$1

iptables -t filter -N ${gpaasSecurityChain}

for port in ${open_ports[@]}; do
	iptables -C INPUT  -p tcp  --dport ${port} -j ACCEPT 1> /dev/null 2>&1

	if [[ $? -eq 0 ]]; then
		echo -e "\033[0;33mIptables rule \"iptables -A INPUT  -p tcp  --dport ${port} -j ACCEPT\" alreay exists.\033[0m"
	else
		iptables -A INPUT  -p tcp  --dport ${port} -j ACCEPT
	fi
done

iptables -C INPUT -j ${gpaasSecurityChain}
if [[ $? -eq 0 ]]; then
	echo -e "\033[0;33mIptables rule \"iptables -I INPUT -j ${gpaasSecurityChain}\" alreay exists.\033[0m"
else
	iptables -I INPUT -j ${gpaasSecurityChain}
fi

# 默认filter表INPUT链策略设置为DROP
iptables -P INPUT  DROP

# 开通指定ip段的访问
for host in ${hosts[@]}; do
	iptables -C ${gpaasSecurityChain} -s ${host}  -j ACCEPT 1> /dev/null 2>&1
	if [[ $? -eq 0 ]]; then
		echo -e "\033[0;33mIptables rule \"iptables -A ${gpaasSecurityChain} -s ${host}  -j ACCEPT\" alreay exists.\033[0m"
#                iptables -D INPUT -s ${host}  -j ACCEPT
	else
		iptables -A ${gpaasSecurityChain} -s ${host}  -j ACCEPT
	fi
done


# 允许内网连接外网
iptables -C ${gpaasSecurityChain} -m state --state established,related -j ACCEPT 1> /dev/null 2>&1
if [[ $? -eq 0 ]]; then
	echo -e "\033[0;33mIptables rule 'iptables -A ${gpaasSecurityChain} -m state --state established,related -j ACCEPT' alreay exists.\033[0m"
else
	iptables -A ${gpaasSecurityChain} -m state --state established,related -j ACCEPT
fi

echo -e "\033[1;33m\n===iptable设置后的规则===\033[0m"
echo -e "\033[1;32m" 
echo "========INPUT======================="
iptables -L INPUT -n
# echo "========${gpaasSecurityChain}======="
# iptables -L ${gpaasSecurityChain} -n
echo -e "\033[0m"
echo "Done!"