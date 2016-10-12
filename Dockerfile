FROM rhel

USER root
ADD https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm /epel-release-latest-7.noarch.rpm
RUN yum install -y /epel-release-latest-7.noarch.rpm
RUN yum install --enablerepo=rhel-7-server-optional-rpms --enablerepo=rhel-7-server-ose-3.3-rpms -y certbot atomic-openshift-clients && yum clean all
RUN mkdir -p /opt/letsencrypt/work/{certs,log,work,config} 
WORKDIR /opt/letsencrypt
ADD get-certs.sh /opt/letsencrypt/get-certs.sh 
RUN chmod +x /opt/letsencrypt/get-certs.sh && chmod 777 /opt/letsencrypt/work && chown 1001:1001 -R /opt/letsencrypt  

USER 1001
VOLUME ['/opt/letsencrypt/work']

ENTRYPOINT ['/opt/letsencrypt/get-certs.sh']
