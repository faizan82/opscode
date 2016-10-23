#
# Cookbook Name:: openam
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
#


include_recipe "openam::tomcat-setup"
include_recipe "openam::java-install"
