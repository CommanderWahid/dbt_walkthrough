with green as (

    select * from {{ ref('fct_green_trips') }} 
),

yellow as (

    select * from {{ ref('fct_yellow_trips') }}

),

green_yellow as (

    select * from green
    union all
    select * from yellow 
),

result as (

    select 
       fct_green_yellow.vendor_id,
       dim_trip_types.trip_type,
       dim_rate_codes.rate_code,
       dim_payment_types.payment_type,
       fct_green_yellow.pickup_date,
       concat(
            dim_pickup_zone.service_zone,': ',
            dim_pickup_zone.borough,' - ',
            dim_pickup_zone.zone
       ) as pickup_location,
       fct_green_yellow.dropoff_date,
       concat(
            dim_dropoff_zone.service_zone,': ',
            dim_dropoff_zone.borough,' - ',
            dim_dropoff_zone.zone
       ) as dropoff_location,
       fct_green_yellow.passenger_count,
       fct_green_yellow.trip_distance, 
       fct_green_yellow.total_amount,
       fct_green_yellow.trip_time_mn,
       dim_trip_modes.trip_mode

    from green_yellow  as fct_green_yellow

    left join {{ ref('dim_trip_types') }} as dim_trip_types
        on fct_green_yellow.trip_type_id = dim_trip_types.trip_type_id

    left join {{ ref('dim_rate_codes') }} as dim_rate_codes
        on fct_green_yellow.rate_code_id = dim_rate_codes.rate_code_id

    left join {{ ref('dim_payment_types') }} as dim_payment_types
        on fct_green_yellow.payment_type_id = dim_payment_types.payment_type_id
    
    left join {{ ref('dim_trip_zones') }} as dim_pickup_zone
       on fct_green_yellow.pickup_location_id = dim_pickup_zone.location_id
    
    left join {{ ref('dim_trip_zones') }} as dim_dropoff_zone
       on fct_green_yellow.dropoff_location_id = dim_dropoff_zone.location_id
    
    left join {{ ref('dim_trip_modes') }} as dim_trip_modes
       on fct_green_yellow.trip_mode_id = dim_trip_modes.trip_mode_id  
)

select * from result