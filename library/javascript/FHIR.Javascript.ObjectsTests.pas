unit FHIR.Javascript.ObjectsTests;

{
Copyright (c) 2017+, Health Intersections Pty Ltd (http://www.healthintersections.com.au)
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

interface

uses
  SysUtils, Classes, Generics.Collections,
  {$IFDEF FPC} FPCUnit, TestRegistry, {$ELSE} DUnitX.TestFramework, {$ENDIF}
  FHIR.Support.Base, FHIR.Javascript, FHIR.Support.Tests,
  FHIR.Base.Objects, FHIR.Base.Factory, FHIR.Base.Common,
  FHIR.R4.Tests.Worker, FHIR.R4.Resources, FHIR.R4.Types, FHIR.R4.Factory, FHIR.R4.Profiles, FHIR.R4.Context, FHIR.R4.Common, FHIR.R4.Utilities, FHIR.R4.Javascript,
  FHIR.Javascript.Base;

{$IFNDEF FPC}
Type
  [TextFixture]
  TFHIRJavascriptTests = Class (TObject)
  Private
    FLog : TStringList;
    FJs : TFHIRJavascript;
    procedure JSLog(sender : TJavascript; message : String);
  Published
    [SetUp]    Procedure Setup;
    [TearDown] Procedure TearDown;
    [TestCase] Procedure TestPatient;
    [TestCase] Procedure TestPatientUnknownProperty;
    [TestCase] Procedure TestPatient2;
    [TestCase] Procedure TestObservation;
    [TestCase] Procedure TestPatientMutation;
    [TestCase] Procedure TestPatientImmutable;
  End;
{$ENDIF}
implementation

{$IFNDEF FPC}
type
  TTestWorkerContext = class (TBaseWorkerContext)
  public
    function expand(vs : TFhirValueSet; options : TExpansionOperationOptionSet = []) : TFHIRValueSet; override;
    function validateCode(system, version, code : String; vs : TFhirValueSet) : TValidationResult; overload; override;
    function validateCode(code : TFHIRCoding; vs : TFhirValueSet) : TValidationResult; overload; override;
    function validateCode(code : TFHIRCodeableConcept; vs : TFhirValueSet) : TValidationResult; overload; override;
    function getChildMap(profile : TFHIRStructureDefinition; element : TFhirElementDefinition) : TFHIRElementDefinitionList; override;
    function getStructure(url : String) : TFHIRStructureDefinition; overload; override;
    function getStructure(ns, name : String) : TFHIRStructureDefinition; overload; override;
    function getCustomResource(name : String) : TFHIRCustomResourceInformation; override;
    function hasCustomResource(name : String) : boolean; override;
    function supportsSystem(system, version : string) : boolean; overload; override;
  end;

{ TJavascriptTests }

procedure TFHIRJavascriptTests.Setup;
begin
  FJs := TFHIRJavascript.Create;
  FJs.registerFactory(registerFHIRTypes, fhirVersionRelease4, TFHIRFactoryR4.Create);
  FJs.registerFactory(registerFHIRTypesDef, fhirVersionUnknown, TFHIRFactoryR4.Create);
  FJs.OnLog := JSLog;
  FLog := TStringList.create;
end;

procedure TFHIRJavascriptTests.TearDown;
begin
  FJs.Free;
  FLog.free;
end;

procedure TFHIRJavascriptTests.JSLog(sender: TJavascript; message: String);
begin
  FLog.Add(message);
end;

procedure TFHIRJavascriptTests.TestPatient;
var
  pat : TFHIRPatient;
begin
  pat := fileToResource(FHIR_TESTING_FILE(4, 'examples', 'patient-example.xml')) as TFhirPatient;
  try
    FJs.execute(
      'function func(pat) {'+#13#10+
      ' console.log(pat.id);'+#13#10+
      ' console.log(pat.language);'+#13#10+
      ' pat.id = "t1";'+#13#10+
      ' console.log(pat.active);'+#13#10+
      ' pat.active = false;'+#13#10+
      ' console.log(pat.gender);'+#13#10+
      ' pat.gender = "female";'+#13#10+
      ' console.log(pat.birthDate);'+#13#10+
      ' pat.birthDate = "1992-03-04";'+#13#10+
      ' console.log(pat.text.status);'+#13#10+
      ' console.log(pat.identifier.length);'+#13#10+
      ' pat.text.status = "extensions";'+#13#10+
      '}'+#13#10,
      'test.js', 'func', [FJs.wrap(pat.Link, true)]);
    Assert.IsTrue(Flog.Text =
      'example'#13#10+
      'null'#13#10+
      'true'#13#10+
      'male'#13#10+
      '1974-12-25'#13#10+
      'generated'#13#10+
      '1'#13#10);
    Assert.IsTrue(pat.id = 't1');
    Assert.IsTrue(not pat.active);
    Assert.IsTrue(pat.gender = AdministrativeGenderFemale);
    Assert.IsTrue(pat.birthDate.toXML = '1992-03-04');
    Assert.IsTrue(pat.birthDateElement.extensionList.Count = 1);
    Assert.IsTrue(pat.text.status = NarrativeStatusExtensions);
  finally
    pat.Free;
  end;
end;

procedure TFHIRJavascriptTests.TestPatient2;
var
  pat : TFHIRPatient;
begin
  pat := fileToResource(FHIR_TESTING_FILE(4, 'examples', 'patient-example.xml')) as TFhirPatient;
  try
    FJs.execute(
      'function func(pat) {'+#13#10+
      ' console.log(pat.identifier[0].system);'+#13#10+
      ' pat.identifier.push({ "system" : "http://something", "value" : "v1"});'+#13#10+
      '}'+#13#10,
      'test.js', 'func', [FJs.wrap(pat.Link, true)]);
    Assert.IsTrue(Flog.Text =
      'urn:oid:1.2.36.146.595.217.0.1'#13#10);
    Assert.IsTrue(pat.identifierList.count = 2);
    Assert.IsTrue(pat.identifierList[1].system = 'http://something');

    FJs.execute(
      'function func(pat) {'+#13#10+
      ' pat.identifier.push(new Identifier4({ "system" : "http://something-else", "value" : "v1"}));'+#13#10+
      '}'+#13#10,
      'test.js', 'func', [FJs.wrap(pat.Link, true)]);
    Assert.IsTrue(pat.identifierList.count = 3);
    Assert.IsTrue(pat.identifierList[2].system = 'http://something-else');

    FLog.Clear;
    FJs.execute(
      'function func(pat) {'+#13#10+
      ' pat.identifier = [{ "system" : "http://something-else-again", "value" : "v1"}];'+#13#10+
      ' console.log(pat.identifier.length);'+#13#10+
      '}'+#13#10,
      'test.js', 'func', [FJs.wrap(pat.Link, true)]);
    Assert.IsTrue(Flog.Text =
      '1'#13#10);
    Assert.IsTrue(pat.identifierList.count = 1);
    Assert.IsTrue(pat.identifierList[0].system = 'http://something-else-again');
  finally
    pat.Free;
  end;
end;

procedure TFHIRJavascriptTests.TestPatientImmutable;
var
  pat : TFHIRPatient;
begin
  pat := fileToResource(FHIR_TESTING_FILE(4, 'examples', 'patient-example.xml')) as TFhirPatient;
  try
    FJs.ObjectsImmutable := true;
    FJs.Strict := true;

    // first, check that reading works
    FJs.execute(
      'function func(pat) {'+#13#10+
      ' console.log(pat.id);'+#13#10+
      '}'+#13#10,
      'test.js', 'func', [FJs.wrap(pat.Link, true)]);
    Assert.IsTrue(Flog.Text =
      'example'#13#10);

    Flog.Clear;
    // now, check that writing to a new property fails
    Assert.WillRaise(procedure begin
      FJs.execute(
      'function func(pat) {'+#13#10+
      ' pat.id1 = "23";'+#13#10+
      ' console.log(pat.id1);'+#13#10+
      '}'+#13#10,
      'test.js', 'func', [FJs.wrap(pat.Link, true)]);
     end, EJavascriptHost);

    // now, check that writing to an existing property fails
    Assert.WillRaise(procedure begin
      FJs.execute(
      'function func(pat) {'+#13#10+
      ' pat.id = "23";'+#13#10+
      ' console.log(pat.id);'+#13#10+
      '}'+#13#10,
      'test.js', 'func', [FJs.wrap(pat.Link, true)]);
     end, EJavascriptHost);
  finally
    pat.Free;
  end;
end;

procedure TFHIRJavascriptTests.TestPatientMutation;
var
  pat : TFHIRPatient;
begin
  pat := fileToResource(FHIR_TESTING_FILE(4, 'examples', 'patient-example.xml')) as TFhirPatient;
  try
    FJs.execute(
      'function func(pat) {'+#13#10+
      ' var p2 = { id: 23};'+#13#10+
      ' console.log(p2.id);'+#13#10+
      '}'+#13#10,
      'test.js', 'func', [FJs.wrap(pat.Link, true)]);
    Assert.IsTrue(Flog.Text =
      '23'#13#10);
  finally
    pat.Free;
  end;
end;

procedure TFHIRJavascriptTests.TestPatientUnknownProperty;
var
  pat : TFHIRPatient;
begin
  pat := fileToResource(FHIR_TESTING_FILE(4, 'examples', 'patient-example.xml')) as TFhirPatient;
  try
    FJs.execute(
      'function func(pat) {'+#13#10+
      ' console.log(pat.id1);'+#13#10+
      '}'+#13#10,
      'test.js', 'func', [FJs.wrap(pat.Link, true)]);
    Assert.IsTrue(Flog.Text =
      'undefined'#13#10);
    FLog.clear;
    FJs.execute(
      'function func(pat) {'+#13#10+
      '  pat.id1 = "3120";'+#13#10+
      '  console.log(pat.id1);'+#13#10+
      '}'+#13#10,
      'test.js', 'func', [FJs.wrap(pat.Link, true)]);
    Assert.IsTrue(Flog.Text =
      '3120'#13#10);
  finally
    pat.Free;
  end;
end;

procedure TFHIRJavascriptTests.TestObservation;
var
  obs : TFhirObservation;
begin
  obs := fileToResource(FHIR_TESTING_FILE(4, 'examples', 'observation-example.xml')) as TFhirObservation;
  try
    FJs.execute(
      'function func(obs) {'+#13#10+
      ' console.log(obs.valueQuantity.value);'+#13#10+
      ' obs.valueQuantity.value = 3.120;'+#13#10+
      '}'+#13#10,
      'test.js', 'func', [FJs.wrap(obs.Link, true)]);
    Assert.IsTrue(Flog.Text =
      '185'#13#10);
    Assert.IsTrue((obs.value as TFHIRQuantity).value = '3.12');

    FJs.execute(
      'function func(obs) {'+#13#10+
      ' obs.valueQuantity.value = "3.120";'+#13#10+
      '}'+#13#10,
      'test.js', 'func', [FJs.wrap(obs.Link, true)]);
    Assert.IsTrue((obs.value as TFHIRQuantity).value = '3.120');

    FJs.execute(
      'function func(obs) {'+#13#10+
      ' obs.valueInteger = 3;'+#13#10+
      '}'+#13#10,
      'test.js', 'func', [FJs.wrap(obs.Link, true)]);
    Assert.IsTrue((obs.value as TFHIRInteger).value = '3');
  finally
    obs.Free;
  end;
end;

{ TTestWorkerContext }

function TTestWorkerContext.expand(vs: TFhirValueSet; options : TExpansionOperationOptionSet = []): TFHIRValueSet;
begin
  raise ETestExceptionNotDone.Create('TTestWorkerContext.expand');
end;

function TTestWorkerContext.getChildMap(profile: TFHIRStructureDefinition; element: TFhirElementDefinition): TFHIRElementDefinitionList;
begin
  raise ETestExceptionNotDone.Create('TTestWorkerContext.getChildMap');
end;

function TTestWorkerContext.getCustomResource(name: String): TFHIRCustomResourceInformation;
begin
  raise ETestExceptionNotDone.Create('TTestWorkerContext.getCustomResource');
end;

function TTestWorkerContext.getStructure(url: String): TFHIRStructureDefinition;
begin
  raise ETestExceptionNotDone.Create('TTestWorkerContext.getStructure');
end;

function TTestWorkerContext.getStructure(ns, name: String): TFHIRStructureDefinition;
begin
  raise ETestExceptionNotDone.Create('TTestWorkerContext.getStructure');
end;

function TTestWorkerContext.hasCustomResource(name: String): boolean;
begin
  raise ETestExceptionNotDone.Create('TTestWorkerContext.hasCustomResource');
end;

function TTestWorkerContext.supportsSystem(system, version: string): boolean;
begin
  raise ETestExceptionNotDone.Create('TTestWorkerContext.supportsSystem');
end;

function TTestWorkerContext.validateCode(system, version, code: String; vs: TFhirValueSet): TValidationResult;
begin
  raise ETestExceptionNotDone.Create('TTestWorkerContext.validateCode');
end;

function TTestWorkerContext.validateCode(code: TFHIRCoding; vs: TFhirValueSet): TValidationResult;
begin
  raise ETestExceptionNotDone.Create('TTestWorkerContext.validateCode');
end;

function TTestWorkerContext.validateCode(code: TFHIRCodeableConcept; vs: TFhirValueSet): TValidationResult;
begin
  raise ETestExceptionNotDone.Create('TTestWorkerContext.validateCode');
end;

initialization
  TDUnitX.RegisterTestFixture(TFHIRJavascriptTests);
{$ENDIF}
end.
