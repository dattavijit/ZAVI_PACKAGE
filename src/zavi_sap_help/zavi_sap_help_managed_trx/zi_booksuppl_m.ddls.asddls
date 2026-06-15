@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface: Booking Suppliments'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_BOOKSUPPL_M
  as select from /dmo/booksuppl_m
  association        to parent ZI_BOOKING_M   as _Booking        on  $projection.travel_id  = _Booking.travel_id
                                                                 and $projection.booking_id = _Booking.booking_id

  association [1..1] to /DMO/I_Travel_M       as _Travel         on  $projection.travel_id = _Travel.travel_id
  association [1..1] to /DMO/I_Supplement     as _Product        on  $projection.supplement_id = _Product.SupplementID
  association [1..*] to /DMO/I_SupplementText as _SupplementText on  $projection.supplement_id = _SupplementText.SupplementID



{
  key travel_id  ,
  key booking_id             ,
  key booking_supplement_id ,
      supplement_id ,
      @Semantics.amount.currencyCode: 'Currency_Code'
      price,
      currency_code,
      last_changed_at,
      _Booking,
      _Travel,
      _Product,
      _SupplementText
}
