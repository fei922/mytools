# httpbin 访问日志


### Http方式访问

1. 

`curl --resolve httpbin.example.com:$INGRESS_PORT:$INGRESS_HOST -HHost:httpbin.example.com -I http://httpbin.example.com:$INGRESS_PORT/status/200`

```
[root@localhost httpbin]# curl -v --resolve httpbin.example.com:31380:10.110.18.209 -HHost:httpbin.example.com -I http://httpbin.example.com:31380/status/200
* Added httpbin.example.com:31380:10.110.18.209 to DNS cache
* About to connect() to httpbin.example.com port 31380 (#0)
*   Trying 10.110.18.209...
* Connected to httpbin.example.com (10.110.18.209) port 31380 (#0)
> HEAD /status/200 HTTP/1.1
> User-Agent: curl/7.29.0
> Accept: */*
> Host:httpbin.example.com
> 
< HTTP/1.1 200 OK
HTTP/1.1 200 OK
< server: envoy
server: envoy
< date: Tue, 26 Jun 2018 01:21:35 GMT
date: Tue, 26 Jun 2018 01:21:35 GMT
< content-type: text/html; charset=utf-8
content-type: text/html; charset=utf-8
< access-control-allow-origin: *
access-control-allow-origin: *
< access-control-allow-credentials: true
access-control-allow-credentials: true
< content-length: 0
content-length: 0
< x-envoy-upstream-service-time: 4
x-envoy-upstream-service-time: 4

< 
* Connection #0 to host httpbin.example.com left intact

```

2. 访问没有暴露的url，报404

```
[root@localhost httpbin]# curl -v --resolve httpbin.example.com:31380:10.110.18.209 -HHost:httpbin.example.com -I http://httpbin.example.com:31380/headers
* Added httpbin.example.com:31380:10.110.18.209 to DNS cache
* About to connect() to httpbin.example.com port 31380 (#0)
*   Trying 10.110.18.209...
* Connected to httpbin.example.com (10.110.18.209) port 31380 (#0)
> HEAD /headers HTTP/1.1
> User-Agent: curl/7.29.0
> Accept: */*
> Host:httpbin.example.com
> 
< HTTP/1.1 404 Not Found
HTTP/1.1 404 Not Found
< date: Tue, 26 Jun 2018 01:37:50 GMT
date: Tue, 26 Jun 2018 01:37:50 GMT
< server: envoy
server: envoy
< content-length: 0
content-length: 0

< 
* Connection #0 to host httpbin.example.com left intact

```

### Https方式访问

`curl --resolve httpbin.example.com:$SECURE_INGRESS_PORT:$INGRESS_HOST -HHost:httpbin.example.com -I -k https://httpbin.example.com:$SECURE_INGRESS_PORT/status/200`

```
[root@localhost httpbin]# curl -v --resolve httpbin.example.com:31390:10.110.18.209 -HHost:httpbin.example.com -I -k https://httpbin.example.com:31390/status/200
* Added httpbin.example.com:31390:10.110.18.209 to DNS cache
* About to connect() to httpbin.example.com port 31390 (#0)
*   Trying 10.110.18.209...
* Connected to httpbin.example.com (10.110.18.209) port 31390 (#0)
* Initializing NSS with certpath: sql:/etc/pki/nssdb
* skipping SSL peer certificate verification
* SSL connection using TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
* Server certificate:
* 	subject: CN=httpbin.example.com
* 	start date: Jun 26 01:39:57 2018 GMT
* 	expire date: Jun 26 01:39:57 2019 GMT
* 	common name: httpbin.example.com
* 	issuer: CN=httpbin.example.com
> HEAD /status/200 HTTP/1.1
> User-Agent: curl/7.29.0
> Accept: */*
> Host:httpbin.example.com
> 
< HTTP/1.1 200 OK
HTTP/1.1 200 OK
< server: envoy
server: envoy
< date: Tue, 26 Jun 2018 01:55:36 GMT
date: Tue, 26 Jun 2018 01:55:36 GMT
< content-type: text/html; charset=utf-8
content-type: text/html; charset=utf-8
< access-control-allow-origin: *
access-control-allow-origin: *
< access-control-allow-credentials: true
access-control-allow-credentials: true
< content-length: 0
content-length: 0
< x-envoy-upstream-service-time: 2
x-envoy-upstream-service-time: 2

< 
* Connection #0 to host httpbin.example.com left intact

```

### circuit_breaking_log

