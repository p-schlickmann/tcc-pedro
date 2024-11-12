#!/bin/bash

# Gerar chave privada e certificado autoassinado.
openssl req -x509 -newkey rsa:4096 -keyout /usr/local/tomcat/conf/localhost.key -out /usr/local/tomcat/conf/localhost.crt -days 365 -nodes -subj "/CN=localhost"

# Converter chave e certificado para o formato PKCS12 e depois para keystore
openssl pkcs12 -export -in /usr/local/tomcat/conf/localhost.crt -inkey /usr/local/tomcat/conf/localhost.key -out /usr/local/tomcat/conf/localhost.p12 -name tomcat -password pass:changeit
keytool -importkeystore -deststorepass changeit -destkeypass changeit -destkeystore /usr/local/tomcat/conf/localhost.keystore -srckeystore /usr/local/tomcat/conf/localhost.p12 -srcstoretype PKCS12 -srcstorepass changeit -alias tomcat

