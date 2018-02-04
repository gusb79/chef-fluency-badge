#
# Cookbook:: apache
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

f node['platform_family'] == 'rhel'
	package = 'httpd'
elseif node['platform_family'] == 'debian'
	package = 'apache2'

package 'apache2' do
	package_name package
	action :install
end


service 'apache2' do
	service_name 'httpd'
	action [:enable, :start]
end
