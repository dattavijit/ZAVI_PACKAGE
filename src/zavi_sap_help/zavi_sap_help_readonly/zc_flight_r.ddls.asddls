@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption Model for Flights' 
@Metadata.allowExtensions: true
define view entity ZC_FLIGHT_R
  as select from ZI_Flight_R
{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      @ObjectModel.text.element: ['AirlineName']
  key CarrierId,
  key ConnectionId,
  key FlightDate,
      _Airline.Name as AirlineName,

      @Semantics.amount.currencyCode: 'CurrencyCode'
      Price,
      CurrencyCode,
      PlaneTypeId,
      SeatsMax,
      SeatsOccupied,
      SeatsOccupied as OccupiedSeatsForChart
}
