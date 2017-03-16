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
# Configure MSB IP address
sed -i "s|msbServerAddr:.*|msbServerAddr: http://$MSB_ADDR|" wso2bps-ext/conf/wso2bpel.yml
sed -i "s|serviceIp:.*|serviceIp: $SERVICE_IP|" wso2bps-ext/conf/wso2bpel.yml
cat wso2bps-ext/conf/wso2bpel.yml

sed -i "s|MSB_URL=.*|MSB_URL=http://$MSB_ADDR|" wso2bps/wso2bps-ext.properties
cat wso2bps/wso2bps-ext.properties