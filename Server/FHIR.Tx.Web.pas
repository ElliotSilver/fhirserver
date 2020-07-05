unit FHIR.Tx.Web;

{
Copyright (c) 2011+, HL7 and Health Intersections Pty Ltd (http://www.healthintersections.com.au)
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

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND
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


interface

uses
  SysUtils, Classes, System.Generics.Collections, Generics.Defaults,
  FHIR.Web.Parsers,
  FHIR.Support.Base, FHIR.Support.Utilities, FHIR.Support.Stream,
  IdContext, IdCustomHTTPServer,
  FHIR.Base.Lang, FHIR.Base.Xhtml, FHIR.Base.Objects, FHIR.Base.Common, FHIR.Base.Factory, FHIR.Base.Parser,
  FHIR.Tools.ValueSets,
  FHIR.Web.HtmlGen, FHIR.Snomed.Publisher, FHIR.Snomed.Services, FHIR.Loinc.Publisher, FHIR.Loinc.Services, FHIR.Snomed.Expressions, FHIR.Snomed.Analysis,
  FHIR.Server.Session, FHIR.Tx.Server, FHIR.Tx.Service, FHIR.Tx.Manager, FHIR.Server.Constants, FHIR.Server.WebBase;

Type

  TSorterType = (byUrl, byVer, byName, byContext, byPub, bySource);

  TCodeSystemSorter = class (TFslObject, IComparer<TFHIRCodeSystemW>)
  private
    FSortType : TSorterType;
  public
    function Compare(const Left, Right: TFHIRCodeSystemW): Integer;
  end;

  TValueSetSorter = class (TFslObject, IComparer<TFHIRValueSetW>)
  private
    FSortType : TSorterType;
  public
    function Compare(const Left, Right: TFHIRValueSetW): Integer;
  end;

  TTerminologyWebServer = class (TFslObject)
  private
    FWorker : TFHIRWorkerContextWithFactory;
    FServer : TTerminologyServer;
    FFHIRPath : String;
    FReturnProcessFileEvent : TReturnProcessFileEvent;
    FCSSorter : TCodeSystemSorter;
    FVSSorter : TValueSetSorter;

    function asJson(r : TFHIRResourceV) : String;
    function asXml(r : TFHIRResourceV) : String;
    function asHtml(r : TFHIRResourceV) : String;
    function paramsAsHtml(p : TFhirResourceV) : String; overload;
    function paramsAsHtml(p : TFhirParametersW) : String; overload;
    function vsSelect(id : String) : String;

    function processFind(pm : THTTPParameters) : String;
    function processValidate(pm : THTTPParameters) : String;
    function processExpand(pm : THTTPParameters; const lang : THTTPLanguages) : String;
    function processTranslate(pm : THTTPParameters) : String;

    function chooseSnomedRelease() : String;
    function HandleLoincRequest(AContext: TIdContext; request: TIdHTTPRequestInfo; response: TIdHTTPResponseInfo) : String;
    function HandleSnomedRequest(AContext: TIdContext; request: TIdHTTPRequestInfo; response: TIdHTTPResponseInfo) : String;
    function HandleTxRequest(AContext: TIdContext; request: TIdHTTPRequestInfo; response: TIdHTTPResponseInfo; session : TFhirSession) : String;
    function HandleTxForm(AContext: TIdContext; request: TIdHTTPRequestInfo; session : TFhirSession; response: TIdHTTPResponseInfo; secure : boolean) : string;
//    Procedure BuildCsByName(html : THtmlPublisher; id : String);
//    Procedure BuildCsByURL(html : THtmlPublisher; id : String);
//    Procedure BuildVsByName(html : THtmlPublisher; id : String);
//    Procedure BuildVsByURL(html : THtmlPublisher; id : String);
    function processSnomedForTool(ss : TSnomedServices; code : String) : String;

    function sortCmByUrl(pA, pB : Pointer) : Integer;
    function sortCmByVer(pA, pB : Pointer) : Integer;
    function sortCmByName(pA, pB : Pointer) : Integer;
    function sortCmByCtxt(pA, pB : Pointer) : Integer;
    function sortCmByPub(pA, pB : Pointer) : Integer;
    function sortCmBySrc(pA, pB : Pointer) : Integer;
    function sortCmByTgt(pA, pB : Pointer) : Integer;
    function ProcessValueSetList(AContext: TIdContext; request: TIdHTTPRequestInfo; response: TIdHTTPResponseInfo; session : TFhirSession) : string;
    function ProcessConceptMapList(AContext: TIdContext; request: TIdHTTPRequestInfo; response: TIdHTTPResponseInfo; session : TFhirSession) : string;
    function ProcessCodeSystemList(AContext: TIdContext; request: TIdHTTPRequestInfo; response: TIdHTTPResponseInfo; session : TFhirSession) : string;
    function ProcessCodeSystemProviderList(AContext: TIdContext; request: TIdHTTPRequestInfo; response: TIdHTTPResponseInfo; session : TFhirSession) : string;
    function ProcessValueSet(AContext: TIdContext; request: TIdHTTPRequestInfo; response: TIdHTTPResponseInfo; session : TFhirSession) : string;
    function ProcessCodeSystem(AContext: TIdContext; request: TIdHTTPRequestInfo; response: TIdHTTPResponseInfo; session : TFhirSession) : string;
    function ProcessConceptMap(AContext: TIdContext; request: TIdHTTPRequestInfo; response: TIdHTTPResponseInfo; session : TFhirSession) : string;
    function ProcessHome(AContext: TIdContext; request: TIdHTTPRequestInfo; response: TIdHTTPResponseInfo; session : TFhirSession) : string;
  public
    constructor Create(server : TTerminologyServer; Worker : TFHIRWorkerContextWithFactory; BaseURL, FHIRPathEngine : String; ReturnProcessFileEvent : TReturnProcessFileEvent); overload;
    destructor Destroy; Override;
    function HandlesRequestVersion(path : String) : boolean;
    function HandlesRequestNoVersion(path : String) : boolean;
    function ProcessVersion(AContext: TIdContext; request: TIdHTTPRequestInfo; session : TFhirSession; response: TIdHTTPResponseInfo; secure : boolean) : string;
    function ProcessNoVersion(AContext: TIdContext; request: TIdHTTPRequestInfo; session : TFhirSession; response: TIdHTTPResponseInfo; secure : boolean) : string;
  end;

implementation

uses
  FHIR.Support.Logging;

{ TTerminologyWebServer }

function TTerminologyWebServer.chooseSnomedRelease: String;
var
  html : THtmlPublisher;
  ss : TSnomedServices;
begin
  html := THtmlPublisher.Create(FWorker.Factory.link);
  try
    html.Version := SERVER_VERSION;
    html.Header('Choose SNOMED CT Version');
    html.StartTable(true);
    html.StartTableRow;
    html.AddTableCell('Choose SNOMED Edition');
    html.AddTableCell('Version');
    html.AddTableCell('Date');
    html.EndTableRow;
    for ss in FServer.CommonTerminologies.Snomed do
    begin
      html.StartTableRow;
      html.AddTableCellURL(ss.EditionName, '/snomed/'+ss.editionId);
      html.AddTableCell(ss.VersionUri);
      html.AddTableCell(ss.VersionDate);
      html.EndTableRow;
    end;
    html.EndTable;
    html.done;
    result := html.output;
  finally
    html.Free;
  end;
end;

constructor TTerminologyWebServer.create(server: TTerminologyServer; Worker : TFHIRWorkerContextWithFactory; BaseURL, FHIRPathEngine : String; ReturnProcessFileEvent : TReturnProcessFileEvent);
begin
  create;
  FServer := server;
  FFHIRPath := FHIRPathEngine;
  FReturnProcessFileEvent := ReturnProcessFileEvent;
  FServer.webBase := BaseURl;
  FWorker := worker;
  FVSSorter := TValueSetSorter.Create;
end;

destructor TTerminologyWebServer.Destroy;
begin
  FWorker.Free;
  FServer.free;
  FVSSorter.Free;
  inherited;
end;

function TTerminologyWebServer.HandlesRequestVersion(path: String): boolean;
begin
  result := path.StartsWith(FServer.webBase+'/tx');
end;

function TTerminologyWebServer.HandlesRequestNoVersion(path: String): boolean;
begin
  result := path.StartsWith('/snomed') or path.StartsWith('/loinc') ;
end;

function TTerminologyWebServer.ProcessVersion(AContext: TIdContext; request: TIdHTTPRequestInfo; session : TFhirSession; response: TIdHTTPResponseInfo; secure : boolean) : string;
var
  path : string;
begin
  path := request.Document;
  if path.StartsWith(FServer.webBase+'/tx/form') then
    result := HandleTxForm(AContext, request, session, response, secure)
  else if path.StartsWith(FServer.webBase+'/tx') then
    result := HandleTxRequest(AContext, request, response, session)
end;

function TTerminologyWebServer.ProcessNoVersion(AContext: TIdContext; request: TIdHTTPRequestInfo; session : TFhirSession; response: TIdHTTPResponseInfo; secure : boolean) : String;
var
  path : string;
begin
  path := request.Document;
  if path.StartsWith('/snomed') and (FServer.CommonTerminologies.Snomed <> nil) then
    result := HandleSnomedRequest(AContext, request, response)
  else if request.Document.StartsWith('/loinc') and (FServer.CommonTerminologies.Loinc <> nil) then
    result := HandleLoincRequest(AContext, request, response)
end;

function TTerminologyWebServer.ProcessHome(AContext: TIdContext; request: TIdHTTPRequestInfo; response: TIdHTTPResponseInfo; session : TFhirSession) : string;
var
  pm: THTTPParameters;
  vars : TFslMap<TFHIRObject>;
begin
  result := 'Tx Server Home';
  vars := TFslMap<TFHIRObject>.create('tx.vars');
  try
    pm := THTTPParameters.create(request.UnparsedParams);
    try
      vars.Add('prefix', FWorker.Factory.makeString(FServer.WebBase));

      vars.Add('param.system', FWorker.Factory.makeString(pm['system']));
      vars.Add('param.version', FWorker.Factory.makeString(pm['version']));
      vars.Add('param.code', FWorker.Factory.makeString(pm['code']));
      vars.Add('param.display', FWorker.Factory.makeString(pm['display']));
      vars.Add('param.filter', FWorker.Factory.makeString(pm['filter']));
      vars.Add('valuesetlist', FWorker.Factory.makeString(vsSelect(pm['valueset'])));
      if pm['nodetails'] = '1' then
        vars.Add('param.nodetails', FWorker.Factory.makeString(' checked'))
      else
        vars.Add('param.nodetails', FWorker.Factory.makeString(''));
      if pm['abstract'] = '1' then
        vars.Add('param.abstract', FWorker.Factory.makeString(' checked'))
      else
        vars.Add('param.abstract', FWorker.Factory.makeString(''));

      vars.Add('find.results', FWorker.Factory.makeString(''));
      vars.Add('validate.results', FWorker.Factory.makeString(''));
      vars.Add('expand.results', FWorker.Factory.makeString(''));
      vars.Add('translate.results', FWorker.Factory.makeString(''));

      if pm['op'] = 'find' then
        vars['find.results'] := FWorker.Factory.makeString(processFind(pm))
      else if pm['op'] = 'validate' then
        vars['validate.results'] := FWorker.Factory.makeString(processValidate(pm))
      else if pm['op'] = 'expand' then
        vars['expand.results'] := FWorker.Factory.makeString(processExpand(pm, THTTPLanguages.Create(request.AcceptLanguage)))
      else if pm['op'] = 'translate' then
        vars['translate.results'] := FWorker.Factory.makeString(processTranslate(pm));

      FReturnProcessFileEvent(request, response, session, request.Document, 'txhome.html', false, vars);
    finally
      pm.Free;
    end;
  finally
    vars.Free;
  end;
end;

function TTerminologyWebServer.ProcessConceptMap(AContext: TIdContext; request: TIdHTTPRequestInfo; response: TIdHTTPResponseInfo; session : TFhirSession) : string;
var
  cm: TLoadedConceptMap;
  vars : TFslMap<TFHIRObject>;
begin
  result := 'Concept Map '+request.Document.Substring(9);
  vars := TFslMap<TFHIRObject>.create('tx.vars');
  try
    cm := FServer.getConceptMapById(request.Document.Substring(9));
    try
      vars.Add('url', FWorker.Factory.makeString(cm.resource.url));
      vars.Add('name', FWorker.Factory.makeString(cm.resource.name));
      vars.Add('html', FWorker.Factory.makeString(ashtml(cm.resource.Resource)));
      vars.Add('json', FWorker.Factory.makeString(asJson(cm.resource.Resource)));
      vars.Add('xml', FWorker.Factory.makeString(asXml(cm.resource.Resource)));
    finally
      cm.Free;
    end;
    FReturnProcessFileEvent(request, response, session, request.Document, 'tx-cm-id.html', false, vars);
  finally
    vars.Free;
  end;
end;

function TTerminologyWebServer.ProcessValueSet(AContext: TIdContext; request: TIdHTTPRequestInfo; response: TIdHTTPResponseInfo; session : TFhirSession) : String;
var
  vs: TFhirValueSetW;
  vars : TFslMap<TFHIRObject>;
begin
  result := 'Value Set '+request.Document.Substring(14);
  vars := TFslMap<TFHIRObject>.create('tx.vars');
  try
    vs := FServer.getValueSetById(request.Document.Substring(14));
    try
      vars.Add('url', FWorker.Factory.makeString(vs.url));
      vars.Add('name', FWorker.Factory.makeString(vs.name));
      vars.Add('html', FWorker.Factory.makeString(ashtml(vs.Resource)));
      vars.Add('json', FWorker.Factory.makeString(asJson(vs.Resource)));
      vars.Add('xml', FWorker.Factory.makeString(asXml(vs.Resource)));
    finally
      vs.Free;
    end;
    FReturnProcessFileEvent(request, response, session, request.Document, 'tx-vs-id.html', false, vars);
  finally
    vars.Free;
  end;
end;

function TTerminologyWebServer.ProcessCodeSystem(AContext: TIdContext; request: TIdHTTPRequestInfo; response: TIdHTTPResponseInfo; session : TFhirSession) : String;
var
  cs: TFhirCodeSystemW;
  vars : TFslMap<TFHIRObject>;
begin
  result := 'Code System '+request.Document.Substring(16);
  vars := TFslMap<TFHIRObject>.create('tx.vars');
  try
    cs := FServer.getCodeSystemById(request.Document.Substring(16));
    try
      vars.Add('url', FWorker.Factory.makeString(cs.url));
      vars.Add('name', FWorker.Factory.makeString(cs.name));
      vars.Add('html', FWorker.Factory.makeString(ashtml(cs.Resource)));
      vars.Add('json', FWorker.Factory.makeString(asJson(cs.Resource)));
      vars.Add('xml', FWorker.Factory.makeString(asXml(cs.Resource)));
    finally
      cs.Free;
    end;
    FReturnProcessFileEvent(request, response, session, request.Document, 'tx-cs-id.html', false, vars);
  finally
    vars.Free;
  end;
end;

function TTerminologyWebServer.ProcessCodeSystemProviderList(AContext: TIdContext; request: TIdHTTPRequestInfo; response: TIdHTTPResponseInfo; session : TFhirSession) : String;
var
  html: THtmlPublisher;
  cs: TCodeSystemProvider;
  c: Integer;
  vars : TFslMap<TFHIRObject>;
begin
  result := 'Code System List';
  vars := TFslMap<TFHIRObject>.create('tx.vars');
  try
    html := THtmlPublisher.Create(FWorker.Factory.link);
    try
      html.Version := SERVER_VERSION;
      html.StartTable(true);
      html.StartTableRow;
      html.AddTableCell('URL', true);
      html.AddTableCell('Version', true);
      html.AddTableCell('Name', true);
      html.AddTableCell('#concepts', true);
      html.EndTableRow;
      for cs in FServer.ProviderClasses.Values do
      begin
        html.StartTableRow;
        html.AddTableCell(cs.system(nil));
        html.AddTableCell(cs.version(nil));
        html.AddTableCell(cs.name(nil));
        c := cs.TotalCount;
        if c > 0 then
          html.AddTableCell(inttostr(c))
        else
          html.AddTableCell('');
        html.EndTableRow;
      end;
      html.EndTable;
      vars.Add('table', FWorker.Factory.makeString(html.output));
      vars.add('kind', FWorker.Factory.makeString('Implicit Code System'));
    finally
      html.Free;
    end;
    FReturnProcessFileEvent(request, response, session, request.Document, 'tx-vs.html', false, vars);
  finally
    vars.Free;
  end;
end;

function TTerminologyWebServer.ProcessCodeSystemList(AContext: TIdContext; request: TIdHTTPRequestInfo; response: TIdHTTPResponseInfo; session : TFhirSession) : String;
var
  list: TFslList<TFHIRCodeSystemW>;
  vs: TFhirCodeSystemW;
  vars : TFslMap<TFHIRObject>;
  html : THtmlPublisher;
begin
  result := 'Code System List';
  vars := TFslMap<TFHIRObject>.create('tx.vars');
  try
    list := TFslList<TFHIRCodeSystemW>.create;
    try
      FServer.GetCodeSystemList(list);
      if (request.UnparsedParams.EndsWith('=ver')) then
        FCSSorter.FSortType := byVer
      else if (request.UnparsedParams.EndsWith('=name')) then
        FCSSorter.FSortType := byName
      else if (request.UnparsedParams.EndsWith('=ctxt')) then
        FCSSorter.FSortType := byContext
      else if (request.UnparsedParams.EndsWith('=pub')) then
        FCSSorter.FSortType := byPub
      else
        FCSSorter.FSortType := byUrl;
      list.Sort(FCSSorter);

      html := THtmlPublisher.Create(FWorker.Factory.link);
      try
        html.Version := SERVER_VERSION;
        html.StartTable(true);
        html.StartTableRow;
        html.AddTableCellURL('URL', '/tx/codesystems?sort=url');
        html.AddTableCellURL('Version', '/tx/codesystems?sort=ver');
        html.AddTableCellURL('Name', '/tx/codesystems?sort=name');
        html.AddTableCellURL('Context', '/tx/codesystems?sort=ctxt');
        html.AddTableCellURL('Publisher', '/tx/codesystems?sort=pub');
        html.EndTableRow;
        for vs in list do
        begin
          html.StartTableRow;
          html.AddTableCellURL(vs.url, '/tx/codesystems/' + vs.id);
          html.AddTableCell(vs.version);
          html.AddTableCell(vs.name);
//          html.AddTableCell(vs.context);
//          html.AddTableCell(vs.publisher);
          html.EndTableRow;
        end;
        html.EndTable;
        vars.Add('table', FWorker.Factory.makeString(html.output));
        vars.add('kind', FWorker.Factory.makeString('Code System'));
      finally
        html.Free;
      end;
    finally
      list.free;
    end;
    FReturnProcessFileEvent(request, response, session, request.Document, 'tx-vs.html', false, vars);
  finally
    vars.Free;
  end;
end;

function TTerminologyWebServer.ProcessConceptMapList(AContext: TIdContext; request: TIdHTTPRequestInfo; response: TIdHTTPResponseInfo; session : TFhirSession) : String;
var
  mlist: TLoadedConceptMapList;
  i: Integer;
  vars : TFslMap<TFHIRObject>;
  html : THtmlPublisher;
  cm : TLoadedConceptMap;
begin
  result := 'Concept Map List';
  vars := TFslMap<TFHIRObject>.create('tx.vars');
  try
    mlist := FServer.GetConceptMapList;
    try
      // determine sort order
      if (request.UnparsedParams.EndsWith('=ver')) then
        mlist.SortedBy(sortCmByVer)
      else if (request.UnparsedParams.EndsWith('=name')) then
        mlist.SortedBy(sortCmByName)
      else if (request.UnparsedParams.EndsWith('=ctxt')) then
        mlist.SortedBy(sortCmByCtxt)
      else if (request.UnparsedParams.EndsWith('=pub')) then
        mlist.SortedBy(sortCmByPub)
      else if (request.UnparsedParams.EndsWith('=src')) then
        mlist.SortedBy(sortCmBySrc)
      else if (request.UnparsedParams.EndsWith('=tgt')) then
        mlist.SortedBy(sortCmByTgt)
      else
        mlist.SortedBy(sortCmByUrl);
      // build the table
      html := THtmlPublisher.Create(FWorker.Factory.link);
      try
        html.Version := SERVER_VERSION;
        html.StartTable(true);
        html.StartTableRow;
        html.AddTableCellURL('URL', '/tx/maps?sort=url');
        html.AddTableCellURL('Version', '/tx/maps?sort=ver');
        html.AddTableCellURL('Name', '/tx/maps?sort=name');
        html.AddTableCellURL('Context', '/tx/maps?sort=ctxt');
        html.AddTableCellURL('Publisher', '/tx/maps?sort=pub');
        html.AddTableCellURL('Source', '/tx/maps?sort=src');
        html.AddTableCellURL('Target', '/tx/maps?sort=tgt');
        html.EndTableRow;
        for i := 0 to mlist.Count - 1 do
        begin
          cm := mlist[i];
          html.StartTableRow;
          html.AddTableCellURL(cm.Resource.url, '/tx/maps/' + cm.Resource.id);
          html.AddTableCell(cm.Resource.version);
          html.AddTableCell(cm.Resource.name);
          html.AddTableCell(cm.Resource.context);
          html.AddTableCell(cm.Resource.publisher);
          if cm.Source <> nil then
            html.AddTableCellURL(cm.Source.url, '/tx/valuesets/' + cm.Source.id)
          else
            html.AddTableCell(cm.Resource.sourceDesc);
          if cm.Target <> nil then
            html.AddTableCellURL(cm.Target.url, '/tx/valuesets/' + cm.Target.id)
          else
            html.AddTableCell(cm.Resource.targetDesc);
          html.EndTableRow;
        end;
        html.EndTable;
        vars.add('kind', FWorker.Factory.makeString('Concept Map'));
        vars.Add('table', FWorker.Factory.makeString(html.output));
      finally
        html.Free;
      end;
    finally
      mlist.free;
    end;
    FReturnProcessFileEvent(request, response, session, request.Document, 'tx-vs.html', false, vars);
  finally
    vars.Free;
  end;
end;

function TTerminologyWebServer.processExpand(pm: THTTPParameters; const lang : THTTPLanguages): String;
var
  res : TFHIRValueSetW;
  vs : TFHIRValueSetW;
  profile : TFhirExpansionParams;
begin
  vs := FServer.getValueSetById(pm['valueset']);
  profile := TFhirExpansionParams.Create;
  try
    profile.includeDefinition := pm['nodetails'] <> '1';
    profile.limitedExpansion := true;
    if lang.header <> '' then
      profile.displayLanguage := lang;

    try
      res := FServer.expandVS(vs, vs.url, profile, pm['filter'], 1000, 0, 0);
      try
        result := asHtml(res.Resource)+#13#10;
//        if (not profile.includeDefinition) then
//          res.text := nil;
        result := result + '<pre class="json">'+asJson(res.Resource)+'</pre>'#13#10+'<pre class="xml">'+asXml(res.Resource)+'</pre>';
      finally
        res.Free;
      end;
    except
      on e : Exception do
        result := '<div style="background: salmon">'+e.message+'</div>';
    end;
  finally
    vs.Free;
    profile.Free;
  end;
end;

function TTerminologyWebServer.processFind(pm: THTTPParameters): String;
var
  coding : TFHIRCodingW;
  resp : TFHIRLookupOpResponseW;
  p : TFhirResourceV;
begin
  coding := FWorker.Factory.wrapCoding(FWorker.Factory.makeByName('Coding'));
  try
    coding.system := pm['system'];
    coding.version := pm['version'];
    coding.code := pm['code'];
    resp := FWorker.Factory.makeOpRespLookup;
    try
      try
        FServer.lookupCode(coding, THTTPLanguages.create('en'), nil, resp);
        p := resp.asParams;
        try
          result := '<div>'+paramsAsHtml(p)+'</div>'#13 +
            #10'<pre class="json">'+asJson(p)+'</pre>'#13#10+'<pre class="xml">'+asXml(p)+'</pre>'
        finally
          p.Free;
        end;
      except
        on e : exception do
          result := '<div>'+e.message+'</div>'#13;
      end;
    finally
      resp.Free;
    end;
  finally
    coding.Free;
  end;
end;

function TTerminologyWebServer.ProcessValueSetList(AContext: TIdContext; request: TIdHTTPRequestInfo; response: TIdHTTPResponseInfo; session : TFhirSession) : String;
var
  vs: TFhirValueSetW;
  vars : TFslMap<TFHIRObject>;
  list : TFslList<TFhirValueSetW>;
  html : THtmlPublisher;
begin
  result := 'Value Set List';
  vars := TFslMap<TFHIRObject>.create('tx.vars');
  try
    list := TFslList<TFhirValueSetW>.create;
    try
      FServer.GetValueSetList(list);
      // determine sort order
      if (request.UnparsedParams.EndsWith('=ver')) then
        FVSSorter.FSortType := byVer
      else if (request.UnparsedParams.EndsWith('=name')) then
        FVSSorter.FSortType := byName
      else if (request.UnparsedParams.EndsWith('=ctxt')) then
        FVSSorter.FSortType := byContext
      else if (request.UnparsedParams.EndsWith('=pub')) then
        FVSSorter.FSortType := byPub
      else if (request.UnparsedParams.EndsWith('=src')) then
        FVSSorter.FSortType := bySource
      else
        FVSSorter.FSortType := byUrl;
      list.Sort(FVSSorter);

      // build the table
      html := THtmlPublisher.Create(FWorker.Factory.link);
      try
        html.Version := SERVER_VERSION;
        html.StartTable(true);
        html.StartTableRow;
        html.AddTableCellURL('URL', '/tx/valuesets?sort=url');
        html.AddTableCellURL('Version', '/tx/valuesets?sort=ver');
        html.AddTableCellURL('Name', '/tx/valuesets?sort=name');
        html.AddTableCellURL('Context', '/tx/valuesets?sort=ctxt');
        html.AddTableCellURL('Publisher', '/tx/valuesets?sort=pub');
        html.AddTableCellURL('Source', '/tx/valuesets?sort=src');
        html.EndTableRow;
        for vs in list do
        begin
          html.StartTableRow;
          html.AddTableCellURL(vs.url, '/tx/valuesets/' + vs.id);
          html.AddTableCell(vs.version);
          html.AddTableCell(vs.name);
          html.AddTableCell(vs.context);
          html.AddTableCell(vs.publisher);
          html.AddTableCell(vs.source);
          html.EndTableRow;
        end;
        html.EndTable;
        vars.add('kind', FWorker.Factory.makeString('Value Set'));
        vars.Add('table', FWorker.Factory.makeString(html.output));
      finally
        html.Free;
      end;
    finally
      list.free;
    end;
    FReturnProcessFileEvent(request, response, session, request.Document, 'tx-vs.html', false, vars);
  finally
    vars.Free;
  end;
end;

function GetId(url, prefix : string) : String;
begin
  if length(url) <= length(prefix) then
    result := ''
  else
    result := url.Substring(length(prefix)+1);
end;



function TTerminologyWebServer.HandleTxForm(AContext: TIdContext; request: TIdHTTPRequestInfo; session : TFhirSession; response: TIdHTTPResponseInfo; secure : boolean) : String;
{var
  vs : String;
  vars : TFslMap<TFHIRObject>;
  list : TFslStringMatch;
  ts : TStringList;
  i : integer;
  }
begin
  result := 'Tx Form - Disabled';
{  vars := TFslMap<TFHIRObject>.create('tx.vars');
  try
    vs := '';

    ts := TStringList.Create;
    list := FServer.GetValueSetList;
    try
      for i := 0 to list.Count - 1 do
        ts.AddObject(list.ValueByIndex[i], TObject(i));
      ts.sort;
      for i := 0 to ts.Count - 1 do
        vs := vs + ' <option value="'+list.KeyByIndex[Integer(ts.Objects[i])]+'">'+ts[i]+'</option>';
    finally
      list.Free;
      ts.Free;
    end;

    vars.Add('vslist', vs);
    FReturnProcessFileEvent(response, session, '/tx/form', IncludeTrailingPathDelimiter(FWebDir)+'txform.html', secure, vars);
  finally
    vars.free;
  end;}
end;

function TTerminologyWebServer.HandleTxRequest(AContext: TIdContext; request: TIdHTTPRequestInfo; response: TIdHTTPResponseInfo; session : TFhirSession) : string;
begin
  if request.Document = '/tx/valuesets' then
    result := ProcessValueSetList(AContext, request, response, session)
  else if request.Document = '/tx/maps' then
    result := ProcessConceptMapList(AContext, request, response, session)
  else if request.Document = '/tx/codesystems' then
    result := ProcessCodeSystemList(AContext, request, response, session)
  else if request.Document = '/tx/codesystemproviders' then
    result := ProcessCodeSystemProviderList(AContext, request, response, session)
  else if request.Document.StartsWith('/tx/valuesets/') then
    result := ProcessValueSet(AContext, request, response, session)
  else if request.Document.StartsWith('/tx/codesystems/') then
    result := ProcessCodeSystem(AContext, request, response, session)
  else if request.Document.StartsWith('/tx/maps/') then
    result := ProcessConceptMap(AContext, request, response, session)
  else
    result := ProcessHome(AContext, request, response, session);
end;

function TTerminologyWebServer.paramsAsHtml(p: TFhirResourceV): String;
var
  pw : TFHIRParametersW;
begin
  pw := FWorker.Factory.wrapParams(p.Link);
  try
    result := paramsAsHtml(pw);
  finally
    pw.free;
  end;
end;
function TTerminologyWebServer.paramsAsHtml(p: TFhirParametersW): String;
var
  html : THtmlPublisher;
  pp : TFhirParametersParameterW;
begin
  html := THtmlPublisher.Create(FWorker.Factory.link);
  try
    html.Version := SERVER_VERSION;
    html.StartTable(true);
    for pp in p.parameterList do
    begin
      html.StartTableRow;
      html.AddTableCell(pp.name);
      html.AddTableCell(pp.value.toString);
      html.EndTableRow;
    end;
    html.EndTable;
    result := html.output;
  finally
    html.Free;
  end;
end;

function TTerminologyWebServer.asHtml(r: TFHIRResourceV): String;
begin
  if (FWorker.factory.getXhtml(r) <> nil) then
    result := TFHIRXhtmlParser.Compose(FWorker.factory.getXhtml(r))
  else
    result := '<i>(no narrative)</i>';
end;

function TTerminologyWebServer.asJson(r: TFHIRResourceV): String;
var
  json : TFHIRComposer;
  b : TBytesStream;
begin
  b := TBytesStream.Create();
  try
    json := FWorker.factory.makeComposer(FWorker.link, ffJson, THTTPLanguages.create('en'), OutputStylePretty);
    try
      json.Compose(b, r);
    finally
      json.Free;
    end;
    result := FormatTextToXml(TEncoding.UTF8.GetString(b.Bytes, 0, b.size), xmlText);
  finally
    b.Free;
  end;
end;

function TTerminologyWebServer.asXml(r: TFHIRResourceV): String;
var
  xml : TFHIRComposer;
  b : TBytesStream;
begin
  b := TBytesStream.Create();
  try
    xml := FWorker.factory.makeComposer(FWorker.link, ffXMl, THTTPLanguages.create('en'), OutputStylePretty);
    try
      xml.Compose(b, r);
    finally
      xml.Free;
    end;
    result := FormatTextToXml(TEncoding.UTF8.GetString(b.Bytes, 0, b.size), xmlText);
  finally
    b.Free;
  end;
end;

//Procedure TTerminologyWebServer.BuildCsByName(html : THtmlPublisher; id : String);
//{var
//  list : TFslStringMatch;
//  ts : TStringList;
//  i: Integer;}
//begin
//{  logt('Tx: CS By Name '+Id);
//  ts := TStringList.Create;
//  list := FServer.GetCodeSystemList;
//  try
//    html.Header('Terminology Server');
//    html.Heading(2, 'CodeSystems');
//    html.StartList;
//
//    for i := 0 to list.Count - 1 do
//      ts.AddObject(list.ValueByIndex[i], TObject(i));
//    ts.sort;
//    for i := 0 to ts.Count - 1 do
//    begin
//      html.StartListItem;
//      html.URL(ts[i], 'tx/cs/'+list.KeyByIndex[Integer(ts.Objects[i])]);
//      html.EndListItem;
//    end;
//  finally
//    list.Free;
//    ts.Free;
//  end;
//  html.EndList; }
//end;
//
//Procedure TTerminologyWebServer.BuildCsByURL(html : THtmlPublisher; id : String);
//{var
//  list : TFslStringMatch;
//  ts : TStringList;
//  i: Integer; }
//begin
//{  logt('Tx: CS By URL '+Id);
//  ts := TStringList.Create;
//  list := FServer.GetCodeSystemList;
//  try
//    html.Header('Terminology Server');
//    html.Heading(2, 'Code Systems (by URL)');
//    html.StartList;
//    for i := 0 to list.Count - 1 do
//      ts.AddObject(list.KeyByIndex[i], TObject(i));
//    ts.sort;
//    for i := 0 to ts.Count - 1 do
//    begin
//      html.StartListItem;
//      html.URL(ts[i], 'tx/cs/'+ts[i]);
//      html.AddTextPlain(': '+list.ValueByIndex[Integer(ts.Objects[i])]);
//      html.EndListItem;
//    end;
//  finally
//    list.Free;
//    ts.Free;
//  end;
//  html.EndList;}
//end;
//
//Procedure TTerminologyWebServer.BuildVsByName(html : THtmlPublisher; id : String);
//{var
//  list : TFslStringMatch;
//  ts : TStringList;
//  i: Integer;
//  }
//begin
//{  logt('Tx: VS By Name '+Id);
//  ts := TStringList.Create;
//  list := FServer.GetValueSetList;
//  try
//    html.Header('Terminology Server');
//    html.Heading(2, 'Value Sets (By Name)');
//    html.StartList;
//    for i := 0 to list.Count - 1 do
//      ts.AddObject(list.ValueByIndex[i], TObject(i));
//    ts.sort;
//    for i := 0 to ts.Count - 1 do
//    begin
//      html.StartListItem;
//      html.URL(ts[i], 'tx/vs/'+list.KeyByIndex[Integer(ts.Objects[i])]);
//      html.EndListItem;
//    end;
//  finally
//    list.Free;
//    ts.Free;
//  end;
//  html.EndList;}
//end;
//
//Procedure TTerminologyWebServer.BuildVsByURL(html : THtmlPublisher; id : String);
////var
////  list : TFslStringMatch;
////  ts : TStringList;
////  i: Integer;
////  vs : TFHIRValueSet;
////  xml : TFHIRXmlComposer;
////  s : TStringStream;
//begin
//{  logt('Tx: VS By URL '+Id);
//  html.Header('Terminology Server');
//  html.Heading(2, 'Value Sets (By URL)');
//  if (id <> '') then
//  begin
//    vs := FServer.getValueSetByUrl(id);
//    if (vs.text <> nil) and (vs.text.div_ <> nil) then
//    begin
//      html.writeXhtml(vs.text.div_);
//      html.Line;
//    end;
//    s := TStringStream.Create;
//    xml := TFHIRXmlComposer.Create(THTTPLanguages.create('en'));
//    try
//      xml.Compose(s, vs, true, nil);
//      html.startPre;
//      html.AddTextPlain(s.DataString);
//      html.endPre;
//    finally
//      xml.Free;
//      s.Free;
//    end;
//  end
//  else
//  begin
//    ts := TStringList.Create;
//    list := FServer.GetValueSetList;
//    try
//      html.StartList;
//      for i := 0 to list.Count - 1 do
//        ts.AddObject(list.KeyByIndex[i], TObject(i));
//      ts.sort;
//      for i := 0 to ts.Count - 1 do
//      begin
//        html.StartListItem;
//        html.URL(ts[i], 'vs-uri/'+EncodeMime(ts[i]));
//        html.AddTextPlain(': '+list.ValueByIndex[Integer(ts.Objects[i])]);
//        html.EndListItem;
//      end;
//    finally
//      list.Free;
//      ts.Free;
//    end;
//  end;
//  html.EndList;}
//end;

function TTerminologyWebServer.HandleSnomedRequest(AContext: TIdContext; request: TIdHTTPRequestInfo; response: TIdHTTPResponseInfo) : String;
var
  code : String;
  pub : TSnomedPublisher;
  html : THtmlPublisher;
  analysis : TSnomedAnalysis;
  parts : TArray<String>;
  ss, t : TSnomedServices;
  pm : THTTPParameters;
  buf : TFslNameBuffer;
begin
  if request.Document.StartsWith('/snomed/tool/') then // FHIR build process support
  begin
    parts := request.Document.Split(['/']);
    ss := nil;
    for t in FServer.CommonTerminologies.Snomed do
      if t.EditionId = parts[length(parts)-2] then
        ss := t;
    if ss = nil then
    begin
      response.ResponseNo := 404;
      response.ContentText := 'Document '+request.Document+' not found';
      result := 'miss: '+request.Document;
    end
    else
    begin
      ss.RecordUse;
      result := 'Snomed Tool: '+parts[length(parts)-1];
      response.ContentType := 'text/xml';
      try
        response.ContentText := processSnomedForTool(ss, parts[length(parts)-1]);
        response.ResponseNo := 200;
      except
        on e : Exception do
        begin
          response.ResponseNo := 500;
          response.ContentText := '<snomed version="'+FServer.CommonTerminologies.DefSnomed.VersionDate+'" type="error" message="'+FormatTextToXml(e.Message, xmlAttribute)+'"/>';
        end;
      end;
    end;
  end
  else if request.Document.StartsWith('/snomed/analysis/')  then
  begin
    result := 'Snomed Analysis';
    FServer.CommonTerminologies.DefSnomed.RecordUse;
    analysis := TSnomedAnalysis.create(FServer.CommonTerminologies.DefSnomed.Link);
    try
      pm := THTTPParameters.create(request.UnparsedParams);
      try
        buf := analysis.generate(pm);
        try
          response.ContentType := buf.Name;
          response.ContentStream := TBytesStream.Create(buf.AsBytes);
          response.FreeContentStream := true;
        finally
          buf.free;
        end;
      finally
        pm.Free;
      end;
      response.ResponseNo := 200;
    finally
      analysis.free;
    end;
  end
  else if request.Document.StartsWith('/snomed/doco') then
  begin
    response.ContentText := chooseSnomedRelease();
    response.ResponseNo := 200;
    result := 'Snomed - choose version';
  end
  else if request.Document.StartsWith('/snomed/') then
  begin
    parts := request.Document.Split(['/']);
    ss := nil;
    for t in FServer.CommonTerminologies.Snomed do
      if t.EditionId = parts[2] then
        ss := t;
    if ss = nil then
    begin
      response.ResponseNo := 404;
      response.ContentText := 'Document '+request.Document+' not found';
      result := 'Snomed: miss '+request.Document;
    end
    else
    begin
      ss.RecordUse;
      code := request.UnparsedParams;
      result := 'Snomed Doco ('+ss.EditionName+'): '+code;

      try
        html := THtmlPublisher.Create(FWorker.factory.link);
        pub := TSnomedPublisher.create(ss, FFHIRPath);
        try
          html.Version := SERVER_VERSION;
          html.BaseURL := '/snomed/'+ss.EditionId+'/';
          html.Lang := THTTPLanguages.Create(request.AcceptLanguage);
          pub.PublishDict(code, '/snomed/'+ss.EditionId+'/', html);
          response.ContentText := html.output;
          response.ResponseNo := 200;
        finally
          html.free;
          pub.free;
        end;
      except
        on e:exception do
        begin
          response.ResponseNo := 500;
          response.ContentText := 'error:'+FormatTextToXml(e.Message, xmlText);
        end;
      end;
    end;
  end
  else
  begin
    response.ResponseNo := 404;
    response.ContentText := 'Document '+request.Document+' not found';
    result := 'Snomed: miss: '+request.Document;
  end;
end;

function TTerminologyWebServer.HandleLoincRequest(AContext: TIdContext; request: TIdHTTPRequestInfo; response: TIdHTTPResponseInfo) : string;
var
  code, lang, country : String;
  pub : TLoincPublisher;
  html : THtmlPublisher;
  mem : TMemoryStream;
  op : TBytes;
  i : integer;
  st : TStringList;
begin
  FServer.CommonTerminologies.Loinc.RecordUse;
  if request.Document.StartsWith('/loinc/doco/') then
  begin
    code := request.UnparsedParams;
    lang := request.Document.Substring(12);
    result := 'Loinc doco '+request.UnparsedParams+' ('+request.Document.Substring(12)+')';
    if ((lang = '') and (code = '')) or ((lang <> '') and not FServer.CommonTerminologies.Loinc.supportsLang(THTTPLanguages.create(lang))) then
    begin
      st := TStringList.create;
      try
        for i := 0 to FServer.CommonTerminologies.Loinc.Lang.count - 1 do
        begin
          FServer.CommonTerminologies.Loinc.Lang.GetEntry(i, lang, country);
          st.add(lang+'-'+country);
        end;
        st.sort;
        html := THtmlPublisher.Create(FWorker.factory.link);
        try
          html.Version := SERVER_VERSION;
          html.BaseURL := '/loinc/doco/';
          html.Lang := THTTPLanguages.create(lang);
          html.Header('LOINC Languages');
          html.StartList();
          for i := 0 to st.count - 1 do
          begin
            html.StartListItem;
            html.URL(st[i], st[i]);
            html.EndListItem;
          end;
          html.EndList();
          mem := TMemoryStream.Create;
          response.ContentStream := mem;
          response.FreeContentStream := true;
          op := TEncoding.UTF8.GetBytes(html.output);
          mem.Write(op, 0, length(op));
          mem.Position := 0;
          response.ContentType := 'text/html; charset=utf-8';
          response.ResponseNo := 200;
        finally
          html.free;
        end;
      finally
        st.free;
      end;
    end
    else
    begin
      result := 'Loinc Doco: '+code;
      try
        html := THtmlPublisher.Create(FWorker.factory.link);
        pub := TLoincPublisher.create(FServer.CommonTerminologies.Loinc, FFHIRPath, THTTPLanguages.Create(lang));
        try
          html.Version := SERVER_VERSION;
          html.BaseURL := '/loinc/doco/'+lang;
          html.Lang := THTTPLanguages.Create(Lang);
          pub.PublishDict(code, '/loinc/doco/'+lang, html);
          mem := TMemoryStream.Create;
          response.ContentStream := mem;
          response.FreeContentStream := true;
          op := TEncoding.UTF8.GetBytes(html.output);
          mem.Write(op, 0, length(op));
          mem.Position := 0;
          response.ContentType := 'text/html; charset=utf-8';
          response.ResponseNo := 200;
        finally
          html.free;
          pub.free;
        end;
      except
        on e:exception do
        begin
          response.ResponseNo := 500;
          response.ContentText := 'error:'+FormatTextToXml(e.Message, xmlText);
        end;
      end;
    end;
  end
  else
  begin
    response.ResponseNo := 404;
    response.ContentText := 'Document '+request.Document+' not found';
    result := ('Loinc : miss '+request.Document);
  end;
end;

function TTerminologyWebServer.processSnomedForTool(ss : TSnomedServices; code : String) : String;
var
  sl : TStringList;
  s : String;
  id : UInt64;
  exp : TSnomedExpression;
  index : cardinal;
begin
  if StringIsInteger64(code) then
  begin
    if ss.ConceptExists(code, index) then
    begin
      result := '<snomed version="'+ss.VersionDate+'" type="concept" concept="'+code+
       '" display="'+FormatTextToXml(ss.GetDisplayName(code, ''), xmlAttribute)+
       '" active="'+booleanToString(ss.isActive(index))+'">';
      sl := TStringList.Create;
      try
        ss.ListDisplayNames(sl, code, '', ALL_DISPLAY_NAMES);
        for s in sl do
          result := result + '<display value="'+FormatTextToXml(s, xmlAttribute)+'"/>';
      finally
        sl.free;
      end;
      result := result + '</snomed>';
    end
    else if ss.IsValidDescription(code, id, s) then
    begin
      result := '<snomed version="'+ss.VersionDate+'" type="description" description="'+code+'" concept="'+inttostr(id)+'" display="'+FormatTextToXml(s, xmlAttribute)+'">';
      sl := TStringList.Create;
      try
        ss.ListDisplayNames(sl, inttostr(id), '', ALL_DISPLAY_NAMES);
        for s in sl do
          result := result + '<display value="'+FormatTextToXml(s, xmlAttribute)+'"/>';
      finally
        sl.free;
      end;
      result := result + '</snomed>';
    end
    else
      result := '<snomed version="'+ss.VersionDate+'" description="Snomed ID '+code+' not known"/>';
  end
  else
  begin
    exp := ss.parseExpression(code);
    try
      result := '<snomed version="'+ss.VersionDate+'" type="expression" expression="'+code+'" expressionMinimal="'+FormatTextToXml(ss.renderExpression(exp, sroMinimal), xmlAttribute)+'" expressionMax="'+
      FormatTextToXml(ss.renderExpression(exp, sroReplaceAll), xmlAttribute)+'" display="'+FormatTextToXml(ss.displayExpression(exp), xmlAttribute)+'" ok="true"/>';
    finally
      exp.Free;
    end;
  end;
end;


function TTerminologyWebServer.processTranslate(pm: THTTPParameters): String;
var
  res : TFhirParametersW;
  vs : TFHIRValueSetW;
  coding : TFhirCodingW;
begin
  vs := FServer.getValueSetById(pm['valueset']); // this is the target
  try
    coding := FWorker.factory.wrapCoding(FWorker.factory.makeByName('Coding'));
    try
      coding.system := pm['system'];
      coding.version := pm['version'];
      coding.code := pm['code'];
      try
        res := FServer.translate(THTTPLanguages.create('en'), nil, coding, vs);
        try
          result := paramsAsHtml(res)+#13#10 + '<pre class="json">'+asJson(res.Resource)+'</pre>'#13#10+'<pre class="xml">'+asXml(res.Resource)+'</pre>';
        finally
          res.Free;
        end;
      except
        on e : Exception do
          result := '<div style="background: salmon">'+e.message+'</div>';
      end;
    finally
      coding.free;
    end;
  finally
    vs.Free;
  end;
end;

function TTerminologyWebServer.processValidate(pm: THTTPParameters): String;
var
  coding : TFHIRCodingW;
  res : TFHIRParametersW;
  vs : TFHIRValueSetW;
begin
  vs := FServer.getValueSetById(pm['valueset']);
  try
    coding := FWorker.factory.wrapCoding(FWorker.factory.makeByName('Coding'));
    try
      coding.system := pm['system'];
      coding.version := pm['version'];
      coding.code := pm['code'];
      coding.display := pm['display'];
      res := FServer.validate(vs, coding, nil, pm['abstract'] = '1', pm['implySystem'] = '1');
      try
        result := '<div>'+paramsAsHtml(res)+'</div>'#13 +
            #10'<pre class="json">'+asJson(res.Resource)+'</pre>'#13#10+'<pre class="xml">'+asXml(res.Resource)+'</pre>'
      finally
        res.Free;
      end;
    finally
      coding.Free;
    end;
  finally
    vs.Free;
  end;
end;


function TTerminologyWebServer.vsSelect(id: String): String;
var
  vs: TFhirValueSetW;
  list : TFslList<TFhirValueSetW>;
  s : String;
begin
  list := TFslList<TFhirValueSetW>.create;
  try
    FServer.GetValueSetList(list);
    // determine sort order
    FVSSorter.FSortType := byName;
    list.Sort(FVSSorter);
    s := '<select name="valueset" size="1">'#13#10;
    for vs in list do
      if (vs.id = id) then
        s := s + ' <option value="'+vs.id+'" selected>'+vs.name+'</option>'#13#10
      else
        s := s + ' <option value="'+vs.id+'">'+vs.name+'</option>'#13#10;
    s := s + '</select>'#13#10;
    result := s;
  finally
    list.free;
  end;
end;

function TTerminologyWebServer.sortCmByCtxt(pA, pB: Pointer): Integer;
var
  vA, vB : TLoadedConceptMap;
begin
  vA := TLoadedConceptMap(pA);
  vB := TLoadedConceptMap(pB);
  result := CompareStr(vA.Resource.context, vb.Resource.context);
end;

function TTerminologyWebServer.sortCmByName(pA, pB: Pointer): Integer;
var
  vA, vB : TLoadedConceptMap;
begin
  vA := TLoadedConceptMap(pA);
  vB := TLoadedConceptMap(pB);
  result := CompareStr(vA.Resource.name, vb.Resource.name);
end;

function TTerminologyWebServer.sortCmByPub(pA, pB: Pointer): Integer;
var
  vA, vB : TLoadedConceptMap;
begin
  vA := TLoadedConceptMap(pA);
  vB := TLoadedConceptMap(pB);
  result := CompareStr(vA.Resource.publisher, vb.Resource.publisher);
end;

function TTerminologyWebServer.sortCmBySrc(pA, pB: Pointer): Integer;
var
  vA, vB : TLoadedConceptMap;
begin
  vA := TLoadedConceptMap(pA);
  vB := TLoadedConceptMap(pB);
  result := CompareStr(vA.Resource.sourceDesc, vb.Resource.sourceDesc);
end;

function TTerminologyWebServer.sortCmByTgt(pA, pB: Pointer): Integer;
var
  vA, vB : TLoadedConceptMap;
begin
  vA := TLoadedConceptMap(pA);
  vB := TLoadedConceptMap(pB);
  result := CompareStr(vA.Resource.TargetDesc, vb.Resource.TargetDesc);
end;

function TTerminologyWebServer.sortCmByUrl(pA, pB: Pointer): Integer;
var
  vA, vB : TLoadedConceptMap;
begin
  vA := TLoadedConceptMap(pA);
  vB := TLoadedConceptMap(pB);
  result := CompareStr(vA.Resource.url, vb.Resource.url);
end;

function TTerminologyWebServer.sortCmByVer(pA, pB: Pointer): Integer;
var
  vA, vB : TLoadedConceptMap;
begin
  vA := TLoadedConceptMap(pA);
  vB := TLoadedConceptMap(pB);
  result := CompareStr(vA.Resource.version, vb.Resource.version);
end;

{ TCodeSystemSorter }

function TCodeSystemSorter.Compare(const Left, Right: TFHIRCodeSystemW): Integer;
begin
  case FSortType of
    byUrl: result := CompareStr(left.url, right.url);
    byVer: result := CompareStr(left.version, right.version);
    byName: result := CompareStr(left.name, right.name);
    byContext: result := CompareStr(left.context, right.context);
    byPub: result := CompareStr(left.publisher, right.publisher);
  else
    result := 0;
  end;
end;

{ TValueSetSorter }

function TValueSetSorter.Compare(const Left, Right: TFHIRValueSetW): Integer;
begin
  case FSortType of
    byUrl: result := CompareStr(left.url, right.url);
    byVer: result := CompareStr(left.version, right.version);
    byName: result := CompareStr(left.name, right.name);
    byContext: result := CompareStr(left.context, right.context);
    byPub: result := CompareStr(left.publisher, right.publisher);
    bySource : result := CompareStr(left.source, right.source);
  else
    result := 0;
  end;
end;

end.
