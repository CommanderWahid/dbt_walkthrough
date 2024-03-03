select count (1) as count_rows
from {{ref('stg_web__yellow_trip')}}

{%- if target.name == 'databricks_dev'%}
where etl_loaded_at > '2023-01-01'
{% endif%}