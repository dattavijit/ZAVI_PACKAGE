@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Connection Interface View'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_Connection_R
  as select from /dmo/connection
  association [1..*] to ZI_Flight_R as _Flight  on  $projection.AirlineID    = _Flight.CarrierId
                                                and $projection.ConnectionId = _Flight.ConnectionId
  association [1]    to ZI_CARRIER  as _Airline on  $projection.AirlineID = _Airline.AirlineId
  association [1]    to ZI_Airport  as _DepartureAirport on  $projection.DepartureAirport = _DepartureAirport.AirportId
  association [1]    to ZI_Airport  as _DestinationAirport on $projection.DestinationAirport = _DestinationAirport.AirportId
{
      
  key carrier_id      as AirlineID,
  key connection_id   as ConnectionId,
      airport_from_id as DepartureAirport,
      airport_to_id   as DestinationAirport,
      departure_time  as DepartureTime,
      arrival_time    as ArrivalTime,
      distance        as Distance,
      distance_unit   as DistanceUnit,
      _Flight,
      _Airline, 
      _DepartureAirport, 
      _DestinationAirport
}
