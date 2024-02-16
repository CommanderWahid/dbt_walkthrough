with rate_codes as (
    
    select * from {{ ref('stg_mdm__rate_codes') }}
)

select * from rate_codes