FROM ubuntu:15.10

RUN apt-get update && apt-get -y install wget
RUN wget -O bootstrap-salt.sh https://bootstrap.saltstack.com
RUN sh bootstrap-salt.sh -U -X -d -M stable 2016.11.1
RUN apt-get clean
COPY minion /etc/salt/

ENTRYPOINT ["/sbin/init"]
