FileName=$1
IsDomain=$2
openssl genrsa -des3 -out ${FileName}.key 4096
openssl req -new -subj /C=US/ST=Washington/CN=${FileName} -key ${FileName}.key -out ${FileName}.csr
mv ${FileName}.key ${FileName}.origin.key
openssl rsa -in ${FileName}.origin.key -out ${FileName}.key
if [ ${IsDomain} -eq 1 ]; then
    openssl x509 -req -days 3650 -in ${FileName}.csr -signkey ${FileName}.key -out ${FileName}.crt
else
    echo subjectAltName = IP:${FileName} > extfile.cnf
    openssl x509 -req -days 3650 -in ${FileName}.csr -signkey ${FileName}.key -extfile extfile.cnf -out ${FileName}.crt
fi
