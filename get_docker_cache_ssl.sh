FileName=$1
Name=$2
Path=$3
mkdir -p /etc/docker/certs.d/${FileName}:5000/
rsync -avz ${Name}@${FileName}:${Path}/${FileName}.crt /etc/docker/certs.d/${FileName}:5000/
