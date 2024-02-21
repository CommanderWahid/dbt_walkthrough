{# setup the audit log module by creating a new schema and a table if they doesnt exist already in the target catalog #}

{% macro setup_audit_log() %}
    
    {% set schema_name = get_audit_schema_name() %}

    {% do adapter.create_schema(api.Relation.create(database=target.database, schema=schema_name)) %}

    {% set audit_table_name =  get_audit_table_full_name() %}
    
    {% set required_columns = [
       ["event_name", dbt.type_string()],
       ["event_timestamp", dbt.type_timestamp()],
       ["event_schema", dbt.type_string()],
       ["event_model", dbt.type_string()],
       ["event_user", dbt.type_string()],
       ["event_target", dbt.type_string()],
       ["event_is_full_refresh", "boolean"],
       ["invocation_id", dbt.type_string()],
    ] %}

    create table if not exists {{ audit_table_name }}
        (
        {% for column in required_columns %}
            {{ column[0] }} {{ column[1] }}{% if not loop.last %},{% endif %}
        {% endfor %}
        )

{% endmacro %}


{# save a log event to target audit table #}

{% macro log_audit_event(event_name, schema_name, model_name, target_name, is_full_refresh) %}

    {% set audit_table_name =  get_audit_table_full_name() %}

    insert into {{ audit_table_name }} values 
    (
     '{{ event_name }}',
     {{dbt.current_timestamp()}},
     {% if schema_name != None %} '{{ schema_name }}' {% else %} null::string {% endif %},  
     {% if model_name != None %}  '{{ model_name }}'  {% else %} null::string {% endif %},  
     {{get_function_current_user_name_full_name()}},
     {% if target_name != None %} '{{ target_name }}' {% else %} null::string {% endif %},   
     {% if is_full_refresh %}      True               {% else %} False {% endif %},     
     '{{ invocation_id }}'    
    )
      
{% endmacro %}


{# save project start event to target audit table #}

{% macro log_project_start_event() %}
    
    {{ log_audit_event(
        event_name='project run started', 
        schema_name=this.schema,  
        target_name=target.name,
        is_full_refresh=flags.FULL_REFRESH
    )}}

{% endmacro%}


{# save project end event to target audit table #}

{% macro log_project_end_event() %}
    
    {{ log_audit_event(
        event_name='project run completed', 
        schema_name=this.schema, 
        target_name=target.name,
        is_full_refresh=flags.FULL_REFRESH
    )}}

{% endmacro%}


{# save model start event to target audit table #}

{% macro log_model_start_event() %}
    
    {{ log_audit_event(
        event_name='model run started', 
        schema_name=this.schema, 
        model_name=this.name,
        target_name=target.name,
        is_full_refresh=flags.FULL_REFRESH
    )}}

{% endmacro%}


{# save model end event to target audit table #}

{% macro log_model_end_event() %}
    
    {{ log_audit_event(
        event_name='model run completed', 
        schema_name=this.schema, 
        model_name=this.name,
        target_name=target.name,
        is_full_refresh=flags.FULL_REFRESH
    )}}

{% endmacro%}