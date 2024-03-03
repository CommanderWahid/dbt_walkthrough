{% macro first() %}

    {# jinja is a python based engine, it supports the usae of basic python objects (variable, list, dictionary) #}
    {# Jinja is a python language friendly #}


    {# get in jinja context #}
    {% set my_var = 'vive scop-it !'%}

    {# get out from jinja context #}
    {{my_var}}


    {% set my_list = ['a','ff','fg'] %}

    {{ my_list[0] }}
    {{ my_list[1] }}
    {{ my_list[2] }}

    {# iteratin over the list #}
    {% for item in my_list %}
        the current value is {{ item }}
    {% endfor%}


    {% set speed = 45 %}
    {% if speed > 40 %}
        yeeeeeeah you are flying ! 
    {% else %}
        move your ass body ! 
    {% endif %}


    {% set my_dict = 
    {
        "key_1":"val_1",
        "key_2":"val_2",
        "key_3":"val_3",
    }%}

    {{ my_dict['key_1']}}
    {{ my_dict['key_2']}}

{% endmacro %}