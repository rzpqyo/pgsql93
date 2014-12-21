FROM ubuntu:14.04

MAINTAINER rzpqyo

RUN apt-get -y update
RUN apt-get -y upgrade
RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main' > /etc/apt/sources.list.d/pgdg.list
RUN cat /etc/apt/sources.list.d/pgdg.list
RUN apt-get -y install wget ca-certificates
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get -y install postgresql-9.3 pgadmin3 postgresql-server-dev-9.3

RUN apt-get -y install language-pack-ja manpages-ja

# RUN apt-get -y install make patch
RUN apt-get -y install make g++

RUN apt-get clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

# RUN mkdir -p /usr/local/src
# RUN cd /usr/local/src && \
# 	wget -O - http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.14.tar.gz |tar -zxvf -
# RUN cd /usr/local/src/libiconv-1.14 && \
# 	wget -O - http://apolloron.org/software/libiconv-1.14-ja/libiconv-1.14-ja-1.patch |patch -p1 && \
# 	./configure --prefix=/usr/local && \
# 	make && \
# 	make install
# RUN echo "/usr/local/lib/" >> /etc/ld.so.conf.d/usr_local_lib.conf
# RUN ldconfig
# 
# RUN cd /usr/local/src && \
# 	wget -O - http://mecab.googlecode.com/files/mecab-0.996.tar.gz |tar -zxvf -
# RUN cd /usr/local/src/mecab-0.996 && \
# 	./configure LDFLAGS="-liconv" --with-charset=utf8 && \
# 	make && \
# 	make install

RUN mkdir -p /usr/local/src
RUN cd /usr/local/src && \
	wget -O - http://mecab.googlecode.com/files/mecab-0.996.tar.gz |tar -zxvf -
RUN cd /usr/local/src/mecab-0.996 && \
	./configure --with-charset=utf8 && \
	make && \
	make install
RUN echo "/usr/local/lib/" >> /etc/ld.so.conf.d/usr_local_lib.conf
RUN ldconfig

RUN cd /usr/local/src && \
	wget -O - http://mecab.googlecode.com/files/mecab-ipadic-2.7.0-20070801.tar.gz |tar -zxvf -
RUN cd /usr/local/src/mecab-ipadic-2.7.0-20070801 && \
	./configure  --with-charset=utf8 && \
	make && \
	make install

RUN cd /usr/local/src && \
	wget -O - http://pgfoundry.org/frs/download.php/2943/textsearch_ja-9.0.0.tar.gz |tar -zxvf -
RUN cd /usr/local/src/textsearch_ja-9.0.0 && \
	make USE_PGXS=1 && \
	make USE_PGXS=1 install
RUN sed -i -e "s/LANGUAGE 'C'/LANGUAGE 'c'/" /usr/share/postgresql/9.3/contrib/textsearch_ja.sql

ADD bashrc /var/lib/postgresql/.bashrc
RUN chmod 600 /var/lib/postgresql/.bashrc && chown postgres:postgres /var/lib/postgresql/.bashrc
ADD postgresql.conf /var/lib/postgresql/postgresql.conf
RUN chmod 600 /var/lib/postgresql/postgresql.conf && chown postgres:postgres /var/lib/postgresql/postgresql.conf

ADD init.sh /usr/local/bin/init.sh
RUN chmod u+x /usr/local/bin/init.sh
CMD ["/usr/local/bin/init.sh"]
EXPOSE 5432
