
# 简介

用于配置局域网docker镜像缓存的脚本，启用ssl保证安全性。

# 服务端配置

## 克隆项目

```
git clone https://github.com/siaimes/docker-cache.git
cd docker-cache
```

## 生成证书

```
cd ssl
chmod +x get_ssl.sh
./get_ssl.sh your_server_ip
cd ..
```

## 启动服务

```
nano docker-compose
```

修改`your_server_ip`为你的服务器IP

```
chmod +x *.sh
./start.sh
```

# 客户端配置

## 克隆项目

```
git clone https://github.com/siaimes/docker-cache.git
cd docker-cache
```

## 获取证书

```
sudo ./get_docker_cache_ssl.sh your_server_ip username /path/to/ssl
```

## 测试服务

```
sudo docker pull your_server_ip:5000/ubuntu
```

## 固化配置

```
sudo nano /etc/docker/daemon.json
```

添加以下内容

```
{"registry-mirrors": ["https://your_server_ip:5000"]}
```

```
sudo systemctl restart docker
```

## 测试结果

```
sudo docker rmi your_server_ip:5000/library/ubuntu
sudo docker pull library/ubuntu
```

# 参考连接

[How To Set Up HTTPS](https://openpai.readthedocs.io/en/latest/manual/cluster-admin/basic-management-operations.html)

[x509: cannot validate certificate for 10.30.0.163 because it doesn't contain any IP SANs](https://blog.csdn.net/min19900718/article/details/87920254)

[私有安全docker registry授权访问实验](https://www.huaweicloud.com/articles/5fa5f84d8308590fcaa949d5dd5d9a04.html)