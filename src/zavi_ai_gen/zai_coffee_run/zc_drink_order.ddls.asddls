@EndUserText.label: 'Drink Order Projection'

@UI.headerInfo: {
  typeName: 'Drink Order',
  typeNamePlural: 'Drink Orders',
  title: { type: #STANDARD, value: 'orderid' },
  description: { type: #STANDARD, value: 'colleague_name' }
}

define view entity ZC_DRINK_ORDER
  as projection on ZI_DRINK_ORDER
{
      @EndUserText.label: 'Order ID'
      @UI.lineItem: [{ position: 10, importance: #HIGH }]
  key orderid,

      @EndUserText.label: 'Run ID'
  key runid,

      @EndUserText.label: 'Colleague'
      @UI.lineItem: [{ position: 20, importance: #HIGH }]
      colleague_name,

      @EndUserText.label: 'Drink'
      @UI.lineItem: [{ position: 30, importance: #HIGH }]
      drink_type,

      @EndUserText.label: 'Size'
      @UI.lineItem: [{ position: 40, importance: #MEDIUM }]
      drink_size,

      @EndUserText.label: 'Milk'
      @UI.lineItem: [{ position: 50, importance: #MEDIUM }]
      milk_preference,

      @EndUserText.label: 'Special Instructions'
      @UI.lineItem: [{ position: 60, importance: #LOW }]
      special_instructions,

      @EndUserText.label: 'Paid'
      @UI.lineItem: [{ position: 70, importance: #HIGH }]
      has_paid,

      @EndUserText.label: 'Created On'
      created_at,

      @EndUserText.label: 'Created By'
      created_by,

      @EndUserText.label: 'Changed On'
      changed_at,

      @EndUserText.label: 'Changed By'
      changed_by,

      _Run : redirected to parent ZC_COFFEE_RUN
}
