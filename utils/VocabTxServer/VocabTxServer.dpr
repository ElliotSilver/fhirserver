program VocabTxServer;

uses
  FastMM4 in '..\..\Libraries\FMM\FastMM4.pas',
  System.StartUpCopy,
  FMX.Forms,
  TxServerFormUnit in 'TxServerFormUnit.pas' {TxServerForm},
  OSXUIUtils in '..\..\Libraries\ui\OSXUIUtils.pas',
  FileSupport in '..\..\reference-platform\support\FileSupport.pas',
  OSXUtils in '..\..\reference-platform\support\OSXUtils.pas',
  StringSupport in '..\..\reference-platform\support\StringSupport.pas',
  MathSupport in '..\..\reference-platform\support\MathSupport.pas',
  MemorySupport in '..\..\reference-platform\support\MemorySupport.pas',
  DateSupport in '..\..\reference-platform\support\DateSupport.pas',
  GUIDSupport in '..\..\reference-platform\support\GUIDSupport.pas',
  DecimalSupport in '..\..\reference-platform\support\DecimalSupport.pas',
  EncodeSupport in '..\..\reference-platform\support\EncodeSupport.pas',
  SystemSupport in '..\..\reference-platform\support\SystemSupport.pas',
  kCritSct in '..\..\reference-platform\support\kCritSct.pas',
  ServerUtilities in '..\..\Server\ServerUtilities.pas',
  AdvObjects in '..\..\reference-platform\support\AdvObjects.pas',
  AdvExceptions in '..\..\reference-platform\support\AdvExceptions.pas',
  FHIRResources in '..\..\reference-platform\r4\FHIRResources.pas',
  FHIRTypes in '..\..\reference-platform\r4\FHIRTypes.pas',
  AdvBuffers in '..\..\reference-platform\support\AdvBuffers.pas',
  BytesSupport in '..\..\reference-platform\support\BytesSupport.pas',
  AdvStringBuilders in '..\..\reference-platform\support\AdvStringBuilders.pas',
  AdvStreams in '..\..\reference-platform\support\AdvStreams.pas',
  AdvObjectLists in '..\..\reference-platform\support\AdvObjectLists.pas',
  AdvItems in '..\..\reference-platform\support\AdvItems.pas',
  AdvFilers in '..\..\reference-platform\support\AdvFilers.pas',
  ColourSupport in '..\..\reference-platform\support\ColourSupport.pas',
  AdvIterators in '..\..\reference-platform\support\AdvIterators.pas',
  AdvPersistents in '..\..\reference-platform\support\AdvPersistents.pas',
  CurrencySupport in '..\..\reference-platform\support\CurrencySupport.pas',
  AdvCollections in '..\..\reference-platform\support\AdvCollections.pas',
  AdvPersistentLists in '..\..\reference-platform\support\AdvPersistentLists.pas',
  AdvFiles in '..\..\reference-platform\support\AdvFiles.pas',
  ErrorSupport in '..\..\reference-platform\support\ErrorSupport.pas',
  FHIRBase in '..\..\reference-platform\support\FHIRBase.pas',
  AdvNames in '..\..\reference-platform\support\AdvNames.pas',
  AdvStringLists in '..\..\reference-platform\support\AdvStringLists.pas',
  AdvCSVFormatters in '..\..\reference-platform\support\AdvCSVFormatters.pas',
  AdvTextFormatters in '..\..\reference-platform\support\AdvTextFormatters.pas',
  AdvFormatters in '..\..\reference-platform\support\AdvFormatters.pas',
  AdvCSVExtractors in '..\..\reference-platform\support\AdvCSVExtractors.pas',
  AdvTextExtractors in '..\..\reference-platform\support\AdvTextExtractors.pas',
  AdvExtractors in '..\..\reference-platform\support\AdvExtractors.pas',
  AdvCharacterSets in '..\..\reference-platform\support\AdvCharacterSets.pas',
  AdvOrdinalSets in '..\..\reference-platform\support\AdvOrdinalSets.pas',
  AdvStreamReaders in '..\..\reference-platform\support\AdvStreamReaders.pas',
  AdvStringStreams in '..\..\reference-platform\support\AdvStringStreams.pas',
  AdvGenerics in '..\..\reference-platform\support\AdvGenerics.pas',
  ParserSupport in '..\..\reference-platform\support\ParserSupport.pas',
  FHIRUtilities in '..\..\reference-platform\r4\FHIRUtilities.pas',
  OIDSupport in '..\..\reference-platform\support\OIDSupport.pas',
  ParseMap in '..\..\reference-platform\support\ParseMap.pas',
  AdvVCLStreams in '..\..\reference-platform\support\AdvVCLStreams.pas',
  AdvMemories in '..\..\reference-platform\support\AdvMemories.pas',
  AdvJSON in '..\..\reference-platform\support\AdvJSON.pas',
  TextUtilities in '..\..\reference-platform\support\TextUtilities.pas',
  AdvZipWriters in '..\..\reference-platform\support\AdvZipWriters.pas',
  AdvNameBuffers in '..\..\reference-platform\support\AdvNameBuffers.pas',
  AdvObjectMatches in '..\..\reference-platform\support\AdvObjectMatches.pas',
  AdvZipDeclarations in '..\..\reference-platform\support\AdvZipDeclarations.pas',
  AdvZipParts in '..\..\reference-platform\support\AdvZipParts.pas',
  AdvZipUtilities in '..\..\reference-platform\support\AdvZipUtilities.pas',
  AdvZipWorkers in '..\..\reference-platform\support\AdvZipWorkers.pas',
  MimeMessage in '..\..\reference-platform\support\MimeMessage.pas',
  InternetFetcher in '..\..\reference-platform\support\InternetFetcher.pas',
  TurtleParser in '..\..\reference-platform\support\TurtleParser.pas',
  FHIRContext in '..\..\reference-platform\r4\FHIRContext.pas',
  FHIRSupport in '..\..\reference-platform\r4\FHIRSupport.pas',
  AdvStringMatches in '..\..\reference-platform\support\AdvStringMatches.pas',
  JWT in '..\..\reference-platform\support\JWT.pas',
  HMAC in '..\..\reference-platform\support\HMAC.pas',
  libeay32 in '..\..\reference-platform\support\libeay32.pas',
  SCIMObjects in '..\..\reference-platform\support\SCIMObjects.pas',
  MXML in '..\..\reference-platform\support\MXML.pas',
  GraphQL in '..\..\reference-platform\support\GraphQL.pas',
  FHIRConstants in '..\..\reference-platform\r4\FHIRConstants.pas',
  FHIRSecurity in '..\..\reference-platform\support\FHIRSecurity.pas',
  FHIRTags in '..\..\reference-platform\r4\FHIRTags.pas',
  FHIRLang in '..\..\reference-platform\support\FHIRLang.pas',
  AfsResourceVolumes in '..\..\reference-platform\support\AfsResourceVolumes.pas',
  AfsVolumes in '..\..\reference-platform\support\AfsVolumes.pas',
  AdvStringHashes in '..\..\reference-platform\support\AdvStringHashes.pas',
  HashSupport in '..\..\reference-platform\support\HashSupport.pas',
  AdvHashes in '..\..\reference-platform\support\AdvHashes.pas',
  AfsStreamManagers in '..\..\reference-platform\support\AfsStreamManagers.pas',
  FHIRXhtml in '..\..\reference-platform\support\FHIRXhtml.pas',
  XMLBuilder in '..\..\reference-platform\support\XMLBuilder.pas',
  FHIRParser in '..\..\reference-platform\support\FHIRParser.pas',
  FHIRParserBase in '..\..\reference-platform\support\FHIRParserBase.pas',
  MXmlBuilder in '..\..\reference-platform\support\MXmlBuilder.pas',
  AdvXmlBuilders in '..\..\reference-platform\support\AdvXmlBuilders.pas',
  AdvXMLFormatters in '..\..\reference-platform\support\AdvXMLFormatters.pas',
  AdvXMLEntities in '..\..\reference-platform\support\AdvXMLEntities.pas',
  FHIRParserXml in '..\..\reference-platform\r4\FHIRParserXml.pas',
  FHIRParserJson in '..\..\reference-platform\r4\FHIRParserJson.pas',
  FHIRParserTurtle in '..\..\reference-platform\r4\FHIRParserTurtle.pas',
  FHIRMetaModel in '..\..\reference-platform\r4\FHIRMetaModel.pas',
  FHIRProfileUtilities in '..\..\reference-platform\r4\FHIRProfileUtilities.pas',
  AdvZipReaders in '..\..\reference-platform\support\AdvZipReaders.pas',
  FhirPath in '..\..\reference-platform\r4\FhirPath.pas',
  FHIRStorageService in '..\..\Server\FHIRStorageService.pas',
  FHIRRestServer in '..\..\Server\FHIRRestServer.pas',
  FHIRUserProvider in '..\..\Server\FHIRUserProvider.pas',
  FHIRIndexManagers in '..\..\Server\FHIRIndexManagers.pas',
  HL7V2DateSupport in '..\..\reference-platform\support\HL7V2DateSupport.pas',
  KDBManager in '..\..\Libraries\db\KDBManager.pas',
  KSettings in '..\..\Libraries\db\KSettings.pas',
  KDBLogging in '..\..\Libraries\db\KDBLogging.pas',
  KDBDialects in '..\..\reference-platform\support\KDBDialects.pas',
  ThreadSupport in '..\..\reference-platform\support\ThreadSupport.pas',
  TerminologyServer in '..\..\Server\TerminologyServer.pas',
  AdvStringObjectMatches in '..\..\reference-platform\support\AdvStringObjectMatches.pas',
  AdvDispatchers in '..\..\reference-platform\support\AdvDispatchers.pas',
  AdvEvents in '..\..\reference-platform\support\AdvEvents.pas',
  AdvMethods in '..\..\reference-platform\support\AdvMethods.pas',
  AdvIntegerMatches in '..\..\reference-platform\support\AdvIntegerMatches.pas',
  AdvIntegerLists in '..\..\reference-platform\support\AdvIntegerLists.pas',
  CDSHooksUtilities in '..\..\reference-platform\support\CDSHooksUtilities.pas',
  MarkdownProcessor in '..\..\..\markdown\source\MarkdownProcessor.pas',
  MarkdownDaringFireball in '..\..\..\markdown\source\MarkdownDaringFireball.pas',
  MarkdownCommonMark in '..\..\..\markdown\source\MarkdownCommonMark.pas',
  SmartOnFhirUtilities in '..\..\reference-platform\support\SmartOnFhirUtilities.pas',
  FHIRClient in '..\..\reference-platform\r4\FHIRClient.pas',
  AdvWinInetClients in '..\..\reference-platform\support\AdvWinInetClients.pas',
  FHIROperations in '..\..\reference-platform\r4\FHIROperations.pas',
  FhirOpBase in '..\..\reference-platform\r4\FhirOpBase.pas',
  TerminologyServices in '..\..\Libraries\TerminologyServices.pas',
  YuStemmer in '..\..\Libraries\stem\YuStemmer.pas',
  DISystemCompat in '..\..\Libraries\stem\DISystemCompat.pas',
  SnomedServices in '..\..\Libraries\snomed\SnomedServices.pas',
  SnomedExpressions in '..\..\Libraries\snomed\SnomedExpressions.pas',
  LoincServices in '..\..\Libraries\loinc\LoincServices.pas',
  UcumServices in '..\..\Libraries\ucum\UcumServices.pas',
  UcumHandlers in '..\..\Libraries\ucum\UcumHandlers.pas',
  Ucum in '..\..\Libraries\ucum\Ucum.pas',
  UcumValidators in '..\..\Libraries\ucum\UcumValidators.pas',
  UcumExpressions in '..\..\Libraries\ucum\UcumExpressions.pas',
  UcumSearch in '..\..\Libraries\ucum\UcumSearch.pas',
  RxNormServices in '..\..\Server\RxNormServices.pas',
  UniiServices in '..\..\Server\UniiServices.pas',
  AdvStringIntegerMatches in '..\..\reference-platform\support\AdvStringIntegerMatches.pas',
  FHIRLog in '..\..\Server\FHIRLog.pas',
  logging in '..\..\Server\logging.pas',
  AdvExclusiveCriticalSections in '..\..\reference-platform\support\AdvExclusiveCriticalSections.pas',
  AdvThreads in '..\..\reference-platform\support\AdvThreads.pas',
  AdvSignals in '..\..\reference-platform\support\AdvSignals.pas',
  SystemService in '..\..\reference-platform\support\SystemService.pas',
  ServiceController in '..\..\reference-platform\support\ServiceController.pas',
  CvxServices in '..\..\Server\CvxServices.pas',
  ACIRServices in '..\..\Server\ACIRServices.pas',
  CountryCodeServices in '..\..\Server\CountryCodeServices.pas',
  AreaCodeServices in '..\..\Server\AreaCodeServices.pas',
  IETFLanguageCodeServices in '..\..\Server\IETFLanguageCodeServices.pas',
  FHIRValueSetChecker in '..\..\Server\FHIRValueSetChecker.pas',
  TerminologyServerStore in '..\..\Server\TerminologyServerStore.pas',
  UriServices in '..\..\Server\UriServices.pas',
  USStateCodeServices in '..\..\Server\USStateCodeServices.pas',
  ClosureManager in '..\..\Server\ClosureManager.pas',
  ServerAdaptations in '..\..\Server\ServerAdaptations.pas',
  FHIRValueSetExpander in '..\..\Server\FHIRValueSetExpander.pas',
  FHIRIndexInformation in '..\..\reference-platform\r4\FHIRIndexInformation.pas',
  FHIRValidator in '..\..\reference-platform\r4\FHIRValidator.pas',
  ServerValidator in '..\..\Server\ServerValidator.pas',
  FHIRSubscriptionManager in '..\..\Server\FHIRSubscriptionManager.pas',
  IdWebSocket in '..\..\reference-platform\support\IdWebSocket.pas',
  FHIRServerUtilities in '..\..\Server\FHIRServerUtilities.pas',
  FHIRSessionManager in '..\..\Server\FHIRSessionManager.pas',
  SCIMServer in '..\..\Server\SCIMServer.pas',
  SCrypt in '..\..\Libraries\security\SCrypt.pas',
  SCIMSearch in '..\..\Server\SCIMSearch.pas',
  FHIRTagManager in '..\..\Server\FHIRTagManager.pas',
  JWTService in '..\..\Server\JWTService.pas',
  ClientApplicationVerifier in '..\..\Libraries\security\ClientApplicationVerifier.pas',
  ApplicationCache in '..\..\Server\ApplicationCache.pas',
  TwilioClient in '..\..\Libraries\security\TwilioClient.pas',
  FHIRServerContext in '..\..\Server\FHIRServerContext.pas',
  CertificateSupport in '..\..\reference-platform\support\CertificateSupport.pas',
  AdvIntegerObjectMatches in '..\..\reference-platform\support\AdvIntegerObjectMatches.pas',
  HTMLPublisher in '..\..\reference-platform\support\HTMLPublisher.pas',
  RDFUtilities in '..\..\reference-platform\support\RDFUtilities.pas',
  MsXmlParser in '..\..\reference-platform\support\MsXmlParser.pas',
  QuestionnaireBuilder in '..\..\reference-platform\r4\QuestionnaireBuilder.pas',
  NarrativeGenerator in '..\..\reference-platform\r4\NarrativeGenerator.pas',
  CDSHooksClientManager in '..\..\reference-platform\support\CDSHooksClientManager.pas',
  FHIRGraphQL in '..\..\reference-platform\support\FHIRGraphQL.pas',
  SnomedPublisher in '..\..\Libraries\snomed\SnomedPublisher.pas',
  LoincPublisher in '..\..\Libraries\loinc\LoincPublisher.pas',
  TerminologyWebServer in '..\..\Server\TerminologyWebServer.pas',
  SnomedAnalysis in '..\..\Libraries\snomed\SnomedAnalysis.pas',
  FHIRServerConstants in '..\..\Server\FHIRServerConstants.pas',
  AuthServer in '..\..\Server\AuthServer.pas',
  FacebookSupport in '..\..\reference-platform\support\FacebookSupport.pas',
  FHIRAuthMap in '..\..\reference-platform\r4\FHIRAuthMap.pas',
  ReverseClient in '..\..\Server\ReverseClient.pas',
  CDSHooksServer in '..\..\Server\CDSHooksServer.pas',
  OpenMHealthServer in '..\..\Server\OpenMHealthServer.pas',
  VocabPocServerCore in 'VocabPocServerCore.pas',
  FHIRSearchSyntax in '..\..\Server\FHIRSearchSyntax.pas',
  FastMM4Messages in '..\..\Libraries\FMM\FastMM4Messages.pas',
  FHIRSearch in '..\..\reference-platform\support\FHIRSearch.pas',
  TerminologyOperations in '..\..\Server\TerminologyOperations.pas',
  WebSourceProvider in '..\..\Server\WebSourceProvider.pas',
  vpocversion in 'vpocversion.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TTxServerForm, TxServerForm);
  Application.Run;
end.