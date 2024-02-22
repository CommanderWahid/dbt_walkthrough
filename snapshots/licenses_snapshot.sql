{% snapshot licenses_snapshot %}

    {{
        config(
          pre_hook="create schema if not exists snapshots",
          target_schema='snapshots',
          strategy='timestamp',
          unique_key='license_number',
          updated_at='updated_at',
          invalidate_hard_deletes=True,
          tblproperties={
              'delta.feature.allowColumnDefaults':'supported'
          }
        )
    }}

    select * from {{  ref('stg_base__base_license') }}

{% endsnapshot %}