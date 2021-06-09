# 简介

用于配置docker镜像的脚本，启用ssl保证安全性，兼容有无域名、兼容局域网或Internet网部署等情况。

# 服务端配置

## 安装docker和docker-compose

[https://docs.docker.com/engine/install/ubuntu/](https://docs.docker.com/engine/install/ubuntu/)

[https://docs.docker.com/compose/install/](https://docs.docker.com/compose/install/)

## 克隆项目

```bash
git clone https://github.com/siaimes/docker-cache.git
cd docker-cache
```

## 生成证书

生成证书，其中第二个参数为1表示生成域名证书，其他值会生成IP证书，以自己条件确定：

```bash
cd ssl
chmod +x get_ssl.sh
./get_ssl.sh your_server_ip_or_domain 0
cd ..
```

如果端口有开放互联网访问，可以申请Let's Encrypt证书，或者配合Nginx部署更多的服务，这里就不展开了。

## 启动服务

```bash
nano docker-compose
```

其中，修改`your_server_ip_or_domain`为你的服务器IP或域名，修改`0.0.0.0:5000:5000`中第一个`5000`为你宿主机可用端口。

```bash
chmod +x *.sh
./start.sh
```

如果你镜像的不是dockerhub，例如gcr.io，那么将
```bash
      - PROXY_REMOTE_URL=https://registry-1.docker.io
```
改为
```bash
      - PROXY_REMOTE_URL=https://gcr.io
```

# 客户端配置

## 克隆项目

```bash
git clone https://github.com/siaimes/docker-cache.git
cd docker-cache
```

## 获取证书

如果是可信的证书，例如Let's Encrypt签发的证书，那么无需这一步。

```bash
sudo ./get_docker_cache_ssl.sh your_server_ip_or_domain port username /path/to/ssl
```

如果服务器限制密码登录，用脚本拷贝证书到客户端可能会遇到问题。

我们可以自己参考`get_docker_cache_ssl.sh`配置客户端：

这里如果port是443可以省略，后面也是如此。

1. 创建文件夹

```bash
sudo mkdir -p /etc/docker/certs.d/your_server_ip_or_domain:port/
```

2. 输出服务端的证书并拷贝到剪切板

```bash
cat ./ssl/your_server_ip_or_domain.crt
```

3. 在客户端创建证书文件并粘贴服务端证书内容

```bash
sudo nano /etc/docker/certs.d/your_server_ip_or_domain:port/your_server_ip_or_domain.crt
```

## 测试服务

如果镜像的是dockerhub，可以用下述命令测试：

```bash
sudo docker pull your_server_ip_or_domain:port/library/ubuntu
```

注意到拉取官方镜像的时候需要加上`library`，否则`Error response from daemon: manifest for ubuntu:latest not found`。

如果镜像的是gcr.io，可以用下述命令测试：

```bash
sudo docker pull your_server_ip_or_domain:port/google-containers/kube-apiserver:v1.15.11
```

## 固化配置

如果是镜像dockerhub才可以做这一步，如果镜像的是其它仓库，请忽略。

```bash
sudo nano /etc/docker/daemon.json
```

添加以下内容

```bash
{"registry-mirrors": ["https://your_server_ip_or_domain:port"]}
```

```bash
sudo systemctl restart docker
```

测试结果

```bash
sudo docker rmi your_server_ip_or_domain:port/library/ubuntu
sudo docker pull ubuntu
```

# 参考连接

[How To Set Up HTTPS](https://openpai.readthedocs.io/en/latest/manual/cluster-admin/basic-management-operations.html)

[x509: cannot validate certificate for 10.30.0.163 because it doesn't contain any IP SANs](https://blog.csdn.net/min19900718/article/details/87920254)

[私有安全docker registry授权访问实验](https://www.huaweicloud.com/articles/5fa5f84d8308590fcaa949d5dd5d9a04.html)