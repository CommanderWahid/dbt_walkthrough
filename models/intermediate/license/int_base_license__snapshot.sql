with snapshot_licenses  as (
    
    select {{ dbt_utils.star(from=ref('licenses_snapshot'), except=['updated_at','dbt_updated_at']) }}
    from {{ ref('licenses_snapshot') }}
),

snapshot_licenses_modified as (

    select *, 
           dbt_valid_to is null as is_current_version,
           row_number() over (
                partition by base_license_number
                order by dbt_valid_from
           ) as version_num
    from snapshot_licenses
)

select * from snapshot_licenses_modified