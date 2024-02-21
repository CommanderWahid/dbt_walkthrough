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

with yellow_trips as (

    select *
    from {{ref('stg_web__yellow_trip')}}
    where row_num = 1
    {% if is_incremental() %}
        and etl_loaded_at > "{{ get_last_timestamp(this,'etl_loaded_at')}}"
    {% endif %}
),

yellow_trips_joined as (

    select 
       yellow.vendor_id,
       yellow.pickup_date,
       yellow.dropoff_date,
       coalesce(dim_trip_types.trip_type_id,-1) as trip_type_id,
       coalesce(dim_rate_codes.rate_code_id,-1) as rate_code_id,
       coalesce(dim_payment_types.payment_type_id,-1) as payment_type_id,
       coalesce(dim_trip_zones_pickup.location_id,-1) as pickup_location_id,
       coalesce(dim_trip_zones_dropoff.location_id,-1) as dropoff_location_id,
       yellow.passenger_count,
       yellow.trip_distance, 
       yellow.total_amount,
       yellow.trip_time_mn,
       coalesce(dim_trip_modes.trip_mode_id,-1) as trip_mode_id,
       yellow.trip_year,
       yellow.trip_month,
       yellow.etl_loaded_at

    from yellow_trips as yellow

    left join {{ ref('dim_trip_types') }} as dim_trip_types
        on yellow.trip_type = dim_trip_types.trip_type

    left join {{ ref('dim_rate_codes') }} as dim_rate_codes
        on yellow.rate_code = dim_rate_codes.rate_code

    left join {{ ref('dim_payment_types') }} as dim_payment_types
        on yellow.payment_type = dim_payment_types.payment_type

    left join {{ ref('dim_trip_zones') }} as dim_trip_zones_pickup
        on  yellow.pickup_borough = dim_trip_zones_pickup.borough
        and yellow.pickup_zone = dim_trip_zones_pickup.zone
        and yellow.pickup_service_zone = dim_trip_zones_pickup.service_zone

    left join {{ ref('dim_trip_zones') }} as dim_trip_zones_dropoff 
        on  yellow.dropoff_borough = dim_trip_zones_dropoff.borough
        and yellow.dropoff_zone = dim_trip_zones_dropoff.zone
        and yellow.dropoff_service_zone = dim_trip_zones_dropoff.service_zone 

    left join {{ ref('dim_trip_modes') }} as dim_trip_modes
        on yellow.trip_mode = dim_trip_modes.trip_mode
)

select * from yellow_trips_joined