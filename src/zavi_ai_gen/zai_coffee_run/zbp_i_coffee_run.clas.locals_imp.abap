*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS lhc_CoffeeRun DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    CONSTANTS:
      BEGIN OF status,
        open      TYPE zavi_coffee_run-status VALUE 'OPEN',
        accepting TYPE zavi_coffee_run-status VALUE 'ACCEPTING',
        ordering  TYPE zavi_coffee_run-status VALUE 'ORDERING',
        departed  TYPE zavi_coffee_run-status VALUE 'DEPARTED',
        closed    TYPE zavi_coffee_run-status VALUE 'CLOSED',
        delivered TYPE zavi_coffee_run-status VALUE 'DELIVERED',
      END OF status.

    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE CoffeeRun.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR CoffeeRun RESULT result.

    METHODS setInitialStatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR CoffeeRun~setInitialStatus.

    METHODS setCreateAdminFields FOR DETERMINE ON SAVE
      IMPORTING keys FOR CoffeeRun~setCreateAdminFields.

    METHODS setChangeAdminFields FOR DETERMINE ON SAVE
      IMPORTING keys FOR CoffeeRun~setChangeAdminFields.

    METHODS validateRunner FOR VALIDATE ON SAVE
      IMPORTING keys FOR CoffeeRun~validateRunner.

    METHODS validateCafe FOR VALIDATE ON SAVE
      IMPORTING keys FOR CoffeeRun~validateCafe.

    METHODS validateTimes FOR VALIDATE ON SAVE
      IMPORTING keys FOR CoffeeRun~validateTimes.

    METHODS validateStatus FOR VALIDATE ON SAVE
      IMPORTING keys FOR CoffeeRun~validateStatus.

    METHODS CloseRun FOR MODIFY
      IMPORTING keys FOR ACTION CoffeeRun~CloseRun RESULT result.

    METHODS earlynumbering_cba__orders FOR NUMBERING
          IMPORTING entities FOR CREATE CoffeeRun\_Orders.

ENDCLASS.


CLASS lhc_CoffeeRun IMPLEMENTATION.

**********************************************************************
* Early numbering: derive the next free RunID
**********************************************************************
  METHOD earlynumbering_create.

    CONSTANTS id_prefix TYPE string VALUE 'RUN'.

    DATA next_no TYPE i.
    DATA this_no TYPE i.
    DATA suffix3 TYPE n LENGTH 3.
    DATA suffix7 TYPE n LENGTH 7.

    " instances that already carry a key are simply passed through
    LOOP AT entities INTO DATA(entity_with_key) WHERE runid IS NOT INITIAL.
      APPEND CORRESPONDING #( entity_with_key ) TO mapped-coffeerun.
    ENDLOOP.

    DATA(entities_wo_key) = entities.
    DELETE entities_wo_key WHERE runid IS NOT INITIAL.
    CHECK entities_wo_key IS NOT INITIAL.

    " RunIDs follow the pattern RUN<number>, so the numeric part has to be
    " isolated before it can be compared - a plain numeric conversion of the
    " whole key would raise CX_SY_CONVERSION_NO_NUMBER.
    SELECT runid FROM zavi_coffee_run INTO TABLE @DATA(used_ids).
    SELECT runid FROM zavi_coffrun_d  APPENDING TABLE @used_ids.

    LOOP AT used_ids INTO DATA(used_id).

      DATA(id_text) = CONV string( used_id-runid ).

      IF strlen( id_text ) <= strlen( id_prefix ).
        CONTINUE.
      ENDIF.

      DATA(number_part) = substring( val = id_text off = strlen( id_prefix ) ).

      " skip anything that is not a pure number behind the prefix
      IF number_part CN '0123456789'.
        CONTINUE.
      ENDIF.

      this_no = number_part.
      IF this_no > next_no.
        next_no = this_no.
      ENDIF.

    ENDLOOP.

    LOOP AT entities_wo_key INTO DATA(entity).

      next_no += 1.
      APPEND CORRESPONDING #( entity ) TO mapped-coffeerun ASSIGNING FIELD-SYMBOL(<mapped>).

      IF next_no <= 999.
        suffix3 = next_no.
        <mapped>-runid = |{ id_prefix }{ suffix3 }|.
      ELSE.
        suffix7 = next_no.
        <mapped>-runid = |{ id_prefix }{ suffix7 }|.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

