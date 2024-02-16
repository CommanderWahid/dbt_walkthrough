with trip_modes as (
    
    select * from {{ ref('stg_mdm__trip_modes') }}
)

select * from trip_modes