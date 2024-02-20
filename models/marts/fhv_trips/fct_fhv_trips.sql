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
),

fhv_trips_joined as (

    select 
        coalesce(dim_licenses.license_id,-1) as license_id,
        fhv.pickup_date,
        fhv.dropoff_date,
        fhv.sr_flag,
        coalesce(dim_trip_zones_pickup.location_id,-1) as pickup_location_id,
        coalesce(dim_trip_zones_dropoff.location_id,-1) as dropoff_location_id,
        trip_time_mn,
        coalesce(dim_trip_modes.trip_mode_id,-1) as trip_mode_id,
        trip_year,
        trip_month,
        etl_loaded_at

    from fhv_trips as fhv 

    left join {{ ref('dim_licenses') }} as dim_licenses 
        on fhv.license_number = dim_licenses.license_number 
        and dim_licenses.is_current_version
    
    left join {{ ref('dim_trip_zones') }} as dim_trip_zones_pickup
        on  fhv.pickup_borough = dim_trip_zones_pickup.borough
        and fhv.pickup_zone = dim_trip_zones_pickup.zone
        and fhv.pickup_service_zone = dim_trip_zones_pickup.service_zone

    left join {{ ref('dim_trip_zones') }} as dim_trip_zones_dropoff 
        on  fhv.dropoff_borough = dim_trip_zones_dropoff.borough
        and fhv.dropoff_zone = dim_trip_zones_dropoff.zone
        and fhv.dropoff_service_zone = dim_trip_zones_dropoff.service_zone

    left join {{ ref('dim_trip_modes') }} as dim_trip_modes
        on fhv.trip_mode = dim_trip_modes.trip_mode
)

select * from fhv_trips_joined