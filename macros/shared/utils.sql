{% macro get_audit_schema_name() %}

    {% set schema_name = var('audit_schema_name') %}
    {{return (schema_name)}}

{% endmacro %}


{% macro get_audit_table_name() %}

    {% set table_name = var('audit_table_name') %}
    {{return (table_name)}}

{% endmacro %}


{% macro get_audit_table_full_name() %}

    {% set schema_name = get_audit_schema_name() %}
    {% set table_name = get_audit_table_name() %}
    {% set table_full_name = target.database ~ "." ~ schema_name ~ "." ~ table_name %}
    {{return (table_full_name)}}

{% endmacro %}


{% macro get_function_current_user_name_full_name() %}

    {% set schema_name = get_audit_schema_name() %}
    {% set function_full_name = target.database ~ "." ~ schema_name ~ "." ~ "get_current_user_name()" %}
    {{return (function_full_name)}}

{% endmacro %}
