#
# Cookbook Name:: openam
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
#

include_recipe 'aws'

# Override some JVM defaults and setup
node.default['tomcat']['catalina_options'] = "-server -Xmx2048m -XX:MaxPermSize=256m"
remote_file  = 'https://s3.amazonaws.com/pearson-web/openam.war'
s3_creds=data_bag_item('aws_creds_s3','aws_s3')


directory '/usr/share/tomcat' do 
   action :create 
   owner 'tomcat'
   mode '0755'
end
 

user 'tomcat' do 
  manage_home true 
  home '/usr/share/tomcat'
end


group 'tomcat' do
  members 'tomcat'
  action :create
end

tomcat_install 'openam' do 
  version       '7.0.72'
  install_path '/opt/tomcat-openam'
  #tarball_uri  'http://mirror.fibergrid.in/apache/tomcat/tomcat-7/v7.0.72/bin/apache-tomcat-7.0.72.tar.gz'
  tomcat_user  'tomcat'
  tomcat_group 'tomcat'
end

=begin
remote_file '/opt/tomcat-openam/webapps/openam.war' do 
  owner 'tomcat'
  mode '0644'
  source  "#{remote_file}"
end
=end
 

aws_s3_file '/opt/tomcat-openam/webapps/openam.war' do
  bucket 'pearson-web'
  remote_path  "openam.war"
  aws_access_key s3_creds['aws_access_key_id']
  aws_secret_access_key s3_creds['aws_secret_access_key']
  owner 'tomcat'
  mode '0644'
end

tomcat_service 'openam' do
  supports :status => true, :restart => true
  action [:start, :enable]
  #env_vars [{ 'JENKINS_HOME' => '/opt/Jenkins' }]
  sensitive true
  tomcat_user 'tomcat'
  tomcat_group 'tomcat'
end


