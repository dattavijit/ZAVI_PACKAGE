@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Certificate MAnagement Projection View'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true
define root view entity ZC_Certificate
  provider contract transactional_query
  as projection on ZI_Certificate
{
  key     CertUUid,
  @Search.defaultSearchElement: true
          Product,
          Version,
            
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_CERTI_SERVICE'
  virtual ProductText : abap.char( 150 ),
          /* Associations */
          _CertificateState  // Make association public
}
