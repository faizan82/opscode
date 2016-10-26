#
# Cookbook Name:: javaApp
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
#

# Common attributes required for dev environment

include_recipe 'apps_java::default'

# Attributes specific to dev environment
node.default['openam']['url'] = "http://devopenam.pearson.com/openam"
node.default['db']['host'] = '10.4.3.217'
node.default['db']['port'] = '27017'


template '/opt/java-app/WORKSPACE/config/filter-common-properties/dev-common-filter.properties' do
    mode '0644'
    source 'common.properties.erb'
    owner 'app-deployer'
    group 'deployer'
end



# Call all dev recipes here 

include_recipe 'apps_java::cds-dev'
