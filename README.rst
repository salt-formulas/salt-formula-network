
==================================
network configuration formula
==================================

Sets up network devices.

Sample pillars
==============

Cisco IOS interfaces setup 

.. code-block:: yaml

  network:
    control:
      enabled: true
      managed: true
      replace_entire_config: False
      commit: True
      config:
        switch_vlan:
          g0/1:
            subinterfaces:
              0:
                description: goesToNetworkX
                address: 10.0.0.1
                mask: 255.255.255.0
                mtu: 1500
          loopback0:
            subinterfaces:
              0:
                description: goesToNetworkY
                address: 10.0.0.1
                mask: 255.255.255.0


Cisco IOS routing setup

.. code-block:: yaml

      device:
        csr1000v:
          type: ios
          kind: router
          domain: example.local
          auth:
            password: r00tme
            user: root
          interfaces: ${network:control:config:switch_vlan}
          routing:
            bgp:
              AS: 65501
              router_id: 1.1.1.1
              neighbors:
              - neighbor_ip: 192.168.2.1
                remote_as: 65501
                update_source: Loopback0
                next_hop_self: True
              - neighbor_ip: 209.165.200.222
                remote_as: 65503
                update_source: Loopback0
                password: cloudlab
              family:
                type: ipv4
                networks:
                - ip: 10.1.0.0
                  mask: 255.255.0.0
                - ip: 192.168.3.1
                  mask: 255.255.255.255
            ospf:
              process: 1
              router_id: 1.1.1.1
              advertise_default_route:
                metric: 100
                metric_type: 1
              networks:
              - ip: 10.1.2.12
                wild_mask: 0.0.0.3
                area: 0
              - ip: 192.168.3.1
                wild_mask: 0.0.0.0
                area: 0
            static:
              routes:
              - destination: 10.1.0.0
                mask: 255.255.255.0
                next_hop: 10.0.0.1
              - destination: 10.2.0.0
                mask: 255.255.255.0
                next_hop: 10.0.0.1



Cisco IOS switch interfaces setup 

.. code-block:: yaml

    network:
      control:
        enabled: true
        managed: true
        config:
          switch_vlan:
            loopback0:
              description: goesToNetworkX
              address: 10.0.0.1
              mask: 255.255.255.0
            Port-channel1:
              native_vlan: 110
              allowed_vlans: 100,110
              mode: trunk
              channel_group: 1
            g0/1:
              native_vlan: 110
              allowed_vlans: 100,110
              mode: trunk
              channel_group: 1
              etherchannel_protocol: lacp
            g0/2:
              no_switchport: True
              address: 10.1.2.1
              mask: 255.255.255.252
            g0/3:
              mode: access
              vlan: 100
            Vlan100:
              address: 10.1.100.1
              mask: 255.255.255.0


Cisco IOS switch setup

.. code-block:: yaml

        device:
          c3560:
            type: ios
            kind: switch
            domain: example.local
            auth:
              password: r00tme
              user: root
            vlans:
              100:
                name: SERVERS
              110:
                name: GUEST
            interfaces: ${network:control:config:switch_vlan}



JunOS interfaces setup 

.. code-block:: yaml

    network:
      control:
        enabled: true
        managed: true
        replace_entire_config: False
        commit: True
        config:
          switch_vlan:
            ge-0/0/1:
              units:
                0:
                  description: goesToNetworkX
                  address: 10.0.0.1/24
            ge-0/0/0:
              units:
                0:
                  description: goesToNetworkY
                  address: 172.16.10.90/24
            xe-2/0/0:
              gigether_options: 802.3ad ae0
            ae0:
              description: goesToNetworkX
              tagging_support_type: flexible-vlan-tagging
              aggreg_ether_opts:
                protocol: lacp
                mode: active
              mtu: 9000
              units:
                110:
                  description: goesToNetworkX
                  vlan_id: 110
                  address: 11.0.0.1/24
                120:
                  description: goesToNetworkX
                  vlan-id: 120
                  address: 12.0.0.1/24

JunOS routing options setup

.. code-block:: yaml

    network:
      control:
        enabled: true
        managed: true
        replace_entire_config: False
        commit: True
        device:
          vsrx01:
            type: junos
            timezone: Europe/Prague
            nameservers:
            - 8.8.8.8
            - 8.8.4.4
            ntp_servers:
            - 46.243.48.4
            - 147.251.48.140
            auth:
              password: r00tme
              user: root
            chassis:
            interfaces: ${network:control:config:switch_vlan}
            routing_options:
              AS: 64512
              dyn_tunnel_name: CLOUD
              source_address: 10.31.4.10
              encapsulation: gre
              dest_networks:
              - 10.31.4.0/24
              - 10.31.5.0/24

JunOS protocols setup

