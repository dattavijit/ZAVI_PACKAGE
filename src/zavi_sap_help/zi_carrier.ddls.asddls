@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Carrier Interface View'
@Metadata.ignorePropagatedAnnotations: true

//make this view search enabled
@Search.searchable: true


define view entity ZI_CARRIER as select from /dmo/carrier
{
    key carrier_id as AirlineId,
    @Semantics.text: true
    @Search.defaultSearchElement: true
    @Search.fuzzinessThreshold: 0.8
    name as Name,
    currency_code as CurrencyCode,
    local_created_by as LocalCreatedBy,
    local_created_at as LocalCreatedAt,
    local_last_changed_by as LocalLastChangedBy,
    local_last_changed_at as LocalLastChangedAt,
    last_changed_at as LastChangedAt
}
