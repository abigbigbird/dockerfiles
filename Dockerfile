FROM abigbigbird/allcodis
MAINTAINER zhijie.lv <401379957@qq.com>

EXPOSE 6900
RUN chmod a+x /opt/codis/shellfiles/runserver.sh 
CMD ["/opt/codis/shellfiles/runserver.sh"]
