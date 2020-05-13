FROM amazonlinux:2

RUN yum install python37 -y

RUN curl -O https://bootstrap.pypa.io/get-pip.py

RUN python3 get-pip.py --user

RUN /root/.local/bin/pip3 install virtualenv

RUN cd /root \
  virtualenv venv
