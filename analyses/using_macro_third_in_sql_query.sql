select vendor_id,
       sum({{ cents_to_euros ('total_amount',2)}}) sum_tot_amount
from {{ ref('fct_yellow_trips') }}
group by vendor_id