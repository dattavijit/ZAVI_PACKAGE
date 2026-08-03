@EndUserText.label: 'Drink Order Child Entity'
define view entity ZI_DRINK_ORDER
  as select from zavi_drink_order
  association to parent ZI_COFFEE_RUN as _Run
    on $projection.runid = _Run.runid
{
      @EndUserText.label: 'Order ID'
  key orderid,

      @EndUserText.label: 'Run ID'
  key runid,

      @EndUserText.label: 'Colleague'
      colleague_name,

      @EndUserText.label: 'Drink'
      drink_type,

      @EndUserText.label: 'Size'
      drink_size,

      @EndUserText.label: 'Milk'
      milk_preference,

      @EndUserText.label: 'Special Instructions'
      special_instructions,

      @EndUserText.label: 'Paid'
      has_paid,

      @EndUserText.label: 'Created On'
      created_at,

      @EndUserText.label: 'Created By'
      created_by,

      @EndUserText.label: 'Changed On'
      changed_at,

      @EndUserText.label: 'Changed By'
      changed_by,

      _Run
}
