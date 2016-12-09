
==================================
network configuration formula
==================================

Sets up network devices.

Sample pillars
==============

Single network config snippet

.. code-block:: yaml

    network:
      control:
        enabled: true
        config:
          switch_vlan:
            eth0-0-1:
              address: 10.0.0.1/24
            eth0-0-2:
              address: 10.0.0.2/24
            eth0-0-3:
              address: 10.0.0.3/24
        device:
          vsrx1:
            interface:
              eth0-0-1: ${network:conrol:config:switch_vlan}

JunOS VSRX device

.. code-block:: yaml

    network:
      control:
        enabled: true
        managed: true
        device:
          vsrx1:
            type: junos
            auth:
              password: $1$gpbfk/Jr$
            interface:
              eth0-0-1:
                address: 10.0.0.1/24

Read more
=========

* links
