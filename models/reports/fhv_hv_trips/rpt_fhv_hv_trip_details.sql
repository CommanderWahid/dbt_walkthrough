with fhv as (

    select * from {{ ref('fct_fhv_trips') }} 
),

hv as (

    select * from {{ ref('fct_hv_trips') }}

),

fhv_hv as (

    select * from fhv
    union all
    select * from hv 
),

result as (

    select 
       dim_licenses.license_number,
       dim_licenses.telephone_number as license_telephone_number,
       concat(
              dim_licenses.address_building,', ',dim_licenses.address_street,' ',
              dim_licenses.address_city,', ',dim_licenses.address_state
        ) as license_address,
       fct_fhv_hv.pickup_date,
       concat(
            dim_pickup_zone.service_zone,': ',
            dim_pickup_zone.borough,' - ',
            dim_pickup_zone.zone
       ) as pickup_location,
       fct_fhv_hv.dropoff_date,
       concat(
            dim_dropoff_zone.service_zone,': ',
            dim_dropoff_zone.borough,' - ',
            dim_dropoff_zone.zone
       ) as dropoff_location,
       fct_fhv_hv.sr_flag,
       fct_fhv_hv.trip_time_mn,
       dim_trip_modes.trip_mode

    from fhv_hv  as fct_fhv_hv
    
    left join {{ ref('dim_licenses') }} as dim_licenses 
       on fct_fhv_hv.license_id = dim_licenses.license_id
    
    left join {{ ref('dim_trip_zones') }} as dim_pickup_zone
       on fct_fhv_hv.pickup_location_id = dim_pickup_zone.location_id
    
    left join {{ ref('dim_trip_zones') }} as dim_dropoff_zone
       on fct_fhv_hv.dropoff_location_id = dim_dropoff_zone.location_id
    
    left join {{ ref('dim_trip_modes') }} as dim_trip_modes
       on fct_fhv_hv.trip_mode_id = dim_trip_modes.trip_mode_id  
)

select * from result