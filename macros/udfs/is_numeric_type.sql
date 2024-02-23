{% macro is_numeric_type(model, column_name)%}

    {% set all_columns = adapter.get_columns_in_relation(model) %}
    
    {% set is_numeric = [] %}

    {% for col in all_columns %}
        
        {% if col.name == column_name   %} 
            {% if col.data_type in ["int","bigint","double"] or col.data_type.startswith("decimal")  %}
                {% do is_numeric.append(1) %}
            {% endif %}
        {% endif %}

    {% endfor %}

    {% if is_numeric|length > 0 %}
        {{return (True)}}
    {% else %}
        {{return (False)}}
    {% endif %}

{% endmacro %}