**********************************************************************
* Dynamic feature control: CloseRun only while the run is still live
**********************************************************************
  METHOD get_instance_features.

    READ ENTITIES OF zi_coffee_run IN LOCAL MODE
      ENTITY CoffeeRun
        FIELDS ( status )
        WITH CORRESPONDING #( keys )
      RESULT DATA(runs)
      FAILED failed.

    result = VALUE #( FOR run IN runs
                      ( %tky             = run-%tky
                        %action-CloseRun = COND #( WHEN run-status = status-closed
                                                     OR run-status = status-delivered
                                                   THEN if_abap_behv=>fc-o-disabled
                                                   ELSE if_abap_behv=>fc-o-enabled ) ) ).

  ENDMETHOD.

**********************************************************************
* Determination: default the status of a new run to OPEN
**********************************************************************
  METHOD setInitialStatus.

    READ ENTITIES OF zi_coffee_run IN LOCAL MODE
      ENTITY CoffeeRun
        FIELDS ( status )
        WITH CORRESPONDING #( keys )
      RESULT DATA(runs).

    DELETE runs WHERE status IS NOT INITIAL.
    CHECK runs IS NOT INITIAL.

    MODIFY ENTITIES OF zi_coffee_run IN LOCAL MODE
      ENTITY CoffeeRun
        UPDATE FIELDS ( status )
        WITH VALUE #( FOR run IN runs
                      ( %tky   = run-%tky
                        status = status-open ) ).

  ENDMETHOD.

**********************************************************************
* Determination: created_at / created_by
**********************************************************************
  METHOD setCreateAdminFields.

    GET TIME STAMP FIELD DATA(now).

    MODIFY ENTITIES OF zi_coffee_run IN LOCAL MODE
      ENTITY CoffeeRun
        UPDATE FIELDS ( created_at created_by )
        WITH VALUE #( FOR key IN keys
                      ( %tky       = key-%tky
                        created_at = now
                        created_by = sy-uname ) ).

  ENDMETHOD.

**********************************************************************
* Determination: changed_at / changed_by (also serves as ETag)
**********************************************************************
  METHOD setChangeAdminFields.

    GET TIME STAMP FIELD DATA(now).

    MODIFY ENTITIES OF zi_coffee_run IN LOCAL MODE
      ENTITY CoffeeRun
        UPDATE FIELDS ( changed_at changed_by )
        WITH VALUE #( FOR key IN keys
                      ( %tky       = key-%tky
                        changed_at = now
                        changed_by = sy-uname ) ).

  ENDMETHOD.

**********************************************************************
* Validation: a run needs a runner
**********************************************************************
  METHOD validateRunner.

    READ ENTITIES OF zi_coffee_run IN LOCAL MODE
      ENTITY CoffeeRun
        FIELDS ( runner_name )
        WITH CORRESPONDING #( keys )
      RESULT DATA(runs).

    LOOP AT runs INTO DATA(run).

      APPEND VALUE #( %tky        = run-%tky
                      %state_area = 'VALIDATE_RUNNER' ) TO reported-coffeerun.

      IF run-runner_name IS INITIAL.
        APPEND VALUE #( %tky = run-%tky ) TO failed-coffeerun.
        APPEND VALUE #( %tky                 = run-%tky
                        %state_area          = 'VALIDATE_RUNNER'
                        %element-runner_name = if_abap_behv=>mk-on
                        %msg                 = new_message_with_text(
                                                 severity = if_abap_behv_message=>severity-error
                                                 text     = 'Please enter the name of the runner' ) )
               TO reported-coffeerun.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

