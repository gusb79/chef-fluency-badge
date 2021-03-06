#
# Cookbook:: tomcat
# Recipe:: server
#
# Copyright:: 2018, The Authors, All Rights Reserved.

# ERROR: Node attributes are read-only when you do not specify which precedence
# level to set. To set an attribute use code like `node.default["key"] = "value"'
node.default['server']['user'] = 'tomcat'
node.default['server']['group'] = 'tomcat'

package 'java-1.7.0-openjdk-devel'

group node['server']['group']

user node['server']['user'] do
  group node['server']['group']
end

directory '/opt/tomcat' do
  owner node['server']['user']
  group node['server']['group']
end

execute 'untar' do
  cwd '/opt/tomcat'
  command 'sudo tar xvf apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1'
  action :nothing
end

remote_file 'Tomcat Binaries' do
  source 'http://mirror.ox.ac.uk/sites/rsync.apache.org/tomcat/tomcat-8/v8.5.28/bin/apache-tomcat-8.5.28.tar.gz'
  path '/opt/tomcat/apache-tomcat-8.5.28.tar.gz'
  not_if { ::File.exist?('/opt/tomcat/apache-tomcat-8.5.28.tar.gz') }
  notifies :run, 'execute[untar]', :immediately
end




directory '/opt/tomcat/conf' do
  owner node['server']['user']
  group node['server']['group']
  mode '0770'
end

# I don't know if this recursive chown can be done with Chef resources
execute 'Recursive Chgrp' do
  command "sudo chgrp -R tomcat /opt/tomcat/conf/"
end

# I don't know how to apply a single command to all the files in the same directory
execute 'Config Files Chown' do
  command "sudo chmod g+r /opt/tomcat/conf/*"
end

# I don't know if this recursive chown can be done with Chef resources
%w( /opt/tomcat/webapps/ /opt/tomcat/work/ /opt/tomcat/temp/ /opt/tomcat/logs/).each do |dir|
  execute 'Recursive Chown' do
    command "sudo chown -R #{node['server']['user']} #{dir}"
  end
end


template 'tomcat.service' do
  source 'tomcat.service.erb'
  path '/etc/systemd/system/tomcat.service'
end

# Does not work in Docker
# Checked the running docker container with
#  docker ps
# Get the container ID
#  docker container exec -ti <ContainerID> "/bin/bash"
#execute 'daemon-reload' do
#  command 'systemctl daemon-reload'
#end

# Use specific Dockerfile with Test Kitchen 
# https://github.com/moby/moby/issues/28614
#
execute 'Add the Tomcat Service' do
  command 'chkconfig --add tomcat'
end

service 'tomcat' do
  action [ :enable, :start ]
end

template 'server.xml' do
  source 'service.xml.erb'
  mode '0750'
  owner node['server']['user']
  group node['server']['group']
  path '/opt/tomcat/conf/server.xml'
  variables(tomcatPort: node['server']['tomcat-port'])
  notifies :reload, 'service[tomcat]', :immediately
end
