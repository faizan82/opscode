#
# Cookbook Name:: javaApp
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
#

user 'app-deployer' do
   manage_home true
   home '/opt/java-app'
end


group 'deployer'  do
   members 'app-deployer'
end

%w[/opt/java-app/config /opt/java-app/config/filter-common-properties].each do |dir|
    directory dir do
      mode "0755"
      owner "app-deployer"
      group "deployer"
      action :create 
      recursive true
    end
end


node.default['openam']['url'] = "http://devopenam.pearson.com/openam"

template '/opt/java-app/config/filter-common-properties/dev-common-filter.properties' do
    mode '0644'
    source 'common.properties.erb'
    owner 'app-deployer'
    group 'deployer'
end
