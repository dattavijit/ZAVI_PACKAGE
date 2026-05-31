@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Certificate Interface View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_Certificate
  as select from zbca_certificate
  composition [0..*] of ZI_CertificateState as _CertificateState
{
  key cert_uuid             as CertUUid,
      matnr                 as Product,
      version               as Version,
      cert_status           as CertificationStatus,
      cert_ce               as CertificateCe,
      cert_gs               as CertificateGs,
      cert_tuev             as CertificateTuev,
      @Semantics.largeObject:{
      mimeType: 'MimetypeCe', 
      fileName: 'FilenameCe', 
      acceptableMimeTypes: [ 'image/png',
                              'image/jpg', 
                              'application/pdf' ], 
      contentDispositionPreference:#INLINE }      
      attachment_ce         as AttachmentCe,
      mimetype_ce           as MimetypeCe,
      filename_ce           as FilenameCe,
      @Semantics.largeObject:{
      mimeType: 'MimetypeGs', 
      fileName: 'FilenameGs', 
      acceptableMimeTypes: [ 'image/png',
                              'image/jpg', 
                              'application/pdf' ], 
      contentDispositionPreference:#INLINE }         
      attachment_gs         as AttachmentGs,
      mimetype_gs           as MimetypeGs,
      filename_gs           as FilenameGs,
            @Semantics.largeObject:{
      mimeType: 'MimetypeTuev', 
      fileName: 'FilenameTuev', 
      acceptableMimeTypes: [ 'image/png',
                              'image/jpg', 
                              'application/pdf' ], 
      contentDispositionPreference:#INLINE }   
      attachment_tuev       as AttachmentTuev,
      mimetype_tuev         as MimetypeTuev,
      filename_tuev         as FilenameTuev,
      // Optimistic Locking
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt, 
      _CertificateState
      
}