```
[root@localhost httpbin]# kubectl exec -it $FORTIO_POD  -c fortio /usr/local/bin/fortio -- load -c 1 -qps 0 -n 20 -loglevel Warning http://httpbin:8000/get
09:11:31 I logger.go:97> Log level is now 3 Warning (was 2 Info)
Fortio 1.0.0 running at 0 queries per second, 4->4 procs, for 20 calls: http://httpbin:8000/get
Starting at max qps with 1 thread(s) [gomax 4] for exactly 20 calls (20 per thread + 0)
Ended after 83.797889ms : 20 calls. qps=238.67
Aggregated Function Time : count 20 avg 0.0041883487 +/- 0.001009 min 0.00272203 max 0.005899572 sum 0.083766973
# range, mid point, percentile, count
>= 0.00272203 <= 0.003 , 0.00286101 , 15.00, 3
> 0.003 <= 0.004 , 0.0035 , 50.00, 7
> 0.004 <= 0.005 , 0.0045 , 70.00, 4
> 0.005 <= 0.00589957 , 0.00544979 , 100.00, 6
# target 50% 0.004
# target 75% 0.00514993
# target 90% 0.00559971
# target 99% 0.00586959
# target 99.9% 0.00589657
Sockets used: 1 (for perfect keepalive, would be 1)
Code 200 : 20 (100.0 %)
Response Header Sizes : count 20 avg 230 +/- 0 min 230 max 230 sum 4600
Response Body/Total Sizes : count 20 avg 865 +/- 0 min 865 max 865 sum 17300
All done 20 calls (plus 0 warmup) 4.188 ms avg, 238.7 qps
[root@localhost httpbin]# 
[root@localhost httpbin]# 
[root@localhost httpbin]# 
[root@localhost httpbin]# 
[root@localhost httpbin]# kubectl exec -it $FORTIO_POD  -c fortio /usr/local/bin/fortio -- load -c 2 -qps 0 -n 20 -loglevel Warning http://httpbin:8000/get
09:11:38 I logger.go:97> Log level is now 3 Warning (was 2 Info)
Fortio 1.0.0 running at 0 queries per second, 4->4 procs, for 20 calls: http://httpbin:8000/get
Starting at max qps with 2 thread(s) [gomax 4] for exactly 20 calls (10 per thread + 0)
09:11:38 W http_client.go:584> Parsed non ok code 503 (HTTP/1.1 503)
Ended after 62.057069ms : 20 calls. qps=322.28
Aggregated Function Time : count 20 avg 0.0060427117 +/- 0.001192 min 0.001463617 max 0.007398775 sum 0.120854234
# range, mid point, percentile, count
>= 0.00146362 <= 0.002 , 0.00173181 , 5.00, 1
> 0.005 <= 0.006 , 0.0055 , 30.00, 5
> 0.006 <= 0.007 , 0.0065 , 85.00, 11
> 0.007 <= 0.00739877 , 0.00719939 , 100.00, 3
# target 50% 0.00636364
# target 75% 0.00681818
# target 90% 0.00713293
# target 99% 0.00737219
# target 99.9% 0.00739612
Sockets used: 3 (for perfect keepalive, would be 2)
Code 200 : 19 (95.0 %)
Code 503 : 1 (5.0 %)
Response Header Sizes : count 20 avg 218.5 +/- 50.13 min 0 max 230 sum 4370
Response Body/Total Sizes : count 20 avg 832.6 +/- 141.2 min 217 max 865 sum 16652
All done 20 calls (plus 0 warmup) 6.043 ms avg, 322.3 qps
[root@localhost httpbin]# 
[root@localhost httpbin]# 
[root@localhost httpbin]# 
[root@localhost httpbin]# kubectl exec -it $FORTIO_POD  -c fortio /usr/local/bin/fortio -- load -c 3 -qps 0 -n 20 -loglevel Warning http://httpbin:8000/get
09:11:45 I logger.go:97> Log level is now 3 Warning (was 2 Info)
Fortio 1.0.0 running at 0 queries per second, 4->4 procs, for 20 calls: http://httpbin:8000/get
Starting at max qps with 3 thread(s) [gomax 4] for exactly 20 calls (6 per thread + 2)
09:11:45 W http_client.go:584> Parsed non ok code 503 (HTTP/1.1 503)
Ended after 104.951136ms : 20 calls. qps=190.56
Aggregated Function Time : count 20 avg 0.013469232 +/- 0.006589 min 0.001559926 max 0.0289988 sum 0.269384642
# range, mid point, percentile, count
>= 0.00155993 <= 0.002 , 0.00177996 , 5.00, 1
> 0.007 <= 0.008 , 0.0075 , 10.00, 1
> 0.008 <= 0.009 , 0.0085 , 35.00, 5
> 0.01 <= 0.011 , 0.0105 , 45.00, 2
> 0.012 <= 0.014 , 0.013 , 65.00, 4
> 0.014 <= 0.016 , 0.015 , 70.00, 1
> 0.016 <= 0.018 , 0.017 , 80.00, 2
> 0.018 <= 0.02 , 0.019 , 85.00, 1
> 0.02 <= 0.025 , 0.0225 , 90.00, 1
> 0.025 <= 0.0289988 , 0.0269994 , 100.00, 2
# target 50% 0.0125
# target 75% 0.017
# target 90% 0.025
# target 99% 0.0285989
# target 99.9% 0.0289588
Sockets used: 4 (for perfect keepalive, would be 3)
Code 200 : 19 (95.0 %)
Code 503 : 1 (5.0 %)
Response Header Sizes : count 20 avg 218.8 +/- 50.2 min 0 max 231 sum 4376
Response Body/Total Sizes : count 20 avg 832.9 +/- 141.3 min 217 max 866 sum 16658
All done 20 calls (plus 0 warmup) 13.469 ms avg, 190.6 qps
[root@localhost httpbin]# 
[root@localhost httpbin]# 
[root@localhost httpbin]# kubectl exec -it $FORTIO_POD  -c fortio /usr/local/bin/fortio -- load -c 3 -qps 0 -n 20 -loglevel Warning http://httpbin:8000/get
09:11:49 I logger.go:97> Log level is now 3 Warning (was 2 Info)
Fortio 1.0.0 running at 0 queries per second, 4->4 procs, for 20 calls: http://httpbin:8000/get
Starting at max qps with 3 thread(s) [gomax 4] for exactly 20 calls (6 per thread + 2)
Ended after 49.72114ms : 20 calls. qps=402.24
Aggregated Function Time : count 20 avg 0.0068435941 +/- 0.001321 min 0.002859845 max 0.009139159 sum 0.136871882
# range, mid point, percentile, count
>= 0.00285985 <= 0.003 , 0.00292992 , 5.00, 1
> 0.004 <= 0.005 , 0.0045 , 10.00, 1
> 0.005 <= 0.006 , 0.0055 , 15.00, 1
> 0.006 <= 0.007 , 0.0065 , 40.00, 5
> 0.007 <= 0.008 , 0.0075 , 85.00, 9
> 0.008 <= 0.009 , 0.0085 , 95.00, 2
> 0.009 <= 0.00913916 , 0.00906958 , 100.00, 1
# target 50% 0.00722222
# target 75% 0.00777778
# target 90% 0.0085
# target 99% 0.00911133
# target 99.9% 0.00913638
Sockets used: 3 (for perfect keepalive, would be 3)
Code 200 : 20 (100.0 %)
Response Header Sizes : count 20 avg 230 +/- 0 min 230 max 230 sum 4600
Response Body/Total Sizes : count 20 avg 865 +/- 0 min 865 max 865 sum 17300
All done 20 calls (plus 0 warmup) 6.844 ms avg, 402.2 qps
[root@localhost httpbin]# 
[root@localhost httpbin]# 
[root@localhost httpbin]# 
[root@localhost httpbin]# kubectl exec -it $FORTIO_POD  -c fortio /usr/local/bin/fortio -- load -c 3 -qps 0 -n 20 -loglevel Warning http://httpbin:8000/get
09:11:53 I logger.go:97> Log level is now 3 Warning (was 2 Info)
Fortio 1.0.0 running at 0 queries per second, 4->4 procs, for 20 calls: http://httpbin:8000/get
Starting at max qps with 3 thread(s) [gomax 4] for exactly 20 calls (6 per thread + 2)
09:11:53 W http_client.go:584> Parsed non ok code 503 (HTTP/1.1 503)
09:11:53 W http_client.go:584> Parsed non ok code 503 (HTTP/1.1 503)
09:11:53 W http_client.go:584> Parsed non ok code 503 (HTTP/1.1 503)
09:11:53 W http_client.go:584> Parsed non ok code 503 (HTTP/1.1 503)
09:11:53 W http_client.go:584> Parsed non ok code 503 (HTTP/1.1 503)
Ended after 52.211508ms : 20 calls. qps=383.06
Aggregated Function Time : count 20 avg 0.005849587 +/- 0.003544 min 0.000505505 max 0.012974963 sum 0.116991741
# range, mid point, percentile, count
>= 0.000505505 <= 0.001 , 0.000752752 , 10.00, 2
> 0.001 <= 0.002 , 0.0015 , 20.00, 2
> 0.002 <= 0.003 , 0.0025 , 25.00, 1
> 0.003 <= 0.004 , 0.0035 , 30.00, 1
> 0.005 <= 0.006 , 0.0055 , 60.00, 6
> 0.006 <= 0.007 , 0.0065 , 70.00, 2
> 0.008 <= 0.009 , 0.0085 , 80.00, 2
> 0.009 <= 0.01 , 0.0095 , 85.00, 1
> 0.011 <= 0.012 , 0.0115 , 95.00, 2
> 0.012 <= 0.012975 , 0.0124875 , 100.00, 1
# target 50% 0.00566667
# target 75% 0.0085
# target 90% 0.0115
# target 99% 0.01278
# target 99.9% 0.0129555
Sockets used: 8 (for perfect keepalive, would be 3)
Code 200 : 15 (75.0 %)
Code 503 : 5 (25.0 %)
Response Header Sizes : count 20 avg 172.55 +/- 99.62 min 0 max 231 sum 3451
Response Body/Total Sizes : count 20 avg 703.05 +/- 280.6 min 217 max 866 sum 14061
All done 20 calls (plus 0 warmup) 5.850 ms avg, 383.1 qps

```