with trip_types as (
    
    select * from {{ ref('stg_mdm__trip_types') }}
)

select trip_type_id,
       trip_type
from trip_types