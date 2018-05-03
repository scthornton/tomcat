#
# Cookbook:: tomcat
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.
#

package 'java-1.7.0-openjdk-devel'

group "tomcat" do
	gid 2501
	action [:create]
end

user "tomcat" do
	comment 'Tomcat Service Account'
	uid 2501
	gid 2501
	home '/opt/tomcat'
	shell '/bin/nologin'
	action [:create]
end

remote_file "/tmp/apache-tomcat-9.0.7-src.tar.gz" do
	source 'http://apache.mirrors.ionfish.org/tomcat/tomcat-9/v9.0.7/src/apache-tomcat-9.0.7-src.tar.gz'
	action :create_if_missing
	mode 00644
end

directory '/opt/tomcat' do
	group 'tomcat'
	recursive true
	action :create
end



execute "untar" do
	user "root"
	group "root"
	cwd "/opt/tomcat"
	action :run
	command "tar xvf /tmp/apache-tomcat-8.5.24.tar.gz -C /opt/tomcat --strip-components=1"
end

execute '/opt/tomcat/conf' do
	user "root"
	group "root"
	cwd "/opt/tomcat"
	action :run
	command "chmod -R g+r conf"
end

execute '/opt/tomcat/conf_2' do
	user "root"
	group "root"
	cwd "/opt/tomcat"
	action :run
	command "chmod g+x conf"
end

execute '/opt/tomcat' do
	user "root"
	group "root"
	cwd "/opt/tomcat"
	action :run
	command "chgrp -R tomcat /opt/tomcat"
end

execute 'chown_webapps_work_temp_logs' do
	user "root"
	group "root"
	cwd "/opt/tomcat"
	action :run
	command "chown -R tomcat webapps/ work/ temp/ logs/"
end

template '/etc/systemd/system/tomcat.service' do
	source 'tomcat.service.erb'
end

service 'tomcat' do
	action [:enable, :start]
end
