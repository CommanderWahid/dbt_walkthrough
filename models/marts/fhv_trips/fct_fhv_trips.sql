{{ 
    config(
        materialized='incremental',
        file_format='delta',
        incremental_strategy='replace_where',
        incremental_predicates = 'trip_year = year(now()) and trip_month = month(now())',
        partition_by=['trip_year','trip_month'],
        tblproperties={
            'delta.feature.allowColumnDefaults':'supported'
        }
    ) 
}}

with fhv_trips as (

    select *
    from {{ref('stg_ax__fhv_trip')}}
   
    {% if is_incremental() %}
    where year(pickup_date) = year(now()) and month(pickup_date) = month(now()) 
    {% endif %}
)

select * from fhv_trips