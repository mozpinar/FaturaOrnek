unit Support.FabricationEditForm;
///***********************************************************************
///  This classes for Edit forms
///***********************************************************************

interface
uses
  System.SysUtils, Forms, RTTI, System.Generics.Collections,
  Data.DB,
  Support.Consts
  ;
type


  TFactoryMethodEditForm<TBaseType> = reference to function(ACmd : TBrowseFormCommand; ADataset : TDataset; Params : array of Variant): TBaseType;

  TFactoryEditForm<TKey, TBaseType> = class
  private
    fFactoryMethods: TDictionary<TKey, TFactoryMethodEditForm<TBaseType>>;
    function GetCount: Integer;
  public
    constructor Create;
    property Count: Integer read GetCount;
    procedure RegisterFactoryMethod(key: TKey; factoryMethod: TFactoryMethodEditForm<TBaseType>);
    procedure UnregisterFactoryMethod(key: TKey);
    function IsRegistered(key: TKey): boolean;
    function GetInstance(AKey: TKey;  ACmd : TBrowseFormCommand; ADataset : TDataset; AParams : array of Variant): TBaseType;
  end;

  TMyFactoryEditForm = class
    FormFactory: TFactoryEditForm<string, TForm>;
    constructor Create;
    procedure RegisterForm<T>(const TypeName : string; aFunc : TFactoryMethodEditForm<TForm>);
    function GetForm(const TypeName : string;  ACmd : TBrowseFormCommand; ADataset : TDataset; Params : array of Variant) : TForm;

  end;

var
  MyFactoryEditForm : TMyFactoryEditForm;

implementation

{ TMyFactory }

constructor TMyFactoryEditForm.Create;
begin
  inherited;
  FormFactory:= TFactoryEditForm<string, TForm>.Create;
end;

function TMyFactoryEditForm.GetForm(const TypeName: string; ACmd : TBrowseFormCommand; ADataset : TDataset; Params : array of Variant): TForm;
begin
  Result := FormFactory.GetInstance(TypeName, ACmd, ADataset, Params);
end;

procedure TMyFactoryEditForm.RegisterForm<T>(const TypeName: string; aFunc : TFactoryMethodEditForm<TForm>);
begin
  FormFactory.RegisterFactoryMethod(TypeName, aFunc);
end;

///////////////

constructor TFactoryEditForm<TKey, TBaseType>.Create;
begin
  inherited Create;
  fFactoryMethods := TDictionary<TKey, TFactoryMethodEditForm<TBaseType>>.Create;
end;

function TFactoryEditForm<TKey, TBaseType>.GetCount: Integer;
begin
  Result := fFactoryMethods.Count;
end;

function TFactoryEditForm<TKey, TBaseType>.GetInstance(AKey: TKey;  ACmd : TBrowseFormCommand; ADataset : TDataset; AParams : array of Variant): TBaseType;
var
  factoryMethod: TFactoryMethodEditForm<TBaseType>;
begin
  if not fFactoryMethods.TryGetValue(AKey, factoryMethod) or not Assigned(factoryMethod) then
    raise Exception.Create('Factory not registered');
  Result := factoryMethod(ACmd, ADataset, AParams);
end;

function TFactoryEditForm<TKey, TBaseType>.IsRegistered(key: TKey): boolean;
begin
  Result := fFactoryMethods.ContainsKey(key);
end;

procedure TFactoryEditForm<TKey, TBaseType>.RegisterFactoryMethod(key: TKey;
  factoryMethod: TFactoryMethodEditForm<TBaseType>);
begin
  if IsRegistered(key) then
    raise Exception.Create('Factory already registered');
  fFactoryMethods.Add(key, factoryMethod);
end;

procedure TFactoryEditForm<TKey, TBaseType>.UnRegisterFactoryMethod(key: TKey);
begin
  if not IsRegistered(key) then
    raise Exception.Create('Factory not registered');
  fFactoryMethods.Remove(key);
end;

////////////////

initialization
  MyFactoryEditForm := TMyFactoryEditForm.Create;

end.
