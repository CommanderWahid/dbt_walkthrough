{% snapshot licenses_snapshot %}

    {{
        config(
          pre_hook=[ 
          "create schema if not exists snapshots",
          "create table if not exists snapshots.licenses_snapshot (id INT)",
          "alter table snapshots.licenses_snapshot set tblproperties ('delta.feature.allowColumnDefaults' = 'supported')" 
          ],
          target_schema='snapshots',
          strategy='timestamp',
          unique_key='base_license_number',
          updated_at='updated_at',
          invalidate_hard_deletes=True,
        )
    }}

    select * from {{  ref('stg_base__base_license') }}

{% endsnapshot %}