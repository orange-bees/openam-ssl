FROM openidentityplatform/openam:14.4.1

COPY domain.crt /usr/local/tomcat/conf/
COPY domain.key /usr/local/tomcat/conf/
COPY server.xml /usr/local/tomcat/conf/
