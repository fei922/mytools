
```
openssl genrsa -out ca.key 2048

openssl req -new -x509 -days 365 -key ca.key -out ca.crt \
-subj "/C=CN/ST=BJ/L=BJ/O=Inspur/OU=SoftwareCenter/CN=rootca"

openssl genrsa -out server.key 2048

openssl req -new -sha256 -key server.key -subj "/C=CN/ST=BJ/O=Inspur/OU=SoftwareCenter/CN=registry" -out server.csr

openssl x509 -req -extfile <(printf "subjectAltName=IP:10.110.18.207,IP:10.254.0.1,DNS:registry.inspur.com") -days 365 -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.cert


#生成private key
openssl genrsa -out private_key.pem 1024

#生成private key对应publickey
openssl rsa -in private_key.pem -pubout -out public_key.pem

#你需要把里面的IP改为你自己的IP

```
