with fhv_licenses as (

    select * from {{ ref('stg_ax__fhv_trip')  }}
),

locations as (

    select * from {{ ref('stg_mdm__trip_zones')  }}
), 

fhv_licenses_row_num as (

    select license_number, 
           dropoff_date, 
           dropoff_location_id,
           row_number() over (
              partition by license_number
              order by dropoff_date desc
           ) as row_num
    from fhv_licenses
), 

result as(

    select recent_row.license_number,
           recent_row.dropoff_date as last_dropoff_date,
           concat(locations.borough,' - ',locations.zone) as last_dropoff_location
    from fhv_licenses_row_num recent_row 
         inner join locations
         on recent_row.dropoff_location_id = locations.location_id
    where recent_row.row_num = 1
)

select * from result
