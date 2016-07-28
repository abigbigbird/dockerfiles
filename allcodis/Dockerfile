FROM ubuntu:15.10
MAINTAINER zhijie.lv <401379957@qq.com>

RUN mkdir -p /opt/codis
ENV CODIS_HOME /opt/codis

ADD . $CODIS_HOME
RUN chmod a+x $CODIS_HOME/bin/codis-*
ENV PATH $PATH:$CODIS_HOME/bin:$CODIS_HOME

WORKDIR $CODIS_HOME
