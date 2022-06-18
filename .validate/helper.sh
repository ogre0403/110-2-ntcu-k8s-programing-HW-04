#!/bin/bash


namespace=$(./bin/kustomize build config/default | yq '(.|select(.kind == "Namespace")).metadata.name')
deployment=$(./bin/kustomize build config/default | yq '(.|select(.kind == "Deployment")).metadata.name')

echo ""
echo "驗證 operator 部署完成"


ready="false"

for i in {1..60}; do 
  ready=$(kubectl get deployments.apps -n="${namespace}" "${deployment}" >/dev/null  2>&1  && \
  kubectl get deployments.apps -n="${namespace}" "${deployment}" -o yaml |  yq .status.readyReplicas==.status.replicas)

	if [ "$ready" == "true" ]; then
	  echo "........ PASS"
		exit 0
	fi

  sleep 1
done


echo "timeout. 經過 60 秒，${deployment} 尚未Ready"
exit 1