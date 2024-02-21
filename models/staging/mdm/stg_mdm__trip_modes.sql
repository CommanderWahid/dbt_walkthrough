with

source as (

    select * from {{ source('mdm','trip_mode') }} order by TripModeID

),

modified as (

    select
        TripModeID as trip_mode_id,
        TripMode as trip_mode
    from source
)

select * from modified