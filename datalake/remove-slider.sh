#! /bin/bash
# Declare variables
USERID=$(echo -e "import hdinsight_common.Constants as Constants\nprint Constants.AMBARI_WATCHDOG_USERNAME" | python)
PASSWD=$(echo -e "import hdinsight_common.ClusterManifestParser as ClusterManifestParser\nimport hdinsight_common.Constants as Constants\nimport base64\nbase64pwd = ClusterManifestParser.parse_local_manifest().ambari_users.usersmap[Constants.AMBARI_WATCHDOG_USERNAME].password\nprint base64.b64decode(base64pwd)" | python)


## Remove SLIDER Service
curl -u $USERID:$PASSWD -i -H 'X-Requested-By: ambari' -X DELETE  http://headnodehost:8080/api/v1/clusters/$1/services/SLIDER