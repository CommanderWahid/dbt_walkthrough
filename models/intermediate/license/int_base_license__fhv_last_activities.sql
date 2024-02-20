with fhv_licenses as (

    select * from {{ ref('stg_ax__fhv_trip')  }}
),

fhv_licenses_row_num as (

    select license_number, 
           dropoff_date,
           dropOff_borough,
           dropOff_zone,
           dropOff_service_zone,
           row_number() over (
              partition by license_number
              order by dropoff_date desc
           ) as row_num
    from fhv_licenses
), 

result as(

    select license_number,
           dropoff_date as last_dropoff_date,
           concat(dropOff_service_zone,': ', dropOff_borough,'-',dropOff_zone) as last_dropoff_location
    from fhv_licenses_row_num 
    where row_num = 1
)

select * from result
