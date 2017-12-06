default['do-private-net-firewall']['enable_ssh_rule']        = true
default['do-private-net-firewall']['ssh_port']               = 22
default['do-private-net-firewall']['private_interface_name'] = 'eth1'

default['consul_template']['version']       = '0.19.4'
default['consul_template']['service_user']  = 'root'
default['consul_template']['service_group'] = 'root'
default['consul_template']['checksums']     = {
  'consul-template_0.19.4_linux_amd64' =>
    '5f70a7fb626ea8c332487c491924e0a2d594637de709e5b430ecffc83088abc0',
}

init_style = if node['platform'] == 'ubuntu' and
                node['platform_version'].to_i < 16
               'upstart'
             else
               'systemd'
             end
default['consul_template']['init_style'] = init_style
