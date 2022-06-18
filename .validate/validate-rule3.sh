#!/bin/bash

echo ""
echo "驗證 operator 是否會自動建立Deployment與Service，並測試是否連連通"


LABEL="ntcu-k8s=hw4"


# 等待nginx ready
web_image=$(kubectl get web.hw4.ntcu.edu.tw -o yaml | oc neat | yq '.items[0].spec.image')
nodeport=$(kubectl get web.hw4.ntcu.edu.tw -o yaml | oc neat | yq '.items[0].spec.nodePortNumber')


nginx_image=$(kubectl get deployments.apps -l ${LABEL} -o yaml | yq '.items[0].spec.template.spec.containers[0].image')


if [ "${web_image}" != "${nginx_image}" ]; then
  echo "Web CRD 的image 為 ${web_image}, 但是 deployment image為 ${nginx_image}"
  exit 1
fi

nginx_name=$(kubectl get deployments.apps -l ${LABEL} -o yaml | yq '.items[0].metadata.name')
ready="false"
for i in {1..60}; do
  sleep 2

   ready=$(kubectl get deployments.apps "${nginx_name}" >/dev/null  2>&1  && \
   kubectl get deployments.apps "${nginx_name}" -o yaml |  yq .status.readyReplicas==.status.replicas)

	if [ "$ready" == "true" ]; then
		break
	fi

  if [[ "$i" -eq 60 ]]; then
    echo "timeout 120 sec. wait for create deployment ${nginx_name} success"
    exit 1
  fi

done


# operator 會建立一個svc

for i in {1..20}; do
  sleep 1
  svc_num=$(kubectl get svc   -l ${LABEL}  -o yaml | yq '.items | length')

  if [[ "$svc_num" -eq 1 ]]; then
      break
  fi

  if [[ "$i" -eq 20 ]]; then
      echo "timeout: operator 建立的svc數量 $svc_num 不正確. 應為 1"
      exit 1
  fi

done

cid=$(docker ps -f name=control-plane -q)


#nodeport=`kubectl get svc  -l ${LABEL}  -o jsonpath='{.items[0].spec.ports[0].nodePort}'`

for i in {1..20}; do

  docker exec "${cid}" curl 127.0.0.1:"${nodeport}"  >/dev/null  2>&1

  RET=$?

  if [[ ${RET} -eq 0 ]]; then
    echo "........ PASS"
    exit 0
  fi

  sleep 3
done

echo "timeout for wait for connect deployment"
exit 1

