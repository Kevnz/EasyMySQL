FROM ubuntu:latest

MAINTAINER Kevin Isom

# Install latest updates

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get -y install sudo
RUN apt-get -y install wget
RUN wget http://dev.mysql.com/get/mysql-apt-config_0.3.7-1ubuntu14.04_all.deb
RUN sudo dpkg -i mysql-apt-config_0.3.7-1ubuntu14.04_all.deb


# RUN apt-cache policy mysql-client
# RUN apt-cache policy mysql-server

# Install mysql client and server
RUN apt-get -y install mysql-client-5.6 mysql-server-5.6 curl

# Enable remote access (default is localhost only, we change this
# otherwise our database would not be reachable from outside the container)
RUN sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf

# Install database
ADD ./database.sql /var/db/database.sql

# Set Standard settings
ENV user student
ENV password secret
ENV url file:/var/db/database.sql
ENV right READ

# Install starting script
ADD ./start-database.sh /usr/local/bin/start-database.sh
RUN chmod +x /usr/local/bin/start-database.sh

EXPOSE 3306

CMD ["/usr/local/bin/start-database.sh"]
