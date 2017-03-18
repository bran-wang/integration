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
# Place the scripts in run order:
# Start all process required for executing test case

source ${SCRIPTS}/common_functions.sh

# Start MSB
docker run -d --name i-msb -p 80:80 openoint/common-services-msb
MSB_IP=`get-instance-ip.sh i-msb`
curl_path='http://'${MSB_IP}'/openoui/microservices/index.html'
sleep_msg="Waiting_connection_for_url_for:i-msb"
wait_curl_driver CURL_COMMAND=$curl_path WAIT_MESSAGE='$sleep_msg' GREP_STRING="org_openo_msb_route_title" REPEAT_NUMBER="15"

# Start ESR
run-instance.sh openoint/common-services-extsys i-esr  "  -d -e MSB_ADDR=${MSB_IP}:80"
extsys_ip=`get-instance-ip.sh i-esr`
sleep_msg="Waiting_for_ESR"
curl_path='http://'${MSB_IP}':80/openoapi/extsys/v1/swagger.json'
wait_curl_driver CURL_COMMAND=$curl_path WAIT_MESSAGE='$sleep_msg' REPEAT_NUMBER=25 GREP_STRING="swagger"

# start multivim-broker
run-instance.sh openoint/multivim-broker multivim-broker  " -d -e MSB_ADDR=${MSB_IP}:80"
extsys_ip=`get-instance-ip.sh multivim-broker`
sleep_msg="Waiting_for_multivim-broker"
curl_path='http://'${MSB_IP}':80/openoapi/multivim/v1/swagger.json'
wait_curl_driver CURL_COMMAND=$curl_path WAIT_MESSAGE='"$sleep_msg"' REPEAT_NUMBER=25 GREP_STRING="swagger"


#start multivim-driver-vio
run-instance.sh openoint/multivim-driver-vio multivim-driver-vio  " -d  -e MSB_ADDR=${MSB_IP}:80"
extsys_ip=`get-instance-ip.sh multivim-driver-vio`
sleep_msg="Waiting_for_multivim-driver-vio"
curl_path='http://'${MSB_IP}':80/openoapi/multivim-vio/v1/swagger.json'
wait_curl_driver CURL_COMMAND=$curl_path WAIT_MESSAGE='"$sleep_msg"' REPEAT_NUMBER=25 GREP_STRING="swagger"


echo SCRIPTS

#start simulator vio
#docker run -d   --name simulator -e SIMULATOR_JSON=Stubs/testcase/multivimdriver-vmware-vio/main.json -p 18009:18009 -p 18008:18008  openoint/simulate-test-docker
#SIMULATOR_IP=`get-instance-ip.sh simulator`
#sleep_msg="Waiting_for_simulator"
#curl_path='http://'${SIMULATOR_IP}':18009/openoapi/extsys/v1/vims'
#wait_curl_driver CURL_COMMAND=$curl_path WAIT_MESSAGE='"$sleep_msg"' REPEAT_NUMBER=25 GREP_STRING="\["

run_simulator

ROBOT_VARIABLES=$ROBOT_VARIABLES" -v MSB_IP:${MSB_IP}  -v SCRIPTS:${SCRIPTS}  -v SIMULATOR_IP:${SIMULATOR_IP}"
VIM_ID=c70fec2d-226d-41ae-8a8a-a5b708f6503f
TENANT_ID=93f742f6cd6f4ab9a779d5e474e20a34
SIMULATOR_PORT=18009
SIMULATOR_NAME=VIO
SIMULATOR_URL=/openoapi/vio/v1
ROBOT_VARIABLES=$ROBOT_VARIABLES" -v VIMID:${VIM_ID}  -v TENANTID:${TENANT_ID} -v SIMULATOR_PORT:${SIMULATOR_PORT}  -v SIMULATOR_NAME:${SIMULATOR_NAME} -v  SIMULATOR_URL:${SIMULATOR_URL}"
#robot ${ROBOT_VARIABLES} ${SCRIPTS}/../tests/multivim-vmware-vio/provision/register_simulator_to_msb.robot

