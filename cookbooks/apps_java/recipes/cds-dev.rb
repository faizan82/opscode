#
# Cookbook Name:: javaApp
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
#


include_recipe 'aws'
s3_creds=data_bag_item('aws_creds_s3','aws_s3')

# Node info
node.default['cdsserver']['port'] = 9020
node.default['cdsmgmt']['port'] = 9021
node.default['cdsmgmt']['addrs']= '127.0.0.1'
node.default['compression']['status'] = true
node.default['context']['path'] = '/cds/v1'

# Override these in all services 
node.override['db']['name'] = 'test'
node.override['db']['uname'] = ''
node.override['db']['passwd'] = ''


cds_jar_path='/opt/java-app/cds-app/cds.jar'
cds_jar_s3='core-data-service-Pearson_0.1-exec.jar'
cds_revision='70'
cds_jar_bucket='pearson-artifacts'

directory '/opt/java-app/cds-app' do
  action :create
  owner 'app-deployer'
  group 'deployer'
  mode '0755'
end 

aws_s3_file "#{cds_jar_path}" do
  bucket "#{cds_jar_bucket}"
  remote_path  '/pearson-sprint-2/70/core-data-service-Pearson_0.1-exec.jar'
  aws_access_key s3_creds['aws_access_key_id']
  aws_secret_access_key s3_creds['aws_secret_access_key']
  owner 'app-deployer'
  group 'deployer'
  mode '0644'
end

# reate logging related setup 
%w[ /opt/java-app/WORKSPACE/config/CDS /opt/java-app/WORKSPACE/config/CDS/dev  /opt/java-app/WORKSPACE/config/CDS/dev/logback /opt/java-app/WORKSPACE/config/CDS/dev/logging].each do |dir|
   directory dir do
     action :create
     mode '0755'
     owner 'app-deployer'
     group 'deployer'
   end
end

template '/opt/java-app/WORKSPACE/config/CDS/dev/application.properties' do
    source 'application.properties.erb'
    owner  'app-deployer'
    group  'deployer'
    mode   '0644'
end

template '/opt/java-app/WORKSPACE/config/CDS/dev/mongodb.properties' do 
    source 'mongodb.erb'
    owner  'app-deployer'
    group  'deployer'
    mode   '0644'
end

# We can templatize these if required else use them as it is
cookbook_file '/opt/java-app/WORKSPACE/config/CDS/dev/logging/logging.xml'  do
   source 'logging.xml'
   owner  'app-deployer'
   group  'deployer'
   mode   '0644'
end


cookbook_file '/opt/java-app/WORKSPACE/config/CDS/dev/logback/logback.properties'  do
   source 'logback.properties'
   owner  'app-deployer'
   group  'deployer'
   mode   '0644'
end


# Start jar and also redirect std out to a file 

bash 'run cds' do 
   code <<-EOH
      cd /opt/java-app/
      /usr/lib/jvm/java-1.8.0-openjdk.x86_64/bin/java -Dconfig.home=/opt/java-app/WORKSPACE/config -Dcomponent.name=CDS -Denv=dev -jar  #{cds_jar_path} > /var/log/apps-java/startup.log 2>&1 nohup &  
      EOH
end

