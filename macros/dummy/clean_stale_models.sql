{#
  - get database metadata
  - filter tables to be dropped 
  - generate drop statements
  - execute the statements if dry_run = False
#}


{% macro clean_stale_models(database=target.catalog, schema=target.schema, days= -10, dry_run= True) %}

    {% set query %}

        select 
            concat(
                'drop ',
                case 
                    when table_type = 'VIEW' then 'view' 
                    else 'table'
                end, 
                ' ',
                table_catalog,
                '.',
                table_schema,
                '.',
                table_name,
                ';'
            ) as drop_statement
        from {{database}}.information_schema.tables 
        where  
          table_schema = "{{schema}}" and
          last_altered < dateadd(current_timestamp(),{{days}}) 

    {% endset %}
     
    {{ log('Build drop queries ....\n',info=True) }}

    {% set queries = run_query(query).columns[0].values() %}

    {% if dry_run %}
        {{ log('Print drop queries ....\n',info=True) }}
    {% else %}
        {{ log('Run drop queries ....\n',info=True) }}
    {% endif %}
    
    {% for query in queries %}
        
        {%if dry_run %}
            {{ log(query, info=True) }}
        {% else %}
            {{ log('Execute query: ' ~ query,info=True)}}
            {% do run_query(query) %}
        {% endif %}   

    {% endfor %}

{% endmacro%}