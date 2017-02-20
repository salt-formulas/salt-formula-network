{%- if pillar.network is defined %}
include:
{%- if pillar.network.proxy is defined %}
- network.proxy
{%- endif %}
{%- if pillar.network.control is defined %}
- network.control
{%- endif %}
{%- endif %}
