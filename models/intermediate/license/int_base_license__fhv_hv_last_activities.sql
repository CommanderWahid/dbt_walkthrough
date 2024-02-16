with fhv_hv_licenses as (

    select * from {{ ref('stg_ax__fhv_hv_trip')  }}
),

locations as (

    select * from {{ ref('stg_mdm__trip_zones')  }}
),

max_dates_by_licence as (

    select license_number, max(dropoff_date) as last_dropoff_date
    from fhv_hv_licenses
    group by license_number
), 

result as(

    select fhv.license_number,
           mx.last_dropoff_date,
           concat(locations.borough,' - ',locations.zone) as last_dropoff_location
    from fhv_hv_licenses fhv 
         inner join 
         max_dates_by_licence mx 
         on  fhv.license_number = mx.license_number and
             fhv.dropoff_date = mx.last_dropOff_date 
         inner join 
         locations
         on fhv.dropoff_location_id = locations.location_id
)

select * from result