**********************************************************************
* Validation: a run needs a cafe
**********************************************************************
  METHOD validateCafe.

    READ ENTITIES OF zi_coffee_run IN LOCAL MODE
      ENTITY CoffeeRun
        FIELDS ( cafe_name )
        WITH CORRESPONDING #( keys )
      RESULT DATA(runs).

    LOOP AT runs INTO DATA(run).

      APPEND VALUE #( %tky        = run-%tky
                      %state_area = 'VALIDATE_CAFE' ) TO reported-coffeerun.

      IF run-cafe_name IS INITIAL.
        APPEND VALUE #( %tky = run-%tky ) TO failed-coffeerun.
        APPEND VALUE #( %tky               = run-%tky
                        %state_area        = 'VALIDATE_CAFE'
                        %element-cafe_name = if_abap_behv=>mk-on
                        %msg               = new_message_with_text(
                                               severity = if_abap_behv_message=>severity-error
                                               text     = 'Please enter the cafe the run goes to' ) )
               TO reported-coffeerun.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

**********************************************************************
* Validation: order cut-off must not be after departure
**********************************************************************
  METHOD validateTimes.

    READ ENTITIES OF zi_coffee_run IN LOCAL MODE
      ENTITY CoffeeRun
        FIELDS ( departure_time order_cutoff_time )
        WITH CORRESPONDING #( keys )
      RESULT DATA(runs).

    LOOP AT runs INTO DATA(run).

      APPEND VALUE #( %tky        = run-%tky
                      %state_area = 'VALIDATE_TIMES' ) TO reported-coffeerun.

      IF run-departure_time IS INITIAL.
        APPEND VALUE #( %tky = run-%tky ) TO failed-coffeerun.
        APPEND VALUE #( %tky                    = run-%tky
                        %state_area             = 'VALIDATE_TIMES'
                        %element-departure_time = if_abap_behv=>mk-on
                        %msg                    = new_message_with_text(
                                                    severity = if_abap_behv_message=>severity-error
                                                    text     = 'Please enter a departure time' ) )
               TO reported-coffeerun.
        CONTINUE.
      ENDIF.

      IF run-order_cutoff_time IS INITIAL.
        APPEND VALUE #( %tky = run-%tky ) TO failed-coffeerun.
        APPEND VALUE #( %tky                       = run-%tky
                        %state_area                = 'VALIDATE_TIMES'
                        %element-order_cutoff_time = if_abap_behv=>mk-on
                        %msg                       = new_message_with_text(
                                                       severity = if_abap_behv_message=>severity-error
                                                       text     = 'Please enter an order cut-off time' ) )
               TO reported-coffeerun.
        CONTINUE.
      ENDIF.

      IF run-order_cutoff_time > run-departure_time.
        APPEND VALUE #( %tky = run-%tky ) TO failed-coffeerun.
        APPEND VALUE #( %tky                       = run-%tky
                        %state_area                = 'VALIDATE_TIMES'
                        %element-order_cutoff_time = if_abap_behv=>mk-on
                        %element-departure_time    = if_abap_behv=>mk-on
                        %msg                       = new_message_with_text(
                                                       severity = if_abap_behv_message=>severity-error
                                                       text     = 'The order cut-off must not be after the departure time' ) )
               TO reported-coffeerun.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

**********************************************************************
* Validation: status must be one of the supported values
**********************************************************************
  METHOD validateStatus.

    READ ENTITIES OF zi_coffee_run IN LOCAL MODE
      ENTITY CoffeeRun
        FIELDS ( status )
        WITH CORRESPONDING #( keys )
      RESULT DATA(runs).

    LOOP AT runs INTO DATA(run).

      APPEND VALUE #( %tky        = run-%tky
                      %state_area = 'VALIDATE_STATUS' ) TO reported-coffeerun.

      IF run-status IS NOT INITIAL
         AND run-status <> status-open
         AND run-status <> status-accepting
         AND run-status <> status-ordering
         AND run-status <> status-departed
         AND run-status <> status-closed
         AND run-status <> status-delivered.

        APPEND VALUE #( %tky = run-%tky ) TO failed-coffeerun.
        APPEND VALUE #( %tky            = run-%tky
                        %state_area     = 'VALIDATE_STATUS'
                        %element-status = if_abap_behv=>mk-on
                        %msg            = new_message_with_text(
                                            severity = if_abap_behv_message=>severity-error
                                            text     = |Status { run-status } is not a valid coffee run status| ) )
               TO reported-coffeerun.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

