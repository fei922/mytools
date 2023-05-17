#!/bin/bash
#

master_allow_iprange=(
127.0.0.1
10.42.0.0/16
222.173.11.26
124.205.203.0/24
10.25.27.9
10.25.27.8
10.25.27.7
10.25.27.6
10.25.27.57
10.25.27.54
10.25.27.52
10.25.27.5
10.25.27.43
10.25.27.42
10.25.27.40
10.25.27.4
10.25.27.39
10.25.27.37
10.25.27.35
10.25.27.33
10.25.27.32
10.25.27.31
10.25.27.30
10.25.27.3
10.25.27.29
10.25.27.27
10.25.27.26
10.25.27.25
10.25.27.24
10.25.27.23
10.25.27.22
10.25.27.21
10.25.27.20
10.25.27.2
10.25.27.19
10.25.27.18
10.25.27.17
10.25.27.16
10.25.27.15
10.25.27.14
10.25.27.13
10.25.27.12
10.25.27.11
10.25.27.10
)

updateMaster443(){
	port=8443

	rancher_ip=$(docker inspect --format '{''{ .NetworkSettings.Networks.harbor_harbor.IPAddress }''}' nginx)

	dockerChain=gpaas-docker

	iptables -t filter -N ${dockerChain}	

	iptables -C ${dockerChain}  -d ${rancher_ip} -p tcp --dport ${port} -j DROP  1> /dev/null 2>&1
	if [[ $? -eq 0 ]]; then
		echo -e "\033[0;33mIptables rule \"iptables -I ${dockerChain}  -d ${rancher_ip} -p tcp --dport ${port} -j DROP\" alreay exists.\033[0m"
		# iptables -D ${dockerChain}  -d ${rancher_ip} -p tcp --dport ${port} -j DROP
	else
		iptables -I ${dockerChain}  -d ${rancher_ip} -p tcp --dport ${port} -j DROP
	fi

	for iprange in ${master_allow_iprange[@]}; do
		iptables -C ${dockerChain} -s ${iprange} -d ${rancher_ip} -p tcp --dport ${port} -j ACCEPT  1> /dev/null 2>&1
		if [[ $? -eq 0 ]]; then
			echo -e "\033[0;33mIptables rule \"iptables -I ${dockerChain} -s ${iprange} -d ${rancher_ip} -p tcp --dport ${port} -j ACCEPT\" alreay exists.\033[0m"
			# iptables -D ${dockerChain} -s ${iprange} -d ${rancher_ip} -p tcp --dport ${port} -j ACCEPT
		else
			iptables -I ${dockerChain} -s ${iprange} -d ${rancher_ip} -p tcp --dport ${port} -j ACCEPT
		fi
	done

	

	iptables -C DOCKER -j ${dockerChain}
	if [[ $? -eq 0 ]]; then
		echo -e "\033[0;33mIptables rule \"iptables -I DOCKER -j ${dockerChain}\" alreay exists.\033[0m"
	else
		iptables -I DOCKER -j ${dockerChain}
	fi
}

updateMaster443

echo "all done!"

