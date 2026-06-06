@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Airport Inerface View'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_Airport as select from /dmo/airport
{
    key airport_id as AirportId,
    @Semantics.text: true
    name as Name,
    city as City,
    country as Country
}
