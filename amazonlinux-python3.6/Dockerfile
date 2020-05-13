FROM amazonlinux:2

RUN yum install -y gcc zlib zlib-devel openssl openssl-devel wget tar gzip

RUN wget https://www.python.org/ftp/python/3.6.1/Python-3.6.1.tgz -O /root/Python-3.6.1.tgz

RUN tar -xzf /root/Python-3.6.1.tgz -C /root

RUN cd /root/Python-3.6.1 && bash configure
RUN cd /root/Python-3.6.1 && make
RUN cd /root/Python-3.6.1 && make install
