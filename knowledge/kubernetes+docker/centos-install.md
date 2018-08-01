# 20180627   centos 装机


### 安装

裸机插上硬盘直接进入安装界面，
如果有系统了，进入inspur欢迎界面需要按F12，进入bios，设置U盘启动
重启ctrl+alt+delete

f11 选择启动盘

1. 进入选择安装语言界面，选择中文

2. 安装位置，系统装在446G

软件安装：开发及生成工作站 => 附加开发，开发工具，kde

设置密码 root root

等待安装完成

重启

选时区 beijing

用户 inspur/inspur

进入之后网络打开eno1


8
onboot=yes
bootproto=static
IPADDR=192.168.1.**
GATEWAY=192.168.1.1
NETMASK=255.255.255.0




3. 配ip  配ip  192.168.1.**








###挂盘

tip 设置远程机器和本机在同一网段


fdisk -l
linux lvm
pv 硬盘  
pvdisplay # 查看分区

vgdisplay #

lvdisplay # 逻辑卷

df -h  





