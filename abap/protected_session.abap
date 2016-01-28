  types:
    BEGIN OF ty_parameter,
        parameter_type type c LENGTH 1,
        parameter_line TYPE c LENGTH 100,
      END OF ty_parameter .
  types:
    ty_t_parameters TYPE TABLE OF ty_parameter .
  types:
    BEGIN OF ty_parse_parameter,
        field    TYPE c LENGTH 30,
        operator TYPE c LENGTH 4,
        value    TYPE c LENGTH 100,
        logic    TYPE c LENGTH 4,
      END OF ty_parse_parameter .
  types:
    ty_t_parse_parameter TYPE TABLE OF ty_parse_parameter WITH NON-UNIQUE DEFAULT KEY .
    
  data DDIC_TABLE type TABNAME .
  data PARAMETERS type TY_T_PARAMETERS .
  data METHOD type CHAR30 .