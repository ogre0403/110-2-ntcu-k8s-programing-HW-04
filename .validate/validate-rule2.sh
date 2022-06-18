#!/bin/bash

echo ""
echo "驗證初始無Deployment 與 Service"


# 初始應無svc
LABEL="ntcu-k8s=hw4"

svc_num=$(kubectl get svc   -l ${LABEL}  -o yaml | yq '.items | length')

if [[ "$svc_num" -ne 0 ]]; then
    echo "operator建立的svc數量為$svc_num 不正確. 應為 0"
    exit 1
fi


deployment_num=`kubectl get deployment   -l ${LABEL}  -o yaml | yq '.items | length'`
if [[ "deployment_num" -ne 0 ]]; then
    echo " operator 建立的 deployment數量為$svc_num 不正確. 應為 0"
    exit 1
fi

# 建立隨機nginx deployment
#deployment=nginx-deployment
random=`echo ${RANDOM}`
random_port=`echo $(( $RANDOM % 1000 + 30001 ))`

nginx_ver=`echo $(( $RANDOM % 10 + 10 ))`


cat <<EOF | kubectl apply -f -
apiVersion: hw4.ntcu.edu.tw/v1alpha1
kind: Web
metadata:
  name: web-${random}
  labels:
    ntcu-k8s: hw4
spec:
  image: "nginx:1.${nginx_ver}-alpine"
  nodePortNumber: $random_port
EOF


echo "........ PASS"
