#
# Cookbook Name:: openam
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
#

remote_file = 'http://mirrors.jenkins-ci.org/war-stable/1.651.3/jenkins.war'
user 'tomcat'

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

remote_file '/opt/tomcat-openam/webapps/openam.war' do 
  owner 'tomcat'
  mode '0644'
  source  "#{remote_file}"
end


tomcat_service 'openam' do
  action [:start, :enable]
  env_vars [{ 'JENKINS_HOME' => '/opt/Jenkins' }]
  sensitive true
  tomcat_user 'tomcat'
  tomcat_group 'tomcat'
end


