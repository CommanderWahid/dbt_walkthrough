
with source as (

    select * from {{ source('web', 'yellow_trips') }}

),

renamed as (

    select
        vendorid as vendor_id,
        pickupdate as pickup_date,
        dropoffdate as dropoff_date,
        TripType as trip_type,
        RateCodeDesc as rate_code,
        PaymentDesc as payment_type,
        PickupBorough as pickup_borough,
        PickupZone as pickup_zone,
        PickupServiceZone as pickup_service_zone,
        DropOffBorough as dropOff_borough,
        DropOffZone as dropOff_zone,
        DropOffServiceZone as dropOff_service_zone,
        passengercount as passenger_count,
        tripdistance as trip_distance, 
        totalamount as total_amount,
        triptimemn as trip_time_mn,
        tripmode as trip_mode,
        tripyear as trip_year,
        tripmonth as trip_month,
        etl_loaded_at,
        row_number() over(
            partition by vendorid,pickupdate,dropoffdate,TripType,RateCodeDesc,
                         PaymentDesc,PickupBorough,PickupZone,PickupServiceZone,
                         DropOffBorough,DropOffZone,DropOffServiceZone
            order by  pickupdate desc
        ) as row_num  

    from source

)

select * from renamed

