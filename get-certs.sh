#!/bin/bash

if [[ "$CERTHOST" == "" ]]; then

  echo "*** Running certbot in standalone mode, expecting additional parameters (e.g. -d options) to be passed ***"
  echo "*** certbot certonly --standalone --cert-path /opt/letsencrypt/certs $@"
  certbot certonly --standalone --logs-dir=/opt/letsencrypt/work/logs \
--config-dir=/opt/letsencrypt/work/config \
--work-dir=/opt/letsencrypt/work/work \
--cert-path /opt/letsencrypt/work/certs $@

else

  echo "*** Running certbot in standalone mode for host: $CERTHOST ***"
  echo "*** certbot certonly --standalone --cert-path /opt/letsencrypt/certs -d $CERTHOST"

  certbot certonly --standalone --logs-dir=/opt/letsencrypt/work/logs \
--config-dir=/opt/letsencrypt/work/config \
--work-dir=/opt/letsencrypt/work/work \
--cert-path /opt/letsencrypt/work/certs -d $CERTHOST

fi

echo "*** Creating secret"
OC_OPTS="--token=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)  --insecure-skip-tls-verify --server=https://kubernetes.default.svc.cluster.local"

EXISTS=$(oc get secret letsencrypt $OC_OPTS --no-headers | wc -l)
[[ $EXISTS -gt 0 ]] && oc delete secret letsencrypt $OC_OPTS && echo "*** deleted existing secret"

oc secret new letsencrypt /opt/letsencrypt/certs/ $OC_OPTS
oc describe secret letsencrypt $OC_OPTS



