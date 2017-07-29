FROM debian:latest

ADD . .
RUN apt-get update
RUN apt-get --assume-yes install ansible
RUN apt-get --assume-yes install python-pip
RUN pip install pywinrm

RUN mkdir windows
RUN mkdir windows/group_vars
