# Choosing second interface as an internal one, imitating DO.
second_interface = (node['network']['interfaces'].keys - ['lo']).sort[1]

override['do-private-net-firewall']['private_interface_name'] =
  second_interface
override['consul_wrapper']['private_interface'] = second_interface
