#!/usr/bin/env bash
set -xe

IMAGE_VERSION=${GO_PIPELINE_LABEL:-latest}
TENANT_NAMESPACE=${TENANT:-admin}
echo "Deploying image version: $IMAGE_VERSION"

cat kubernetes/web-mini.yml | sed "s/\\\$tenant\\\$/$TENANT_NAMESPACE/" | sed "s/\(image: \).*$/\1$DOCKER_USER\/ci-workshop-app:$TENANT_NAMESPACE.$IMAGE_VERSION/" | kubectl apply -f -

#external_ip=""
#while [ -z $external_ip ]; do
#  echo "Waiting for end point..."
#  external_ip=$(kubectl get svc ci-workshop-web --namespace=$TENANT_NAMESPACE --template="{{range .status.loadBalancer.ingress}}{{.ip}}{{end}}")
#  [ -z "$external_ip" ] && sleep 10
#done
#echo "End point ready: http://$external_ip:5005"
