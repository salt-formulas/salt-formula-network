{%- from "network/map.jinja" import control with context %}
{%- if control.enabled %}

network_dirs:
  file.directory:
  - name: {{ control.dir.base }}
  - makedirs: true

{%- for device_name, device in control.device.iteritems() %}

{% if device.get('enabled', True) %}

{{ control.dir.base }}/{{ device_name }}.conf:
  file.managed:
  - source: salt://network/files/{{ device.type }}/base.conf
  - template: jinja
  - defaults:
    device_name: {{ device_name }}
    device: {{ device|yaml }}
  - require:
    - file: network_dirs

{% if device.get('managed', False) %}
 
{{ device_name }}_config_enforce
  network.device_config:
  - config: {{ control.dir.base }}/{{ device_name }}.conf
  - dev_os: {{ device.type }}
  - hostname: {{ device.auth.host}}
  - username: {{ device.auth.user }}
  - password: {{ device.auth.password }}
  - commit_changes: {{ device.get('commit_changes', True) }}
  - get_diffs: {{ device.get('get_diffs', True) }}

{%- endif %}

{%- endif %}

{%- endfor %}

{%- endif %}
