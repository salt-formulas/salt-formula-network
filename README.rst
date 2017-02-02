
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
