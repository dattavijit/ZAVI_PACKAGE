@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface: Booking Suppliments'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_BOOKSUPPL_M
  as select from /dmo/booksuppl_m
  association        to parent ZI_BOOKING_M   as _Booking        on  $projection.TravelId  = _Booking.TravelId
                                                                 and $projection.BookingId = _Booking.BookingId

  association [1..1] to /DMO/I_Travel_M       as _Travel         on  $projection.TravelId = _Travel.travel_id
  association [1..1] to /DMO/I_Supplement     as _Product        on  $projection.SupplementId = _Product.SupplementID
  association [1..*] to /DMO/I_SupplementText as _SupplementText on  $projection.SupplementId = _SupplementText.SupplementID



{
  key travel_id             as TravelId,
  key booking_id            as BookingId,
  key booking_supplement_id as BookingSupplementId,
      supplement_id         as SupplementId,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      price                 as Price,
      currency_code         as CurrencyCode,
      last_changed_at       as LastChangedAt,
      _Booking,
      _Travel,
      _Product,
      _SupplementText
}
