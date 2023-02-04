#!/usr/bin/env bash

#更新软件源
apt update
#启用 BBR TCP 拥塞控制算法
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
sysctl -p

#安装x-ui：
bash <(curl -Ls https://raw.githubusercontent.com/vaxilu/x-ui/master/install.sh)

#安装nginx
apt install nginx
#添加配置
cp -f ./etc/nginx.conf /etc/nginx/nginx.conf 

#安装acme：
curl https://get.acme.sh | sh
#添加软链接：
ln -s  /root/.acme.sh/acme.sh /usr/local/bin/acme.sh
#切换CA机构： 
acme.sh --set-default-ca --server letsencrypt
#申请证书： 
acme.sh  --issue -d 你的域名 -k ec-256 --webroot  /var/www/html
#安装证书：
acme.sh --install-cert -d 你的域名 --ecc --key-file  /etc/x-ui/server.key  --fullchain-file /etc/x-ui/server.crt --reloadcmd     "systemctl force-reload nginx"