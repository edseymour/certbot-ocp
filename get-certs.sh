#!/bin/bash

if [[ "$CERTHOST" == "" ]]; then

  echo "*** Running certbot in standalone mode, expecting additional parameters (e.g. -d options) to be passed ***"
  echo "*** certbot --standalone --cert-path /opt/letsencrypt/certs $@"
  certbot --standalone --cert-path /opt/letsencrypt/certs $@

else

  echo "*** Running certbot in standalone mode for host: $CERTHOST ***"
  echo "*** certbot --standalone --cert-path /opt/letsencrypt/certs -d $CERTHOST"

  certbot --standalone --cert-path /opt/letsencrypt/certs -d $CERTHOST

fi

echo "*** Creating secret"
TOKEN="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)"

oc login --token="$TOKEN" --insecure-skip-tls-verify https://kubernetes.default.svc.cluster.local

EXISTS=$(oc get secret letsencrypt --no-headers | wc -l)
[[ $EXISTS -gt 0 ]] && oc delete secret letsencrypt && echo "*** deleted existing secret"

oc secret new letsencrypt /opt/letsencrypt/certs/
oc describe secret letsencrypt



