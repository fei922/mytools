# k8s 1.8.8集群部署 dns

### 参考资料

* [Kubernetes 1.8 DNS服务](http://www.lstop.pub/2017/12/04/Kubernetes-1-8-DNS%E6%9C%8D%E5%8A%A1/)
* [高可用Kubernetes集群-11. 部署kube-dns](https://www.cnblogs.com/netonline/p/8858809.html)
* [Kubernetes 1.7版本安装](http://www.cnblogs.com/ericnie/p/7904617.html)
* [Kubernetes ServiceAccount的配置](https://www.cnblogs.com/ericnie/p/6894688.html)


### 1. 下载所需镜像

### 2. 执行命令

    kubectl create -f kube-dns.yaml



在kubelet中需要配置cluster-dns和cluster-domain

    [root@node1 ~]# cat /etc/kubernetes/kubelet 
    KUBELET_ADDRESS="--address=0.0.0.0"
	KUBELET_PORT="--port=10250"
	KUBELET_HOSTNAME="--hostname_override=node1"
	KUBELET_API_SERVER="--api_servers=http://k8s-master:8080"
	KUBELET_ARGS="--cluster-dns=10.254.0.10 --cluster-domain=cluster.local --pod-infra-container-image=docker.io/kubernetes/pause:latest"


	systemctl daemon-reload 
	systemctl restart kubelet




* Kubernetes ServiceAccount的配置

```

    [root@localhost generate-cert]# ./make-ca-cert.sh "10.110.18.141" "IP:10.110.18.141,IP:10.254.0.1,DNS:kubernetes,DNS:kubernetes.default,DNS:kubernetes.default.svc,DNS:kubernetes.default.svc.cluster.local"
	chgrp: invalid group: ‘kube-cert’

	[root@localhost generate-cert]# ls /srv/kubernetes/
	ca.crt  kubecfg.crt  kubecfg.key  server.cert  server.key
   
    [root@localhost generate-cert]# cp /srv/kubernetes/* /etc/kubernetes/certs/

	# adminission-control 增加ServiceAccount，然后增加剩下的几行 
	[root@localhost istio-0.8.0]# vi /etc/kubernetes/manifests/apiserver.manifest 
    "--admission-control=NamespaceLifecycle,NamespaceExists,LimitRanger,ServiceAccount,ResourceQuota",

    "--authorization-mode=RBAC",
    "--secure-port=443",
    "--client-ca-file=/etc/kubernetes/certs/ca.crt",
    "--tls-cert-file=/etc/kubernetes/certs/server.cert",
    "--tls-private-key-file=/etc/kubernetes/certs/server.key"
    
	# 注意逗号
	[root@localhost istio-0.8.0]# vi /etc/kubernetes/manifests/controller-manager.manifest
	"--root-ca-file=/etc/kubernetes/certs/ca.crt",
    "--service-account-private-key-file=/etc/kubernetes/certs/server.key"
	
	# 然后把/srv/kuberentes 替换成/etc/kubernetes

	# 将/etc/kubernetes/certs下的文件分发到node节点
	[root@localhost generate-cert]# ssh 10.110.18.142
	Last login: Sat Jun  9 23:24:53 2018 from 10.9.11.168
	[root@localhost ~]# ls /etc/kubernetes/certs/
	[root@localhost ~]# 
	[root@localhost ~]# scp -r 10.110.18.141:/etc/kubernetes/certs/* /etc/kubernetes/certs/
	The authenticity of host '10.110.18.141 (10.110.18.141)' can't be established.
	ECDSA key fingerprint is ee:87:55:3a:d4:96:9e:c7:78:0e:a8:c1:8b:26:d3:75.
	Are you sure you want to continue connecting (yes/no)? yes
	Warning: Permanently added '10.110.18.141' (ECDSA) to the list of known hosts.
	root@10.110.18.141's password: 
	ca.crt                                                                                                                                            100% 1224     1.2KB/s   00:00    
	kubecfg.crt                                                                                                                                       100% 4474     4.4KB/s   00:00    
	kubecfg.key                                                                                                                                       100% 1704     1.7KB/s   00:00    
	server.cert                                                                                                                                       100% 4880     4.8KB/s   00:00    
	server.key  
	