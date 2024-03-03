{#

with payments as (
    select * from {{ ref('stg_web__yellow_trip') }}
),

agg as (

    select vendor_id,
           sum(case when payment_type = 'Credit card' then total_amount else 0 end) as credit_card_total_amount, 
           sum(case when payment_type = 'Cash' then total_amount else 0 end) as cash_total_amount, 
           sum(case when payment_type = 'No Charge' then total_amount else 0 end) as no_charge_total_amount, 
           sum(case when payment_type = 'Dispute' then total_amount else 0 end) as dispute_total_amount, 
           sum(case when payment_type = 'Voided trip' then total_amount else 0 end) as voided_trip_total_amount
    from payments
    group by vendor_id
)

select * from agg

#}


{%- set payment_methods = ['Credit card', 'Cash', 'No Charge', 'Dispute', 'Voided trip'] -%}

with payments as (
    select * from {{ ref('stg_web__yellow_trip') }}
),

agg as (

    select vendor_id,
           {% for payment in payment_methods -%}
           sum(case when payment_type = {{ payment }} then total_amount else 0 end) as {{payment.lower().replace(' ','_')}}_total_amount  
           {%- if not loop.last -%}
            ,
           {%- endif %} 
           {% endfor -%}
    from payments
    group by vendor_id
)

select * from agg