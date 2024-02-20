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
),

green_trips_joined as (

    select 
       green.vendor_id,
       green.pickup_date,
       green.dropoff_date,
       coalesce(dim_trip_types.trip_type_id,-1) as trip_type_id,
       coalesce(dim_rate_codes.rate_code_id,-1) as rate_code_id,
       coalesce(dim_payment_types.payment_type_id,-1) as payment_type_id,
       coalesce(dim_trip_zones_pickup.location_id,-1) as pickup_location_id,
       coalesce(dim_trip_zones_dropoff.location_id,-1) as dropoff_location_id,
       green.passenger_count,
       green.trip_distance, 
       green.total_amount,
       green.trip_time_mn,
       coalesce(dim_trip_modes.trip_mode_id,-1) as trip_mode_id,
       green.trip_year,
       green.trip_month,
       green.etl_loaded_at

    from green_trips as green

    left join {{ ref('dim_trip_types') }} as dim_trip_types
        on green.trip_type = dim_trip_types.trip_type

    left join {{ ref('dim_rate_codes') }} as dim_rate_codes
        on green.rate_code = dim_rate_codes.rate_code

    left join {{ ref('dim_payment_types') }} as dim_payment_types
        on green.payment_type = dim_payment_types.payment_type

    left join {{ ref('dim_trip_zones') }} as dim_trip_zones_pickup
        on  green.pickup_borough = dim_trip_zones_pickup.borough
        and green.pickup_zone = dim_trip_zones_pickup.zone
        and green.pickup_service_zone = dim_trip_zones_pickup.service_zone

    left join {{ ref('dim_trip_zones') }} as dim_trip_zones_dropoff 
        on  green.dropoff_borough = dim_trip_zones_dropoff.borough
        and green.dropoff_zone = dim_trip_zones_dropoff.zone
        and green.dropoff_service_zone = dim_trip_zones_dropoff.service_zone 

    left join {{ ref('dim_trip_modes') }} as dim_trip_modes
        on green.trip_mode = dim_trip_modes.trip_mode
)

select * from green_trips_joined