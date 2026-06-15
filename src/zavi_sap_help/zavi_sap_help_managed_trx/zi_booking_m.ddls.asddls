@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface : Booking'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_BOOKING_M
  as select from /dmo/booking_m
  association        to parent ZI_TRAVEL_M       as _Travel        on  $projection.travel_id = _Travel.travel_id
  composition [0..*] of ZI_BOOKSUPPL_M           as _BookingSupplement

  association [1..1] to /DMO/I_Customer          as _Customer      on  $projection.customer_id = _Customer.CustomerID
  association [1..1] to /DMO/I_Carrier           as _Carrier       on  $projection.carrier_id = _Carrier.AirlineID
  association [1..1] to /DMO/I_Connection        as _Connection    on  $projection.carrier_id    = _Connection.AirlineID
                                                                   and $projection.connection_id = _Connection.ConnectionID
  association [1..1] to /DMO/I_Booking_Status_VH as _BookingStatus on  $projection.booking_status = _BookingStatus.BookingStatus

{
  key travel_id,
  key booking_id,
      booking_date,
      customer_id,
      carrier_id,
      connection_id,
      flight_date,
      @Semantics.amount.currencyCode: 'Currency_Code'
      flight_price,
      currency_code,
      booking_status,
      last_changed_at,
      _Travel,
      _BookingSupplement,
      _Customer,
      _Carrier,
      _Connection,
      _BookingStatus
}
