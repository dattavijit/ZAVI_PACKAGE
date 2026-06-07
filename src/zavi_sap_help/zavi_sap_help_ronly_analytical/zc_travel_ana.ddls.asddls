@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View Travel Analytical Table'
@OData.applySupportedForAggregation: #FULL
@Metadata.allowExtensions: true
define root view entity ZC_TRAVEL_ANA
  provider contract transactional_query
  as projection on ZI_TRAVEL_ANA
{
  key TravelUuid,
      TravelId,
      AgencyId,
      CustomerId,
      BeginDate,
      EndDate,
      
      @EndUserText.label: 'Booking Fee (#AVG)'
      @Aggregation.default: #AVG
      BookingFee,
      
      @Aggregation.default: #MIN
      MinBookingFee,
      
      @Aggregation.default: #MAX
      MaxBookingFee,
      
      @EndUserText.label: 'Different Currencies (#COUNT_DISTINCT)'
      @Aggregation.default: #COUNT_DISTINCT
      @Aggregation.referenceElement: ['CurrencyCode']
      differentCurrencies,

      @Aggregation.default: #SUM
      TotalPrice,
      CurrencyCode,
      Description,
      OverallStatus
}
