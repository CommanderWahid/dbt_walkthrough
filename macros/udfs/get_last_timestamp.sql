{% macro get_last_timestamp(table_name, column_name) %}

    {% set target_relation = load_relation (table_name) %}
    
    {% set table_exists=target_relation is not none %}
    
    {% if table_exists %}
        
        {% set query %}
            select cast(max({{column_name}}) as timestamp) as last_timestamp from {{table_name}}
        {% endset %}

        {% set result = run_query(query) %}

        {% set last_timestamp = result.columns[0].values()[0] %}
    
    {% else %}

       {% set last_timestamp =  modules.datetime.datetime(1900,1,1) %}

    {% endif %}

    {{return (last_timestamp)}}

{% endmacro %}