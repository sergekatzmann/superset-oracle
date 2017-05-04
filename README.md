# Docker container for Superset demo with Oracle 11.2 client.

Objective
------------
The purpose of this project is to create a superset container with oracle client to allow the data analyses/visualization of data stored in an oracle database. The oracle client used is 11.2.0.4

Requirements
------------
Docker
Ports available:

Superset
```
8088
```

Usage
-----

Build container from Dockerfile using

```
sudo ./build.sh
```

or

```
docker build -t sergekatzmann/superset-oracle .
```

Run container in daemon mode with

```
sudo ./run.sh
```

or

```
docker run -p 8088:8088 -d sergekatzmann/superset-oracle
```

Open Superset in browser using the following link:
```
http://docker_host_ip:8088
User: admin
Password: superset_admin
```

Connect to running container with
```
docker exec -it <container_id> /bin/bash
```
