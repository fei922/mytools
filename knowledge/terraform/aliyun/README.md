#阿里云demo
+ vpc
+ security group
+ ecs instance

参考：
* https://github.com/alibaba/terraform-alicloud-ecs-instance
* https://github.com/alibaba/terraform-alicloud-security-group
* https://github.com/alibaba/terraform-alicloud-vpc

### 2018-05-02 02

创建阿里云ecs、vpc、security-group 

依次在vpc、security-group、vpc-sg-ecs三个目录执行
    
    terrafrom init
    terraform plan
    terrafrom apply

即可创建vpc、vswitch、security-group、ecs

```
  当前目录结构
  |- aliyun
      | -- ecs-instance
      | -- security-group
      | -- vpc
      | -- vpc-sg-ecs
```


### 2018-05-02
在阿里云提供的创建ecs、vpc、security-group，文件的基础上做了修改

可以创建以上三种实例，不过目前ecs、sg都是用的默认vpc，创建好的vpc还没有用来创建ecs

当前terraform 版本 0.11.7

```
  当前目录结构
  |- aliyun
      | -- ecs-instance
      | -- security-group
      | -- vpc
```