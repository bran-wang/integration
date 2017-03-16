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
source ${SCRIPTS}/common_functions.sh

# Start MSB
${SCRIPTS}/common-services-microservice-bus/startup.sh i-msb
MSB_IP=`get-instance-ip.sh i-msb`
curl_path='http://'${MSB_IP}'/openoui/microservices/index.html'
sleep_msg="Waiting_connection_for_url_for:i-msb"
wait_curl_driver CURL_COMMAND=$curl_path WAIT_MESSAGE='"$sleep_msg"' GREP_STRING="org_openo_msb_route_title" REPEAT_NUMBER="15"

#Start openoint/common-services-extsys
run-instance.sh openoint/common-services-extsys i-common-services-extsys " -i -t -e MSB_ADDR=${MSB_IP}:80"
extsys_ip=`get-instance-ip.sh i-common-services-extsys`
curl_path='http://'$extsys_ip':8100/openoapi/extsys/v1/vims'
sleep_msg="Waiting_connection_for_url_for: common-services-extsys"
wait_curl_driver CURL_COMMAND=$curl_path WAIT_MESSAGE='"$sleep_msg"' REPEAT_NUMBER=25 GREP_STRING="\["

# Pass any variables required by Robot test suites in ROBOT_VARIABLES
run_simulator "sdnhub-driver-main.json"

#Start openoint/common-services-drivermanager
run-instance.sh openoint/common-services-drivermanager d-drivermgr " -i -t -e MSB_ADDR=${MSB_IP}:80"
curl_path='http://'${MSB_IP}':80/openoapi/drivermgr/v1/drivers'
sleep_msg="DRIVER_MANAGER_load"
wait_curl_driver CURL_COMMAND=$curl_path WAIT_MESSAGE='"$sleep_msg"' REPEAT_NUMBER=25 GREP_STRING="\["

#Start openoint/sdno-driver-huawei-openstack
${SCRIPTS}/sdnhub-driver-huawei-openstack/startup.sh d-driver-huawei-openstack ${MSB_IP}:80
OPENSTACK_IP=`docker inspect --format '{{ .NetworkSettings.IPAddress }}' d-driver-huawei-openstack`
DRIVERMGR_IP=`get-instance-ip.sh d-drivermgr`

DRIVER_PORT='8539'
DRIVER_NAME='sdnhubopenstackdriver-0-1'
DRIVERMGR_PORT="8103"
SIMULATOR_NAME="sdnomss"
SIMULATOR_URL="/openoapi/sdnomss/v1"
SIMULATOR_PORT="18009"


# Pass any variables required by Robot test suites in ROBOT_VARIABLES
ROBOT_VARIABLES="-v MSB_IP:${MSB_IP}  -v DRIVERMGR_IP:${DRIVERMGR_IP} -v DRIVERMGR_PORT:${DRIVERMGR_PORT} -v DRIVER_PORT:${DRIVER_PORT} -v DRIVER_NAME:${DRIVER_NAME} -v SCRIPTS:${SCRIPTS} -v SIMULATOR_IP:${SIMULATOR_IP} -v OPENSTACK_IP:${OPENSTACK_IP} -v SIMULATOR_URL:${SIMULATOR_URL} -v SIMULATOR_NAME:${SIMULATOR_NAME} -v SIMULATOR_PORT:${SIMULATOR_PORT} -L TRACE"

echo "-----------------------------------------------------------------------------------"
echo ${ROBOT_VARIABLES}
