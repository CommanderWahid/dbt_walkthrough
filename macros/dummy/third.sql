{% macro cents_to_euros(column_name, decimal_places = 3) %}
    round(
        {{column_name}}/100,
        {{decimal_places}}
    )
{% endmacro %}