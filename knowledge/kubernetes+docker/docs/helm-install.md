# 安装helm

###参考资料

* [Helm 安装文档](https://docs.helm.sh/using_helm/#installing-helm)

###步骤

1. 下载[安装包](https://storage.googleapis.com/kubernetes-helm/helm-v2.9.1-linux-amd64.tar.gz)，这里使用的是2.9.1版本

2. 解压。

`tar -zxvf helm-v2.0.0-linux-amd64.tgz`

3. 将helm二进制文件拷贝到/usr/local/bin。

`cp  linux-amd64/helm /usr/local/bin/helm`

4. 将helm需要的镜像下载到节点

gcr.io/kubernetes-helm/tiller:v2.9.1

