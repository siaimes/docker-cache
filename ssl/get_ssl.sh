FileName=$1
openssl genrsa -des3 -out ${FileName}.key 4096
openssl req -new -subj /C=US/ST=Washington/CN=${FileName} -key ${FileName}.key -out ${FileName}.csr
mv ${FileName}.key ${FileName}.origin.key
openssl rsa -in ${FileName}.origin.key -out ${FileName}.key
echo subjectAltName = IP:${FileName} > extfile.cnf
openssl x509 -req -days 3650 -in ${FileName}.csr -signkey ${FileName}.key -extfile extfile.cnf -out ${FileName}.crt
