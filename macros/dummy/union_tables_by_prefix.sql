{% macro union_tables_by_prefix(database, schema, prefix) %}
    
    {% set tables = dbt_utils.get_relations_by_prefix(database=database, schema=schema, prefix=prefix) %}
    
    {% for item in tables %}
        {# item is a relation #}
        
        {% if not loop.first %}
          union 
        {% endif%}

        select * from {{item.database}}.{{item.schema}}.{{item.name}}

    {% endfor %}

{% endmacro %}