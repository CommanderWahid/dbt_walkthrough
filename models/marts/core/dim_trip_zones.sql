with trip_zones as (
    
    select * from {{ ref('stg_mdm__trip_zones') }}
)

select location_id,
       borough,
       zone,
       service_zone
from trip_zones