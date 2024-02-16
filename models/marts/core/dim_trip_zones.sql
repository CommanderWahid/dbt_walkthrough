with trip_zones as (
    
    select * from {{ ref('stg_mdm__trip_zones') }}
)

select * from trip_zones