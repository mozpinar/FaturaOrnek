unit Support.LanguageDictionary;

interface
uses
  System.Classes,
  Data.DB,
  Vcl.DBGrids;

type
  TLanguageDictionaryType = (ldtMessage, ldtComponentStr, ldtComponentList, ldtComponentListNameValue);

  IBaseDictionary = Interface
    ['{232D6C14-5B50-4948-A1A0-3E6152A502A4}']
    function GetText(const AFormName, AControlName : string; ADefaultValue : string='') : string;
    function GetMessage(const AMessageName : string) : string;
    procedure GetTextNamesAndValues(const AFormName, AControlName : string; var ANames : string; var AValues : string);
    procedure AssignGridColumnTitles(const AFormName : string; aDBGrid : TDBGrid);
  end;

  TLanguageDictionaryFunction = reference to function(AFileName : string): IBaseDictionary;

function MessageDictionary(AFileName : string = '') : IBaseDictionary;
function ComponentDictionary(AFileName : string = '') : IBaseDictionary;
function ComponentListDictionary(AFileName : string = '') : IBaseDictionary;
function ComponentListNameDictionary(AFileName : string = '') : IBaseDictionary;
function GridColumnDictionary(AFileName : string = '') : IBaseDictionary;

implementation

uses
  System.IOUtils,
  System.SysUtils,
  System.Generics.Collections;

const
  LanguageDictinaryFileName = 'BM.LANG';
  MessageFormName = 'MessagesForLanguage';

type
  TBaseDictionary = class(TInterfacedObject, IBaseDictionary)
  private
    //FDict : TStringList;
    //FFileName : string;
    //FFile : TStream;
  public
    function GetText(const AFormName, AControlName : string; ADefaultValue : string='') : string; virtual; abstract;
    function GetMessage(const AMessageName : string) : string; virtual; abstract;
    procedure GetTextNamesAndValues(const AFormName, AControlName : string; var ANames : string; var AValues : string); virtual; abstract;
    procedure AssignGridColumnTitles(const AFormName : string; aDBGrid : TDBGrid); virtual; abstract;
  end;

type
{$REGION TLanguageDictionaryFactory}
  TLanguageDictionaryFactory = class
  private
    class var FDictionary: TDictionary<TLanguageDictionaryType, TLanguageDictionaryFunction>;
  public
    class constructor Create;
    class procedure AddLanguageDictionary(aType : TLanguageDictionaryType; aFunction : TLanguageDictionaryFunction);
    class function GetLanguageDictionary(aType : TLanguageDictionaryType) : IBaseDictionary;
  end;

  class constructor TLanguageDictionaryFactory.Create;
  begin
    FDictionary := TDictionary<TLanguageDictionaryType, TLanguageDictionaryFunction>.Create;
  end;

  class procedure TLanguageDictionaryFactory.AddLanguageDictionary(aType : TLanguageDictionaryType;
                                                               aFunction : TLanguageDictionaryFunction);
  begin
    FDictionary.AddOrSetValue(aType, aFunction);
  end;

  class function TLanguageDictionaryFactory.GetLanguageDictionary(aType : TLanguageDictionaryType) : IBaseDictionary;
  begin
    Result := FDictionary.Items[aType]('');
  end;
{$ENDREGION TLanguageDictionaryFactory}
function SetCR(s : String) : string;
var
  i : Integer;
begin
  Result := s;
  i := Pos('\n', Result);
  if i=0 then
    i := Pos('\N', Result);
  while (i>0) do
  begin
    Result[i] := #13;
    Result[i+1] := #10;
    i := Pos('\n', Result);
    if i=0 then
      i := Pos('\N', Result);
  end;
end;

type
{$REGION TComponentDictionary}
{ TComponentDictionary }
  TComponentDictionary = class(TBaseDictionary)
  private
    FDict : TStringList;
    FFileName : string;
    //FFile : TStream;
  public
    constructor Create(AFileName : string);
    function GetText(const AFormName, AControlName : string; ADefaultValue : string='') : string; override;
    function GetMessage(const AMessageName : string) : string; override; abstract;
    procedure GetTextNamesAndValues(const AFormName, AControlName : string; var ANames : string; var AValues : string); override; abstract;
  end;

constructor TComponentDictionary.Create(AFileName : string);
begin
  if AFileName='' then
    FFileName := ExtractFilePath(ParamStr(0))+TPath.GetFileNameWithoutExtension(ParamStr(0))+'.lang'
  else
    FFileName := AFileName;
  FDict := TStringList.Create;
  FDict.LoadFromFile(FFileName);
end;

function TComponentDictionary.GetText(const AFormName, AControlName: string;
  ADefaultValue: string): string;
var aName : string;
begin
  if AControlName='' then
    aName := AFormName
  else
    aName := AFormName+'.'+AControlName;

  if FDict.IndexOfName(aName)>=0 then
    Result := SetCR(FDict.Values[aName])
  else
    Result := ADefaultValue;
end;

{$ENDREGION TComponentDictionary}

{$REGION TListDictionary}
type
  TListDictionary = class(TComponentDictionary)
  public
    function GetText(const AFormName, AControlName : string; ADefaultValue : string='') : string; override;
  end;

function TListDictionary.GetText(const AFormName, AControlName : string; ADefaultValue : string='') : string;
begin
  Result := inherited GetText(AFormName, AControlName, ADefaultValue);
  Result := SetCR(Result);
end;
{$ENDREGION TListDictionary}

{$REGION TListNameValueDictionary}
type
  TListNameValueDictionary = class(TListDictionary)
  public
    function GetText(const AFormName, AControlName : string; ADefaultValue : string='') : string; override;
    procedure GetTextNamesAndValues(const AFormName, AControlName : string; var ANames : string; var AValues : string); override;
  end;

