{% macro grant_select_on_target(catalog=target.catalog, schema=target.schema, role= target.role) %}

   {% set query %}
        grant use_catalog on  {{catalog}} to {{role}}
        grant use_schema  on  {{schema}} to {{role}}
        grant select on  {{schema}} to {{role}}
   {% endset %}

   {{ log('granting usage on catalog '~ catalog ~ ' schema ' ~ schema ~ ' and select on all tables to role ' ~ role, info=True) }}
   
   {% do run_query(query) %}
   
   {{ log('Privileges granted!', info=True) }}

{% endmacro%}