FROM centos:centos7

#setting locate
RUN rm -f /etc/rpm/macros.image-language-conf && \
    sed -i '/^override_install_langs=/d' /etc/yum.conf && \
    yum -y install glibc-common && \
    yum clean all && \
	rm -rf /var/cache/yum && \
	localedef -f UTF-8 -i ja_JP ja_JP.UTF-8
	

ENV LANG=ja_JP.UTF-8
ENV LANGUAGE=ja_JP.UTF-8
ENV LC_ALL=ja_JP.UTF-8

#setting timezone
RUN unlink /etc/localtime && \
	ln -s /usr/share/zoneinfo/Japan /etc/localtime

ENV APP_NAME=np-pfs-api
ENV APP_HOME=/data01/np/bin
ENV JAVA_HOME=$APP_HOME/jdk1.8.0_152
ENV TOMCAT_HOME=$APP_HOME/apache-tomcat-8.5.29
ENV CATALINA_HOME=$APP_HOME/apache-tomcat-8.5.29
ENV PATH=$PATH:$APP_HOME/apache-tomcat-8.5.29/bin:$JAVA_HOME/bin

ENV NLS_LANG=JAPANESE_JAPAN.JA16SJISTILDE
ENV TZ=JST-9

RUN mkdir -p $APP_HOME

ADD docker/midware/jdk-8u152-linux-x64.tar.gz $APP_HOME
ADD docker/midware/apache-tomcat-8.5.29.tar.gz $APP_HOME
COPY target/spring-boot-docker-example.war $TOMCAT_HOME/webapps

COPY docker/tomcat-conf/tomcat-users.xml $TOMCAT_HOME/conf/tomcat-users.xml
COPY docker/tomcat-conf/context.xml $TOMCAT_HOME/webapps/manager/META-INF/context.xml

VOLUME $TOMCAT_HOME/logs
VOLUME /logs

EXPOSE 8080

CMD $TOMCAT_HOME/bin/catalina.sh run
