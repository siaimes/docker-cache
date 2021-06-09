FileName=$1
Port=$2
Name=$3
Path=$4
if [ ${Port} -ne 443 ]; then
    mkdir -p /etc/docker/certs.d/${FileName}:${Port}/
    rsync -avz ${Name}@${FileName}:${Path}/${FileName}.crt /etc/docker/certs.d/${FileName}:${Port}/
else
    mkdir -p /etc/docker/certs.d/${FileName}/
    rsync -avz ${Name}@${FileName}:${Path}/${FileName}.crt /etc/docker/certs.d/${FileName}/
fi
