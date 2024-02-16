with stg_licenses  as (
    
    select {{ dbt_utils.star(from=ref('stg_base__base_license'), except=['updated_at']) }}
    from {{ ref('stg_base__base_license') }}
),

int_licenses as (

    select * from {{ ref('int_base_license__fhv_hv_last_activities') }} 
    union 
    select * from {{ ref('int_base_license__fhv_last_activities') }} 
),

licenses as (

    select stg.*, 
           inter.last_dropoff_date,
           inter.last_dropoff_location  
    from stg_licenses stg 
         left join
         int_licenses inter 
         on stg.license_number = inter.license_number
)

select * from licenses