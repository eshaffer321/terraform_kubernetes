#!/bin/bash

failed=0
if [[ -z "${NEXUS_ADMIN_PASSWORD}" ]]; then
  echo "[ERROR] NEXUS_ADMIN_PASSWORD is required"
  failed=1
fi

if [[ -z "${DRONE_PASSWORD}" ]]; then
  echo "[ERROR] DRONE_PASSWORD is required"
  failed=1
fi

if [[ -z "${NEXUS_HOST}" ]]; then
  echo "[ERROR] NEXUS_HOST is required"
  failed=1
fi

if [[ -z "${KUBERNETES_NEXUS_PASSWORD}" ]]; then
  echo "[ERROR] KUBERNETES_NEXUS_PASSWORD is required"
  failed=1
fi

if [ $failed -eq 1 ]; then
  exit 1
fi

echo "[INFO] Changing default admin password"
curl -X PUT -u admin:admin123 "${NEXUS_HOST}/service/rest/v1/security/users/admin/change-password" \
  -H "accept: application/json" \
  -H "Content-Type: text/plain" \
  -d ${NEXUS_ADMIN_PASSWORD}

echo "[INFO] Creating drone role"
curl -o -X POST -u admin:${NEXUS_ADMIN_PASSWORD} "${NEXUS_HOST}/service/rest/v1/security/roles" \
  -H "accept: application/json" \
  -H "Content-Type: application/json" -d \
  '{
    "id": "drone",
    "name": "drone",
    "description": "Drone role",
    "privileges": [
      "nx-repository-view-docker-*-*"
    ]
   }'

echo "[INFO] Creating kubernetes role"
curl -o -X POST -u admin:${NEXUS_ADMIN_PASSWORD} "${NEXUS_HOST}/service/rest/v1/security/roles" \
  -H "accept: application/json" \
  -H "Content-Type: application/json" -d \
  '{
    "id": "kubernetes",
    "name": "kubernetes",
    "description": "kubernetes role",
    "privileges": [
      "nx-repository-view-docker-docker-browse",
      "nx-repository-view-docker-docker-read"
    ]
  }'

echo "[INFO] Creating kubernetes user"
curl -o -X POST -u admin:${NEXUS_ADMIN_PASSWORD} "${NEXUS_HOST}/service/rest/v1/security/users" \
  -H "accept: application/json" \
  -H "Content-Type: application/json" \
  -d "{
  \"userId\": \"kubernetes\",
  \"firstName\": \"kubernetes\",
  \"lastName\": \"kubernetes\",
  \"emailAddress\": \"kubernetes@commandyourmoney.co\",
  \"password\": \"${KUBERNETES_NEXUS_PASSWORD}\",
  \"status\": \"active\",
  \"roles\": [
    \"kubernetes\"
  ]
 }"

echo "[INFO] Creating drone user"
curl -o -X POST -u admin:${NEXUS_ADMIN_PASSWORD} "${NEXUS_HOST}/service/rest/v1/security/users" \
  -H "accept: application/json" \
  -H "Content-Type: application/json" \
  -d "{
  \"userId\": \"drone\",
  \"firstName\": \"drone\",
  \"lastName\": \"drone\",
  \"emailAddress\": \"drone@commandyourmoney.co\",
  \"password\": \"${DRONE_PASSWORD}\",
  \"status\": \"active\",
  \"roles\": [
    \"drone\"
  ]
 }"

echo "[INFO] Creating docker registry"
curl -o -X POST -u admin:${NEXUS_ADMIN_PASSWORD} "${NEXUS_HOST}/service/rest/v1/repositories/docker/hosted" \
  -H "accept: application/json" \
  -H "Content-Type: application/json" \
  -d "{
   \"name\":\"docker\",
   \"online\":true,
   \"storage\":{
      \"blobStoreName\":\"default\",
      \"strictContentTypeValidation\":true,
      \"writePolicy\":\"allow_once\"
   },
   \"cleanup\":{
      \"policyNames\":[
         \"string\"
      ]
   },
   \"docker\":{
      \"v1Enabled\":false,
      \"forceBasicAuth\":true,
      \"httpPort\":5003
   }
}"
