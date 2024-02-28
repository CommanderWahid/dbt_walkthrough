with trip_modes as (
    
    select * from {{ ref('stg_mdm__trip_modes') }}
), 

trip_modes_descr as (

    select *
    from {{ ref('stg_seed__trip_modes') }}
)

select modes.trip_mode_id as trip_mode_id,
       modes.trip_mode as trip_mode,
       coalesce(modes_descr.trip_mode_descr) as trip_mode_descr
from trip_modes as modes 
left join trip_modes_descr as modes_descr
   on modes.trip_mode = modes_descr.trip_mode