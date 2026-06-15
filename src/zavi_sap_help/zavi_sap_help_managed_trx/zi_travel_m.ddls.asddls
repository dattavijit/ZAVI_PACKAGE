@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface: Travel'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_TRAVEL_M
  as select from /dmo/travel_m

  composition [0..*] of ZI_BOOKING_M             as _Booking
  association [0..1] to /DMO/I_Agency            as _Agency        on $projection.agency_id = _Agency.AgencyID
  association [0..1] to /DMO/I_Customer          as _Customer      on $projection.customer_id = _Customer.CustomerID
  association [0..1] to I_Currency               as _Currency      on $projection.currency_code = _Currency.Currency
  association [1..1] to /DMO/I_Overall_Status_VH as _OverallStatus on $projection.overall_status = _OverallStatus.OverallStatus


{
  key travel_id ,
      agency_id ,
      customer_id     ,
      begin_date      ,
      end_date        ,
      @Semantics.amount.currencyCode: 'Currency_Code'
      booking_fee     ,
      @Semantics.amount.currencyCode: 'Currency_Code'
      total_price     ,
      currency_code   ,
      description     ,
      overall_status  ,
      created_by      ,
      created_at      ,
      last_changed_by ,
      last_changed_at ,

      _Booking,
      _Agency,
      _Customer,
      _Currency,
      _OverallStatus
}
