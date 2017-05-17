FROM ubuntu:16.04

RUN apt-get update && apt-get -y install wget
RUN apt-get install -y software-properties-common
RUN wget -O - https://repo.saltstack.com/apt/ubuntu/16.04/amd64/2016.11/SALTSTACK-GPG-KEY.pub | apt-key add -
RUN add-apt-repository "deb http://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest xenial main"
RUN apt-get install -y salt-api
RUN apt-get install -y salt-master
RUN apt-get clean
COPY minion /etc/salt/

ENTRYPOINT ["/sbin/init"]
