with

source as (

    select * from {{ source('mdm','trip_zone') }} order by LocationID

),

modified as (

    select
        cast(LocationID as bigint) as location_id,
        Borough as borough,
        Zone as zone,
        ServiceZone as service_zone
    from source
)

select * from modified