.. code-block:: yaml

    network:
      control:
        enabled: true
        managed: true
        replace_entire_config: False
        commit: True
        device:
          vsrx01:
            type: junos
            timezone: Europe/Prague
            nameservers:
            - 8.8.8.8
            - 8.8.4.4
            ntp_servers:
            - 46.243.48.4
            - 147.251.48.140
            auth:
              password: cloudlab
              user: root
            chassis:
            interfaces: ${network:control:config:switch_vlan}
            protocols:
              mpls:
                interfaces:
                  ge-0/0/0.605:
                  fxp0.0:
                    disable_proto: True
                  ge-0/0/0.606:
                  all:
              bgp:
                groups:
                  IBGP-CLOUD:
                    type: internal
                    local_address: 10.167.2.8
                    families:
                      inet-vpn:
                        include: unicast
                      inet:
                        include: any
                    neighbors:
                    - 10.167.3.21
                    - 10.167.3.22
                    - 10.167.3.23
                  EBGP-CLOUD:
                    type: external
                    local_address: 10.167.2.8
                    families:
                      inet-vpn:
                        include: unicast
                      inet:
                        include: any
                    neighbors:
                    - 10.167.3.21
                    - 10.167.3.22
                    - 10.167.3.23
              lldp:
                interfaces:
                  ge-0/0/0.605:
                    disable_proto: True
                  all:
              lldp-med:
                interfaces:
                  ge-0/0/0.605:
                    disable_proto: True
                  all:


JunOS policy options setup

.. code-block:: yaml

    network:
      control:
        enabled: true
        managed: true
        replace_entire_config: False
        commit: True
        device:
          vsrx01:
            type: junos
            timezone: Europe/Prague
            nameservers:
            - 8.8.8.8
            - 8.8.4.4
            ntp_servers:
            - 46.243.48.4
            - 147.251.48.140
            auth:
              password: cloudlab
              user: root
            chassis:
            interfaces: ${network:control:config:switch_vlan}
            policy_options:
              policy_statements:
                VRF-EXT-TENANT000-IMPORT:
                  terms:
                    FROM-CONTRAIL:
                      matches:
                        protocol: bgp
                        community: VRF-EXT-TENANT000-IMPORT-COMMUNITY
                        route_filters: 
                        - 10.31.128.0/18 exact
                        - 10.31.128.0/18 orlonger
                      actions:
                        type: accept
                        communities: 
                        - VRF-EXT-TENANT003-EXPORT-COMMUNITY
                        - VRF-EXT-TENANT004-EXPORT-COMMUNITY
                    LAST:
                      actions:
                        type: reject
              communities:
                VRF-EXT-TENANT000-EXPORT-COMMUNITY:
                  member: target:10:10
                VRF-EXT-TENANT000-IMPORT-COMMUNITY
                  member: target:10:10

JunOS security setup

.. code-block:: yaml

    network:
      control:
        enabled: true
        managed: true
        replace_entire_config: False
        commit: True
        device:
          vsrx01:
            type: junos
            timezone: Europe/Prague
            nameservers:
            - 8.8.8.8
            - 8.8.4.4
            ntp_servers:
            - 46.243.48.4
            - 147.251.48.140
            auth:
              password: cloudlab
              user: root
            chassis:
            interfaces: ${network:control:config:switch_vlan}
            security: 
              type: default
              interfaces:
                in_trust_zone:
                - ge-0/0/0.0
                - ge-0/0/1.0


JunOS routing instances setup

.. code-block:: yaml

    network:
      control:
        enabled: true
        managed: true
        replace_entire_config: False
        commit: True
        device:
          vsrx01:
            type: junos
            timezone: Europe/Prague
            nameservers:
            - 8.8.8.8
            - 8.8.4.4
            ntp_servers:
            - 46.243.48.4
            - 147.251.48.140
            auth:
              password: cloudlab
              user: root
            chassis:
            interfaces: ${network:control:config:switch_vlan}
            routing_instances:
              VRF-EXT-TENANT000:
                instance_type: vrf
                interfaces:
                - ge-0/0/0.601
                - ae0.2301
                route_distinguisher: '64512:1'
                vrf_import: VRF-EXT-TENANT001-IMPORT
                vrf_export: VRF-EXT-TENANT001-EXPORT
                vrf_table_label: True
                static_routes:
                - destination: 0.0.0.0/0
                  next_hops:
                  - 172.16.10.1
                  - 172.16.20.1
                - destination: 10.0.0.0/8
                  next_hops:
                  - 172.16.10.1
              VRF-EXT-TENANT001:
                instance_type: vrf
                interfaces:
                - ge-0/0/0.602
                - ae0.2302
                route_distinguisher: '64512:2'
                vrf_import: VRF-EXT-TENANT002-IMPORT
                vrf_export: VRF-EXT-TENANT002-EXPORT
                vrf_table_label: True
                static_routes:
                - destination: 0.0.0.0/0
                  next_hops:
                  - 172.16.40.1
                  - 172.16.50.1
                - destination: 10.0.0.0/8
                  next_hops:
                  - 172.16.60.1



Read more
=========

* links

Documentation and Bugs
======================

To learn how to install and update salt-formulas, consult the documentation
available online at:

    http://salt-formulas.readthedocs.io/

In the unfortunate event that bugs are discovered, they should be reported to
the appropriate issue tracker. Use Github issue tracker for specific salt
formula:

    https://github.com/salt-formulas/salt-formula-network/issues

For feature requests, bug reports or blueprints affecting entire ecosystem,
use Launchpad salt-formulas project:

    https://launchpad.net/salt-formulas

You can also join salt-formulas-users team and subscribe to mailing list:

    https://launchpad.net/~salt-formulas-users

Developers wishing to work on the salt-formulas projects should always base
their work on master branch and submit pull request against specific formula.

    https://github.com/salt-formulas/salt-formula-network

Any questions or feedback is always welcome so feel free to join our IRC
channel:

    #salt-formulas @ irc.freenode.net
