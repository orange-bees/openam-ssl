# Open AM SSL

## Introduction
This is an implementation of Open AM based on [openidentityplatform/openam](https://hub.docker.com/r/openidentityplatform/openam) that has SSL enabled by default using a self-signed certificate. The implementation uses a native APR connector in Apache Tomcat.

## Docker

You can run this in a docker container with the following command.

    docker container run -d --name openam -p 8080:8080 -p 8443:8443 orangebees/openam-ssl:14.4.1

Once the container is started you can access it at https://localhost:8443/openam to begin the configuration process.

## Docker Swarm 

Alternatively, you can run it with `docker-compose up` or `docker stack deploy` commands. An example *docker-compose.yml* file is included in the project. A basic example is shown below.

```
version: '3.7'

services:

  openam:
    image: orangebees/openam-ssl:14.4.1
    hostname: openam
    environment:
    # Enable additional JVM information and garbage collection information. Enable only one line below.  
    #  - JAVA_OPTS=-Xmx2048m -Xms512m -XX:ReservedCodeCacheSize=64m -XX:+UseG1GC -XX:+CMSClassUnloadingEnabled -XX:+PrintHeapAtGC -XX:+PrintGCDetails -XX:+PrintGCTimeStamps
      - JAVA_OPTS=-Xmx4096m -Xms1024m -XX:ReservedCodeCacheSize=64m -XX:+UseG1GC -XX:+CMSClassUnloadingEnabled
    volumes:
      - tomcat_conf:/usr/local/tomcat/conf
      - openam_data:/usr/openam
    ports:
      - "8080:8080/tcp"
      - "8443:8443/tcp"
    networks:
      - openam-net

networks:
  openam-net:
    driver: overlay

volumes:
  tomcat_conf:
  openam_data:
```
    docker stack deploy -c docker-compose.yml ob

## Generate Self-Signed Certificate with OpenSSL

To generate a self-signed certificate you may use the command below. This will prompt you for additional information to be used in the certificate.

**NOTE:** The `Common Name (eg, fully qualified host name) []:` is the name of the host. It is currently set to **localhost** in the certificate. You should set this value to FQDN on your certificate. 

    openssl req \
       -newkey rsa:2048 -nodes -keyout domain.key \
       -x509 -days 365 -out domain.crt

You can copy these files to the container and replace the existing files by using `docker cp <src> <dest>` as shown below. 
    
    docker cp domain.key openam:/usr/local/tomcat/conf/
    docker cp domain.crt openam:/usr/local/tomcat/conf/
