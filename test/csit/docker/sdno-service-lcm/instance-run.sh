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

logs_path="/service/logs"
mkdir -p $logs_path

# proxy connection to MSB
nohup socat TCP-LISTEN:8080,fork TCP:$MSB_ADDR  </dev/null >/dev/null 2>&1 &

# assign the ip provided from command line while running docker to SDNO_LCM_IP environment variable
export SDNO_LCM_IP=$SERVICE_IP

#Starting LCM service
java -jar sdno-lcm-webapp*.jar | tee -a $logs_path/sdno-lcm.log

# keep shell running to prevent container from exit
tail -f $logs_path/sdno-lcm.log
