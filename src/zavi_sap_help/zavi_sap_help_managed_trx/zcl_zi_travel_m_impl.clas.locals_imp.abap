CLASS lhc_travel DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE travel.

ENDCLASS.

CLASS lhc_travel IMPLEMENTATION.

  METHOD earlynumbering_create.
    FIELD-SYMBOLS <entity> TYPE STRUCTURE FOR CREATE zi_travel_m.

    LOOP AT entities ASSIGNING <entity> WHERE travel_id IS NOT INITIAL.
      APPEND CORRESPONDING #( <entity> ) TO mapped-travel.
    ENDLOOP.

    DATA(entities_without_travelID) = entities.
    DELETE entities_without_travelid WHERE travel_id IS INITIAL.

    TRY.
        cl_numberrange_runtime=>number_get(
          EXPORTING
            nr_range_nr       = '01'
            object            = '/DMO/TRV_M'
            quantity          = CONV #( lines( entities_without_travelid ) )
          IMPORTING
            number            = DATA(number_range_key)
            returncode        = DATA(number_range_return_code)
            returned_quantity = DATA(number_range_returned_quantity)
        ).
      CATCH cx_number_ranges INTO DATA(lx_number_range).
        LOOP AT entities_without_travelid ASSIGNING FIELD-SYMBOL(<entity_without_travelID>) .
          APPEND VALUE #( %cid = <entity_without_travelID>-%cid
                          %key = <entity_without_travelid>-%key
                          %msg = lx_number_range  ) TO reported-travel.
          APPEND VALUE #( %cid = <entity_without_travelID>-%cid
                          %key = <entity_without_travelid>-%key ) TO failed-travel.
        ENDLOOP.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

