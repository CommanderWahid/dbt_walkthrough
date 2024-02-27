{% test is_zero_amount(model, column_name) %}
    
    {{ config(severity = 'warn') }}
    
    with validation as (

        select
            {{ column_name }} as amount_field

        from {{ model }}

    ),

    validation_errors as (

        select
            amount_field

        from validation
        {% if is_numeric_type(model,column_name) %}
            where amount_field = 0
        {% endif%}

    )

    select * from validation_errors

{% endtest %}