**********************************************************************
* Action: close the run so that no further orders are accepted
**********************************************************************
  METHOD CloseRun.

    READ ENTITIES OF zi_coffee_run IN LOCAL MODE
      ENTITY CoffeeRun
        FIELDS ( status )
        WITH CORRESPONDING #( keys )
      RESULT DATA(runs)
      FAILED failed.

    LOOP AT runs INTO DATA(run).

      IF run-status = status-closed OR run-status = status-delivered.
        APPEND VALUE #( %tky = run-%tky ) TO failed-coffeerun.
        APPEND VALUE #( %tky = run-%tky
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-error
                                 text     = 'This coffee run is already closed' ) )
               TO reported-coffeerun.
        CONTINUE.
      ENDIF.

      MODIFY ENTITIES OF zi_coffee_run IN LOCAL MODE
        ENTITY CoffeeRun
          UPDATE FIELDS ( status )
          WITH VALUE #( ( %tky   = run-%tky
                          status = status-closed ) ).

    ENDLOOP.

    READ ENTITIES OF zi_coffee_run IN LOCAL MODE
      ENTITY CoffeeRun
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(closed_runs).

    result = VALUE #( FOR closed_run IN closed_runs
                      ( %tky   = closed_run-%tky
                        %param = closed_run ) ).

  ENDMETHOD.

  METHOD earlynumbering_cba__orders.

    CONSTANTS id_prefix TYPE string VALUE 'ORD'.

    DATA next_no TYPE i.
    DATA this_no TYPE i.
    DATA suffix3 TYPE n LENGTH 3.
    DATA suffix7 TYPE n LENGTH 7.
    DATA new_id  TYPE zavi_drink_order-orderid.

    " OrderIDs follow the pattern ORD<number>, so the numeric part has to be
    " isolated before it can be compared - a plain numeric conversion of the
    " whole key would raise CX_SY_CONVERSION_NO_NUMBER.
    SELECT orderid FROM zavi_drink_order INTO TABLE @DATA(used_ids).
    SELECT orderid FROM zavi_drinkord_d  APPENDING TABLE @used_ids.

    LOOP AT used_ids INTO DATA(used_id).

      DATA(id_text) = CONV string( used_id-orderid ).

      IF strlen( id_text ) <= strlen( id_prefix ).
        CONTINUE.
      ENDIF.

      DATA(number_part) = substring( val = id_text off = strlen( id_prefix ) ).

      " skip anything that is not a pure number behind the prefix
      IF number_part CN '0123456789'.
        CONTINUE.
      ENDIF.

      this_no = number_part.
      IF this_no > next_no.
        next_no = this_no.
      ENDIF.

    ENDLOOP.

    LOOP AT entities INTO DATA(entity).
      LOOP AT entity-%target INTO DATA(order).

        " instances that already carry a key are simply passed through
        IF order-orderid IS NOT INITIAL.
          INSERT VALUE #( %cid      = order-%cid
                          %is_draft = order-%is_draft
                          runid     = entity-runid
                          orderid   = order-orderid )
                 INTO TABLE mapped-drinkorder.
          CONTINUE.
        ENDIF.

        next_no += 1.

        IF next_no <= 999.
          suffix3 = next_no.
          new_id  = |{ id_prefix }{ suffix3 }|.
        ELSE.
          suffix7 = next_no.
          new_id  = |{ id_prefix }{ suffix7 }|.
        ENDIF.

        INSERT VALUE #( %cid      = order-%cid
                        %is_draft = order-%is_draft
                        runid     = entity-runid
                        orderid   = new_id )
               INTO TABLE mapped-drinkorder.

      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
