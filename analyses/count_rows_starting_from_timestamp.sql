select count (1) as count_rows
from {{ref('stg_web__yellow_trip')}}
where etl_loaded_at > "{{ get_last_timestamp(ref('fct_yellow_trips'),'etl_loaded_at')}}"