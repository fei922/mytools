#!/bin/bash
#
for host in $(kubectl get node  -owide --no-headers  |awk '{print $6}')
do
  echo -e "\033[1;33m==================$host==================\033[0m"
  #ssh-copy-id $host    # 第一次执行，用来做免密登录

  scp -r  setiptables ${host}:/tmp/
  ssh $host 'cd  /tmp/setiptables;chmod +x set.sh;  ./set.sh'
 
done
echo "all done!"

