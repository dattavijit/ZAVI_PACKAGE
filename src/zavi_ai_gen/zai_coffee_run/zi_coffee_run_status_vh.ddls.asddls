@EndUserText.label: 'Coffee Run Status Value Help'
@ObjectModel.resultSet.sizeCategory: #XS
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true
define view entity ZI_COFFEE_RUN_STATUS_VH
  as select from t000
{
  @Search.defaultSearchElement: true
  key cast( 'OPEN' as abap.char(20) ) as status,
  cast( 'Open' as abap.char(40) )     as status_text
}
where
  mandt = $session.client

union all
select from t000
{
  key cast( 'ORDERING' as abap.char(20) ) as status,
  cast( 'Ordering' as abap.char(40) )     as status_text
}
where
  mandt = $session.client

union all
select from t000
{
  key cast( 'DEPARTED' as abap.char(20) ) as status,
  cast( 'Departed' as abap.char(40) )     as status_text
}
where
  mandt = $session.client

union all
select from t000
{
  key cast( 'CLOSED' as abap.char(20) ) as status,
  cast( 'Closed' as abap.char(40) )     as status_text
}
where
  mandt = $session.client

union all
select from t000
{
  key cast( 'DELIVERED' as abap.char(20) ) as status,
  cast( 'Delivered' as abap.char(40) )     as status_text
}
where
  mandt = $session.client
