@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Connection Consumption View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@Search.searchable: true
define view entity ZC_Connection_R
  as select from ZI_Connection_R
  association [1..*] to ZC_FLIGHT_R as _Flight on  $projection.AirlineID    = _Flight.CarrierId
                                               and $projection.ConnectionId = _Flight.ConnectionId
{
      @ObjectModel.text.association: '_Airline'
      @Consumption.valueHelpDefinition: [{ entity: {name: '/DMO/I_Carrier_StdVH', element: 'AirlineID' }}]
      @ObjectModel.text.element: ['AirlineName']
  key AirlineID,
  key ConnectionId,
      
      _Airline.Name                                                  as AirlineName,
      @ObjectModel.text.association: '_DepartureAirport'
      @Consumption.valueHelpDefinition: [{ entity: {name: '/DMO/I_Airport_StdVH', element: 'AirportID' }}]
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      DepartureAirport,
      
      @ObjectModel.text.association: '_DestinationAirport'
      @Consumption.valueHelpDefinition: [{ entity: {name: '/DMO/I_Airport_StdVH', element: 'AirportID' }}]
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      DestinationAirport,
      
      DepartureTime,
      
      ArrivalTime,
      
      @Semantics.quantity.unitOfMeasure: 'DistanceUnit'
      Distance,
      
      DistanceUnit,
      _Flight,
      _Airline,
      _DepartureAirport,
      _DestinationAirport
}
