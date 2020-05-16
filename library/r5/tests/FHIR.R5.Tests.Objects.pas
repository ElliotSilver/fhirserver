unit FHIR.R5.Tests.Objects;

interface

uses
  SysUtils, Classes,
  DUnitX.TestFramework,
  IdSSLOpenSSLHeaders, FHIR.Support.Certs, FHIR.Support.Stream, FHIR.Support.Tests,
  FHIR.Base.Objects, FHIR.Version.Parser,
  FHIR.R5.Types, FHIR.R5.Resources, FHIR.R5.Json;

type
  [TextFixture]
  TFHIRObjectTests = Class (TObject)
  private
    function json(o : TFHIRResource) : String;
  public
    [TestCase] Procedure TestDropEmptySimple;
    [TestCase] Procedure TestDropEmptyComplex;
  end;

implementation

{ TFHIRObjectTests }

function TFHIRObjectTests.json(o: TFHIRResource): String;
var
  c : TFHIRJsonComposer;
begin
  c := TFHIRJsonComposer.Create(nil, OutputStyleCanonical, THTTPLanguages.create('en'));
  try
    result := c.Compose(o);
  finally
    c.Free;
  end;
end;

procedure TFHIRObjectTests.TestDropEmptySimple;
var
  o : TFHIRPatient;
begin
  o := TFHIRPatient.Create;
  try
    Assert.IsTrue(json(o) = '{"resourceType":"Patient"}');
    Assert.IsTrue(o.idElement = nil);
    o.id := 'test';
    Assert.IsTrue(json(o) = '{"id":"test","resourceType":"Patient"}');
    Assert.IsTrue(o.idElement <> nil);
    o.id := '';
    Assert.IsTrue(json(o) = '{"resourceType":"Patient"}');
    Assert.IsTrue(o.idElement <> nil);
    o.dropEmpty;
    Assert.IsTrue(json(o) = '{"resourceType":"Patient"}');
    Assert.IsTrue(o.idElement = nil);
  finally
    o.Free;
  end;
  Assert.IsTrue(true);
end;

procedure TFHIRObjectTests.TestDropEmptyComplex;
var
  o : TFHIRPatient;
begin
  o := TFHIRPatient.Create;
  try
    Assert.IsTrue(json(o) = '{"resourceType":"Patient"}');
    Assert.IsTrue(o.identifierList.Count = 0);
    o.identifierList.Append.value := 'test';
    Assert.IsTrue(json(o) = '{"identifier":[{"value":"test"}],"resourceType":"Patient"}');
    Assert.IsTrue(o.identifierList.Count = 1);
    o.identifierList[0].value := '';
    Assert.IsTrue(json(o) = '{"identifier":[{}],"resourceType":"Patient"}');
    Assert.IsTrue(o.identifierList.Count = 1);
    o.dropEmpty;
    Assert.IsTrue(json(o) = '{"resourceType":"Patient"}');
    Assert.IsTrue(o.identifierList.Count = 0);
  finally
    o.Free;
  end;
  Assert.IsTrue(true);
end;

initialization
  TDUnitX.RegisterTestFixture(TFHIRObjectTests);
end.
