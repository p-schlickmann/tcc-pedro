#!/bin/bash

mvn clean
mvn package

cp target/projetostcc.war /usr/local/tomcat/webapps/ROOT.war

catalina.sh run
