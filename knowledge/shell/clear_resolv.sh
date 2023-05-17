#!/bin/bash
#
for host in $(kubectl get node  -owide | grep -v NAME |awk '{print $6}')
do
  echo ---------------------$host-----------------------
  #ssh-copy-id $host    # 第一次执行，用来做免密登录

#  ssh $host 'sed -i "s/search hollysys.net/# search hollysys.net/" /etc/resolv.conf'
  ssh $host 'sed -i "s/# search hollysys.net//" /etc/resolv.conf'
  ssh $host 'cat /etc/resolv.conf | grep search'


done

