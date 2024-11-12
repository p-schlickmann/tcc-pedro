# Usando imagem base do Tomcat 8 com JDK 8
FROM tomcat:8-jdk8

# Instalando utilitários necessários
RUN apt-get update && apt-get install -y \
iputils-ping \
maven \
nodejs \
npm \
cmake

# Definindo diretório de trabalho
WORKDIR /tcc-app

# Criando diretório para arquivos (conforme original)
RUN mkdir -p /home/tcc/files

# Copiando e instalando as dependencias antes de copiar todos os arquivos para o container
# https://stackoverflow.com/questions/70318095/why-copy-package-json-and-install-dependencies-before-copying-the-rest-of-the-pr
COPY ./dependencias ./dependencias
COPY pom.xml .
RUN mvn dependency:go-offline

# Copiando os arquivos para o container
COPY . .

RUN ["chmod", "+x", "./entrypoint.sh"]
RUN ["chmod", "+x", "./self_ssl.sh"]

# Expondo as portas do tomcat
EXPOSE 8080
EXPOSE 8443

ARG SELF_SSL=no
RUN if [ "$SELF_SSL" = "yes" ]; then ./self_ssl.sh; fi

# Construindo a aplicação
CMD ./entrypoint.sh
