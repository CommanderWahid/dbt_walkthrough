{{
   config(
    tblproperties={
            'delta.feature.allowColumnDefaults':'supported'
        }
   )
}}


with snapshot_licenses  as (
    
    select * from {{ ref('int_base_license__snapshot') }}
),

int_fhv_licenses as (

    select * from {{ ref('int_base_license__fhv_last_activities') }} 
),

int_fhv_hv_licenses as (

    select * from {{ ref('int_base_license__fhv_hv_last_activities') }} 
),

licenses as (

    select
        snp.license_id,  
        snp.license_number,
        snp.entity_name,
        snp.telephone_number,
        snp.shl_endorsed,
        snp.base_type,
        snp.address_building,
        snp.address_street,
        snp.address_city,
        snp.address_state,
        snp.address_post_code,
        snp.geolocation_latitude,
        snp.geolocation_longitude,
        snp.geolocation_location,
        int_fhv.last_dropoff_date         as fhv_last_dropoff_date,
        int_fhv.last_dropoff_location     as fhv_last_dropoff_location,
        int_fhv_hv.last_dropoff_date      as fhv_hv_last_dropoff_date,
        int_fhv_hv.last_dropoff_location  as fhv_hv_last_dropoff_location,
        snp.dbt_valid_from,
        snp.dbt_valid_to,
        snp.is_current_version,
        snp.version_num
    from snapshot_licenses snp 
         left join int_fhv_licenses int_fhv 
            on snp.license_number = int_fhv.license_number
            and snp.is_current_version 
         left join int_fhv_hv_licenses int_fhv_hv 
            on snp.license_number = int_fhv_hv.license_number
            and snp.is_current_version 
)

select * from licenses