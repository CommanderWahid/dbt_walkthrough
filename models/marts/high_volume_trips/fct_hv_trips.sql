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
),

fhv_hv_trips_joined as (

    select 
        coalesce(dim_licenses.license_id,-1) as license_id,
        hv.pickup_date,
        hv.dropoff_date,
        hv.sr_flag,
        coalesce(dim_trip_zones_pickup.location_id,-1) as pickup_location_id,
        coalesce(dim_trip_zones_dropoff.location_id,-1) as dropoff_location_id,
        trip_time_mn,
        coalesce(dim_trip_modes.trip_mode_id,-1) as trip_mode_id,
        trip_year,
        trip_month,
        etl_loaded_at

    from hv_trips as hv 

    left join {{ ref('dim_licenses') }} as dim_licenses 
        on  hv.license_number = dim_licenses.license_number 
        and dim_licenses.is_current_version
    
    left join {{ ref('dim_trip_zones') }} as dim_trip_zones_pickup
        on  hv.pickup_borough = dim_trip_zones_pickup.borough
        and hv.pickup_zone = dim_trip_zones_pickup.zone
        and hv.pickup_service_zone = dim_trip_zones_pickup.service_zone

    left join {{ ref('dim_trip_zones') }} as dim_trip_zones_dropoff 
        on  hv.dropoff_borough = dim_trip_zones_dropoff.borough
        and hv.dropoff_zone = dim_trip_zones_dropoff.zone
        and hv.dropoff_service_zone = dim_trip_zones_dropoff.service_zone

    left join {{ ref('dim_trip_modes') }} as dim_trip_modes
        on hv.trip_mode = dim_trip_modes.trip_mode

)

select * from fhv_hv_trips_joined