function TListNameValueDictionary.GetText(const AFormName, AControlName : string; ADefaultValue : string='') : string;
begin
  Result := inherited GetText(AFormName, AControlName, ADefaultValue);
  Result := SetCR(Result);
end;

procedure TListNameValueDictionary.GetTextNamesAndValues(const AFormName, AControlName : string; var ANames : string; var AValues : string);
var s : string;
  sl : TStringList;
  I : integer;
  ws : string;
begin
  s := inherited GetText(AFormName, AControlName);
  if s='' then
    Exit;
  s := SetCR(s);
  sl := TStringList.Create;
  try
    sl.Text := s;

    ANames := '';
    AValues := '';
    for I := 0 to sl.Count-1 do
    begin
      if ANames='' then
        ANames := sl.Names[I]
      else
        ANames := ANames + #13#10 + sl.Names[I];

      if AValues='' then
        AValues := sl.Values[sl.Names[I]]
      else
        AValues := AValues + #13#10 + sl.Values[sl.Names[I]];
    end;
  finally
    sl.Free;
  end;
end;
{$ENDREGION TListNameValueDictionary}

{$REGION TMessageDictionary}
type
  TMessageDictionary = class(TComponentDictionary)
  public
    function GetText(const AFormName, AControlName : string; ADefaultValue : string='') : string; override;
    function GetMessage(const AMessageName : string) : string; override;
  end;

function TMessageDictionary.GetMessage(const AMessageName: string): string;
begin
  Result := GetText(MessageFormName, AMessageName, AMessageName);
end;

function TMessageDictionary.GetText(const AFormName: string; const AControlName: string; ADefaultValue: string = '') : string;
begin
   Result :=  inherited GetText(AFormName, AControlName, ADefaultValue);
end;
{$ENDREGION TMessageDictionary}

{$REGION TGridColumnDictionary}
type
  TGridColumnDictionary = class(TComponentDictionary)
  public
    function GetText(const AFormName, AControlName : string; ADefaultValue : string='') : string; override;
    procedure AssignGridColumnTitles(const AFormName : string; aDBGrid : TDBGrid); override;
  end;

function TGridColumnDictionary.GetText(const AFormName, AControlName : string; ADefaultValue : string='') : string;
begin
  Result := inherited GetText(AFormName, AControlName, ADefaultValue);
  Result := SetCR(Result);
end;

procedure TGridColumnDictionary.AssignGridColumnTitles(const AFormName : string; aDBGrid : TDBGrid);
var
  i: Integer;
  col : TCollectionItem; //TColumn;
  fld : TField;
begin
  for col in aDBGrid.Columns do
    if ((col as TColumn).Field<>nil) and ((col as TColumn).FieldName<>'') then
      (col as TColumn).Title.Caption := GetText(AFormName, aDBGrid.Name+'['+(col as TColumn).FieldName+'].Caption', (col as TColumn).Title.Caption);
end;

{$ENDREGION TGridColumnDictionary}


var
  FMessageDictionary : IBaseDictionary = nil;
  FComponentDictionary : IBaseDictionary = nil;
  FComponentListDictionary : IBaseDictionary = nil;
  FComponentListNameDictionary : IBaseDictionary = nil;
  FGridColumnDictionary : IBaseDictionary = nil;

function MessageDictionary(AFileName : string = '') : IBaseDictionary;
begin
  if FMessageDictionary=nil then
    FMessageDictionary := TMessageDictionary.Create(AFileName);
  Result := FMessageDictionary;
end;

function ComponentDictionary(AFileName : string = '') : IBaseDictionary;
begin
  if FComponentDictionary=nil then
    FComponentDictionary := TComponentDictionary.Create(AFileName);
  Result := FComponentDictionary;
end;

function ComponentListDictionary(AFileName : string = '') : IBaseDictionary;
begin
  if FComponentListDictionary=nil then
    FComponentListDictionary := TListDictionary.Create(AFileName);
  Result := FComponentListDictionary;
end;

function ComponentListNameDictionary(AFileName : string = '') : IBaseDictionary;
begin
  if FComponentListNameDictionary=nil then
    FComponentListNameDictionary := TListNameValueDictionary.Create(AFileName);
  Result := FComponentListNameDictionary;
end;

function GridColumnDictionary(AFileName : string = '') : IBaseDictionary;
begin
  if FGridColumnDictionary=nil then
    FGridColumnDictionary := TGridColumnDictionary.Create(AFileName);
  Result := FGridColumnDictionary;
end;

var LDF : TLanguageDictionaryFunction;

initialization
  LDF := function(AFileName : string) : IBaseDictionary
         begin
           Result := TMessageDictionary.Create(AFileName);
         end;
  TLanguageDictionaryFactory.AddLanguageDictionary(TLanguageDictionaryType.ldtMessage, LDF);

  LDF := function(AFileName : string) : IBaseDictionary
         begin
           Result := TComponentDictionary.Create(AFileName);
         end;
  TLanguageDictionaryFactory.AddLanguageDictionary(TLanguageDictionaryType.ldtComponentStr, LDF);

  LDF := function(AFileName : string) : IBaseDictionary
         begin
           Result := TListDictionary.Create(AFileName);
         end;
  TLanguageDictionaryFactory.AddLanguageDictionary(TLanguageDictionaryType.ldtComponentList, LDF);

  LDF := function(AFileName : string) : IBaseDictionary
         begin
           Result := TListNameValueDictionary.Create(AFileName);
         end;
  TLanguageDictionaryFactory.AddLanguageDictionary(TLanguageDictionaryType.ldtComponentListNameValue, LDF);

end.


