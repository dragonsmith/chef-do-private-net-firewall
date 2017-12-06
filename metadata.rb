name             'do-private-net-firewall'
maintainer       'Kirill Kouznetsov'
maintainer_email 'agon.smith@gmail.com'
license          'Apache-2.0'
version          '0.1.0'

chef_version '>= 12.14', '< 14'

supports 'ubuntu', '>= 14.04'
supports 'debian', '>= 8.0'

depends 'consul-template'
depends 'firewall'
depends 'ufw'

source_url 'https://github.com/dragonsmith/chef-do-private-net-firewall'
issues_url 'https://github.com/dragonsmith/chef-do-private-net-firewall/issues'
