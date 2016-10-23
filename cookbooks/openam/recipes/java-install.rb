#
# Cookbook Name:: openam
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
#

#node.set['java']['install_flavor'] = 'openjdk'
#node.set['java']['jdk_version'] = 8

node.default['java']['install_flavor'] = 'openjdk'
node.default['java']['jdk_version'] = 8

include_recipe 'java'
