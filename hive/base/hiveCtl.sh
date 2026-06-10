#!/bin/bash
#
# Apache Hive 4.2.0 on Kubernetes
# Author: j.martinez.poblete@gmail.com
# Free to use but please provide propper credit
#
# This script provides to stop/restart Apache Hive on K8S
# Note that PVC's dynamic PV provisioning are not touched
# after creation in a attempt to preserve data
#
source .functions
YAML=hive.yaml

function stopHive(){
   OPTS="--selector=hive"
   OPTS="${OPTS} -o custom-columns=KIND:.kind,NAME:metadata.name,NAMESPACE:metadata.namespace"
   OPTS="${OPTS} --no-headers"
   kubectl get svc,cm,pods,sts ${OPTS}      \
   | tr '[:upper:]' '[:lower:]'             \
   | xargs -L1 kubectl 
}

function startHive(){
   kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/v0.0.36/deploy/local-path-storage.yaml
   kubectl create -f ${YAML}
}

main(){
  NAMESPACE=$(kubectl get pods -A  --selector=hive -o custom-columns=NAMESPACE:metadata.namespace --no-headers | sort -u)
  case $1 in
    logs)
      if [ "${NAMESPACE}" ]; then
         echo "HIVEMETASTORE:"
         kubectl logs -n ${NAMESPACE} hive -c hivemetastore | tail -25
         echo "HIVESERVER2:"
         kubectl logs -n ${NAMESPACE} hive -c hiveserver2   | tail -25
      else
         echo "Hive is NOT running! Cannot produce logs"  
      fi
      ;;
    start)
      if [ -z "${NAMESPACE}" ]; then
         echo "Starting Hive..."
         startHive
      else
         echo "Hive is ALREADY running"
      fi
      ;;
    status)
      if [ "${NAMESPACE}" ]; then
         kubectl get pv,pvc,cm,svc,pods,sts -n ${NAMESPACE} -o wide
      else
         echo "Hive is STOPPED"
      fi   
      ;;
    stop)
      if [ "${NAMESPACE}" ]; then
         stopHive
      else
         echo "Hive is ALREADY stopped"
      fi   
      ;;
  esac
}
#
# Main
#
main $@
#EOF
