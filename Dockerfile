FROM rhel

USER root
ADD https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm /epel-release-latest-7.noarch.rpm
RUN yum install -y /epel-release-latest-7.noarch.rpm
RUN yum install --enablerepo=rhel-7-server-optional-rpms --enablerepo=rhel-7-server-ose-3.3-rpms -y certbot atomic-openshift-clients && yum clean all
RUN mkdir -p /opt/letsencrypt/certs && chown 1001:1001 -R /opt/letsencrypt
WORKDIR /opt/letsencrypt
ADD get-certs.sh /opt/letsencrypt/get-certs.sh 

USER 1001

ENTRYPOINT ['/opt/letsencrypt/get-certs.sh']
