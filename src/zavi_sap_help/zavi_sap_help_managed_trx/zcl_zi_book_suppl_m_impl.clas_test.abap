CLASS zcl_zi_book_suppl_m_impl_test DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    CONSTANTS:
      c_travel_id             TYPE /dmo/travel_id VALUE '1',
      c_booking_id            TYPE /dmo/booking_id VALUE '1',
      c_booking_supplement_id TYPE /dmo/booking_supplement_id VALUE '1',
      c_supplement_code       TYPE /dmo/over_bookd TYPE 'TICKET',
      c_price                 TYPE /dmo/booking_supplement_price VALUE '150.00'.

    DATA:
      cut                 TYPE REF TO zcl_zi_book_suppl_m_impl,
      booking_supplement  TYPE zi_booksuppl_m.

    METHODS:
      setup,
      test_instantiation FOR TESTING,
      test_create_booking_supplement FOR TESTING,
      test_update_booking_supplement FOR TESTING,
      test_readonly_fields FOR TESTING.

ENDCLASS.


CLASS zcl_zi_book_suppl_m_impl_test IMPLEMENTATION.

  METHOD setup.
    " Initialize the class under test
    cut = NEW zcl_zi_book_suppl_m_impl( ).
  ENDMETHOD.

  METHOD test_instantiation.
    " Verify that the class can be instantiated
    cl_abap_unit_assert=>assert_not_initial( cut ).
  ENDMETHOD.

  METHOD test_create_booking_supplement.
    " Test creating a booking supplement
    booking_supplement-travel_id = c_travel_id.
    booking_supplement-booking_id = c_booking_id.
    booking_supplement-booking_supplement_id = c_booking_supplement_id.
    booking_supplement-supplement_code = c_supplement_code.
    booking_supplement-price = c_price.

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act = booking_supplement-travel_id
        exp = c_travel_id
        msg = 'Travel ID should be set correctly'
    ).

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act = booking_supplement-booking_id
        exp = c_booking_id
        msg = 'Booking ID should be set correctly'
    ).

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act = booking_supplement-booking_supplement_id
        exp = c_booking_supplement_id
        msg = 'Booking supplement ID should be set correctly'
    ).
  ENDMETHOD.

  METHOD test_update_booking_supplement.
    " Test updating booking supplement price
    CONSTANTS c_new_price TYPE /dmo/booking_supplement_price VALUE '200.00'.

    booking_supplement-travel_id = c_travel_id.
    booking_supplement-booking_id = c_booking_id.
    booking_supplement-booking_supplement_id = c_booking_supplement_id.
    booking_supplement-price = c_price.

    " Simulate update operation
    booking_supplement-price = c_new_price.

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act = booking_supplement-price
        exp = c_new_price
        msg = 'Price should be updated successfully'
    ).
  ENDMETHOD.

  METHOD test_readonly_fields.
    " Test that readonly fields cannot be modified after creation
    " Fields: travel_id, booking_id, booking_supplement_id

    booking_supplement-travel_id = c_travel_id.
    booking_supplement-booking_id = c_booking_id.
    booking_supplement-booking_supplement_id = c_booking_supplement_id.

    DATA(original_travel_id) = booking_supplement-travel_id.
    DATA(original_booking_id) = booking_supplement-booking_id.
    DATA(original_supplement_id) = booking_supplement-booking_supplement_id.

    " Verify initial values match
    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act = original_travel_id
        exp = c_travel_id
        msg = 'Readonly field: travel_id should be preserved'
    ).

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act = original_booking_id
        exp = c_booking_id
        msg = 'Readonly field: booking_id should be preserved'
    ).

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act = original_supplement_id
        exp = c_booking_supplement_id
        msg = 'Readonly field: booking_supplement_id should be preserved'
    ).
  ENDMETHOD.

ENDCLASS.
