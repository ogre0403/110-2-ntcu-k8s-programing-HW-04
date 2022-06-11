#!/bin/bash

echo ""
echo "測試刪除web CRD後，operator 建立的 Deployment與Service也被刪除"

web_crd=`kubectl get web.hw4.ntcu.edu.tw -o yaml | yq '.items[0].metadata.name'`

kubectl delete web.hw4.ntcu.edu.tw ${web_crd}





LABEL="ntcu-k8s=hw4"


for i in {1..20}; do
  sleep 1
  svc_num=`kubectl get svc   -l ${LABEL}  -o yaml | yq '.items | length'`
  if [[ "$svc_num" -eq 0 ]]; then
      break
  fi

  if [[ "$i" -eq 20 ]]; then
      echo "timeout: informer 刪除建立的svc, 應為0,  $svc_num 不正確"
      exit 1
  fi

done



for i in {1..60}; do
  sleep 2
  deployment_num=`kubectl get deployment   -l ${LABEL}  -o yaml | yq '.items | length'`
  if [[ "$deployment_num" -eq 0 ]]; then
      break
  fi

  if [[ "$i" -eq 20 ]]; then
      echo "timeout: operator 刪除建立的 deployment, 應為0,  $deployment_num 不正確"
      exit 1
  fi

done

echo "........ PASS"
