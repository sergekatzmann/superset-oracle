FROM python:2.7.11

MAINTAINER Serge Katzmann serge.katzmann@gmail.com

# Oracle instantclient
ADD oracle/instantclient-basic-linux.x64-11.2.0.4.0.zip /tmp/instantclient-basic-linux.x64-11.2.0.4.0.zip
ADD oracle/instantclient-sdk-linux.x64-11.2.0.4.0.zip /tmp/instantclient-sdk-linux.x64-11.2.0.4.0.zip
ADD oracle/instantclient-sqlplus-linux.x64-11.2.0.4.0.zip /tmp/instantclient-sqlplus-linux.x64-11.2.0.4.0.zip

RUN apt-get update -y && apt-get install -y unzip

RUN unzip /tmp/instantclient-basic-linux.x64-11.2.0.4.0.zip -d /usr/local/
RUN unzip /tmp/instantclient-sdk-linux.x64-11.2.0.4.0.zip -d /usr/local/
RUN unzip /tmp/instantclient-sqlplus-linux.x64-11.2.0.4.0.zip -d /usr/local/
RUN ln -s /usr/local/instantclient_11_2 /usr/local/instantclient
RUN ln -s /usr/local/instantclient/libclntsh.so.11.1 /usr/local/instantclient/libclntsh.so
RUN ln -s /usr/local/instantclient/sqlplus /usr/bin/sqlplus

ENV TERM=vt100
ENV ORACLE_HOME="/usr/local/instantclient"
ENV LD_LIBRARY_PATH="/usr/local/instantclient"
RUN export PATH=$PATH:/usr/local/instantclient/bin

RUN echo '/usr/local/instantclient/' | tee -a /etc/ld.so.conf.d/oracle_instant_client.conf && ldconfig

RUN apt-get install libaio-dev libsasl2-dev libldap2-dev -y && apt-get clean -y

# Install caravel
RUN pip install cx_Oracle caravel

# copy admin password details to /caravel for fabmanager
RUN mkdir /caravel
COPY admin.config /caravel/

# Create an admin user
RUN /usr/local/bin/fabmanager create-admin --app caravel < /caravel/admin.config

# Initialize the database
RUN caravel db upgrade

# Create default roles and permissions
RUN caravel init

# Load some data to play with
RUN caravel load_examples

# Start the development web server
CMD caravel runserver -d
