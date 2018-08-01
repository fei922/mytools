#/bin/bash

# 2018-06-13 13:49:16 by zhoufeirj
# 保存istio部署所需要的镜像
# istio version： 0.7.1

#images=(pause-amd64:3.0 kube-scheduler-amd64:v1.6.3 kube-controller-manager-amd64:v1.6.3 kube-apiserver-amd64:v1.6.3 etcd-amd64:3.0.17 kube-proxy-amd64:v1.6.3 k8s-dns-sidecar-amd64:1.14.1 k8s-dns-kube-dns-amd64:1.14.1 k8s-dns-dnsmasq-nanny-amd64:1.14.1 kubernetes-dashboard-amd64:v1.6.3)
# images=(pause-amd64:3.0)

images="istio"
output_dir=istio-images

if [[ ! -d $output_dir ]]; then

	echo -e "\033[0;33mCreate output directory $output_dir \033[0m"
	mkdir $output_dir
fi
cd $output_dir

# for imageName in ${images[@]}
# 获取匹配到的镜像
for imageName in $(docker images | grep $images |  awk '{print $1,$2}' | sed 's/ /:/g')
do
    # 截取最后一个/后面的镜像名
	tmp_tar_name=${imageName##*/}
	tar_name=${tmp_tar_name//:/-}.tar

	if [[ -f $tar_name ]]; then
		echo -e "\033[0;32m$tar_name already exists, jumped ... \033[0m"
	else
		echo -e "\033[0;33mStart save image $imageName ... \033[0m"
		# docker save -o fedora-all.tar fedora
		#
		# docker load -i fedora-all.tar

		echo "tar name is $tar_name"
		docker save -o $tar_name $imageName
	fi

done

ls .
pwd
