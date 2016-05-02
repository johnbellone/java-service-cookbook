#
# Cookbook: java-service
# License: Apache 2.0
#
# Copyright 2010-2013, Chef Software, Inc.
# Copyright 2015-2016, Bloomberg Finance L.P.
#
if platform?('ubuntu')
  include_recipe 'apt::default'

  apt_repository 'openjdk-r' do
    uri 'http://ppa.launchpad.net/openjdk-r/ppa/ubuntu'
    distribution node['lsb']['codename']
    components ['main']
    keyserver 'keyserver.ubuntu.com'
    key '86F44E2A'
  end
end

if platform_family?('rhel')
  include_recipe 'yum-centos::default' if platform?('centos')
  include_recipe 'yum-epel::default'
end

node.default['java']['jdk_version'] = '8'
node.default['java']['accept_license_agreement'] = true
node.default['java']['oracle']['accept_oracle_download_terms'] = true
node.default['java']['set_etc_environment'] = true
include_recipe 'java::default'

install = maven_installation 'maven' do
  version node['java-service']['maven']['version']
end

node.default['java-service']['mavenrc']['M2_HOME'] = install.maven_home

rc_file File.join(Dir.home, 'mavenrc_pre.bat') do
  type 'bat'
  options node['java-service']['mavenrc']
  only_if { platform?('windows') }
end

rc_file '/etc/mavenrc' do
  mode '0644'
  options node['java-service']['mavenrc']
  not_if { platform?('windows') }
end
