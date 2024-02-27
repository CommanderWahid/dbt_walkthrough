with snapshot_licenses  as (
    
    select {{ dbt_utils.star(from=ref('licenses_snapshot'), except=['updated_at','dbt_updated_at']) }}
    from {{ ref('licenses_snapshot') }}
),

snapshot_licenses_modified as (

    select 
        dbt_scd_id as license_id,
        base_license_number as license_number,
        entity_name,
        telephone_number,
        shl_endorsed,
        base_type,
        address_building,
        address_street,
        address_city,
        address_state,
        address_post_code,
        geolocation_latitude,
        geolocation_longitude,
        geolocation_location,
        dbt_valid_from,
        dbt_valid_to, 
        dbt_valid_to is null as is_current_version,
        row_number() over (
            partition by base_license_number
            order by dbt_valid_from
        ) as version_num
    from snapshot_licenses
)

select * from snapshot_licenses_modified