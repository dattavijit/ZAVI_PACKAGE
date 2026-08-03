@EndUserText.label: 'Coffee Run Projection'
@UI.headerInfo: { typeName: 'Coffee Run', typeNamePlural: 'Coffee Runs', title: { type: #STANDARD, value: 'runid' }, description: { type: #STANDARD, value: 'runner_name' } }
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZC_COFFEE_RUN
  provider contract transactional_query
  as projection on ZI_COFFEE_RUN
{
      @EndUserText.label: 'Run ID'
      @UI.facet: [{ id: 'RunDetails', type: #FIELDGROUP_REFERENCE, targetQualifier: 'RunDetails', label: 'Run Details', position: 10 }, { id: 'DrinkOrders', type: #LINEITEM_REFERENCE, label: 'Drink Orders', position: 20, targetElement: '_Orders' }]
      @UI.lineItem: [{ position: 10, importance: #HIGH }]
      @UI.selectionField: [{ position: 10 }]
  key runid,

      @EndUserText.label: 'Runner'
      @UI.lineItem: [{ position: 20, importance: #HIGH }]
      @UI.selectionField: [{ position: 20 }]
      @UI.fieldGroup: [{ qualifier: 'RunDetails', position: 10 }]
      runner_name,

      @EndUserText.label: 'Cafe'
      @UI.lineItem: [{ position: 30, importance: #HIGH }]
      @UI.selectionField: [{ position: 30 }]
      @UI.fieldGroup: [{ qualifier: 'RunDetails', position: 20 }]
      cafe_name,

      @EndUserText.label: 'Order Cut-Off'
      @UI.lineItem: [{ position: 40, importance: #MEDIUM }]
      @UI.fieldGroup: [{ qualifier: 'RunDetails', position: 30 }]
      order_cutoff_time,

      @EndUserText.label: 'Departure Time'
      @UI.lineItem: [{ position: 50, importance: #MEDIUM }]
      @UI.fieldGroup: [{ qualifier: 'RunDetails', position: 40 }]
      departure_time,

      @EndUserText.label: 'Status'
      @UI.lineItem: [{ position: 60, importance: #HIGH }]
      @UI.selectionField: [{ position: 40 }]
      @UI.fieldGroup: [{ qualifier: 'RunDetails', position: 50 }]
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_COFFEE_RUN_STATUS_VH', element: 'status' } }]
      status,

      @EndUserText.label: 'Created On'
      created_at,

      @EndUserText.label: 'Created By'
      created_by,

      @EndUserText.label: 'Changed On'
      changed_at,

      @EndUserText.label: 'Changed By'
      changed_by,

      _Orders : redirected to composition child ZC_DRINK_ORDER
}
