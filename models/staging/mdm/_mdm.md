{% docs model_stg_mdm__rate_codes %}
Taxi trip rate codes data with basic cleaning and transformation applied, one row per rate code.
{% enddocs %}

{% docs column_stg_mdm__rate_codes__rate_code_id %}
The unique identifier for each rate code.
{% enddocs %}

{% docs model_stg_mdm__trip_modes %}
Taxi trip modes data with basic cleaning and transformation applied, one row per trip mode.
{% enddocs %}

{% docs column_stg_mdm__trip_modes__trip_mode_id %}
The unique identifier for each trip mode.
{% enddocs %}

{% docs model_stg_mdm__trip_types %}
Taxi trip types data with basic cleaning and transformation applied, one row per trip type.
{% enddocs %}

{% docs column_stg_mdm__trip_types__trip_type_id %}
The unique identifier for each trip type.
{% enddocs %}

{% docs model_stg_mdm__trip_zones %}
Taxi trip zones data with basic cleaning and transformation applied, one row per location (borough, servcie zone, zone).
{% enddocs %}

{% docs column_stg_mdm__trip_zones__location_id %}
The unique identifier for each location.
{% enddocs %}




{% docs source_rate_code %}
Contains information about the different rate codes used for taxi trips.
{% enddocs %}

{% docs source_trip_mode %}
Contains a list of unique identifiers and corresponding names for the different modes of transportation used during taxi trips.
{% enddocs %}

{% docs source_trip_type %}
Contains a list of unique trip types that are used to categorize taxi trips.
{% enddocs %}

{% docs source_trip_zone %}
Contains information on the different zones and service zones within each borough.
{% enddocs %}