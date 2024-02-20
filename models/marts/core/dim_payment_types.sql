with payment_types as (
    
    select * from {{ ref('stg_wallet__payment_types') }}
)

select payment_type_id, 
       payment_description as payment_type
from payment_types