#
# Cookbook Name:: stunnel
# Resources:: install
#
# Copyright 2018 DNSimple Corp
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

action :create do
  directory '/etc/stunnel/'

  execute 'Create stunnel SSL Certificates' do
    command "openssl req -subj \"#{node['stunnel']['server_ssl_req']}\" -new -nodes -x509 -out /etc/stunnel/stunnel.pem -keyout /etc/stunnel/stunnel.pem"
    creates '/etc/stunnel/stunnel.pem'
  end

  file '/etc/stunnel/stunnel.pem' do
    mode 0600
  end

  package 'stunnel4'

  user 'stunnel4' do
    home '/var/run/stunnel4'
    system true
    shell '/bin/false'
    manage_home true
    not_if { node['platform_family'] == 'debian' }
  end

  template '/etc/stunnel/stunnel.conf' do
    source 'stunnel.conf.erb'
    mode 0644
  end
end
