with

source as (

    select * from {{ source('mdm','trip_type') }} order by TripTypeID

),

modified as (

    select
        TripTypeID as trip_type_id,
        TripType as trip_type
    from source
)

select * from modified