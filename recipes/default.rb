#
# Cookbook Name:: do-private-net-firewall
# Resource:: default
#
# Copyright 2017, Kirill Kuznetsov
#
# All rights reserved
#

private_interface_name =
  node['do-private-net-firewall']['private_interface_name']

interface = node['network']['interfaces'][private_interface_name]
interface_addrs = interface['addresses'].find do |_address, data|
  data['family'] == 'inet'
end

internal_ip = interface_addrs.first

node.default['consul_template']['config'] = {
  'consul' => {
    'address' => "#{internal_ip}:8500",
  },
}

include_recipe 'consul-template'

template '/etc/default/ufw-consul.ctmpl' do
  source 'ufw-consul.ctmpl.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :reload, 'service[consul-template]', :delayed
  variables(
    enable_ssh_rule: node['do-private-net-firewall']['enable_ssh_rule'],
    ssh_port: node['do-private-net-firewall']['ssh_port'],
  )
end

ufw_reload_cmd = %(
  /bin/bash -c '
  yes | ufw reset &&
  source /etc/default/ufw-chef.rules &&
  source /etc/default/ufw-consul.rules &&
  yes | ufw enable'
).gsub(/\s+/, ' ').strip

consul_template_config 'ufw-consul' do
  templates [
    {
      source: '/etc/default/ufw-consul.ctmpl',
      destination: '/etc/default/ufw-consul.rules',
      command: ufw_reload_cmd,
    },
  ]
  notifies :reload, 'service[consul-template]', :delayed
end

# When ufw-chef.rules is changed by cookbook[firewall] our rules are be
# discarded. Moreover, applying ufw-consul.rules may take a considerable
# amount of time. We have to temporarily disable UFW, apply ufw-consul.rules
# and enable it again afterwards.
execute 'reload ufw rules' do
  action :nothing
  command %(bash -c 'ufw disable &&
    source /etc/default/ufw-consul.rules &&
    yes | ufw enable'
  )
  subscribes :run, 'firewall[default]', :immediately
  only_if do
    ::File.exist? '/etc/default/ufw-consul.rules'
  end
end
