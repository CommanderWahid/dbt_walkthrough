with rate_codes as (
    
    select * from {{ ref('stg_mdm__rate_codes') }}
)

select rate_code_id, 
       rate_code_description as rate_code
from rate_codes