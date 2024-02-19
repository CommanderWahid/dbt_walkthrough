
with source as (

    select * from {{ source('web', 'green_trip') }}

),

renamed as (

    select
        vendorid as vendor_id,
        pickupdate as pickup_date,
        dropoffdate as dropoff_date,
        triptypeid as trip_type_id,
        ratecodeid as rate_code_id,
        paymenttypeid as payment_type_id,
        pickuplocationid as pickup_location_id,
        dropofflocationid as dropoff_location_id,
        passengercount as passenger_count,
        tripdistance as trip_distance, 
        totalamount as total_amount,
        triptimemn as trip_time_mn,
        tripmode as trip_mode,
        tripyear as trip_year,
        tripmonth as trip_month,
        etl_loaded_at,
        row_number() over(
            partition by vendorid,pickupdate,dropoffdate,triptypeid,ratecodeid,
                         paymenttypeid,pickuplocationid,dropofflocationid
            order by  pickupdate desc
        ) as row_num

    from source

)

select * 
from renamed
