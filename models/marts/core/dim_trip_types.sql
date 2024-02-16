with trip_types as (
    
    select * from {{ ref('stg_mdm__trip_types') }}
)

select * from trip_types