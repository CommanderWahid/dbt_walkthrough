{{ 
    config(
        materialized='incremental',
        file_format='delta', 
        incremental_strategy='append',
        partition_by=['trip_year','trip_month'],
        tblproperties={
            'delta.feature.allowColumnDefaults':'supported'
        }
    ) 
}}

with hv_trips as (

    select *
    from {{ref('stg_ax__fhv_hv_trip')}}
   
    {% if is_incremental() %}
    where etl_loaded_at > (select max(etl_loaded_at) from {{ this }})
    {% endif %}
)

select * from hv_trips