#
# Cookbook: java-service
# License: Apache 2.0
#
# Copyright 2015, Bloomberg Finance L.P.
#
node.default['java']['jdk_version'] = '8'
node.default['java']['accept_license_agreement'] = true
node.default['java']['set_etc_environment'] = true
include_recipe 'java::default'

node.default['maven']['install_java'] = false
node.default['maven']['setup_bin'] = true
include_recipe 'maven::default'
