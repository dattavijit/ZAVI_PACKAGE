@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption Model for Flights'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_FLIGHT_R
  as select from ZI_Flight_R
{
  key CarrierId,
  key ConnectionId,
  key FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      Price,
      CurrencyCode,
      PlaneTypeId,
      SeatsMax,
      SeatsOccupied,
      SeatsOccupied as OccupiedSeatsForChart
}
