#
# Cookbook: java-service
# License: Apache 2.0
#
# Copyright 2010-2013, Chef Software, Inc.
# Copyright 2015-2016, Bloomberg Finance L.P.
#
include_recipe 'libarchive::default'

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

artifact_url = node['maven']['remote_url'] % {
  major_version: node['maven']['version'].to_i,
  version: node['maven']['version']
}

basename = File.basename(artifact_url)
remote_file File.join(Chef::Config[:file_cache_path], basename) do
  source artifact_url
  mode '0755'
  checksum node['maven']['remote_checksum']
end

libarchive_file basename do
  action :nothing
  path File.join(Chef::Config[:file_cache_path], basename)
  extract_to node['maven']['extract_to']
  subscribes :extract, "remote_file[#{path}]"
end

if platform?('windows')
  rc_file File.join(Dir.home, 'mavenrc_pre.bat') do
    type 'bat'
    options node['maven']['mavenrc']
  end
else
  link node['maven']['mavenrc']['M2_HOME'] do
    to File.join(node['maven']['extract_to'], "apache-maven-#{node['maven']['version']}")
  end

  link '/usr/local/bin/mvn' do
    to File.join(node['maven']['mavenrc']['M2_HOME'], 'bin', 'mvn')
  end

  rc_file '/etc/mavenrc' do
    mode '0644'
    options node['maven']['mavenrc']
  end
end
