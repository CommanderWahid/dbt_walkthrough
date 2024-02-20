
with source as (

    select * from {{ source('ax', 'fhv_hv_trips') }}

),

renamed as (

    select
        licensenumber as license_number,
        pickupdate as pickup_date,
        dropoffdate as dropoff_date,
        sr_flag,
        PickupBorough as pickup_borough,
        PickupZone as pickup_zone,
        PickupServiceZone as pickup_service_zone,
        DropOffBorough as dropOff_borough,
        DropOffZone as dropOff_zone,
        DropOffServiceZone as dropOff_service_zone,
        triptimemn as trip_time_mn,
        tripmode as trip_mode,
        tripyear as trip_year,
        tripmonth as trip_month,
        etl_loaded_at 

    from source

)

select * from renamed

