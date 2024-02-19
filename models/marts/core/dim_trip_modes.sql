with trip_modes as (
    
    select * from {{ ref('stg_mdm__trip_modes') }}
)

select trip_mode_id,
       trip_mode
from trip_modes