
with source as (

    select * from {{ source('base', 'base_license') }}

),

renamed as (

    select
        baselicensenumber as license_number,
        entityname as entity_name,
        telephonenumber as telephone_number,
        shlendorsed as shl_endorsed,
        basetype as base_type,
        addressbuilding as address_building,
        addressstreet as address_street,
        addresscity as address_city,
        addressstate as address_state,
        addresspostcode as address_post_code,
        geolocationlatitude as geolocation_latitude,
        geolocationlongitude as geolocation_longitude,
        geolocationlocation as geolocation_location,
        updated_at

    from source

)

select * from renamed

