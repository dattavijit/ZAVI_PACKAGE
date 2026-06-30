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
        cl_numberrange_runtime=>number_get( EXPORTING nr_range_nr       = '01'
                                                      object            = '/DMO/TRV_M'
                                                      quantity          = CONV #( lines( entities_without_travelid ) )
                                            IMPORTING number            = DATA(number_range_key)
                                                      returncode        = DATA(number_range_return_code)
                                            " TODO: variable is assigned b  ut never used (ABAP cleaner)
                                                      returned_quantity = DATA(number_range_returned_quantity) ).
      CATCH cx_number_ranges INTO DATA(lx_number_range).
        LOOP AT entities_without_travelid ASSIGNING FIELD-SYMBOL(<entity_without_travelID>).
          APPEND VALUE #( %cid = <entity_without_travelID>-%cid
                          %key = <entity_without_travelid>-%key
                          %msg = lx_number_range  ) TO reported-travel.
          APPEND VALUE #( %cid = <entity_without_travelID>-%cid
                          %key = <entity_without_travelid>-%key ) TO failed-travel.
        ENDLOOP.
        RETURN.
    ENDTRY.
    CASE number_range_return_code.
      WHEN '1'.
        LOOP AT entities_without_travelid ASSIGNING <entity_without_travelid>.
          APPEND VALUE #( %cid = <entity_without_travelid>-%cid
                          %key = <entity_without_travelid>-%key
                          %msg = NEW /dmo/cm_flight_messages( textid   = /dmo/cm_flight_messages=>number_range_depleted
                                                              severity = if_abap_behv_message=>severity-warning ) )
                 TO reported-travel.
          APPEND VALUE #( %cid = <entity_without_travelID>-%cid
                          %key = <entity_without_travelid>-%key ) TO failed-travel.
        ENDLOOP.
      WHEN '2' OR '3'.
        LOOP AT entities_without_travelid ASSIGNING <entity_without_travelid>.
          APPEND VALUE #( %cid = <entity_without_travelid>-%cid
                          %key = <entity_without_travelid>-%key
                          %msg = NEW /dmo/cm_flight_messages( textid   = /dmo/cm_flight_messages=>not_sufficient_numbers
                                                              severity = if_abap_behv_message=>severity-warning ) )
                 TO reported-travel.
          APPEND VALUE #( %cid        = <entity_without_travelid>-%cid
                          %key        = <entity_without_travelid>-%key
                          %fail-cause = if_abap_behv=>cause-conflict )
                 TO failed-travel.
        ENDLOOP.
        RETURN.
    ENDCASE.

    ASSERT number_range_returned_quantity = lines( entities_without_travelid ).
    DATA(travel_id_max) = CONV /dmo/travel_id( number_range_key - number_range_returned_quantity ).

    LOOP AT entities_without_travelid ASSIGNING <entity>.
      travel_id_max += 1.
      <entity>-travel_id = travel_id_max.

      APPEND VALUE #( %cid = <entity>-%cid
                      %key = <entity>-%key )
             TO mapped-travel.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
