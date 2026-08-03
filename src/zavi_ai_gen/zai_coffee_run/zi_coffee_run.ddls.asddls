@EndUserText.label: 'Coffee Run Root Entity'
define root view entity ZI_COFFEE_RUN
  as select from zavi_coffee_run
  composition [0..*] of ZI_DRINK_ORDER as _Orders
{
      @EndUserText.label: 'Run ID'
  key runid,

      @EndUserText.label: 'Runner'
      runner_name,

      @EndUserText.label: 'Cafe'
      cafe_name,

      @EndUserText.label: 'Departure Time'
      departure_time,

      @EndUserText.label: 'Order Cut-Off'
      order_cutoff_time,

      @EndUserText.label: 'Status'
      status,

      @EndUserText.label: 'Created On'
      created_at,

      @EndUserText.label: 'Created By'
      created_by,

      @EndUserText.label: 'Changed On'
      changed_at,

      @EndUserText.label: 'Changed By'
      changed_by,

      _Orders
}
