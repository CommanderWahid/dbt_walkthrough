{% macro create_fn_get_current_user_name() %}

    {% set function_full_name = get_function_current_user_name_full_name() %}
    create or replace function {{function_full_name}} returns string return current_user();

{% endmacro %}


{% macro create_udfs() %}
    {{ create_fn_get_current_user_name() }}
{% endmacro %}