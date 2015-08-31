#
# Cookbook: java-service
# License: Apache 2.0
#
# Copyright 2015, Bloomberg Finance L.P.
#
if platform?('ubuntu')
  include_recipe 'apt::default'

  apt_repository 'openjdk-r' do
    url 'http://ppa.launchpad.net/openjdk-r/ppa/ubuntu'
    distribution node['lsb']['codename']
    components ['main']
    keyserver 'keyserver.ubuntu.com'
    key '86F44E2A'
  end
end

node.default['java']['jdk_version'] = '8'
node.default['java']['accept_license_agreement'] = true
node.default['java']['set_etc_environment'] = true
include_recipe 'java::default', 'maven::default'
