FROM ubuntu:focal
# FROM centos:7

RUN mkdir -p /usr/oecc /oecc/data/conf
ADD ./PROGRESS_OECC_SERVER_1.3.0_LNX_64.tar.gz /usr/oecc
COPY ./start.sh /usr/oecc
COPY db-config.json firstuser-config.json /oecc/data/conf/
COPY server-config.json /usr/oecc/conf/
RUN cp /usr/oecc/orig/system-config.json.orig /oecc/data/conf/system-config.json
RUN chmod +x /usr/oecc/oeccserver
RUN chmod +x /usr/oecc/start.sh

CMD [ "/usr/oecc/start.sh" ]

