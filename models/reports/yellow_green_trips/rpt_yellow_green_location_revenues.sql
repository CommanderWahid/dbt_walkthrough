with details as (

    select * from {{ ref('rpt_yellow_green_trip_details') }} 
),

monthly_revenues as (

    select pickup_location,
           to_date(pickup_date, 'yyyy-MM-dd') as pickup_date,
           trip_mode,
           trip_type,
           rate_code,
           payment_type,
           sum(total_amount) as total_amount
    
    from details
    group by pickup_location,to_date(pickup_date, 'yyyy-MM-dd'),trip_mode,trip_type,rate_code,payment_type
)

select * from monthly_revenues