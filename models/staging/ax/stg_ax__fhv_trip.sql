
with source as (

    select * from {{ source('ax', 'fhv_trip') }}

),

renamed as (

    select
        licensenumber as license_number,
        pickupdate as pickup_date,
        dropoffdate as dropoff_date,
        sr_flag,
        pickuplocationid as pickup_location_id,
        dropofflocationid as dropoff_location_id,
        triptimemn as trip_time_mn,
        tripmode as trip_mode,
        tripyear as trip_year,
        tripmonth as trip_month

    from source

)

select * from renamed

