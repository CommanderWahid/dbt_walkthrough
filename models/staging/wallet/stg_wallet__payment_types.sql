with

source as (

    select * from {{ source('wallet','payment_type') }} order by PaymentTypeID

), 

modified as (

    select 

        cast(PaymentTypeID as bigint) as payment_type_id,
        PaymentDesc as payment_description

    from source
)

select * from modified