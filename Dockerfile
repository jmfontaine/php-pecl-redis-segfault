FROM centos:6.9

RUN rpm --install http://mirror.nodesdirect.com/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN rpm --install https://rpms.remirepo.net/enterprise/remi-release-6.rpm

ARG php_version
ARG phpredis_version
RUN yum install --assumeyes --enablerepo remi-php${php_version} php-cli php-pecl-redis-${phpredis_version}
