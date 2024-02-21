with details as (

    select * from {{ ref('rpt_yellow_green_trip_details') }} 
),

monthly_revenues as (

    select year(pickup_date) as pickup_year,
           month(pickup_date) as pickup_month,
           trip_mode,
           trip_type,
           rate_code,
           payment_type,
           sum(total_amount) as total_amount
    
    from details
    group by year(pickup_date),month(pickup_date),trip_mode,trip_type,rate_code,payment_type
)

select * from monthly_revenues