#!/bin/bash

echo "*** Running certbot in standalone mode, expecting additional parameters (e.g. -d options) to be passed ***"
echo "*** certbot --standalone $@"

certbot --standalone $@
