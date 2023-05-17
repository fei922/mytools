cat > update-monit-conf.sh << EOF
#!/bin/bash
#

MONIT_CONF_DIR="/etc/monit/conf-enabled/"



for host in \$(kubectl get node  -owide --no-headers |awk '{print \$6}')
do
  echo -e "\033[1;33m------------\$host---------------\033[0m"
  #ssh-copy-id $host    # 第一次执行，用来做免密登录

#  ssh $host 'sed -i "s/search hollysys.net/# search hollysys.net/" /etc/resolv.conf'
  # ssh $host 'sed -i "s/# search hollysys.net//" /etc/resolv.conf'
  ssh \$host 'MONIT_CONF_DIR="/etc/monit/conf-enabled/";conffiles=\$(ls \$MONIT_CONF_DIR); for conf in \${conffiles[@]}; do  echo -e "\033[1;33m\$MONIT_CONF_DIR\$conf\033[0m"; cat \$MONIT_CONF_DIR\$conf; done'


done
EOF


# chmod +x update-monit-conf.sh
# ./update-monit-conf.sh


# cd /etc/monit/conf-enabled/
# ls -l


cat > update-ulimit.sh << EOF
#!/bin/bash
#

for host in \$(kubectl get node  -owide --no-headers |awk '{print \$6}')
do
  echo -e "\033[1;33m------------\$host---------------\033[0m"
  #ssh-copy-id $host    # 第一次执行，用来做免密登录

#  ssh $host 'sed -i "s/search hollysys.net/# search hollysys.net/" /etc/resolv.conf'
  # ssh $host 'sed -i "s/# search hollysys.net//" /etc/resolv.conf'
  ssh \$host 'ulimit -n 51200'


done
EOF

chmod +x update-ulimit.sh
./update-ulimit.sh




cat > restart-k3s-agent.sh << EOF
#!/bin/bash
#

for host in \$(kubectl get node  -owide --no-headers |awk '{print \$6}')
do
  echo -e "\033[1;33m------------\$host---------------\033[0m"
  #ssh-copy-id $host    # 第一次执行，用来做免密登录

#  ssh $host 'sed -i "s/search hollysys.net/# search hollysys.net/" /etc/resolv.conf'
  # ssh $host 'sed -i "s/# search hollysys.net//" /etc/resolv.conf'
  ssh \$host 'systemctl restart k3s-agent'


done
EOF

chmod +x restart-k3s-agent.sh
./restart-k3s-agent.sh


cat > history-cmd-add-time.sh << EOF
#!/bin/bash
#

for host in \$(kubectl get node  -owide --no-headers |awk '{print \$6}')
do
  echo -e "\033[1;33m------------\$host---------------\033[0m"
  ssh-copy-id \$host    # 第一次执行，用来做免密登录

  ssh \$host 'if ! grep HISTTIMEFORMAT /root/.bashrc ; then echo  -e "export HISTTIMEFORMAT=\"%F %T  \""  >> ~/.bashrc; fi'


done
EOF

chmod +x history-cmd-add-time.sh
./history-cmd-add-time.sh



cat > copy-center-image-cert.sh << EOF
#!/bin/bash
#

for host in \$(kubectl get node  -owide --no-headers |awk '{print \$6}')
do
  echo -e "\033[1;33m------------\$host---------------\033[0m"
  ssh-copy-id \$host    # 第一次执行，用来做免密登录

  scp -r  /etc/docker/certs.d/192.168.2.200\:443/      \$host:/etc/docker/certs.d


done
EOF

chmod +x copy-center-image-cert.sh
./copy-center-image-cert.sh
sit@7556



cat > /etc/docker/daemon.json << EOF
{
 "registry-mirrors":["https://kx1m9a0x.mirror.aliyuncs.com"],
   "log-driver": "json-file",
    "log-opts": {
    "max-size": "100m",
    "max-file": "3"
  },
    "max-concurrent-downloads": 10,
    "max-concurrent-uploads": 10,
    "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
    ]
}
EOF




cat > reboot-worker.sh << EOF
#!/bin/bash
#

for host in \$(kubectl get node  -owide --no-headers | grep worker|awk '{print \$6}')
do
  echo -e "\033[1;33m------------\$host---------------\033[0m"
  #ssh-copy-id $host    # 第一次执行，用来做免密登录

#  ssh $host 'sed -i "s/search hollysys.net/# search hollysys.net/" /etc/resolv.conf'
  # ssh $host 'sed -i "s/# search hollysys.net//" /etc/resolv.conf'
  ssh \$host 'sync; reboot'


done
EOF
chmod +x reboot-worker.sh
./reboot-worker.sh