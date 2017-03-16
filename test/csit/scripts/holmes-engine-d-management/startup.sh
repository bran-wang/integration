#!/bin/bash
#
# Copyright 2017 ZTE Corporation.
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
# $1 nickname for the engined instance
# $2 IP address of JDBC
# $3 IP address of BrokerIP

run-instance.sh openoint/holmes-engine-d-standalone $1 "-e URL_JDBC=$2:3306 -e BROKER_IP=$3 -e MSB_ADDR=$3"