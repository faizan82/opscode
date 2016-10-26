#
# Cookbook Name:: javaApp
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
#

# Use this recipe to setup items common to all envs
# Any software 

# JDK installation
node.default['java']['install_flavor'] = 'openjdk'
node.default['java']['jdk_version'] = 8
node.override['config']['dir'] = '/opt/java-app/WORKSPACE/config'

include_recipe 'java'


user 'app-deployer' do
   manage_home true
   home '/opt/java-app'
end


group 'deployer'  do
   members 'app-deployer'
end

# Ensure log directory is present
directory '/var/log/apps-java/' do
   mode "0755"
   owner "app-deployer"
   group "deployer"
   action :create 
end
    

# This will setup config directory location as well as common dir
%w[ /opt/java-app/WORKSPACE /opt/java-app/WORKSPACE/config /opt/java-app/WORKSPACE/config/filter-common-properties].each do |dir|
    directory dir do
      mode "0755"
      owner "app-deployer"
      group "deployer"
      action :create 
      recursive true
    end
end

