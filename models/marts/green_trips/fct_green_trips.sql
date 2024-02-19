{{ 
    config(
        materialized='incremental',
        file_format='delta', 
        unique_key=['vendor_id','pickup_date','dropoff_date','trip_type_id','rate_code_id','payment_type_id','pickup_location_id','dropoff_location_id'],
        incremental_strategy='merge',
        partition_by=['trip_year','trip_month'],
        tblproperties={
            'delta.feature.allowColumnDefaults':'supported'
        }
    ) 
}}

with green_trips as (

    select *
    from {{ref('stg_web__green_trip')}}
    where row_num = 1
    {% if is_incremental() %}
        and etl_loaded_at > "{{ get_last_timestamp(this,'etl_loaded_at')}}"
    {% endif %}
)

select vendor_id,
       pickup_date,
       dropoff_date,
       trip_type_id,
       rate_code_id,
       payment_type_id,
       pickup_location_id,
       dropoff_location_id,
       passenger_count,
       trip_distance, 
       total_amount,
       trip_time_mn,
       trip_mode,
       trip_year,
       trip_month,
       etl_loaded_at
from green_trips