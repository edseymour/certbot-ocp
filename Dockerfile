FROM rhel7.2

USER root
ADD https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm /epel-release-latest-7.noarch.rpm
RUN yum install -y /epel-release-latest-7.noarch.rpm
RUN yum --enablerepo=rhel-7-server-optional-rpms && yum install -y certbot && yum clean all
RUN mkdir -p /opt/letsencrypt/certs && chown 1001:1001 -R /opt/letsencrypt
WORKDIR /opt/letsencrypt
ADD get-certs.sh /opt/letsencrypt/get-certs.sh 

USER 1001

ENTRYPOINT ['/opt/letsencrypt/get-certs.sh']
