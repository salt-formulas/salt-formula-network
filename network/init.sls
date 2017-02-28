{%- if pillar.network is defined %}
include:
{%- if pillar.network.control is defined %}
- network.control
{%- endif %}
{%- endif %}
