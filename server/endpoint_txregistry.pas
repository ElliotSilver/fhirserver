unit endpoint_txregistry;

{
Copyright (c) 2001-2021, Health Intersections Pty Ltd (http://www.healthintersections.com.au)
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

 * Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.
 * Neither the name of HL7 nor the names of its contributors may be used to
   endorse or promote products derived from this software without specific
   prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
}

{$i fhir.inc}

interface

uses
  SysUtils, Classes,
  IdContext, IdCustomHTTPServer, IdOpenSSLX509,
  fsl_base, fsl_utilities, fsl_threads, fsl_logging, fsl_json, fsl_http, fsl_npm, fsl_stream, fsl_versions, fsl_i18n,
  fhir_objects,
  tx_registry_spider, tx_registry_model,

  server_config, utilities, telnet_server,
  tx_manager, time_tracker, kernel_thread, server_stats,
  web_event, web_base, endpoint, session;

type
  TTxRegistryServerEndPoint = class;

  TTxRegistryUpdaterThread = class(TFslThread)
  private
    FEndPoint : TTxRegistryServerEndPoint;
    FNextRun : TDateTime;
    FLastEmail : TDateTime;
    FZulip : TZulipTracker;
    procedure RunUpdater;
    procedure doSendEmail(dest, subj, body : String);
  protected
    function ThreadName : String; override;
    procedure Initialise; override;
    procedure Execute; override;
  public
    constructor Create(endPoint : TTxRegistryServerEndPoint);
    destructor Destroy; override;
  end;

  TMatchTableSort = (mtsNull, mtsId, mtsVersion, mtsDate, mtsFhirVersion, mtsCanonical, mtsDownloads, mtsKind);

  { TFHIRTxRegistryWebServer }

  TFHIRTxRegistryWebServer = class (TFhirWebServerEndpoint)
  private
    FLastUpdate : TDateTime;
    FNextScan : TDateTIme;
    FScanning: boolean;
    FInfo : TServerRegistries; 
    FAddress : String;

    procedure populate(json: TJsonObject; srvr: TServerInformation; ver: TServerVersionInformation);
    function status : String;

    //function getVersion(v : String) : String;
    //function interpretVersion(v : String) : String;
    //
    //function genTable(url : String; list: TFslList<TJsonObject>; sort : TMatchTableSort; rev, inSearch, secure, packageLevel: boolean): String;
    //
    //function serveCreatePackage(request : TIdHTTPRequestInfo; response : TIdHTTPResponseInfo) : String;
    //
    //procedure servePage(fn : String; request : TIdHTTPRequestInfo; response : TIdHTTPResponseInfo; secure : boolean);
    //procedure serveDownload(id, version : String; response : TIdHTTPResponseInfo);
    //procedure serveVersions(id, sort : String; secure : boolean; request : TIdHTTPRequestInfo; response : TIdHTTPResponseInfo);
    //procedure serveSearch(name, canonicalPkg, canonicalUrl, FHIRVersion, dependency, sort : String; secure : boolean; request : TIdHTTPRequestInfo; response : TIdHTTPResponseInfo);
    //procedure serveUpdates(date : TFslDateTime; secure : boolean; response : TIdHTTPResponseInfo);
    //procedure serveProtectForm(request : TIdHTTPRequestInfo; response : TIdHTTPResponseInfo; id : String);
    //procedure serveUpload(request : TIdHTTPRequestInfo; response : TIdHTTPResponseInfo; secure : boolean; id : String);
    //procedure processProtectForm(request : TIdHTTPRequestInfo; response : TIdHTTPResponseInfo; id, pword : String);
    procedure SetScanning(const Value: boolean);

    procedure sortJson(json : TJsonObject; sort : String);
    function renderJson(json : TJsonObject; path, reg, srvr, ver : String) : String;
    procedure sendHtml(request: TIdHTTPRequestInfo; response: TIdHTTPResponseInfo; secure : boolean; json : TJsonObject; reg, srvr, ver, tx : String);
    function listRows(reg, srvr, ver, tx : String) : TJsonObject;
    function resolve(version, tx : String) : TJsonObject;

    function doRequest(AContext: TIdContext; request: TIdHTTPRequestInfo; response: TIdHTTPResponseInfo; id: String; secure: boolean): String;
  public
    destructor Destroy; override;
    function link  : TFHIRTxRegistryWebServer; overload;
    function description : String; override;

    property NextScan : TDateTIme read FNextScan write FNextScan;
    property scanning : boolean read FScanning write SetScanning;

    function PlainRequest(AContext: TIdContext; ip : String; request: TIdHTTPRequestInfo; response: TIdHTTPResponseInfo; id : String; tt : TTimeTracker) : String; override;
    function SecureRequest(AContext: TIdContext; ip : String; request: TIdHTTPRequestInfo; response: TIdHTTPResponseInfo; cert : TIdOpenSSLX509; id : String; tt : TTimeTracker) : String; override;
    function logId : string; override;
  end;

  { TTxRegistryServerEndPoint }

  TTxRegistryServerEndPoint = class (TFHIRServerEndPoint)
  private
    FTxRegistryServer : TFHIRTxRegistryWebServer;
    FUpdater : TTxRegistryUpdaterThread; 
    FAddress : String;

    function sourceFile : String;
  public
    constructor Create(config : TFHIRServerConfigSection; settings : TFHIRServerSettings; common : TCommonTerminologies; i18n : TI18nSupport);
    destructor Destroy; override;

    function summary : String; override;
    function makeWebEndPoint(common : TFHIRWebServerCommon) : TFhirWebServerEndpoint; override;
    procedure InstallDatabase; override;
    procedure UninstallDatabase; override;
    procedure LoadPackages(plist : String); override;
    procedure updateAdminPassword; override;
    procedure Load; override;
    Procedure Unload; override;
    procedure internalThread(callback : TFhirServerMaintenanceThreadTaskCallBack); override;
    function cacheSize(magic : integer) : UInt64; override;
    procedure clearCache; override; 
    procedure SweepCaches; override;
    procedure SetCacheStatus(status : boolean); override;
    procedure getCacheInfo(ci: TCacheInformation); override;
    procedure recordStats(rec : TStatusRecord); override;
  end;

implementation

function TTxRegistryServerEndPoint.sourceFile: String;
begin
  result := tempFile('tx-registry.json');
end;

constructor TTxRegistryServerEndPoint.Create(config : TFHIRServerConfigSection; settings : TFHIRServerSettings; common : TCommonTerminologies; i18n : TI18nSupport);
var
  s : String;
begin
  inherited create(config, settings, nil, common, nil, i18n);
  s := config.clone['folder'].value;
  FAddress := s;
  if (FAddress = '') then
    FAddress := MASTER_URL;
end;

destructor TTxRegistryServerEndPoint.Destroy;
begin
  FTxRegistryServer.Free;

  inherited;
end;

function TTxRegistryServerEndPoint.cacheSize(magic : integer): UInt64;
begin
  result := inherited cacheSize(magic);
end;

procedure TTxRegistryServerEndPoint.clearCache;
begin
  inherited;
end;

procedure TTxRegistryServerEndPoint.SweepCaches;
begin
  inherited SweepCaches;
end;

procedure TTxRegistryServerEndPoint.getCacheInfo(ci: TCacheInformation);
begin
  inherited;
end;

procedure TTxRegistryServerEndPoint.recordStats(rec: TStatusRecord);
begin
  inherited recordStats(rec);
  // nothing
end;

procedure TTxRegistryServerEndPoint.Load;
begin
  FUpdater := TTxRegistryUpdaterThread.Create(self);
end;

procedure TTxRegistryServerEndPoint.Unload;
begin
  FUpdater.StopAndWait(50);
  FUpdater.Free;
  FUpdater := nil;
end;

procedure TTxRegistryServerEndPoint.InstallDatabase;
begin
  DeleteFile(sourceFile);
end;

procedure TTxRegistryServerEndPoint.UninstallDatabase;
begin
  DeleteFile(sourceFile);
end;

procedure TTxRegistryServerEndPoint.internalThread(callback: TFhirServerMaintenanceThreadTaskCallBack);
begin
  // nothing, for now
  // todo: health check on spider
end;

procedure TTxRegistryServerEndPoint.LoadPackages(plist: String);
begin
  raise EFslException.Create('This is not applicable to this endpoint');
end;

function TTxRegistryServerEndPoint.makeWebEndPoint(common: TFHIRWebServerCommon): TFhirWebServerEndpoint;   
var
  json : TJsonObject;
begin
  inherited makeWebEndPoint(common);
  FTxRegistryServer := TFHIRTxRegistryWebServer.Create(config.name, config['path'].value, common);
  FTxRegistryServer.NextScan := FUpdater.FNextRun;
  WebEndPoint := FTxRegistryServer;

  if FileExists(sourceFile) then
  begin
    json := TJsonParser.ParseFile(sourceFile);
    try
      FTxRegistryServer.FInfo := TServerRegistryUtilities.fromJson(json);
    finally
      json.free;
    end;
  end
  else
    FTxRegistryServer.FInfo := TServerRegistries.create;
  FTxRegistryServer.FInfo.Address := FAddress;
  FUpdater.Start;
  result := FTxRegistryServer.link;
end;

procedure TTxRegistryServerEndPoint.SetCacheStatus(status: boolean);
begin
  inherited;
end;

function TTxRegistryServerEndPoint.summary: String;
begin
  result := 'TxRegistry Server based off '+FAddress;
end;

procedure TTxRegistryServerEndPoint.updateAdminPassword;
begin
  raise EFslException.Create('This is not applicable to this endpoint');
end;

{ TTxRegistryUpdaterThread }

constructor TTxRegistryUpdaterThread.Create(endPoint : TTxRegistryServerEndPoint);
begin
  inherited create;
  FEndPoint := endPoint;
  FNextRun := now + 1/(24 * 60);
  FZulip := TZulipTracker.Create('https://fhir.zulipchat.com/api/v1/messages',
      'pascal-github-bot@chat.fhir.org', FEndPoint.Settings.ZulipPassword);
end;

destructor TTxRegistryUpdaterThread.Destroy;
begin
  FZulip.Free;
  inherited;
end;

procedure TTxRegistryUpdaterThread.Execute;
begin
  FEndPoint.FTxRegistryServer.scanning := true;
  try
    RunUpdater;
  finally
    FEndPoint.FTxRegistryServer.scanning := false;
  end;
  FEndPoint.FTxRegistryServer.NextScan := now + 1/24;
end;

procedure TTxRegistryUpdaterThread.Initialise;
begin
  TimePeriod := 60 * 60 * 1000;
end;

procedure TTxRegistryUpdaterThread.doSendEmail(dest, subj, body : String);
begin
  sendEmail(FEndPoint.Settings, dest, subj, body);
end;


procedure TTxRegistryUpdaterThread.RunUpdater;
var
  upd : TTxRegistryScanner;
  info : TServerRegistries;
begin
  upd := TTxRegistryScanner.create(FZulip.link);
  try
    upd.address := FEndPoint.FAddress;
    upd.OnSendEmail := doSendEmail;
    try
      info := TServerRegistries.create;
      try
        upd.update(FEndPoint.FTxRegistryServer.code, info);
        FEndPoint.FTxRegistryServer.FInfo.update(info);
      finally
        info.free;
      end;
      if (TFslDateTime.makeToday.DateTime <> FLastEmail) then
      begin
        if upd.errors <> '' then
          sendEmail(FEndPoint.Settings, 'grahameg@gmail.com', 'TxRegistry Errors', upd.errors);
        FLastEmail := TFslDateTime.makeToday.DateTime;
      end;
    except
      on e : exception do
      begin
        Logging.log('Exception check tx registry: '+e.Message);
      end;
    end;
  finally
    upd.free;
  end;
end;

function TTxRegistryUpdaterThread.threadName: String;
begin
  result := 'TxRegistry Scanner';
end;

function readSort(sort : String) : TMatchTableSort;
begin
  if sort.StartsWith('-') then
    sort := sort.Substring(1);
  if (SameText('id', sort)) then
    result := mtsId
  else if (SameText('version', sort)) then
    result := mtsVersion
  else if (SameText('date', sort)) then
    result := mtsDate
  else if (SameText('fhirversion', sort)) then
    result := mtsFhirVersion
  else if (SameText('canonical', sort)) then
    result := mtsCanonical
  else if (SameText('downloads', sort)) then
    result := mtsDownloads
  else if (SameText('kind', sort)) then
    result := mtsKind
  else
    result := mtsNull;
end;

{ TFHIRTxRegistryWebServer }

destructor TFHIRTxRegistryWebServer.Destroy;
begin
  FInfo.Free;
  inherited;
end;

function TFHIRTxRegistryWebServer.description: String;
begin
  result := 'Package Server - browser packages, or use the <a href="https://simplifier.net/docs/package-server/home">Package Server API</a>';
end;

procedure TFHIRTxRegistryWebServer.SetScanning(const Value: boolean);
begin
  FScanning := Value;
  FLastUpdate := now;
end;

procedure TFHIRTxRegistryWebServer.sortJson(json: TJsonObject; sort: String);
begin
  // nothing yet
end;

function TFHIRTxRegistryWebServer.renderJson(json: TJsonObject; path, reg, srvr, ver : String): String;
var
  b : TFslStringBuilder;
  row : TJsonObject;
  i : integer;
  arr : TJsonArray;
begin
  b := TFslStringBuilder.create;
  try
    b.append('<table class="grid">'#13#10);
    b.append('<tr>'#13#10);
    if (reg = '') then
      b.append('<td><b>Registry</b></td>'#13#10);
    if (srvr = '') then
      b.append('<td><b>Server</b></td>'#13#10);
    if (ver = '') then
      b.append('<td><b>Version</b></td>'#13#10);
    b.append('<td><b>Url</b></td>'#13#10);
    b.append('<td><b>Status</b></td>'#13#10);
    b.append('<td><b>Content</b></td>'#13#10);
    b.append('<td><b>Authoritative</b></td>'#13#10);
    b.append('<td><b>Security</b></td>'#13#10);
    b.append('</tr>'#13#10);

    for row in json.forceArr['results'].asObjects.forEnum do
    begin
      b.append('<tr>'#13#10);
      if (reg = '') then
        b.append('<td><a href="'+path+'&registry='+row.str['registry-code']+'">'+FormatTextToHTML(row.str['registry-name'])+'</a></td>'#13#10);
      if (srvr = '') then
        b.append('<td><a href="'+path+'&server='+row.str['server-code']+'">'+FormatTextToHTML(row.str['server-name'])+'</a></td>'#13#10);
      if (ver = '') then
        b.append('<td><a href="'+path+'&version='+row.str['version']+'">'+row.str['version']+'</a></td>'#13#10);
      b.append('<td><a href="'+FormatTextToHTML(row.str['url'])+'">'+FormatTextToHTML(row.str['url'])+'</a></td>'#13#10);
      if (row.str['error']) <> '' then
        b.append('<td>>span style="color: maroon">Error: '+FormatTextToHTML(row.str['error'])+'</span>Last OK '+DurationToSecondsString(row.int['last-success'])+' ago</td>'#13#10)
      else
        b.append('<td>Last OK '+DurationToSecondsString(row.int['last-success'])+' ago</td>'#13#10);
      b.append('<td>'+inttostr(row.int['systems'])+' systems</td>'#13#10);
      b.append('<td>');
      arr := row.forceArr['authoritative'];
      for i := 0 to arr.Count - 1 do
      begin
        if i > 0 then b.append(', ');
        b.append('<code>'+FormatTextToHTML(arr.Value[i])+'</code>');
      end;
      b.append('</td>'#13#10);
      b.append('<td>');
      if (row.bool[CODES_TServerSecurity[ssOpen]]) then
        b.append('<span style="padding-left: 3px; padding-right: 3px; border: 1px grey solid; color: white; background-color: green" title="Open">O</span> ');
      if (row.bool[CODES_TServerSecurity[ssPassword]]) then
        b.append('<span style="padding-left: 3px; padding-right: 3px; border: 1px grey solid; color: white; background-color: red" title="Username/Password">P</span> ');
      if (row.bool[CODES_TServerSecurity[ssToken]]) then
        b.append('<span style="padding-left: 3px; padding-right: 3px; border: 1px grey solid; color: white; background-color: red" title="API Token">T</span> ');
      if (row.bool[CODES_TServerSecurity[ssOAuth]]) then
        b.append('<span style="padding-left: 3px; padding-right: 3px; border: 1px grey solid; color: white; background-color: red" title="OAuth">O</span> ');
      if (row.bool[CODES_TServerSecurity[ssSmart]]) then
        b.append('<span style="padding-left: 3px; padding-right: 3px; border: 1px grey solid; color: white; background-color: red" title="Smart App Launch">S</span> ');
      if (row.bool[CODES_TServerSecurity[ssCert]]) then
        b.append('<span style="padding-left: 3px; padding-right: 3px; border: 1px grey solid; color: white; background-color: red" title="Certificates">C</span> ');
      b.append('</td>'#13#10);
      b.append('</tr>'#13#10);
    end;

    b.append('</table>'#13#10);
    result := b.ToString;
  finally
    b.free;
  end;
end;

procedure TFHIRTxRegistryWebServer.sendHtml(request: TIdHTTPRequestInfo; response: TIdHTTPResponseInfo; secure : boolean; json: TJsonObject; reg, srvr, ver, tx : String);
var
  path : String;
  vars : TFslMap<TFHIRObject>;
begin
  path := AbsoluteURL(secure)+'/?';
  if (reg <> '') then
    path := path+'&registry='+reg;
  if (srvr <> '') then
    path := path+'&server='+srvr;
  if (ver <> '') then
    path := path+'&version='+ver;
  if (tx <> '') then
    path := path+'&url='+tx;

  vars := TFslMap<TFHIRObject>.create('vars');
  try
    vars.add('path', TFHIRObjectText.create(path));
    vars.add('matches', TFHIRObjectText.create(renderJson(json, path, reg, srvr, ver)));
    vars.add('count', TFHIRObjectText.create(json.forceArr['results'].Count));
    vars.add('registry', TFHIRObjectText.create(reg));
    vars.add('server', TFHIRObjectText.create(srvr));
    vars.add('version', TFHIRObjectText.create(ver));
    vars.add('url', TFHIRObjectText.create(tx));
    vars.add('status', TFHIRObjectText.create(status));
    returnFile(request, response, nil, request.Document, 'tx-registry.html', false, vars);
  finally
    vars.free;
  end;
end;

function TFHIRTxRegistryWebServer.listRows(reg, srvr, ver, tx : String): TJsonObject;
var
  rows :TFslList<TServerRow>;
  row : TServerRow;
begin
  result := TJsonObject.create;
  try
    result.str['last-update'] := FInfo.LastRun.toXML;
    result.str['master-url'] := FInfo.Address;

    rows := TServerRegistryUtilities.buildRows(FInfo, reg, srvr, ver, tx);
    try
      for row in rows do
        result.forceArr['results'].add(TServerRegistryUtilities.toJson(row));
    finally
      rows.free;
    end;
    result.link;
  finally
    result.free;
  end;
end;


procedure TFHIRTxRegistryWebServer.populate(json : TJsonObject; srvr : TServerInformation; ver : TServerVersionInformation);
begin
  json.str['server-name'] := srvr.Name;
  json.str['url'] := ver.Address;

  if (ssOpen in ver.Security) then json.bool[CODES_TServerSecurity[ssOpen]] := true;
  if (ssPassword in ver.Security) then json.bool[CODES_TServerSecurity[ssPassword]] := true;
  if (ssToken in ver.Security) then json.bool[CODES_TServerSecurity[ssToken]] := true;
  if (ssOAuth in ver.Security) then json.bool[CODES_TServerSecurity[ssOAuth]] := true;
  if (ssSmart in ver.Security) then json.bool[CODES_TServerSecurity[ssSmart]] := true;
  if (ssCert in ver.Security) then json.bool[CODES_TServerSecurity[ssCert]] := true;
end;

function TFHIRTxRegistryWebServer.resolve(version, tx: String): TJsonObject;
var
  reg : TServerRegistry;
  srvr : TServerInformation;
  ver : TServerVersionInformation;
begin
  if (version = '') then
    raise EFslException.create('A version is required');
  if (tx = '') then
    raise EFslException.create('A code system url is required');

  result := TJsonObject.create;
  try
    for reg in FInfo.Registries do
      for srvr in reg.Servers do
      begin
        if (srvr.isAuth(tx)) then
        begin
          for ver in srvr.Versions do
            if TSemanticVersion.matches(version, ver.version, semverAuto) and (ver.Terminologies.IndexOf(tx) > -1) then
              populate(result.forceArr['authoritative'].addObject, srvr, ver);
        end
        else
        begin
          for ver in srvr.Versions do
            if TSemanticVersion.matches(version, ver.version, semverAuto) and (ver.Terminologies.IndexOf(tx) > -1) then
              populate(result.forceArr['candidates'].addObject, srvr, ver);
        end;
      end;
    result.link;
  finally
    result.free;
  end;
end;

function TFHIRTxRegistryWebServer.status: String;
begin
  if FScanning then
    result := 'Scanning for updates now'
  else if FlastUpdate = 0 then
    result := 'First Scan in '+DescribePeriod(FNextScan-now)
  else
    result := 'Next Scan in '+DescribePeriod(FNextScan-now)+'. Last scan was '+DescribePeriod(now - FLastUpdate)+' ago';
end;

function genSort(this, sort : TMatchTableSort; rev : boolean) : String;
begin
  case this of
    mtsId : result := 'id';
    mtsVersion : result := 'version';
    mtsDate : result := 'date';
    mtsFhirVersion : result := 'fhirversion';
    mtsCanonical : result := 'canonical';
    mtsDownloads : result := 'downloads';
    mtsKind : result := 'kind';
  end;
  if (this = sort) and not rev then
    result := '-'+ result;
end;

type
  TFHIRTxRegistryWebServerSorter = class (TFslComparer<TJsonObject>)
  private
    sort : TMatchTableSort;
    factor : integer;
  public
    constructor Create(sort : TMatchTableSort; factor : integer);
    function Compare(const l, r : TJsonObject) : integer; override;
  end;

constructor TFHIRTxRegistryWebServerSorter.Create(sort: TMatchTableSort; factor: integer);
begin
  inherited create;
  self.sort := sort;
  self.factor := factor;
end;

function TFHIRTxRegistryWebServerSorter.Compare(const l, r : TJsonObject) : integer;
begin
  case sort of
    mtsId : result := CompareText(l['name'], r['name']) * factor;
    mtsVersion : result := CompareText(l['version'], r['version']) * factor;
    mtsDate : result := CompareText(l['date'], r['date']) * factor;
    mtsFhirVersion : result := CompareText(l['fhirVersion'], r['fhirVersion']) * factor;
    mtsCanonical : result := CompareText(l['canonical'], r['canonical']) * factor;
    mtsDownloads : result := (l.int['count'] - r.int['count']) * factor;
    mtsKind : result := CompareText(l['kind'], r['kind']) * factor;
  else
    result := 0;
  end;
end;

function TFHIRTxRegistryWebServer.link: TFHIRTxRegistryWebServer;
begin
  result := TFHIRTxRegistryWebServer(inherited link);
end;

function TFHIRTxRegistryWebServer.logId: string;
begin
  result := 'TXR';
end;

function TFHIRTxRegistryWebServer.PlainRequest(AContext: TIdContext; ip : String; request: TIdHTTPRequestInfo; response: TIdHTTPResponseInfo; id : String; tt : TTimeTracker) : String;
begin
  countRequest;
  result := doRequest(AContext, request, response, id, false);
end;


function TFHIRTxRegistryWebServer.doRequest(AContext: TIdContext; request: TIdHTTPRequestInfo; response: TIdHTTPResponseInfo; id : String; secure : boolean) : String;
var
  pm : THTTPParameters;
  reg, srvr, ver, tx : String;
  //s : TArray<String>;
  //sId : string;
  json : TJsonObject;
begin
  pm := THTTPParameters.create(request.UnparsedParams);
  try
    if (request.CommandType <> hcGET) then
      raise EFslException.Create('The operation '+request.Command+' '+request.Document+' is not supported');
    if request.document = PathWithSlash then
    begin
      reg := pm.Value['registry'];
      srvr := pm.Value['server'];
      ver := pm.Value['version'];
      tx := pm.Value['url'];
      json := listRows(reg, srvr, ver, tx);
      try
        result := 'Tx servers (registry='+reg+', server='+srvr+', version='+ver+', url='+tx+')';
        if (pm.has('sort')) then
          sortJson(json, pm.Value['sort']);
        if request.Accept.Contains('json') then
        begin
          response.ResponseNo := 200;
          response.ContentType := 'application/json';
          response.ContentText := TJSONWriter.writeObjectStr(json, true);
        end
        else
          sendHtml(request, response, secure, json, reg, srvr, ver, tx);
      finally
        json.Free;
      end;
    end
    else if request.document = PathWithSlash+'resolve' then
    begin
      result := 'Resolve '+pm.Value['version']+' server for '+pm.Value['url'];
      json := resolve(pm.Value['version'], pm.Value['url']);
      try
        response.ResponseNo := 200;
        response.ContentType := 'application/json';
        response.ContentText := TJSONWriter.writeObjectStr(json, true);
      finally
        json.Free;
      end;
    end
    else
      raise EFslException.Create('The operation '+request.Command+' '+request.Document+' is not supported');
  finally
    pm.free;
  end;
end;

function TFHIRTxRegistryWebServer.SecureRequest(AContext: TIdContext; ip : String; request: TIdHTTPRequestInfo; response: TIdHTTPResponseInfo;  cert: TIdOpenSSLX509; id: String; tt : TTimeTracker): String;
begin
  countRequest;
  result := doRequest(AContext, request, response, id, true);
end;

end.