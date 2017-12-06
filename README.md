# do-private-net-firewall

The main idea is to collect information about all known nodes and services from your Consul cluster and create UFW rule list that only allows connections between this particular nodes and services inside the DO private network.

For an external service to be exposed on all interfaces, mark Consul service with the tag `external`.

## Dependencies

* `cookbook[firewall]`
* `cookbook[consul]`

## Supports

This cookbook was tested on:

* Debian 8.9
* Debian 9.2
* Ubuntu 14.04
* Ubuntu 16.04

with both Chef `13.6.4` & Chef `12.21.14`

Also, it will probably work on other Debian-based distributions.

## How to use

1. Register all your network services in Consul.
2. Mark any services you want to be exposed globally with the `external` tag.
3. Add this cookbook to your run list after your consul configuration cookbook & `cookbook[firewall]`.
4. Profit.

If you want to check the rules, see `/etc/default/ufw-consul.rules`.

# License and Author

Author:: Kirill Kouznetsov (<agon.smith@gmail.com>)

Copyright:: 2015, Kirill Kouznetsov.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.