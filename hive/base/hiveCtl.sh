#!/bin/bash

YAML=hive.yaml
NAMESPACE=$(sed -n '/kind: Pod/,/namespace:/p' hive.yaml | awk '/namespace/ {print $2}')

function stopHive(){
sed -n '/kind:/,/namespace:/p' ${YAML}         \
| awk '/kind:|name:|namespace:/ {print $2}'    \
| xargs -n3 | tr '[:upper:]' '[:lower:]'       \
| awk '{print "delete -n "$3,$1,$2" --force"}' \
| grep -v persistentvolumeclaim                \
| xargs -L1 kubectl 
}

function startHive(){ 
kubectl create -f ${YAML}
}

main(){
  case $1 in
    logs)
      LOG=$(kubectl logs -n default hive -c hivemetastore | awk -F= '/LOG=/ {print $2}') 
      echo "HIVEMETASTORE:"
      kubectl exec -n ${NAMESPACE} hive -c hivemetastore -it -- tail -25 ${LOG}
      LOG=$(kubectl logs -n default hive -c hiveserver2   | awk -F= '/LOG=/ {print $2}') 
      echo "HIVESERVER2:"
      kubectl exec -n ${NAMESPACE} hive -c hiveserver2 -it -- tail -25 ${LOG}
      ;;
    start)
      startHive
      ;;
    status)
      kubectl get pv,pvc,cm,svc,pods -n ${NAMESPACE} -o wide
      ;;
    stop)
      stopHive
      ;;
  esac
}
#
# Main
#
main $@
#EOF
