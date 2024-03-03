{{ union_tables_by_prefix(

      database=target.catalog,
      schema=target.schema, 
      prefix='stg_web__'
        
      )
      
  }}