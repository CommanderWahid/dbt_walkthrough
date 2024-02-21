with

source as (

    select * from {{ source('mdm','rate_code') }} order by RateCodeID

), 

modified as (

    select 

        cast(RateCodeID as bigint) as rate_code_id,
        RateCodeDesc as rate_code_description

    from source
)

select * from modified