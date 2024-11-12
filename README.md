# Sistema de TCCs do INE (Versão em Docker)

## Variáveis de ambiente
```
MYSQLDB_USER=root
MYSQLDB_ROOT_PASSWORD=password
MYSQLDB_DATABASE=projetos
JAVA_OPTS="-Dspring.profiles.active=dev"
SELF_SSL=yes
```
1. `MYSQLDB_USER`: Usuário para conectar no banco de dados.
2. `MYSQLDB_ROOT_PASSWORD`: A senha para conectar no banco de dados.
3. `MYSQLDB_DATABASE`: Define o nome do banco de dados.
4. `JAVA_OPTS`: Define qual arquivo `.properties` será utilizado. Em produção deve ser usado o valor `prod`. Em desenvolvimento, o valor `dev`.
5. `SELF_SSL`: **Não utilizar essa variável em produção**. Cria um certificado de SSL não assinado para usar no ambiente local. O certificado SSL é necessário no ambiente local para a comunicação efetiva com o Sistema de Autenticação Centralizada (CAS) da UFSC.

## Ambiente local

### 1. Pré requisitos
1. Ter o Docker instalado na sua máquina. [Link para instalação](https://docs.docker.com/get-docker/)
2. Ter um backup do banco de dados do sistema de TCCs. Contatar professor responsável pelo sistema.
3. Estar conectado no VPN da UFSC. [Link tutorial](https://servicosti.sistemas.ufsc.br/publico/detalhes.xhtml?servico=112)
4. Criar um host local chamado `projetostcc` apontando para `127.0.0.1`. [Como alterar o arquivo hosts da sua máquina?](https://docs.saninternet.com/arquivo-hosts)

### 2. Subir os containers
1. No seu terminal, entre na raiz do projeto e digite o comando `docker-compose --profile dev up --build` (caso queira, utilize a flag `-d` para "desprender" os logs do seu terminal)
2. Para entrar em um container, temos o comando auxiliar `docker exec -it TCC-db bash` por exemplo, que entra no container do banco de dados.

### 3. Restaurar o backup
1. Pelo terminal, entre no diretório que se encontra o backup baixado, por exemplo `cd ~/Downloads`
2. Digite o comando `cat bk_sistema_tcc_20201027.sql | docker exec -i TCC-db /usr/bin/mysql --password=password projetos`.

**Após o passo 1 (requisitos), 2 (subir os containers) e 3 (restaurar o backup) serem completos, a aplicação estará rodando. Note que os passos 1 e 3 só precisam ser completos na primeira vez.**

### 4. Lidando com mudanças no código
O projeto não lida bem com recarregamento automático. **É necessário reiniciar os containers**. As dependências possuem cache então esse processo não deve ser demorado.

### 5. Parando e reiniciando os containers
Utilize o comando `docker-compose --profile dev down` caso queira parar todos os containers rodando.

Também existe o comando `docker restart <nome_do_container>` para reiniciar apenas um dos containers caso necessário.
Utilize o comando `docker restart TCC-app` para carregar as mudanças no código.

### 6. Diagnosticando problemas comuns
Paragráfo destinado a documentar problemas comuns e possíveis soluções para futuras consultas de desenvolvedores iniciantes.

**6.1 org.opensaml.SAMLException: UNAUTHORIZED_SERVICE:**
Causado na autenticação. Garanta que você está conectado no VPN da UFSC.

**6.2 Logs do docker:**
Abra o terminal e inspecione os logs do docker com o comando `docker logs TCC-app`.

**6.3 Logs do Tomcat:**
Para inspecionar os logs do Tomcat diretamente, é necessário abrir o terminal e seguir os seguintes passos:
1. `docker exec -it TCC-app bash`
2. `cd /usr/local/tomcat/logs`
3. Os dois arquivos de log mais úteis nesse diretório são o `catalina.log` e o `localhost_access_log.txt`.
Utilize o comando `tail -F <nome_do_arquivo>` para inspecionar o arquivo de log desejado.
[Documentação sobre o comando tail ](https://guialinux.uniriotec.br/tail/)



## Ambiente de Produção


A configuração do ambiente de produção possui algumas diferenças em relação ao ambiente local. Abaixo estão listadas as principais mudanças e instruções para configurar e rodar a aplicação em produção:


### 1. Diferenças nas Variáveis de Ambiente


- **`JAVA_OPTS`**:

  No ambiente de produção, o valor de `JAVA_OPTS` deve ser alterado para ativar o perfil de produção, ou seja, `JAVA_OPTS="-Dspring.profiles.active=prod"`. Esse valor deve substituir o `dev` utilizado no ambiente local.

### 2. Execução dos Containers


- **Comando Docker para Produção**:

  No ambiente de produção, o Docker Compose deve ser executado com o profile `prod`. O comando para iniciar os containers em produção é:


  ```bash
  docker-compose --profile prod up --build
```
### 3. Configuração de NFS para Arquivos Estáticos

O diretório `./tcc-files`, que contém arquivos estáticos, deve ser mapeado para um NFS (Network File System) externo no ambiente de produção. Essa configuração permite que os arquivos sejam armazenados fora do container, garantindo persistência e fácil acesso a esses dados. A configuração de volumes no arquivo `docker-compose.yml` já está preparada para isso, e a SETIC deve realizar o mapeamento apropriado.
