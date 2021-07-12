REPORT yr_wbs_tonumeral.

CLASS lcl_number DEFINITION.

  PUBLIC SECTION.
    DATA:
      mv_number type i.
    METHODS:
      constructor IMPORTING iv_number TYPE i,
      counter.
    CLASS-METHODS :
      factory IMPORTING iv_number        TYPE i
              RETURNING VALUE(ro_number) TYPE REF TO lcl_number.

  PROTECTED SECTION.

  PRIVATE SECTION.


ENDCLASS.

CLASS lcl_number IMPLEMENTATION.

  METHOD constructor.
    mv_number = iv_number.
  ENDMETHOD.

  METHOD factory.

  ENDMETHOD.

  method counter.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_number_thousands DEFINITION
                         INHERITING FROM lcl_number.
  PUBLIC SECTION.
methods counter REDEFINITION.

ENDCLASS.



CLASS lcx_roman_converter DEFINITION
    INHERITING FROM cx_static_check.

  PUBLIC SECTION.

ENDCLASS.

CLASS lcl_roman_converter DEFINITION.
  PUBLIC SECTION.
    DATA mv_number TYPE i.
    METHODS one IMPORTING iv_number       TYPE i
                RETURNING VALUE(rv_roman) TYPE string.

    METHODS validate IMPORTING iv_number TYPE i
                     RAISING   lcx_roman_converter.
    METHODS to_roman IMPORTING iv_number       TYPE i
                     RETURNING VALUE(rv_roman) TYPE string.
ENDCLASS.



CLASS lcl_roman_converter IMPLEMENTATION.

  METHOD validate.
    IF iv_number < 0 OR iv_number > 3999.
      RAISE EXCEPTION TYPE lcx_roman_converter.
    ENDIF.
  ENDMETHOD.

  METHOD one.
    TYPES : tyt_string TYPE STANDARD TABLE OF string WITH DEFAULT KEY.

    DATA(thousands) = VALUE tyt_string( ( |M| ) ( |MM| ) ( |MMM| ) ).

    DATA(numberofthousands) = iv_number / 1000.
    rv_roman = thousands[ numberofthousands ].

    cl_demo_output=>display( |{ iv_number } in roman is { rv_roman }| ).

*    DATA(thousands) = VALUE tyt_string(
*                ( `x1y1z1` )
*                ( `x2y2z2` )
*                ( `x3y3z3` ) ).

  ENDMETHOD.

  METHOD to_roman.
    TRY.
        validate( iv_number ).
      CATCH lcx_roman_converter.
        cl_demo_output=>write( 'Boudaries exceeded' ).
    ENDTRY.

    DATA(lo_number) = NEW lcl_number( iv_number ).

  ENDMETHOD.

ENDCLASS.


CLASS ltc_roman_converter DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA :
      mo_cut TYPE REF TO lcl_roman_converter.
    METHODS:
      setup,
      acceptance_test FOR TESTING,
      test1_3_iii FOR TESTING.
ENDCLASS.


CLASS ltc_roman_converter IMPLEMENTATION.

  METHOD setup.
    mo_cut = NEW #(  ).
  ENDMETHOD.

  METHOD acceptance_test.
    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  = mo_cut->to_roman( 3999 )
        exp                  = 'MMMCMXCIX' ).
  ENDMETHOD.

  METHOD test1_3_iii.
    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  = mo_cut->to_roman( 3 )
        exp                  = 'III' ).
  ENDMETHOD.

ENDCLASS.



CLASS application DEFINITION.
  PUBLIC SECTION.
    METHODS:
      main.
ENDCLASS.

CLASS application IMPLEMENTATION.

  METHOD main.
    NEW lcl_roman_converter(  )->to_roman( 3000 ).
  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.
  NEW application(  )->main(  ).
