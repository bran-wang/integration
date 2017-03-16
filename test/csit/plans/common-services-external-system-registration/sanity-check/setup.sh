#!/bin/bash
#
# Copyright 2016-2017 Huawei Technologies Co., Ltd.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# These scripts are sourced by run-csit.sh.

# Start MSB
${SCRIPTS}/common-services-microservice-bus/startup.sh i-msb
MSB_IP=`get-instance-ip.sh i-msb`
echo MSB_IP=${MSB_IP}

# Start extsys
${SCRIPTS}/common-services-external-system-registration/startup.sh i-extsys ${MSB_IP}:80
EXTSYS_IP=`get-instance-ip.sh i-extsys`
echo EXTSYS_IP=${EXTSYS_IP}

# Wait for initialization
for i in {1..20}; do
#    curl -sS -m 1 ${MSB_IP}:80/openoapi/extsys/v1/common && curl -sS -m 1 ${MSB_IP}:80/openoui/microservices/index.html && break
    HTTP_CODE=`curl -o /dev/null -s -w "%{http_code}" "${MSB_IP}:80/openoapi/extsys/v1/common"`     
    if [ ${HTTP_CODE} -eq 200 ]; then
       break;
    else
       sleep $i 
    fi     
done

# Pass any variables required by Robot test suites in ROBOT_VARIABLES
ROBOT_VARIABLES="-v MSB_IP:${MSB_IP} -v EXTSYS_IP:${MSB_IP} -v PORT:80"

