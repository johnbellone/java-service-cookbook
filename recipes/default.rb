#
# Cookbook: java-service
# License: Apache 2.0
#
# Copyright 2010-2013, Chef Software, Inc.
# Copyright 2015-2016, Bloomberg Finance L.P.
#
include_recipe 'apt::default' if platform?('ubuntu')

if platform_family?('rhel')
  include_recipe 'yum-centos::default' if platform?('centos')
  include_recipe 'yum-epel::default'
end

node.default['java']['jdk_version'] = '8'
node.default['java']['accept_license_agreement'] = true
node.default['java']['oracle']['accept_oracle_download_terms'] = true
node.default['etc_environment']['JAVA_HOME'] = node['java']['java_home']
include_recipe 'java::default'

install = maven_installation 'maven' do
  version node['java-service']['maven']['version']
end

node.default['java-service']['mavenrc']['M2_HOME'] = install.maven_home

if platform?('windows')
  rc_file File.join(Dir.home, 'mavenrc_pre.bat') do
    type 'bat'
    options node['java-service']['mavenrc']
  end
else
  rc_file '/etc/mavenrc' do
    mode '0644'
    options node['java-service']['mavenrc']
  end
end
