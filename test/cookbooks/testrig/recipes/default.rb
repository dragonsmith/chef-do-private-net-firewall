#
# Cookbook Name:: testrig
# Resource:: default
#
# Copyright 2017, Kirill Kuznetsov
#
# All rights reserved
#

address = node['ipaddress']

package 'nginx'

consul_definition 'nginx' do
  type 'service'
  parameters(tags: %w(nginx external), address: address, port: 80)
  notifies :reload, 'consul_service[consul]'
end

consul_definition 'nginx-http' do
  type 'check'
  parameters(
    http: "http://#{address}:80",
    interval: '15s',
    timeout: '5s',
    notes: 'Nginx http port',
    service_id: 'nginx',
  )
  notifies :reload, 'consul_service[consul]'
end
