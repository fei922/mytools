# service mesh 开源框架Istio部署

### 参考资料

* [istio install by helm](https://istio.io/docs/setup/kubernetes/helm-install/)


### 前提

* k8s集群需要开启ServiceAccount配置
* k8s集群需要部署Dns

### 使用helm部署

需要先[安装helm](helm-install.md)

### k8s配置ServiceAccount

1. 生成证书

```
    if [[ -d /etc/kubernetes/certs ]]; then mkdir -p /etc/kubernetes/certs; fi
    
    cd /etc/kubernetes/certs
    
    openssl genrsa -out ca.key 2048
    
    openssl req -new -x509 -days 365 -key ca.key -out ca.crt \
    -subj "/C=CN/ST=BJ/L=BJ/O=Inspur/OU=SoftwareCenter/CN=rootca"
    
    openssl genrsa -out kube-apiserver.key 2048
    
    openssl req -new -sha256 -key kube-apiserver.key -subj "/C=CN/ST=BJ/O=Inspur/OU=SoftwareCenter/CN=registry" -out server.csr
    
    # 将10.110.18.207，修改成宿主机ip
    openssl x509 -req -extfile <(printf "subjectAltName=IP:10.110.18.207,IP:10.254.0.1,DNS:registry.inspur.com") -days 365 -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out kube-apiserver.cert
    
    #生成private key
    openssl genrsa -out private.pem 1024
    
    #生成private key对应publickey
    openssl rsa -in private.pem -pubout -out public.pem

```

2. 修改api-server和manage-controller的配置

```
    vi /etc/kubernetes/manifests/apiserver.manifest
    "--service-account-key-file=/certs/public.pem",
    "--tls-ca-file=/certs/ca.crt",
    "--tls-cert-file=/certs/kube-apiserver.cert",
    "--tls-private-key-file=/certs/kube-apiserver.key",
    "--admission-control=NamespaceLifecycle,ServiceAccount,NamespaceExists,LimitRanger,ResourceQuota"
    
    {
        "name": "certs",
        "mountPath": "/certs",
        "readOnly": true
    }
    
    {
        "name": "certs",
        "hostPath": {
            "path": "/etc/kubernetes/certs"
         }
    }
```

```
     vi /etc/kubernetes/manifests/controller-manager.manifest
     "--service-account-private-key-file=/certs/private.pem",
     "--root-ca-file=/certs/ca.crt"
     
      {
         "name": "certs",
         "mountPath": "/certs",
         "readOnly": true
     }
     
     {
         "name": "certs",
         "hostPath": {
                 "path": "/etc/kubernetes/certs"
         }
     }
```

看是否刷新了配置 `ps -ef | grep controller`

验证是否有serviceaccount，并且serviceaccount是否关联了secret

`kubectl get sa --all-namespaces` 

执行`kubectl get sa default -o yaml`，如果打印出下面信息

```
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      creationTimestamp: 2018-06-21T06:33:48Z
      name: default
      namespace: default
      resourceVersion: "3687"
      selfLink: /api/v1/namespaces/default/serviceaccounts/default
      uid: 0e267861-751d-11e8-b378-005056830924
    secrets:
    - name: default-token-klbrm
```
然后检查secret是否关联了证书 `kubectl get secret default-token-klbrm -o  yaml`

```
    apiVersion: v1
    data:
      ca.crt: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURsekNDQW4rZ0F3SUJBZ0lKQUlNcFdZT0ljNk5qTUEwR0NTcUdTSWIzRFFFQkN3VUFNR0l4Q3pBSkJnTlYKQkFZVEFrTk9NUXN3Q1FZRFZRUUlEQUpDU2pFTE1Ba0dBMVVFQnd3Q1Frb3hEekFOQmdOVkJBb01Ca2x1YzNCMQpjakVYTUJVR0ExVUVDd3dPVTI5bWRIZGhjbVZEWlc1MFpYSXhEekFOQmdOVkJBTU1Cbkp2YjNSallUQWVGdzB4Ck9EQTJNakV3TnpFek1qTmFGdzB4T1RBMk1qRXdOekV6TWpOYU1HSXhDekFKQmdOVkJBWVRBa05PTVFzd0NRWUQKVlFRSURBSkNTakVMTUFrR0ExVUVCd3dDUWtveER6QU5CZ05WQkFvTUJrbHVjM0IxY2pFWE1CVUdBMVVFQ3d3TwpVMjltZEhkaGNtVkRaVzUwWlhJeER6QU5CZ05WQkFNTUJuSnZiM1JqWVRDQ0FTSXdEUVlKS29aSWh2Y05BUUVCCkJRQURnZ0VQQURDQ0FRb0NnZ0VCQU5JVzZJamNUYUNzNVd4VTNnWmE4VUpBQjdNNFJOVUsxOHZVdzdHeTc3MmgKVkx4TGdZSVU1cGtEUlRSdmVwOTBoZitqRDhocjQ4QXNDRjdGSUM0SWpGcVdMZXV6MFNqMCtRR2VIZmVzNVRQMAo0WmZWSWU3N3oxVHlwRXBMZEZYaVBKTkFlL1hQa21nVGZQalk3TXRjOFBOTUxyc0xtTFc1N2lpaW0zTU5FdklXClptSkl5aFMwQW94WDBuek40c1RxRlloSmM0aEwxc3hzeHYrQWJIT1RsZGloYXZ5cjdFWmx0UVk5TEtTL3ZDb1kKQkt3SXBtOVpOTFYveklvZ0FOSDNKMEpBSjhlblFKUHJkdjQwZXIvQmVhMVFCdGNsc3hLaXk3R1duT292aitCTgorZG83cE9RbFRTQk4ySndxN1ZSc0Jib3A4WlJaVTlpM0Ftc2hMWlQ4R2NrQ0F3RUFBYU5RTUU0d0hRWURWUjBPCkJCWUVGSjhCeXNlR0pvbmMxc09mOHdzSURQNHAyZ3Y2TUI4R0ExVWRJd1FZTUJhQUZKOEJ5c2VHSm9uYzFzT2YKOHdzSURQNHAyZ3Y2TUF3R0ExVWRFd1FGTUFNQkFmOHdEUVlKS29aSWh2Y05BUUVMQlFBRGdnRUJBQVF0ZnhqaApoRUpnTXY2MlBUeG05QWprTE9adFlQSDZ5QjFZbVBHb0htVDNHQ1lYNnpLQWg1TjNmcE1ERTZURFN2VGlRdE1HCmpMNU1IeS9QdjRJbEZpeklKUjI2RTBKK3JISkwxU3hWTGF6bC9pTEJSTEVZaGFwdDZ5Vnl5V1EwaVZmekdaT1gKVDd2TDRIaGNDK001dTJVUFA5ZGVOYVlJMDMyL2p3b0ZkQUt1cVdZY2czTVgxbGdOVGJ3aFdrdFU1eHhnVEo2bApqYWZVMlNNWEpuQ0wwVlZGUkZRSHRZUXhNTFdnZUR2UGw3NkV0RG16NjF2c25rTzdINE1vWjRZazd0YlZUY0RGCmprNS9IbDBhdWxxbmhQcTRzb3hvSS9DeUpDT1Y1bEdOY1NTZjhvVlV6VHplMUZZbVpEdlJoSXNZbG1GL3RsNk0KTFlkOHowUXkxVEhYYzhJPQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==
      namespace: ZGVmYXVsdA==
      token: ZXlKaGJHY2lPaUpTVXpJMU5pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SnBjM01pT2lKcmRXSmxjbTVsZEdWekwzTmxjblpwWTJWaFkyTnZkVzUwSWl3aWEzVmlaWEp1WlhSbGN5NXBieTl6WlhKMmFXTmxZV05qYjNWdWRDOXVZVzFsYzNCaFkyVWlPaUprWldaaGRXeDBJaXdpYTNWaVpYSnVaWFJsY3k1cGJ5OXpaWEoyYVdObFlXTmpiM1Z1ZEM5elpXTnlaWFF1Ym1GdFpTSTZJbVJsWm1GMWJIUXRkRzlyWlc0dGEyeGljbTBpTENKcmRXSmxjbTVsZEdWekxtbHZMM05sY25acFkyVmhZMk52ZFc1MEwzTmxjblpwWTJVdFlXTmpiM1Z1ZEM1dVlXMWxJam9pWkdWbVlYVnNkQ0lzSW10MVltVnlibVYwWlhNdWFXOHZjMlZ5ZG1salpXRmpZMjkxYm5RdmMyVnlkbWxqWlMxaFkyTnZkVzUwTG5WcFpDSTZJakJsTWpZM09EWXhMVGMxTVdRdE1URmxPQzFpTXpjNExUQXdOVEExTmpnek1Ea3lOQ0lzSW5OMVlpSTZJbk41YzNSbGJUcHpaWEoyYVdObFlXTmpiM1Z1ZERwa1pXWmhkV3gwT21SbFptRjFiSFFpZlEuaktyYU5oS19vUWZxYXhIbHRtQy1BS1J5SHVPUzlVQk53bFV1dF90dHpPWk1lSXljWVYtb0tqRXdUU3pDTlV0MVotcURpYlFmQkdSRk9fdElqTnRCNjU1LTZrcDZSTldlX3F5eVR5cE1mMEJnbVJ2bU5teXRUUEFrWEVzYnhlM1FnUW40dFZIYl84MTZoNC1xMjRjWlJYM1U0bjZHc2ZmWFpMMmRXVWdYTDNv
    kind: Secret
    metadata:
      annotations:
        kubernetes.io/service-account.name: default
        kubernetes.io/service-account.uid: 0e267861-751d-11e8-b378-005056830924
      creationTimestamp: 2018-06-21T07:24:46Z
      name: default-token-klbrm
      namespace: default
      resourceVersion: "3683"
      selfLink: /api/v1/namespaces/default/secrets/default-token-klbrm
      uid: 2cf9a1c4-7524-11e8-bc79-005056830924
    type: kubernetes.io/service-account-token
```
这样说明ServiceAccount配置基本没有啥问题

3. 部署kube-dns

基于[k8s-dns](https://github.com/kubernetes/kubernetes/tree/release-1.8/cluster/addons/dns)，去掉了一部分认证相关的label，形成[k8s-dns.yml](../yaml/kube-dns.yaml)。

`kubectl create -f kube-dns.yml` 

检查pod和svc是否都起来了。

修改node 节点的kubelet.service，在启动参数中指定cluster-dns和cluster-domain。

```
    vi /usr/lib/systemd/system/kubelet.service
    # 在Exec的最后加上 --cluster-dns=10.254.0.254 --cluster-domain=cluster.local
    # 保存后，重启kubelet
    systemctl daemon-reload
    systemctl restart kubelet
```

验证dns是否部署成功

```
    [root@localhost yaml]# kubectl exec -it busybox sh
    / # 
    / # nslookup kubernetes
    Server:    10.254.0.254
    Address 1: 10.254.0.254 kube-dns.kube-system.svc.cluster.local
    
    Name:      kubernetes
    Address 1: 10.254.0.1 kubernetes.default.svc.cluster.local
    / # 
    / # 
    / # exit
    [root@localhost yaml]# kubectl exec -it busybox sh
    / # 
    / # 
    / # nslookup nginx-svc
    Server:    10.254.0.254
    Address 1: 10.254.0.254 kube-dns.kube-system.svc.cluster.local
    
    Name:      nginx-svc
    Address 1: 10.254.227.35 nginx-svc.default.svc.cluster.local
    / # 
    # 如果发现在同一个节点上的dns能够解析，但是不同节点上的访问不了，说明网络有问题
    # 检查cat /sys/devices/virtual/net/cni0/bridge/nf_call_iptables，如果打出来的值为0，则执行下面命令
    echo 1 > /sys/devices/virtual/net/cni0/bridge/nf_call_iptables
    # 然后重试，看是dns是否正常
    # [注意] 如果node节点重新启动，配置会重置。需要重新执行上面这条命令
    
    # 发现有时候busybox容器，
    # nslookup会提示类似dns问题[dns can't resolve kubernetes.default and/or cluster.local](https://github.com/kubernetes/kubernetes/issues/66924#issuecomment-411806846)，
    # 可以换成其他容器测试dns，比如alpine
    [root@localhost test]# cat alpine-pod.yaml 
    apiVersion: v1
    kind: Pod
    metadata:
      name: alpine
    spec:
      containers:
      - name: alpine 
        image: alpine:latest
        imagePullPolicy: IfNotPresent
        command: [ "sleep", "3600" ]
    
    [root@localhost test]# kubectl create -f alpine-pod.yaml 
    pod "alpine" created
    
    [root@localhost test]# kubectl exec -it alpine sh
    / # nslookup kubernetes
    nslookup: can't resolve '(null)': Name does not resolve
    
    Name:      kubernetes
    Address 1: 10.254.0.1 kubernetes.default.svc.cluster.local 
```

4. 通过helm安装

[root@localhost ~]# cd istio-0.8.0/


把istio所需的镜像(位于istio-0.8.0/istio-images目录下)都分发到节点，例如其中一台k8s-node上操作，

[root@localhost istio-images]# scp -r 10.111.66.66:/root/istio-images/* ./

[root@localhost istio-images]# images=$(ls .); for imageName in ${images[@]}; do docker load -i $imageName; done

加载所有镜像即可。

在k8s-master节点执行以下命令。

使用option 1进行部署，使用option2部署的时候出问题了。

Render Istio’s core components to a Kubernetes manifest called istio.yaml:

k8s 1.9以上支持开启自动边车注入，执行以下命令:

`helm template install/kubernetes/helm/istio --name istio --namespace istio-system > $HOME/istio.yaml`

不启动自动边车注入，执行以下命令:

`helm template install/kubernetes/helm/istio --name istio --namespace istio-system --set sidecarInjectorWebhook.enabled=false  --set tracing.enabled=true  > $HOME/istio.yaml`

因为当前使用的是1.8.8版本的集群，所以采用不自动边车注入的部署方式。

Install the components via the manifest:

`kubectl create namespace istio-system`

`kubectl create -f $HOME/istio.yaml`

然后看pod和service是否都启动了

`kubectl get pod -n isito-system`

`kubectl get svc -n istio-system`

5. bookinfo demo部署

把bookinfo的镜像分发到各个节点。

1). Change directory to the root of the Istio installation directory.

2). `kubectl apply -f <(istioctl kube-inject -f samples/bookinfo/kube/bookinfo.yaml)`

3). `istioctl create -f samples/bookinfo/routing/bookinfo-gateway.yaml`

```
    # 在root用户下执行，会提示需要在$HOME/.kube下有config文件
    # 将下面的ip，改成master的ip地址即可
    apiVersion: v1
    clusters:
    - cluster:
        server: http://10.110.18.207:8080
      name: development
    - cluster:
        server: http://10.110.18.207:8080
      name: maincluster
    contexts:
    - context:
        cluster: development
        user: developer
      name: dev
    - context:
        cluster: maincluster
        user: mycluster-1
      name: normal
    current-context: normal
    kind: Config
    preferences: {}
    users:
    - name: developer
      user: {}    
```
###卸载

采用helm部署的option1方法，执行以下命令来卸载

`kubectl delete -f $HOME/istio.yaml`