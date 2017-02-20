{%- from "network/map.jinja" import proxy with context %}
{%- if proxy.enabled %}

network_proxy_packages:
  pkg.installed:
  - names: {{ proxy.pkgs }}

napalm:
  pip.installed:
    - name: {{ proxy.pip_pkgs}}
    - require:
      - pkg: python-pip

/etc/salt/proxy:
  file.managed:
  - source: salt://network/files/proxy.conf.{{ grains.os_family }}
  - template: jinja
  - require:
    - pip: napalm

/usr/lib/python2.7/dist-packages/salt/grains/napalm.py:
  file.managed:
  - source: salt://network/files/grains_napalm.py
  - template: jinja
  - require:
    - pip: napalm


/usr/lib/python2.7/dist-packages/salt/proxy/napalm.py:
  file.managed:
  - source: salt://network/files/proxy_napalm.py
  - template: jinja
  - require:
    - pip: napalm


/usr/lib/python2.7/dist-packages/salt/utils/napalm.py:
  file.managed:
  - source: salt://network/files/utils_napalm.py
  - template: jinja
  - require:
    - pip: napalm

refresh_pillar:
  cmd.run:
  - name: "salt '*' saltutil.refresh_pillar"

salt_master_service:
  service.running:
  - enable: true
  - names: {{ proxy.services }}
  - watch:
    - file: /etc/salt/proxy

{%- for device_name in proxy.devices %}

salt_proxy_service_{{ device_name }}:
  cmd.run:
  - name: "salt-proxy --proxyid={{ device_name }} -l debug"
  - unless: "ps aux | grep {{ device_name }} | grep python"
  - require:
    - file: /etc/salt/proxy

{%- endfor %}
{%- endif %}