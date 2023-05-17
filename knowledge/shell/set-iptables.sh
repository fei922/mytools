#!/bin/bash
#
for host in $(kubectl get node  -owide --no-headers  |awk '{print $6}')
do
  echo -e "\033[1;33m==================$host==================\033[0m"
  #ssh-copy-id $host    # 第一次执行，用来做免密登录

  scp  setiptables ${host}:/tmp/
  ssh $host 'cd  /tmp/setiptables; ./set.sh'
 
done
echo "all done!"



#############
# set.sh

#!/bin/bash
#

hosts=$(cat hosts.txt)

echo -e "\033[0;33m===iptable设置前的规则===\033[0m"
echo -e "\033[0;32m" 
iptables -L INPUT -n
echo -e "\033[0m"

# 放通22端口
iptables -C INPUT  -p tcp  --dport 22 -j ACCEPT 1> /dev/null 2>&1

if [[ $? -eq 0 ]]; then
	echo -e "\033[0;33mIptables rule 'iptables -A INPUT  -p tcp  --dport 22 -j ACCEPT' alreay exists.\033[0m"
else
	iptables -A INPUT  -p tcp  --dport 22 -j ACCEPT
fi
iptables -P INPUT  DROP

for host in ${hosts[@]}; do
	iptables -C INPUT -s ${host}  -j ACCEPT 1> /dev/null 2>&1
	if [[ $? -eq 0 ]]; then
		echo -e "\033[0;33mIptables rule \"iptables -A INPUT -s ${host}  -j ACCEPT\" alreay exists.\033[0m"
#                iptables -D INPUT -s ${host}  -j ACCEPT
	else
		iptables -A INPUT -s ${host}  -j ACCEPT
	fi
done

# 允许内网连接外网
iptables -C INPUT -m state --state established,related -j ACCEPT 1> /dev/null 2>&1
if [[ $? -eq 0 ]]; then
	echo -e "\033[0;33mIptables rule 'iptables -A INPUT -m state --state established,related -j ACCEPT' alreay exists.\033[0m"
else
	iptables -A INPUT -m state --state established,related -j ACCEPT
fi

echo -e "\033[1;33m\n===iptable设置后的规则===\033[0m"
echo -e "\033[1;32m" 
iptables -L INPUT -n
echo -e "\033[0m"
echo "Done!"



