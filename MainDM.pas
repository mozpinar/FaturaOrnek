unit MainDM;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.MSSQLDef, FireDAC.Phys.ODBCBase,
  FireDAC.Phys.MSSQL,

  FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet,

  Vcl.Dialogs,
  Vcl.Controls,

  System.Rtti,
  System.TypInfo
  ;

type
  TDMMain = class(TDataModule)
    MyDB: TFDConnection;
    FDPhysMSSQLDriverLink1: TFDPhysMSSQLDriverLink;
    FDTable1: TFDTable;
    FDTransaction1: TFDTransaction;
    FDQuery1: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
  private
    FLoggedIn: Boolean;
    FLoggedUserId: Integer;
    FLoggedUserName: string;
    function GetFieldType(AColType: TTypeKind; ALen, APrec, AScl: integer; ATypeInfo: PTypeInfo): TFieldType;

  public
    IniFName : string;
    property LoggedIn: Boolean read FLoggedIn write FLoggedIn;
    property LoggedUserId: Integer read FLoggedUserId write FLoggedUserId;
    property LoggedUserName: string read FLoggedUserName write FLoggedUserName;

    function ExecuteLogin : boolean;
  public
    function AppendRecord<T>(AEntity : TObject) : Boolean; overload;
    function AppendRecord<T>(ASourceDS: TDataset; const AAllRecords: Boolean = false) : Boolean; overload;
    function UpdateRecord<T>(AId : Integer; AEntity : TObject) : Boolean; overload;
    function UpdateRecord<T>(AId : Integer; ASourceDS: TDataset; const AAllRecords: Boolean = false) : Boolean; overload;

    function DeleteRecord<T>(AId : Integer) : Boolean;
    function GetList<T>(const AFilter : string;ASelect: string='*'; const AOrderBy : string = '') : TDataset; overload;
    function GetList(const ASql : string; const AParams : Array of Variant; const ATypes: array of TFieldType) : TDataset; overload;

    function GetRecord<T>(id : integer; select: string='*') : TDataset; overload;
    function GetRecord<T>(const where : string; const AParams : Array of Variant; select: string='*') : TDataset; overload;

    function ExecSql(const ASql : string; AParams : array of Variant; AFieldTypes: array of TFieldType) : boolean;
    function TableName<T> : string;

    function GetServerUtcDateTime: TDateTime;
    function CreateQuery: TFDQuery;

    function GetDatasetClone(ADS: TDataset): TDataset;
  public
    // Authenticate & Authorize
    function LoginSystem(const AUsername, APassword : string) : boolean;
    function IsUserAuthorized(const APermissions : string) : boolean;

  private
    function GetCascadedPermissions(aPermission: string): string;
    function GroupsUserHas(AUserId: Integer): string;
    procedure CreateDB;
  end;

var
  DMMain: TDMMain;

type
  TFieldProp = class
    fieldName : string;
    fieldType : TFieldType;
    fieldValue : TValue;
  end;

function TValueToVariant(AValue : TValue) : Variant;

implementation
uses
  System.IOUtils,
  System.StrUtils,
  System.Variants,
  System.DateUtils,
  System.Generics.Collections,

  Model.Declarations,
  Support.Attributes,
  Support.Consts,
  IniFiles,

  View.LoginForm,
  View.ServerAccess,
  Support.LanguageDictionary;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

var
  MyDBDriverName: string;
  MyServer: string;
  MyDBName: string;
  MyServerUsesOSAuthenticate: boolean;
  MyServerUsername: string;
  MyServerPassword: string;
  MyServerCharset: string;


function Instr(const SubStr, MainStr, Separator : String) : Boolean;
begin
  Result := SearchBuf(PWideChar(MainStr), StrLen(PWideChar(MainStr)), 0, 0 {StrLen(PWideChar(MainStr))}, SubStr, [TStringSeachOption.soDown, TStringSeachOption.soWholeWord])<>Nil;
end;

function MyLowercase(const s : string) : string;
var
  I: Integer;
begin
  Result := s;
  for I := 1 to Length(Result) do
    case Result[I] of
      'Ð' : Result[I] := 'ð';
      'Þ' : Result[I] := 'þ';
      'Ç' : Result[I] := 'ç';
      'Ü' : Result[I] := 'ü';
      'Ý' : Result[I] := 'i';
      'Ö' : Result[I] := 'ö';
      'I' : Result[I] := 'i';
      else
        Result[I] := Char(Byte(Result[I])+$20);
    end;
end;

function StreamToVariant(const stream: TStream): Variant;
var
  lock: Pointer;
  size: Integer;
begin
  if not Assigned(stream) then
    Exit(Null);
  size := stream.Size;
  if size = 0 then
    Exit(Null);
  stream.Position := 0;
  Result := VarArrayCreate([0, size - 1], varByte);
  lock := VarArrayLock(Result);
  try
    stream.ReadBuffer(lock^, stream.Size);
  finally
    VarArrayUnlock(Result);
  end;
end;

function TValueToVariant(AValue : TValue) : Variant;
var
  obj : TObject;
  stream: TStream;
  persist: IStreamPersist;
begin
  case AValue.Kind of
    tkInteger: Result := AValue.AsInteger;
    tkInt64: Result := AValue.AsInt64;
    tkEnumeration:
      if AValue.IsType<Boolean> then
        Result := AValue.AsBoolean
      else
        Result := AValue.AsOrdinal;
    tkFloat:
      if (AValue.TypeInfo = System.TypeInfo(TDateTime))
        or (AValue.TypeInfo = System.TypeInfo(TDate))
        or (AValue.TypeInfo = System.TypeInfo(TTime)) then
        Result := AValue.AsVariant //.TryAsType<TDateTime>()
      else
      if AValue.TypeInfo = System.TypeInfo(Currency) then
        Result := AValue.AsCurrency
      else
        Result := AValue.AsExtended;
    tkRecord:
    begin
      if AValue.TypeInfo = System.TypeInfo(TGUID) then
        Result := AValue.AsType<TGUID>.ToString;
    end;
    tkClass:
    begin
      obj := AValue.AsObject;
      if obj is TStream then
      begin
        stream := TStream(obj);
        stream.Position := 0;
        Exit(StreamToVariant(stream));

      end
      else if Supports(obj, IStreamPersist, persist) then
      begin
        stream := TMemoryStream.Create;
        try
          persist.SaveToStream(stream);
          stream.Position := 0;
          Exit(StreamToVariant(stream));
        finally
          stream.Free;
        end;
      end;
    end;

    tkString, tkChar, tkWChar, tkLString, tkWString, tkUString:
      Result := AValue.AsString;
    tkVariant: Result := AValue.AsVariant
    else
    begin
      raise Exception.Create('Unsupported type');
    end;
  end;
end;

function TDMMain.GetDatasetClone(ADS: TDataset): TDataset;
begin
  if (ADS is TFDDataset) then
  begin
    //Result := TFDMemTable.Create(self);

    //(Result as TFDMemTable).CloneCursor((ADS as TFDDataset));
    Result := ADS.GetClonedDataSet(true);

    Result.RecNo := ADS.RecNo;
    //(Result as TFDMemTable)
  end
  else
    raise Exception.Create('SDatasetMustBeFireDAC');
end;

function TDMMain.GetFieldType(AColType: TTypeKind; ALen, APrec, AScl: integer;
  ATypeInfo: PTypeInfo): TFieldType;
begin
  Result := ftInteger;
  case AColType of
    tkUnknown: ;
    tkInteger, tkSet:
      if APrec > 0 then
        Result := ftFloat;
    tkEnumeration:
      if ATypeInfo = System.TypeInfo(Boolean) then
        Result := ftBoolean;
    tkInt64:
      if APrec > 0 then
        Result := ftFloat
      else
        Result := ftInteger;
    tkChar: Result := ftString;
    tkFloat:
      if ATypeInfo = System.TypeInfo(TDate) then
        Result := ftDate
      else
      if ATypeInfo = System.TypeInfo(TDateTime) then
       Result := ftDateTime
      else
      if ATypeInfo = System.TypeInfo(TTime) then
        Result := ftTime
      else
        if APrec > 0 then
          Result := ftFloat
        else
          Result := ftFloat;
    tkString, tkLString: Result := ftString;
    tkClass, tkArray, tkDynArray, tkVariant: Result := ftBlob;
    tkMethod: ;
    tkWChar: Result := ftString;
    tkWString, tkUString: Result := ftString;
    tkRecord: ;
    tkInterface: ;
    tkClassRef: ;
    tkPointer: ;
    tkProcedure: ;
  end;
end;


function TDMMain.AppendRecord<T>(AEntity: TObject): Boolean;
var
    FRttiContext: TRttiContext;
    LRttiType: TRttiType;
    m : TRttiMethod;
    prop : TRttiProperty;
    i : Integer;

    name : string;
    dbName : string;
    tableName : string;
    attr : TCustomAttribute;
    pars, vals : string;

    alength, aprecision, ascale : Integer;
    aautogen : Boolean;

var
  flds : TObjectList<TFieldProp>;
  fp : TFieldProp;
  dt : TFieldType;
  fdQry : TFDQuery;
begin
  i := 0;
  flds := TObjectList<TFieldProp>.Create;
  try
    FRttiContext := TRttiContext.Create;
    try
      LRttiType := FRttiContext.GetType(TypeInfo(T));

      for attr in LRttiType.GetAttributes do
        if attr is TableAttribute then
        begin
          tableName := (attr as TableAttribute).Schema + (attr as TableAttribute).TableName;
          Break;
        end;

      pars := '';
      vals := '';
      for prop in LRttiType.GetProperties do
      begin
        if prop.Visibility in [mvPublished, mvPublic] then
        begin
          name := prop.Name;

          for attr in prop.GetAttributes do
          begin
            if attr is ColumnAttribute then
            begin
              if (ColumnAttribute(attr).ColumnName<>'') then
                name := ColumnAttribute(attr).ColumnName;

              alength := (attr as ColumnAttribute).Length;
              aprecision := (attr as ColumnAttribute).Precision;
              ascale := (attr as ColumnAttribute).Scale;

              aautogen := (attr as ColumnAttribute).IsAutoGenerated;

              fp := TFieldProp.Create;
              fp.fieldName := name;
              fp.fieldType := TFieldType.ftUnknown;
              if aautogen then
              // do nothing
              else
              begin
                fp.fieldType := GetFieldType(prop.PropertyType.TypeKind, alength, aprecision, ascale, prop.PropertyType.Handle);
                fp.fieldValue := prop.GetValue(AEntity);
              end;

              if (not fp.fieldValue.IsEmpty) and not(aautogen) then
                flds.Add(fp);

              Break;
            end;
          end;

          if (not fp.fieldValue.IsEmpty) and not(aautogen) then
          begin
            if pars<>'' then
            begin
              pars := pars + ',';
              vals := vals + ',';
            end;
            pars := pars + name;
            vals := vals + ':' + name;
          end;
        end;

      end;
    finally
      FRttiContext.Free;
    end;

    Result := False;
    fdQry := CreateQuery;
    try
      fdQry.SQL.Clear;
      fdQry.SQL.Add('insert into '+tableName+' ');
      fdQry.SQL.Add(' ('+pars+')');
      fdQry.SQL.Add(' values ');
      fdQry.SQL.Add(' ('+vals+')');

      for fp in flds do
      begin
        if (fdQry.FindParam(fp.fieldName)<>nil) or not(fp.fieldValue.IsEmpty) then
        begin
          fdQry.ParamByName(fp.fieldName).DataType := fp.fieldType;
          fdQry.ParamByName(fp.fieldName).Value := fp.fieldValue.AsVariant;
        end;
      end;
      fdQry.ExecSQL;
      Result := True;
    finally
      fdQry.Free;
    end;
  finally
    flds.Free;
  end;
end;

function TDMMain.AppendRecord<T>(ASourceDS: TDataset; const AAllRecords: Boolean = false) : Boolean;
var
  FRttiContext: TRttiContext;
  LRttiType: TRttiType;

  attr: TCustomAttribute;
  tableName: string;
  dbName: string;
  fdQry: TFDQuery;

  pars,
  vals : string;

  aautogen : Boolean;

  prop : TRttiProperty;
  name : string;

  fp : TCollectionItem; // TFDParam;

begin
  if not ASourceDS.Active then
    raise Exception.Create('SSourceDSIsNotOpened');

  FRttiContext := TRttiContext.Create;
  try
    LRttiType := FRttiContext.GetType(TypeInfo(T));

    for attr in LRttiType.GetAttributes do
      if attr is TableAttribute then
      begin
        tableName := (attr as TableAttribute).Schema + (attr as TableAttribute).TableName;
        Break;
      end;

    pars := '';
    vals := '';

    for prop in LRttiType.GetProperties do
    begin
      if prop.Visibility in [mvPublished, mvPublic] then
      begin
        name := prop.Name;

        for attr in prop.GetAttributes do
        begin
          if attr is ColumnAttribute then
          begin
            if (ColumnAttribute(attr).ColumnName<>'') then
              name := ColumnAttribute(attr).ColumnName;

            aautogen := (attr as ColumnAttribute).IsAutoGenerated;
            Break;
          end;
        end;

        if (ASourceDS.FindField(name)<>nil) and not(aautogen) then
        begin
          if pars<>'' then
          begin
            pars := pars + ',';
            vals := vals + ',';
          end;
          pars := pars + name;
          vals := vals + ':' + name;
        end;
      end;

    end;
  finally
    FRttiContext.Free;
  end;

  Result := False;

  fdQry := CreateQuery;
  try
    fdQry.SQL.Clear;
    fdQry.SQL.Add('insert into '+tableName+' ');
    fdQry.SQL.Add(' ('+pars+')');
    fdQry.SQL.Add(' values ');
    fdQry.SQL.Add(' ('+vals+')');

    if AAllRecords then
    begin
      ASourceDS.First;
      while not ASourceDS.Eof do
      begin
        for fp in fdQry.Params do
        begin
          TFDParam(fp).DataType := ASourceDS.FieldByName(TFDParam(fp).Name).DataType;
          TFDParam(fp).Value := ASourceDS.FieldByName(TFDParam(fp).Name).Value;
        end;

        fdQry.ExecSQL;
        ASourceDS.Next;
      end;
    end
    else
    begin
      for fp in fdQry.Params do
      begin
        TFDParam(fp).DataType := ASourceDS.FieldByName(TFDParam(fp).Name).DataType;
        TFDParam(fp).Value := ASourceDS.FieldByName(TFDParam(fp).Name).Value;
      end;
      fdQry.ExecSQL;
    end;

    Result := True;
  finally
    fdQry.Free;
  end;

end;

function TDMMain.UpdateRecord<T>(AId: Integer; AEntity: TObject): Boolean;
var
    FRttiContext: TRttiContext;
    LRttiType: TRttiType;
    m : TRttiMethod;
    prop : TRttiProperty;
    i : Integer;
    //s : string;
    name : string;
    dbName : string;
    tableName : string;
    attr : TCustomAttribute;
    pars, vals : string;

    alength, aprecision, ascale : Integer;
    aautogen : Boolean;

    flds : TObjectList<TFieldProp>;
    fp : TFieldProp;
    dt : TFieldType;
    fdQry : TFDQuery;
    spk : string;
begin
  i := 0;

  flds := TObjectList<TFieldProp>.Create;
  try
    FRttiContext := TRttiContext.Create;
    try
      LRttiType := FRttiContext.GetType(TypeInfo(T));

      for attr in LRttiType.GetAttributes do
        if attr is TableAttribute then
        begin
          tableName := (attr as TableAttribute).Schema + (attr as TableAttribute).TableName;
          Break;
        end;

      pars := '';
      vals := '';
      spk := '';
      for prop in LRttiType.GetProperties do
      begin
        if prop.Visibility in [mvPublished, mvPublic] then
        begin
          name := prop.Name;

          for attr in prop.GetAttributes do
          begin
            if attr is ColumnAttribute then
            begin
              if (ColumnAttribute(attr).ColumnName<>'') then
                name := ColumnAttribute(attr).ColumnName;

              alength := (attr as ColumnAttribute).Length;
              aprecision := (attr as ColumnAttribute).Precision;
              ascale := (attr as ColumnAttribute).Scale;
              //colProps := (attr as ColumnAttribute).ColProps;

              aautogen := (attr as ColumnAttribute).IsAutoGenerated;

              if spk='' then
                if ColumnAttribute(attr).IsPrimaryKey then
                  spk := ColumnAttribute(attr).ColumnName;

              fp := TFieldProp.Create;
              fp.fieldName := name;
              fp.fieldType := TFieldType.ftUnknown;
              if not aautogen then
              begin
                fp.fieldType := GetFieldType(prop.PropertyType.TypeKind, alength, aprecision, ascale, prop.PropertyType.Handle);
                fp.fieldValue := prop.GetValue(AEntity);
              end;

              if (not fp.fieldValue.IsEmpty) and not(aautogen) then
                flds.Add(fp);

              Break;
            end;
          end;

          if (not fp.fieldValue.IsEmpty) and not(aautogen) then
          begin
            if pars<>'' then
            begin
              pars := pars + ',';
              //vals := vals + ',';
            end;
            pars := pars + name +'= :'+name;
            //vals := vals + ':' + name;
          end;
        end;

      end;
    finally
      FRttiContext.Free;
    end;

    if spk='' then
      raise Exception.Create('Primary key not specified for this Entity : '+tableName);

    Result := False;
    fdQry := CreateQuery;
    try
      fdQry.SQL.Clear;
      fdQry.SQL.Add('Update '+tableName+' ');
      fdQry.SQL.Add('Set');
      fdQry.SQL.Add(pars);
      fdQry.SQL.Add('where '+spk+'='+IntToStr(AId));
      for fp in flds do
      begin
        if (fdQry.FindParam(fp.fieldName)<>nil) or not(fp.fieldValue.IsEmpty) then
        begin
          fdQry.ParamByName(fp.fieldName).DataType := fp.fieldType;
          fdQry.ParamByName(fp.fieldName).Value := TValueToVariant(fp.fieldValue);
        end;
      end;
      fdQry.ExecSQL;
      Result := True;
    finally
      fdQry.Free;
    end;
  finally
    flds.Free;
  end;

end;

function TDMMain.UpdateRecord<T>(AId : Integer; ASourceDS: TDataset; const AAllRecords: Boolean = false) : Boolean;
var
  FRttiContext: TRttiContext;
  LRttiType: TRttiType;

  attr: TCustomAttribute;
  tableName: string;
  dbName: string;
  fdQry: TFDQuery;

  pars : string;

  aautogen : Boolean;

  prop : TRttiProperty;
  name : string;

  fp : TCollectionItem; // TFDParam;
  bm : TBookmark;
  spk : string;
begin
  if not ASourceDS.Active then
    raise Exception.Create('SSourceDSIsNotOpened');

  FRttiContext := TRttiContext.Create;
  try
    LRttiType := FRttiContext.GetType(TypeInfo(T));

    for attr in LRttiType.GetAttributes do
      if attr is TableAttribute then
      begin
        tableName := (attr as TableAttribute).Schema + (attr as TableAttribute).TableName;
        Break;
      end;

    pars := '';
    spk := '';

    for prop in LRttiType.GetProperties do
    begin
      if prop.Visibility in [mvPublished, mvPublic] then
      begin
        name := prop.Name;

        for attr in prop.GetAttributes do
        begin
          if attr is ColumnAttribute then
          begin
            if (ColumnAttribute(attr).ColumnName<>'') then
              name := ColumnAttribute(attr).ColumnName;

            aautogen := (attr as ColumnAttribute).IsAutoGenerated;

            if spk='' then
              if ColumnAttribute(attr).IsPrimaryKey then
                spk := ColumnAttribute(attr).ColumnName;

            Break;
          end;
        end;


        if (ASourceDS.FindField(name)<>nil) and not(aautogen) then
        begin
          if pars<>'' then
          begin
            pars := pars + ',';
          end;
          pars := pars + name + '= :'+name;
        end;
      end;

    end;
  finally
    FRttiContext.Free;
  end;

  Result := False;

  fdQry := CreateQuery;
  try
    fdQry.SQL.Clear;
    fdQry.SQL.Add('update '+tableName+' set ');
    fdQry.SQL.Add(' '+pars+' ');

    if AAllRecords then
    begin
      bm := ASourceDS.GetBookmark;
      try
        fdQry.SQL.Add('where '+spk+'='+IntToStr(AId));
        ASourceDS.First;
        while not ASourceDS.Eof do
        begin
          fdQry.SQL[fdQry.SQL.Count-1] := 'where '+spk+'='+IntToStr(ASourceDS.FieldByName(spk).AsInteger);
          for fp in fdQry.Params do
          begin
            TFDParam(fp).DataType := ASourceDS.FieldByName(TFDParam(fp).Name).DataType;
            TFDParam(fp).Value := ASourceDS.FieldByName(TFDParam(fp).Name).Value;
          end;

          fdQry.ExecSQL;

          ASourceDS.Next;
        end;
      finally
        ASourceDS.GotoBookmark(bm);
        ASourceDS.FreeBookmark(bm);
      end;
    end
    else
    begin
      fdQry.SQL.Add('where '+spk+'='+IntToStr(AId));
      for fp in fdQry.Params do
      begin
        TFDParam(fp).DataType := ASourceDS.FieldByName(TFDParam(fp).Name).DataType;
        TFDParam(fp).Value := ASourceDS.FieldByName(TFDParam(fp).Name).Value;
      end;
      fdQry.ExecSQL;
    end;

    Result := True;
  finally
    fdQry.Free;
  end;
end;

procedure TDMMain.DataModuleCreate(Sender: TObject);
var ini : TIniFile;
begin
  IniFName :=   System.SysUtils.GetCurrentDir+'\Ornek.ini';

  ini := TIniFile.Create(IniFName);
  try
    MyServer := Ini.ReadString('DB Connection', 'Server', '');
    MyServerUsesOSAuthenticate := Ini.ReadBool('DB Connection', 'OSAuthenticate', False);
    MyServerUsername := Ini.ReadString('DB Connection', 'Username', '');
    MyServerPassword := Ini.ReadString('DB Connection', 'Password', '');
    MyDBName := Ini.ReadString('DB Connection', 'Database', MyDBName);
    if (MyServer='') or (MyServerUsername='') or (MyDBName='') then
      if ServerLoginParams(MyServer, MyServerUsername, MyServerPassword, MyServerUsesOSAuthenticate, MyDBName) then
      begin
        Ini.WriteString('DB Connection', 'Server', MyServer);
        Ini.WriteBool('DB Connection', 'OSAuthenticate', MyServerUsesOSAuthenticate);
        Ini.WriteString('DB Connection', 'Username', MyServerUsername);
        Ini.WriteString('DB Connection', 'Password', MyServerPassword);
        Ini.WriteString('DB Connection', 'Database', MyDBName);
      end
      else
        Abort;
  finally
    ini.Free;
  end;

  MyDB.Connected := False;
  MyDB.DriverName := 'MSSQL';

  MyDB.Params.Clear;
  MyDB.Params.Add('DriverID=MSSQL');
  MyDB.Params.Add('Server='+MyServer);
  MyDB.Params.Add('Database='+MyDBName);

  MyDB.Params.Add('User_Name='+MyServerUsername);
  MyDB.Params.Add('Password='+MyServerPassword);
  MyDB.Params.Add('CharacterSet='+MyServerCharset);

  repeat
    try
      MyDB.Connected := True;
    except
      if MessageDlg(Support.LanguageDictionary.MessageDictionary('').GetMessage(SDatabaseNotFoundCreate), TMsgDlgType.mtConfirmation, [mbYes, mbNo], 0)=mrYes then
        CreateDB
      else
        raise;
    end;
  until MyDB.Connected;
end;

procedure TDMMain.CreateDB;
var cmd : TFDCommand;
begin
  MyDB.Params.Clear;
  MyDB.Params.Add('DriverID=MSSQL');
  MyDB.Params.Add('Server='+MyServer);
  MyDB.Params.Add('Database=tempdb');

  MyDB.Params.Add('User_Name='+MyServerUsername);
  MyDB.Params.Add('Password='+MyServerPassword);
  MyDB.Params.Add('CharacterSet='+MyServerCharset);

  MyDB.Connected := True;
  cmd := TFDCommand.Create(Self);
  try
    cmd.Connection := MyDB;
    cmd.CommandKind := TFDPhysCommandKind.skCreate;
    cmd.CommandText.Add('create database '+MyDBName);
    cmd.Execute();
  finally
    cmd.Free;
  end;
  MyDB.Connected := False;
  MyDB.Params.Database := MyDBName;
  MyDB.Connected := True;

  cmd := TFDCommand.Create(self);
  try
    cmd.Connection := MyDB;
    cmd.CommandKind := TFDPhysCommandKind.skCreate;
    cmd.CommandText.Text := 'create table CurrencyType('#13#10+
            '  CurrencyTypeId integer not null identity(1,1) primary key,'#13#10+
            '  CurrencyCode varchar(5) not null,'#13#10+
            '  CurrencyName nvarchar(50)'#13#10+
            ');';
    cmd.Execute();

    cmd.CommandText.Text := 'insert into CurrencyType (CurrencyCode, CurrencyName) values'#13#10+
                '(''USD'', ''ABD Dolarý''),'#13#10+
                '(''EUR'', ''Avrupa Para Birimi''),'#13#10+
                '(''AUD'', ''Avustralya Dolarý''),'#13#10+
                '(''DKK'', ''Danimarka Kronu''),'#13#10+
                '(''GBP'', ''Ýngiliz Sterlini''),'#13#10+
                '(''CHF'', ''Ýsviçre Frangý''),'#13#10+
                '(''SEK'', ''Ýsveç Kronu''),'#13#10+
                '(''CAD'', ''Kanada Dolarý''),'#13#10+
                '(''KWD'', ''Kuveyt Dinarý''),'#13#10+
                '(''NOK'', ''Norveç Kronu''),'#13#10+
                '(''SAR'', ''Suudi Arabistan Riyali''),'#13#10+
                '(''JPY'', ''Japon Yeni'')'#13#10;
    cmd.Execute();

    cmd.CommandText.Text := 'create table CurrencyDailyRate('#13#10+
                '  CurrencyDailyRateId integer not null identity(1,1) primary key,'#13#10+
                '  CurrencyDate date not null,'#13#10+
                '  CurrencyTypeId integer not null,'#13#10+
                '  BuyingRate float default 0,'#13#10+
                '  SellingRate float default 0,'#13#10+
                '  CONSTRAINT FK_CurrencyDailyRate_CurrencyType FOREIGN KEY (CurrencyTypeId)'#13#10+
                '    REFERENCES CurrencyType (CurrencyTypeId)'#13#10+
                ');'#13#10;
    cmd.Execute();

    cmd.CommandText.Text := 'create table Customer('#13#10+
              '  CustomerId integer not null identity(1,1) primary key,'#13#10+
              '  CustomerName nvarchar(100) null,'#13#10+
              '  AddressLine1 nvarchar(50) null,'#13#10+
              '  AddressLine2 nvarchar(50) null,'#13#10+
              '  AddressLine3 nvarchar(50) null,'#13#10+
              '  City nvarchar(50) null,'#13#10+
              '  Country nvarchar(50) null,'#13#10+
              '  PostCode nvarchar(20) null,'#13#10+
              '  ContactPerson nvarchar(50) null,'#13#10+
              '  Phone varchar(15) null,'#13#10+
              '  Fax varchar(15) null,'#13#10+
              '  ContactEMail nvarchar(100) null,'#13#10+
              '  CurrencyTypeId integer,'#13#10+
              '  TotalDebit float default 0,'#13#10+
              '  TotalCredit float default 0,'#13#10+
              '  Balance float default 0,'#13#10+
              '  PaymentDueDate integer default 0,'#13#10+
              '  InBlackList bit not null default 0,'#13#10+
              '  IsActive bit not null default 1,'#13#10+
              ');';
    cmd.Execute();

    cmd.CommandText.Text := 'insert into Customer'#13#10+
        '(CustomerName, AddressLine1, AddressLine2, AddressLine3, City, Country, ContactPerson, Phone, Fax, ContactEMail)'#13#10+
        'values'#13#10+
    '(''Kart Dekorasyon Malzemeleri ve Müt.Hiz. A.Þ.'', ''Bedesten Sok. Katmerli Han No:4/13 Kat:3'', ''Karaköy'', '+#39#39+', ''Ýstanbul'', ''Türkiye'', ''Ahmet Alagöz'', ''0532717717'', ''02127127272'', ''a-alagoz@gmail.com''),'#13#10+
    '(''Damak Þekercilik ve Pastacýlýk Ltd.'', ''Limon Sok. Hacýoðlu Ap. No:12/1'', ''Göztepe'', '+#39#39+', ''Ýstanbul'', ''Türkiye'', ''Murat Yapan'', ''05327177818'', ''02127127273'', ''muratyapan@damak.com.tr'');';
    cmd.Execute();

    cmd.CommandText.Text := 'create table Supplier('#13#10+
        '  SupplierId integer not null identity(1,1) primary key,'#13#10+
        '  SupplierName nvarchar(100) null,'#13#10+
        '  AddressLine1 nvarchar(50) null,'#13#10+
        '  AddressLine2 nvarchar(50) null,'#13#10+
        '  AddressLine3 nvarchar(50) null,'#13#10+
        '  City nvarchar(50) null,'#13#10+
        '  Country nvarchar(50) null,'#13#10+
        '  PostCode nvarchar(20) null,'#13#10+
        '  ContactPerson nvarchar(50) null,'#13#10+
        '  Phone varchar(15) null,'#13#10+
        '  Fax varchar(15) null,'#13#10+
        '  ContactEMail nvarchar(100) null,'#13#10+
        '  CurrencyTypeId integer,'#13#10+
        '  TotalDebit float default 0,'#13#10+
        '  TotalCredit float default 0,'#13#10+
        '  Balance float default 0,'#13#10+
        '  PaymentDueDate integer default 0,'#13#10+
        '  InBlackList bit not null default 0,'#13#10+
        '  IsActive bit not null default 1,'#13#10+
        '  CONSTRAINT FK_Customer_CurrencyType FOREIGN KEY (CurrencyTypeId)'#13#10+
        '    REFERENCES CurrencyType (CurrencyTypeId)'#13#10+
        ');';
    cmd.Execute();

    cmd.CommandText.Text := 'insert into Supplier'#13#10+
        '(SupplierName, AddressLine1, AddressLine2, AddressLine3, City, Country, ContactPerson, Phone, Fax, ContactEMail)'#13#10+
        'values'#13#10+
'(''Kartel Yemek ve Ýkram Üretim ve Satýþ A.Þ.'', '+#39#39', ''Ümraniye'', '+#39#39+', ''Ýstanbul'', ''Türkiye'', ''Mehmet Yurdan'', ''0532717719'', ''02127127274'', ''mehmetyurdan@gmail.com''),'#13#10+
'(''Alaylý Otomotiv San. ve Tic. A.Þ.'', ''Yalý Cad. Nur Han No:15/44 Kat 4'', ''Karaköy'', '+#39#39+', ''Ýstanbul'', ''Türkiye'', ''Yelda Saran'', ''05327177819'', ''02127127275'', ''yeldasaran@alayliotomotiv.com.tr'');';
    cmd.Execute();

    cmd.CommandText.Text := 'create table InventoryGroup('#13#10+
        '  InventoryGroupId integer not null identity(1,1) primary key,'#13#10+
        '  InventoryGroupName nvarchar(100) not null'#13#10+
        ');';
    cmd.Execute();

    cmd.CommandText.Text := 'insert into InventoryGroup (InventoryGroupName) values'#13#10+
        '(''Kaðýt''),'#13#10+
        '(''Defter''),'#13#10+
        '(''Kalem''),'#13#10+
        '(''Ders kitabý''),'#13#10+
        '(''Edebi kitaplar''),'#13#10+
        '(''Oyuncak''),'#13#10+
        '(''Diðer''),'#13#10+
        '(''Sarf malzemeleri''),'#13#10+
        '(''Hizmet'')';
    cmd.Execute();

    cmd.CommandText.Text := 'create table Inventory('#13#10+
        '  InventoryId integer not null identity(1,1) primary key,'#13#10+
        '  InventoryGroupId integer not null,'#13#10+
        '  MainSupplierId integer null,'#13#10+
        '  InventoryCode nvarchar(30) not null,'#13#10+
        '  InventoryName nvarchar(100) not null,'#13#10+
        '  SpecCode nvarchar(20) null,'#13#10+
        '  StoragePlace nvarchar(100) null,'#13#10+
        '  PictureFileName nvarchar(100) null,'#13#10+
        '  Measurements nvarchar(50) null,'#13#10+
        '  CurrencyTypeId integer null,'#13#10+
        '  BuyingPrice float null,'#13#10+
        '  SellingPrice float null,'#13#10+
        '  VatPercentage float null,'#13#10+
        '  TotalIncomingQtty float default 0,'#13#10+
        '  TotalOutgoingQtty float default 0,'#13#10+
        '  TotalIncomingAmount float default 0,'#13#10+
        '  TotalOutgoingAmount float default 0,'#13#10+
        '  OtvAmount float default 0,'#13#10+
        '  UnitDesc nvarchar(10) null,'#13#10+
        '  ReorderPoint float default 0,'#13#10+
        '  BufferStock float default 0,'#13#10+
        '  IsActive bit default 1,'#13#10+
        '  CONSTRAINT FK_Inventory_InventoryGroup FOREIGN KEY (InventoryGroupId)'#13#10+
        '    REFERENCES InventoryGroup (InventoryGroupId)'#13#10+
        ');'#13#10;
    cmd.Execute();

    cmd.CommandText.Text := 'insert into Inventory'#13#10+
    '(InventoryGroupId, MainSupplierId, InventoryCode, InventoryName,                        SpecCode, StoragePlace, Measurements, CurrencyTypeId, BuyingPrice, SellingPrice, VatPercentage, OtvAmount, UnitDesc, ReorderPoint, BufferStock)'#13#10+
    '  values'#13#10+
'(1,0,''KAG80-1'',	  ''Kaðýt 80 gram 1. hamur'',				 '#39#39',       ''C18R5'',    ''A4,80gr'',    null, 15,  19,  18, null, ''Paket'', 100, 20),'#13#10+
'(1,0,''KAG90-1'',	  ''Kaðýt 90 gram 1. hamur'',				 '#39#39',       ''C18R6'',    ''A4,90gr'',    null, 20,  25,  18, null, ''Paket'', 40, 5),'#13#10+
'(2,0,''DEFHMO160-3'', ''Defter Harita Metot 1 orta 3. hamur'', '#39#39',''C18R4'',		 ''B3,60yaprak'',null, 10,  13,  18, null, ''Adet'',  90, 10),'#13#10+
'(3,0,''RSKLSA3'',     ''Resim Kalemi Siyah A3'',				 ''kkk'',          ''R-B18'',    '+#39#39+',     2,    1.2, 1.4, 18, null, ''Adet'',  80, 10);';
    cmd.Execute();

    cmd.CommandText.Text := 'create table PurchaseInvoiceHeader('#13#10+
          '  PurchaseInvoiceHeaderId integer not null identity(1, 1) primary key,'#13#10+
          '  InvoiceDate datetime not null,'#13#10+
          '  InvoiceNumber nvarchar(20),'#13#10+
          '  SupplierId integer not null,'#13#10+
          '  SpecCode nvarchar(20) null,'#13#10+
          '  InvDescription nvarchar(100) null,'#13#10+
          '  CurrencyTypeId integer,'#13#10+
          '  CurrencyRate float,'#13#10+
          '  TotalAmount float,'#13#10+
          '  VatPercentage1 float,'#13#10+
          '  VatAmount1 float,'#13#10+
          '  VatPercentage2 float,'#13#10+
          '  VatAmount2 float,'#13#10+
          '  VatPercentage3 float,'#13#10+
          '  VatAmount3 float,'#13#10+
          '  TotalOtvAmount float,'#13#10+
          '  DueDate integer default 0,'#13#10+
          '  Paid bit default 0,'#13#10+
          '  MailAddress1 nvarchar(50) NULL,'#13#10+
          '  MailAddress2 nvarchar(50) NULL,'#13#10+
          '  MailAddress3 nvarchar(50) NULL,'#13#10+
          '  MailCity nvarchar(50) NULL,'#13#10+
          '  MailCountry nvarchar(50) NULL,'#13#10+
          '  MailPostCode nvarchar(20) NULL,'#13#10+
          '  CONSTRAINT FK_PurchaseInvoiceHeader_Supplier FOREIGN KEY (SupplierId)'#13#10+
          '    REFERENCES Supplier (SupplierId),'#13#10+
          '  CONSTRAINT FK_PurchaseInvoiceHeader_CurrencyType FOREIGN KEY (CurrencyTypeId)'#13#10+
          '    REFERENCES CurrencyType (CurrencyTypeId)'#13#10+
          ')';
    cmd.Execute();

    cmd.CommandText.Text :=
          'CREATE trigger PurchaseInvoiceHeader_SupplierUpdate ON PurchaseInvoiceHeader FOR INSERT, UPDATE, DELETE'#13#10+
          'AS'#13#10+
          '  DECLARE @SupplierId integer = -1;'#13#10+
          '  DECLARE @InvCurrencyId integer = -1;'#13#10+
          '  DECLARE @InvCurrencyRate float = 0;'#13#10+
          '  DECLARE @InvDate date;'#13#10+
          ' DECLARE @InvAmount float;'#13#10+
          ''#13#10+
          '  DECLARE @SupplierCurrencyId integer = -1;'#13#10+
          '  DECLARE @SupplierCurrencyRate float = 0;'#13#10+
          '  DECLARE @wCredit float;'#13#10+
          ''#13#10+
          '  if EXISTS(select * from deleted)'#13#10+
          '  begin'#13#10+
          '    select @SupplierId=H.SupplierId, @InvCurrencyId=H.CurrencyTypeId, @InvCurrencyRate=H.CurrencyRate,  @InvAmount=H.TotalAmount,'#13#10+
          '           @SupplierCurrencyId=S.CurrencyTypeId, @SupplierCurrencyRate=CR.SellingRate  from deleted H'#13#10+
          '            left outer join Supplier S on (S.SupplierId=H.SupplierId)'#13#10+
          '		     left outer join CurrencyDailyRate CR on (CR.CurrencyDailyRateId=S.CurrencyTypeId and CR.CurrencyDate=H.InvoiceDate);'#13#10+
          ''#13#10+
          '    if (ISNULL(@SupplierCurrencyId, -1)=-1)'#13#10+
          '	begin'#13#10+
          '	  SELECT @wCredit = ISNULL(@InvAmount, 0);'#13#10+
          '	end'#13#10+
          '	else'#13#10+
          '	if (ISNULL(@InvCurrencyId, -1)=ISNULL(@SupplierCurrencyId, -1))'#13#10+
          '    begin'#13#10+
          '     --SELECT @SupplierCurrencyRate = ISNULL(@InvCurrencyRate, 0)'#13#10+
          '	  SELECT @wCredit = ISNULL(@InvAmount, 0);'#13#10+
          '    end'#13#10+
          '    else'#13#10+
          '    begin'#13#10+
          '      SELECT @SupplierCurrencyRate=SellingRate from CurrencyDailyRate where CurrencyDate=@InvDate and CurrencyTypeId=@SupplierCurrencyId'#13#10+
          '	  if @SupplierCurrencyRate is null'#13#10+
          '	    SELECT @SupplierCurrencyRate = ISNULL(@InvCurrencyRate, 0)'#13#10+
          ''#13#10+
          '	  if ISNULL(@SupplierCurrencyRate, 0)=0 or ISNULL(@InvCurrencyRate, 0)=0'#13#10+
          '	    SELECT @wCredit = ISNULL(@InvCurrencyRate, 0) * ISNULL(@InvAmount, 0)'#13#10+
          '	  else'#13#10+
          '	    SELECT @wCredit = ISNULL(@InvCurrencyRate, 0) * ISNULL(@InvAmount, 0) / ISNULL(@SupplierCurrencyRate, 1)'#13#10+
          '    end'#13#10+
          '    update Supplier set TotalCredit = IsNull(TotalCredit, 0) - ISNULL(@wCredit, 0) where SupplierId=@SupplierId;'#13#10+
          '  end;'#13#10+
          ''#13#10+
          '  if EXISTS(select * from inserted)'#13#10+
          '  begin'#13#10+
          '    select @SupplierId=H.SupplierId, @InvCurrencyId=H.CurrencyTypeId, @InvCurrencyRate=H.CurrencyRate,  @InvAmount=H.TotalAmount,'#13#10+
          '          @SupplierCurrencyId=S.CurrencyTypeId, @SupplierCurrencyRate=CR.SellingRate  from inserted H'#13#10+
          '             left outer join Supplier S on (S.SupplierId=H.SupplierId)'#13#10+
          '		     left outer join CurrencyDailyRate CR on (CR.CurrencyDailyRateId=S.CurrencyTypeId and CR.CurrencyDate=H.InvoiceDate);'#13#10+
          ''#13#10+
          '    if (ISNULL(@SupplierCurrencyId, -1)=-1)'#13#10+
          '	begin'#13#10+
          '	  SELECT @wCredit = ISNULL(@InvAmount, 0);'#13#10+
          '	end'#13#10+
          '	else'#13#10+
          '	if (ISNULL(@InvCurrencyId, -1)=ISNULL(@SupplierCurrencyId, -1))'#13#10+
          '    begin'#13#10+
          '      --SELECT @SupplierCurrencyRate = ISNULL(@InvCurrencyRate, 0)'#13#10+
          '	  SELECT @wCredit = ISNULL(@InvAmount, 0);'#13#10+
          '    end'#13#10+
          '    else'#13#10+
          '    begin'#13#10+
          '      SELECT @SupplierCurrencyRate=SellingRate from CurrencyDailyRate where CurrencyDate=@InvDate and CurrencyTypeId=@SupplierCurrencyId'#13#10+
          '	  if @SupplierCurrencyRate is null'#13#10+
          '	    SELECT @SupplierCurrencyRate = ISNULL(@InvCurrencyRate, 0)'#13#10+
          ''#13#10+
          '	  if ISNULL(@SupplierCurrencyRate, 0)=0 or ISNULL(@InvCurrencyRate, 0)=0'#13#10+
          '	    SELECT @wCredit = ISNULL(@InvCurrencyRate, 0) * ISNULL(@InvAmount, 0)'#13#10+
          '	  else'#13#10+
          '	    SELECT @wCredit = ISNULL(@InvCurrencyRate, 0) * ISNULL(@InvAmount, 0) / ISNULL(@SupplierCurrencyRate, 1)'#13#10+
          '    end'#13#10+
          '    update Supplier set TotalCredit = IsNull(TotalCredit, 0) + ISNULL(@wCredit, 0) where SupplierId=@SupplierId;'#13#10+
          '  end;';
    cmd.Execute();

    cmd.CommandText.Text := 'create table PurchaseInvoiceDetail('#13#10+
          '  PurchaseInvoiceDetailId integer not null identity(1,1) primary key,'#13#10+
          '  PurchaseInvoiceHeaderId integer not null,'#13#10+
          '  InventoryId integer not null,'#13#10+
          '  Quantity float not null default 0,'#13#10+
          '  UnitPrice float not null,'#13#10+
          '  VatPercentage float default 0,'#13#10+
          '  VatAmount float default 0,'#13#10+
          '  OtvAmount float default 0,'#13#10+
          '  TotalAmount float,'#13#10+
          '  SpecCode varchar(20) null,'#13#10+
          '  LineDescription nvarchar(100) null,'#13#10+
          '  InvoiceDate datetime not null,'#13#10+
          '  SupplierId integer not null,'#13#10+
          '  CurrencyTypeId integer,'#13#10+
          '  CurrencyRate float,'#13#10+
          '  CONSTRAINT FK_PurchaseInvoiceDetail_PurchaseInvoiceHeader FOREIGN KEY (PurchaseInvoiceHeaderId)'#13#10+
          '    REFERENCES PurchaseInvoiceHeader (PurchaseInvoiceHeaderId),'#13#10+
          '  CONSTRAINT FK_PurchaseInvoiceDetail_Inventory FOREIGN KEY (InventoryId)'#13#10+
          '    REFERENCES Inventory (InventoryId)'#13#10+
          ')';
    cmd.Execute();

    cmd.CommandText.Text :=
          'create trigger PurchaseInvoiceDetail_InventoryUpdate ON PurchaseInvoiceDetail FOR INSERT, UPDATE, DELETE'#13#10+
          'AS'#13#10+
          '  DECLARE @InvCurrencyId integer = -1;'#13#10+
          '  DECLARE @InvCurrencyRate float = 0;'#13#10+
          '  DECLARE @InvDate date;'#13#10+
          ''#13#10+
          '  DECLARE @InventoryId integer = -1;'#13#10+
          '  DECLARE @InventoryCurrencyId integer;'#13#10+
          '  DECLARE @InventoryCurrencyRate float;'#13#10+
          ''#13#10+
          '  DECLARE @IncomingQtty float;'#13#10+
          '  --DECLARE @OutgoingQtty float;'#13#10+
          '  DECLARE @IncomingAmount float;'#13#10+
          '  --DECLARE @OutgoingAmount float;'#13#10+
          ''#13#10+
          '  DECLARE @wAmount float;'#13#10+
          '  if EXISTS(select * from deleted)'#13#10+
          '  begin'#13#10+
          '    select @InventoryId=D.InventoryId, @InvCurrencyId=D.CurrencyTypeId, @IncomingQtty=D.Quantity, @wAmount=D.TotalAmount,'#13#10+
          '           @InventoryCurrencyId=INVENTORY.CurrencyTypeId, @InventoryCurrencyRate=CUR.SellingRate from deleted D'#13#10+
          '        left outer join Inventory INVENTORY on(INVENTORY.InventoryId=D.InventoryId)'#13#10+
          '	    left outer join CurrencyDailyRate CUR on(CUR.CurrencyTypeId=INVENTORY.CurrencyTypeId and CUR.CurrencyDate=D.InvoiceDate);'#13#10+
          ''#13#10+
          '    if (ISNULL(@InvCurrencyId, -1)=ISNULL(@InventoryCurrencyId, -1))'#13#10+
          '    begin'#13#10+
          '	  SELECT @IncomingAmount = @wAmount;'#13#10+
          '    end'#13#10+
          '    else'#13#10+
          '    begin'#13#10+
          '	  if (ISNULL(@InventoryCurrencyRate, 0)=0)'#13#10+
          '	  begin'#13#10+
          '	    SELECT @IncomingAmount = ISNULL(@wAmount, 0) * ISNULL(@InvCurrencyRate, 0);'#13#10+
          '	  end'#13#10+
          '	  else'#13#10+
          '	  begin'#13#10+
          '        SELECT @IncomingAmount = ISNULL(@wAmount, 0) * ISNULL(@InvCurrencyRate, 0) / ISNULL(@InventoryCurrencyRate, 0);'#13#10+
          '	  end'#13#10+
          '    end'#13#10+
          ''#13#10+
          '    update Inventory set'#13#10+
          '      TotalIncomingQtty = ISNULL(TotalIncomingQtty, 0) - ISNULL(@IncomingQtty, 0),'#13#10+
          '      --TotalOutgoingQtty = ISNULL(TotalOutgoingQtty, 0) - ISNULL(@OutgoingQtty, 0),'#13#10+
          '      TotalIncomingAmount = ISNULL(TotalIncomingAmount, 0) - ISNULL(@IncomingAmount, 0)'#13#10+
          '      --TotalOutgoingAmount = ISNULL(TotalOutgoingAmount, 0) - ISNULL(@OutgoingAmount, 0)'#13#10+
          '    where'#13#10+
          '      InventoryId = @InventoryId;'#13#10+
          '  end'#13#10+
          ''#13#10+
          '  if EXISTS(select * from inserted)'#13#10+
          '  begin'#13#10+
          '    select @InventoryId=D.InventoryId, @InvCurrencyId=D.CurrencyTypeId, @IncomingQtty=D.Quantity, @wAmount=D.TotalAmount,'#13#10+
          '           @InventoryCurrencyId=INVENTORY.CurrencyTypeId, @InventoryCurrencyRate=CUR.SellingRate from inserted D'#13#10+
          '        left outer join Inventory INVENTORY on(INVENTORY.InventoryId=D.InventoryId)'#13#10+
          '	    left outer join CurrencyDailyRate CUR on(CUR.CurrencyTypeId=INVENTORY.CurrencyTypeId and CUR.CurrencyDate=D.InvoiceDate);'#13#10+
          ''#13#10+
          '     if (ISNULL(@InvCurrencyId, -1)=ISNULL(@InventoryCurrencyId, -1))'#13#10+
          '    begin'#13#10+
          '	  SELECT @IncomingAmount = @wAmount;'#13#10+
          '    end'#13#10+
          '    else'#13#10+
          '    begin'#13#10+
          '	  if (ISNULL(@InventoryCurrencyRate, 0)=0)'#13#10+
          '	  begin'#13#10+
          '	    SELECT @IncomingAmount = ISNULL(@wAmount, 0) * ISNULL(@InvCurrencyRate, 0);'#13#10+
          '	  end'#13#10+
          '	  else'#13#10+
          '	  begin'#13#10+
          '        SELECT @IncomingAmount = ISNULL(@wAmount, 0) * ISNULL(@InvCurrencyRate, 0) / ISNULL(@InventoryCurrencyRate, 0);'#13#10+
          '	  end'#13#10+
          '    end'#13#10+
          ''#13#10+
          '    update Inventory set'#13#10+
          '      TotalIncomingQtty = ISNULL(TotalIncomingQtty, 0) + ISNULL(@IncomingQtty, 0),'#13#10+
          '      --TotalOutgoingQtty = ISNULL(TotalOutgoingQtty, 0) + ISNULL(@OutgoingQtty, 0),'#13#10+
          '      TotalIncomingAmount = ISNULL(TotalIncomingAmount, 0) + ISNULL(@IncomingAmount, 0)'#13#10+
          '      --TotalOutgoingAmount = ISNULL(TotalOutgoingAmount, 0) + ISNULL(@OutgoingAmount, 0)'#13#10+
          '    where'#13#10+
          '      InventoryId = @InventoryId;'#13#10+
          '  end';

   cmd.Execute();

   cmd.CommandText.Text := 'create table SalesInvoiceHeader('#13#10+
          '  SalesInvoiceHeaderId integer not null primary key,'#13#10+
          '  InvoiceDate datetime not null,'#13#10+
          '  InvoiceNumber nvarchar(20),'#13#10+
          '  CustomerId integer not null,'#13#10+
          '  SpecCode varchar(20) null,'#13#10+
          '  InvDescription nvarchar(100) null,'#13#10+
          '  CurrencyTypeId integer,'#13#10+
          '  CurrencyRate float,'#13#10+
          '  TotalAmount float,'#13#10+
          '  VatPercentage1 float,'#13#10+
          '  VatAmount1 float,'#13#10+
          '  VatPercentage2 float,'#13#10+
          '  VatAmount2 float,'#13#10+
          '  VatPercentage3 float,'#13#10+
          '  VatAmount3 float,'#13#10+
          '  TotalOtvAmount float,'#13#10+
          '  DueDate integer default 0,'#13#10+
          '  Paid bit default 0,'#13#10+
          '  DeliveryAddress1 nvarchar(50) null,'#13#10+
          '  DeliveryAddress2 nvarchar(50) null,'#13#10+
          '  DeliveryAddress3 nvarchar(50) null,'#13#10+
          '  DeliveryCity nvarchar(50) null,'#13#10+
          '  DeliveryCountry nvarchar(50) null,'#13#10+
          '  DeliveryPostCode nvarchar(20) null,'#13#10+
          '  CONSTRAINT FK_SalesInvoiceHeader_Customer FOREIGN KEY (CustomerId)'#13#10+
          '    REFERENCES Customer (CustomerId),'#13#10+
          '  CONSTRAINT FK_SalesInvoiceHeader_CurrencyType FOREIGN KEY (CurrencyTypeId)'#13#10+
          '    REFERENCES CurrencyType (CurrencyTypeId)'#13#10+
          ')';
    cmd.Execute();

    cmd.CommandText.Text :=
          'CREATE trigger SalesInvoiceHeader_SupplierUpdate ON SalesInvoiceHeader FOR INSERT, UPDATE, DELETE'#13#10+
          'AS'#13#10+
          '  DECLARE @CustomerId integer = -1;'#13#10+
          '  DECLARE @InvCurrencyId integer = -1;'#13#10+
          '  DECLARE @InvCurrencyRate float = 0;'#13#10+
          '  DECLARE @InvDate date;'#13#10+
          '  DECLARE @InvAmount float;'#13#10+
          ''#13#10+
          '  DECLARE @CustomerCurrencyId integer = -1;'#13#10+
          '  DECLARE @CustomerCurrencyRate float = 0;'#13#10+
          '  DECLARE @wCredit float;'#13#10+
          ''#13#10+
          '  if EXISTS(select * from deleted)'#13#10+
          '  begin'#13#10+
          '    select @CustomerId=H.CustomerId, @InvCurrencyId=H.CurrencyTypeId, @InvCurrencyRate=H.CurrencyRate,  @InvAmount=H.TotalAmount,'#13#10+
          '           @CustomerCurrencyId=S.CurrencyTypeId, @CustomerCurrencyRate=CR.SellingRate  from deleted H'#13#10+
          '             left outer join Customer S on (S.CustomerId=H.CustomerId)'#13#10+
          '		     left outer join CurrencyDailyRate CR on (CR.CurrencyDailyRateId=S.CurrencyTypeId and CR.CurrencyDate=H.InvoiceDate);'#13#10+
          ''#13#10+
          '    if (ISNULL(@CustomerCurrencyId, -1)=-1)'#13#10+
          '	begin'#13#10+
          '	  SELECT @wCredit = ISNULL(@InvAmount, 0);'#13#10+
          '	end'#13#10+
          '	else'#13#10+
          '	if (ISNULL(@InvCurrencyId, -1)=ISNULL(@CustomerCurrencyId, -1))'#13#10+
          '    begin'#13#10+
          '      --SELECT @CustomerCurrencyRate = ISNULL(@InvCurrencyRate, 0)'#13#10+
          '	  SELECT @wCredit = ISNULL(@InvAmount, 0);'#13#10+
          '    end'#13#10+
          '    else'#13#10+
          '    begin'#13#10+
          '      SELECT @CustomerCurrencyRate=SellingRate from CurrencyDailyRate where CurrencyDate=@InvDate and CurrencyTypeId=@CustomerCurrencyId'#13#10+
          '	  if @CustomerCurrencyRate is null'#13#10+
          '	    SELECT @CustomerCurrencyRate = ISNULL(@InvCurrencyRate, 0)'#13#10+
          ''#13#10+
          '	  if ISNULL(@CustomerCurrencyRate, 0)=0 or ISNULL(@InvCurrencyRate, 0)=0'#13#10+
          '	    SELECT @wCredit = ISNULL(@InvCurrencyRate, 0) * ISNULL(@InvAmount, 0)'#13#10+
          '	  else'#13#10+
          '	    SELECT @wCredit = ISNULL(@InvCurrencyRate, 0) * ISNULL(@InvAmount, 0) / ISNULL(@CustomerCurrencyRate, 1)'#13#10+
          '    end'#13#10+
          '    update Customer set TotalCredit = IsNull(TotalCredit, 0) - ISNULL(@wCredit, 0) where CustomerId=@CustomerId;'#13#10+
          '  end;'#13#10+
          ''#13#10+
          '  if EXISTS(select * from inserted)'#13#10+
          '  begin'#13#10+
          '    select @CustomerId=H.CustomerId, @InvCurrencyId=H.CurrencyTypeId, @InvCurrencyRate=H.CurrencyRate,  @InvAmount=H.TotalAmount,'#13#10+
          '           @CustomerCurrencyId=S.CurrencyTypeId, @CustomerCurrencyRate=CR.SellingRate  from inserted H'#13#10+
          '             left outer join Customer S on (S.CustomerId=H.CustomerId)'#13#10+
          '		     left outer join CurrencyDailyRate CR on (CR.CurrencyDailyRateId=S.CurrencyTypeId and CR.CurrencyDate=H.InvoiceDate);'#13#10+
          ''#13#10+
          '    if (ISNULL(@CustomerCurrencyId, -1)=-1)'#13#10+
          '	begin'#13#10+
          '	  SELECT @wCredit = ISNULL(@InvAmount, 0);'#13#10+
          '	end'#13#10+
          '	else'#13#10+
          '	if (ISNULL(@InvCurrencyId, -1)=ISNULL(@CustomerCurrencyId, -1))'#13#10+
          '    begin'#13#10+
          '      --SELECT @CustomerCurrencyRate = ISNULL(@InvCurrencyRate, 0)'#13#10+
          '	     SELECT @wCredit = ISNULL(@InvAmount, 0);'#13#10+
          '    end'#13#10+
          '    else'#13#10+
          '    begin'#13#10+
          '      SELECT @CustomerCurrencyRate=SellingRate from CurrencyDailyRate where CurrencyDate=@InvDate and CurrencyTypeId=@CustomerCurrencyId'#13#10+
          '	  if @CustomerCurrencyRate is null'#13#10+
          '	    SELECT @CustomerCurrencyRate = ISNULL(@InvCurrencyRate, 0)'#13#10+
          ''#13#10+
          '	  if ISNULL(@CustomerCurrencyRate, 0)=0 or ISNULL(@InvCurrencyRate, 0)=0'#13#10+
          '	    SELECT @wCredit = ISNULL(@InvCurrencyRate, 0) * ISNULL(@InvAmount, 0)'#13#10+
          '	  else'#13#10+
          '	    SELECT @wCredit = ISNULL(@InvCurrencyRate, 0) * ISNULL(@InvAmount, 0) / ISNULL(@CustomerCurrencyRate, 1)'#13#10+
          '    end'#13#10+
          '    update Customer set TotalCredit = IsNull(TotalCredit, 0) + ISNULL(@wCredit, 0) where CustomerId=@CustomerId;'#13#10+
          '  end;';
    cmd.Execute();

    cmd.CommandText.Text := 'create table SalesInvoiceDetail('#13#10+
          '  SalesInvoiceDetailId integer not null identity(1,1) primary key,'#13#10+
          '  SalesInvoiceHeaderId integer not null,'#13#10+
          '  InventoryId integer not null,'#13#10+
          '  Quantity float not null default 0,'#13#10+
          '  UnitPrice float not null,'#13#10+
          '  VatPercentage float default 0,'#13#10+
          '  VatAmount float default 0,'#13#10+
          '  OtvAmount float default 0,'#13#10+
          '  TotalAmount float,'#13#10+
          '  SpecCode nvarchar(20),'#13#10+
          '  LineDescription nvarchar(100) null,'#13#10+
          '  InvoiceDate datetime not null,'#13#10+
          '  CustomerId integer not null,'#13#10+
          '  CurrencyTypeId integer,'#13#10+
          '  CurrencyRate float,'#13#10+
          '  CONSTRAINT FK_SalesInvoiceDetail_SalesInvoiceHeader FOREIGN KEY (SalesInvoiceHeaderId)'#13#10+
          '    REFERENCES SalesInvoiceHeader (SalesInvoiceHeaderId),'#13#10+
          '  CONSTRAINT FK_SalesInvoiceDetail_Inventory FOREIGN KEY (InventoryId)'#13#10+
          '    REFERENCES Inventory (InventoryId)'#13#10+
          ')';
    cmd.Execute();

    cmd.CommandText.Text := 
          'create trigger SalesInvoiceDetail_InventoryUpdate ON SalesInvoiceDetail FOR INSERT, UPDATE, DELETE'#13#10+
          'AS'#13#10+
          '  DECLARE @InvCurrencyId integer = -1;'#13#10+
          '  DECLARE @InvCurrencyRate float = 0;'#13#10+
          '  DECLARE @InvDate date;'#13#10+
          ''#13#10+
          '  DECLARE @InventoryId integer = -1;'#13#10+
          '  DECLARE @InventoryCurrencyId integer;'#13#10+
          '  DECLARE @InventoryCurrencyRate float;'#13#10+
          ''#13#10+
          '  --DECLARE @IncomingQtty float;'#13#10+
          '  DECLARE @OutgoingQtty float;'#13#10+
          '  --DECLARE @IncomingAmount float;'#13#10+
          '  DECLARE @OutgoingAmount float;'#13#10+
          ''#13#10+
          '  DECLARE @wAmount float;'#13#10+
          '  if EXISTS(select * from deleted)'#13#10+
          '  begin'#13#10+
          '    select @InventoryId=D.InventoryId, @InvCurrencyId=D.CurrencyTypeId, @OutgoingQtty=D.Quantity, @wAmount=D.TotalAmount,'#13#10+
          '           @InventoryCurrencyId=INVENTORY.CurrencyTypeId, @InventoryCurrencyRate=CUR.SellingRate from deleted D'#13#10+
          '        left outer join Inventory INVENTORY on(INVENTORY.InventoryId=D.InventoryId)'#13#10+
          '	    left outer join CurrencyDailyRate CUR on(CUR.CurrencyTypeId=INVENTORY.CurrencyTypeId and CUR.CurrencyDate=D.InvoiceDate);'#13#10+
          ''#13#10+
          '    if (ISNULL(@InvCurrencyId, -1)=ISNULL(@InventoryCurrencyId, -1))'#13#10+
          '    begin'#13#10+
          '	  SELECT @OutgoingAmount = @wAmount;'#13#10+
          '    end'#13#10+
          '    else'#13#10+
          '    begin'#13#10+
          '	  if (ISNULL(@InventoryCurrencyRate, 0)=0)'#13#10+
          '	  begin'#13#10+
          '	    SELECT @OutgoingAmount = ISNULL(@wAmount, 0) * ISNULL(@InvCurrencyRate, 0);'#13#10+
          '	  end'#13#10+
          '	  else'#13#10+
          '	  begin'#13#10+
          '        SELECT @OutgoingAmount = ISNULL(@wAmount, 0) * ISNULL(@InvCurrencyRate, 0) / ISNULL(@InventoryCurrencyRate, 0);'#13#10+
          '	  end'#13#10+
          '    end'#13#10+
          ''#13#10+
          '    update Inventory set'#13#10+
          '      TotalOutgoingQtty = ISNULL(TotalOutgoingQtty, 0) - ISNULL(@OutgoingQtty, 0),'#13#10+
          '      TotalOutgoingAmount = ISNULL(TotalOutgoingAmount, 0) - ISNULL(@OutgoingAmount, 0)'#13#10+
          '    where'#13#10+
          '      InventoryId = @InventoryId;'#13#10+
          '  end'#13#10+
          ''#13#10+
          '  if EXISTS(select * from inserted)'#13#10+
          '  begin'#13#10+
          '    select @InventoryId=D.InventoryId, @InvCurrencyId=D.CurrencyTypeId, @OutgoingQtty=D.Quantity, @wAmount=D.TotalAmount,'#13#10+
          '           @InventoryCurrencyId=INVENTORY.CurrencyTypeId, @InventoryCurrencyRate=CUR.SellingRate from inserted D'#13#10+
          '        left outer join Inventory INVENTORY on(INVENTORY.InventoryId=D.InventoryId)'#13#10+
          '	    left outer join CurrencyDailyRate CUR on(CUR.CurrencyTypeId=INVENTORY.CurrencyTypeId and CUR.CurrencyDate=D.InvoiceDate);'#13#10+
          ''#13#10+
          '     if (ISNULL(@InvCurrencyId, -1)=ISNULL(@InventoryCurrencyId, -1))'#13#10+
          '    begin'#13#10+
          '	  SELECT @OutgoingAmount = @wAmount;'#13#10+
          '    end'#13#10+
          '    else'#13#10+
          '    begin'#13#10+
          '	  if (ISNULL(@InventoryCurrencyRate, 0)=0)'#13#10+
          '	  begin'#13#10+
          '	    SELECT @OutgoingAmount = ISNULL(@wAmount, 0) * ISNULL(@InvCurrencyRate, 0);'#13#10+
          '	  end'#13#10+
          '	  else'#13#10+
          '	  begin'#13#10+
          '        SELECT @OutgoingAmount = ISNULL(@wAmount, 0) * ISNULL(@InvCurrencyRate, 0) / ISNULL(@InventoryCurrencyRate, 0);'#13#10+
          '	  end'#13#10+
          '    end'#13#10+
          ''#13#10+
          '    update Inventory set'#13#10+
          '      TotalOutgoingQtty = ISNULL(TotalOutgoingQtty, 0) + ISNULL(@OutgoingQtty, 0),'#13#10+
          '      TotalOutgoingAmount = ISNULL(TotalOutgoingAmount, 0) + ISNULL(@OutgoingAmount, 0)'#13#10+
          '    where'#13#10+
          '      InventoryId = @InventoryId;'#13#10+
          '  end';

    cmd.Execute();

    cmd.CommandText.Text := 'create table secUser('#13#10+
          '  UserId integer not null identity(1,1) primary key,'#13#10+
          '  UserName varchar(50) not null,'#13#10+
          '  Pswd varchar(150) not null,'#13#10+
          '  IsActive bit not null default 1'#13#10+
          ')';
    cmd.Execute();

    cmd.CommandText.Text := 'insert into secUser(UserName, Pswd) values (''m1'', ''a''), (''m2'', ''a''), (''m3'', ''a'');';
    cmd.Execute();

    cmd.CommandText.Text := 'create table secGroup('#13#10+
          '  GroupId integer not null identity(1,1) primary key,'#13#10+
          '  GroupName varchar(50) not null,'#13#10+
          '  IsActive bit not null default 1'#13#10+
          ')';
    cmd.Execute();

    cmd.CommandText.Text := 'insert into secGroup(GroupName) values(''Admin''), (''Satýþ''), (''Muhasebe''), (''Depo'');';
    cmd.Execute();

    cmd.CommandText.Text := 'create table secGroupUser('#13#10+
          '  GroupId integer not null,'#13#10+
          '  UserId integer not null,'#13#10+
          '  CONSTRAINT secGroupUser_pk PRIMARY KEY (GroupId, UserId)'#13#10+
          ')';
    cmd.Execute();

    cmd.CommandText.Text := 'insert into secGroupUser values(1, 1), (2,2), (3,3), (4,3);';
    cmd.Execute();

    cmd.CommandText.Text := 'create table secPermission('#13#10+
          '  PermissionId integer not null primary key,'#13#10+
          '  PermDescription nvarchar(50),'#13#10+
          '  ParentId integer default 0,'#13#10+
          '  IsActive bit not null default 1'#13#10+
          ')';
    cmd.Execute();

    cmd.CommandText.Text := 'insert into secPermission(PermissionId, PermDescription, ParentId) values'#13#10+
          '   (1, ''Tüm iþlemler'', 0),'#13#10+
          '   (100, ''Güvenlik yetkileri'', 1),'#13#10+
          '   (101, ''Kullanýcý kayýtlarý'', 100),'#13#10+
          '   (102, ''Kullanýcý ekleme'', 101),'#13#10+
          '   (103, ''Kullanýcý düzelt'', 101),'#13#10+
          '   (104, ''Kullanýcý sil'', 101),'#13#10+
          '   (105, ''Kullanýcý incele'', 101),'#13#10+
          '   (111, ''Grup kayýtlarý'', 100),'#13#10+
          '   (112, ''Grup ekleme'', 111),'#13#10+
          '   (113, ''Grup düzelt'', 111),'#13#10+
          '   (114, ''Grup sil'', 111),'#13#10+
          '   (115, ''Grup incele'', 111),'#13#10+
          '   (121, ''Ýzin kayýtlarý'', 100),'#13#10+
          '   (122, ''Ýzin ekleme'', 121),'#13#10+
          '   (123, ''Ýzin düzelt'', 121),'#13#10+
          '   (124, ''Ýzin sil'', 121),'#13#10+
          '   (125, ''Ýzin incele'', 121),'#13#10+
          '   (500, ''Döviz iþlemleri'', 1),'#13#10+
          '   (510, ''Döviz kodlarý'', 500),'#13#10+
          '   (511, ''Döviz kodu ekle'', 510),'#13#10+
          '   (512, ''Döviz kodu düzelt'', 510),'#13#10+
          '   (513, ''Döviz kodu sil'', 510),'#13#10+
          '   (514, ''Döviz kodu incele'', 510),'#13#10+
          '   (520, ''Döviz kurlarý'', 500),'#13#10+
          '   (521, ''Günlük kur giriþleri'', 520),'#13#10+
          '   (522, ''Günlük kurlarý indir'', 520),'#13#10+
          '   (523, ''Günlük kur raporlarý'', 520),'#13#10+
          '   (1000, ''Ticari sistem tüm iþlemler'', 1),'#13#10+
          '   (1010, ''Müþteri iþlemleri'', 1000),'#13#10+
          '   (1011, ''Müþteri ekle'', 1010),'#13#10+
          '   (1012, ''Müþteri düzelt'', 1010),'#13#10+
          '   (1013, ''Müþteri sil'', 1010),'#13#10+
          '   (1014, ''Müþteri ekle'', 1010),'#13#10+
          '   (1020, ''Satýcý firma iþlemleri'', 1000),'#13#10+
          '   (1021, ''Satýcý firma ekle'', 1020),'#13#10+
          '   (1022, ''Satýcý firma düzelt'', 1020),'#13#10+
          '   (1023, ''Satýcý firma sil'', 1020),'#13#10+
          '   (1024, ''Satýcý firma ekle'', 1020),'#13#10+
          '   (1030, ''Stok grubu iþlemleri'', 1000),'#13#10+
          '   (1031, ''Stok grubu ekle'', 1030),'#13#10+
          '   (1032, ''Stok grubu düzelt'', 1030),'#13#10+
          '   (1033, ''Stok grubu sil'', 1030),'#13#10+
          '   (1034, ''Stok grubu incele'', 1030),'#13#10+
          '   (1040, ''Stok iþlemleri'', 1000),'#13#10+
          '   (1041, ''Stok ekle'', 1040),'#13#10+
          '   (1042, ''Stok düzelt'', 1040),'#13#10+
          '   (1043, ''Stok sil'', 1040),'#13#10+
          '   (1044, ''Stok incele'', 1040),'#13#10+
          '   (1050, ''Satýnalma fatura iþlemleri'', 1000),'#13#10+
          '   (1051, ''Satýnalma faturasý ekle'', 1050),'#13#10+
          '   (1052, ''Satýnalma faturasý düzelt'', 1050),'#13#10+
          '   (1053, ''Satýnalma faturasý sil'', 1050),'#13#10+
          '   (1054, ''Satýnalma faturasý incele'', 1050),'#13#10+
          '   (1060, ''Satýþ fatura iþlemleri'', 1000),'#13#10+
          '   (1061, ''Satýþ faturasý ekle'', 1060),'#13#10+
          '   (1062, ''Satýþ faturasý düzelt'', 1060),'#13#10+
          '   (1063, ''Satýþ faturasý sil'', 1060),'#13#10+
          '   (1064, ''Satýþ faturasý incele'', 1060);';
    cmd.Execute();

    cmd.CommandText.Text := 'create table secUserPermission('#13#10+
          '  UserId integer,'#13#10+
          '  PermissionId integer,'#13#10+
          '  CONSTRAINT secUserPermission_pk PRIMARY KEY (UserId, PermissionId),'#13#10+
          '  CONSTRAINT FK_secUserPermission_secUser FOREIGN KEY (UserId)'#13#10+
          '    REFERENCES secUser (UserId),'#13#10+
          '  CONSTRAINT FK_secUserPermission_secPermission FOREIGN KEY (PermissionId)'#13#10+
          '    REFERENCES secPermission (PermissionId)'#13#10+
          ');';
    cmd.Execute();

    cmd.CommandText.Text := 'create table secGroupPermission('#13#10+
          '  GroupId integer,'#13#10+
          '  PermissionId integer,'#13#10+
          '  CONSTRAINT secGroupPermission_pk PRIMARY KEY (GroupId, PermissionId),'#13#10+
          '  CONSTRAINT FK_secGroupPermission_secGroup FOREIGN KEY (GroupId)'#13#10+
          '    REFERENCES secGroup (GroupId),'#13#10+
          '  CONSTRAINT FK_secGroupPermission_secPermission FOREIGN KEY (PermissionId)'#13#10+
          '    REFERENCES secPermission (PermissionId)'#13#10+
          ');';
    cmd.Execute();

    cmd.CommandText.Text := 'insert into secGroupPermission values(1, 1), (2, 1060), (3, 1030), (3, 1040), (3, 1050), (3, 1060);';
    cmd.Execute();

    cmd.CommandText.Text := 
          '-- ============================================='#13#10+
          '-- Author:		Mustafa Özpýnar'#13#10+
          '-- Create date: 13.6.2019 Perþembe'#13#10+
          '-- Description:'#13#10+
          '-- ============================================='#13#10+
          'CREATE PROCEDURE secUserLogin(@UserName varchar(50), @Password varchar(100), @Userid int out, @Result int out)'#13#10+
          'AS'#13#10+
          'BEGIN'#13#10+
          '	SET NOCOUNT ON;'#13#10+
          '	declare @cnt int;'#13#10+
          '	set @result=-1;'#13#10+
          ''#13#10+
          '	select top 1 @userid=UserId from secUser as A where (A.Username=@username) and (A.Pswd=@password) and (A.IsActive is not null and A.IsActive <> 0);'#13#10+
          ''#13#10+
          '	if @@ROWCOUNT=0'#13#10+
          '	begin'#13#10+
          '	  set @Result=-101;'#13#10+
          '	  return -101'#13#10+
          '	end'#13#10+
          '	else'#13#10+
          '	begin'#13#10+
          '	  set @Result=1;'#13#10+
          '	  return 1;'#13#10+
          '	end'#13#10+
          'END;';
    cmd.Execute();

    cmd.CommandText.Text :=
          '-- ============================================='#13#10+
          '-- Author:		Mustafa Özpýnar'#13#10+
          '-- Create date: 13.6.2019 Perþembe'#13#10+
          '-- Description:'#13#10+
          '-- ============================================='#13#10+
          ''#13#10+
          'CREATE FUNCTION secinUserBasePermissions (@UserId int) RETURNS @tblRet TABLE'#13#10+
          '('#13#10+
          '  PermissionId int,'#13#10+
          '   ParentId int'#13#10+
          ')'#13#10+
          'AS'#13#10+
          'BEGIN'#13#10+
          '	insert into @tblRet'#13#10+
          '	SELECT aUP.PermissionId, P.ParentId from secUserPermission as aUP inner join secPermission as P on (P.PermissionId=aUP.PermissionId)'#13#10+
          '	where (UserId=@UserId)'#13#10+
          '	union'#13#10+
          '	SELECT aGP.PermissionId, P.ParentId from secGroupPermission as aGP inner join secPermission as P on (P.PermissionId=aGP.PermissionId)'#13#10+
          '	where (GroupId in (SELECT GroupId FROM secGroupUser where (UserId=@UserId)))'#13#10+
          '  	RETURN;'#13#10+
          'END;';
    cmd.Execute();

    cmd.CommandText.Text :=
          '-- ============================================='#13#10+
          '-- Author:		Mustafa Özpýnar'#13#10+
          '-- Create date: 13.6.2019 Perþembe'#13#10+
          '-- Description:	This procedure gives if user has one of rights or not. @RequiredRights separated with comma values and it''s sufficiant to have one of them.'#13#10+
          '-- ============================================='#13#10+
          'create PROCEDURE secUserAuthorize(@UserName varchar(50), @RequiredRights varchar(200), @Result int out)'#13#10+
          'AS'#13#10+
          'BEGIN'#13#10+
          '	declare @retval int;'#13#10+
          '	declare @UserId int;'#13#10+
          '	select @UserId=UserId from secUser where UserName=@UserName;'#13#10+
          '	if ISNULL(@UserId,0)=0'#13#10+
          '	  return -1;'#13#10+
          ''#13#10+
          '   with ctePermissions as('#13#10+
          '	  select PermissionId, ParentId, 0 as Level from secinUserBasePermissions(@UserId)'#13#10+
          '	  union all'#13#10+
          '	  select p.PermissionId, p.ParentId, Level + 1 from  secPermission p'#13#10+
          '	     inner join ctePermissions c on c.PermissionId=p.ParentId'#13#10+
          '		 where ISNULL(p.[IsActive], 1)=1'#13#10+
          '	)'#13#10+
          '	select @retval=count(*) from ctePermissions where '',''+@RequiredRights+'','' like ''%,''+CAST(PermissionId as varchar(20))+'',%'''#13#10+
          '	return @retval;'#13#10+
          'END;';
    cmd.Execute();


  finally
    cmd.Free;
  end;
end;

function TDMMain.ExecSql(const ASql: string;
  AParams: array of Variant; AFieldTypes: array of TFieldType): boolean;
var
  qry : TFDQuery;
begin
  qry := CreateQuery;
  Result := qry.ExecSQL(ASql, AParams, AFieldTypes)>0;
end;

function TDMMain.ExecuteLogin: boolean;
begin
  Result := View.LoginForm.ExecLogin;
end;

function TDMMain.DeleteRecord<T>(AId: Integer): Boolean;
var
    FRttiContext: TRttiContext;
    LRttiType: TRttiType;
    prop : TRttiProperty;
    s : string;
    name : string;
    dbName : string;
    tableName : string;
    attr : TCustomAttribute;
var
  sql : string;
  pk : string;
  I: Integer;
  fdQry : TFDQuery;
begin
  Result := False;
  FRttiContext := TRttiContext.Create;
  try
    LRttiType := FRttiContext.GetType(TypeInfo(T));

    for attr in LRttiType.GetAttributes do
      if attr is TableAttribute then
      begin
        tableName := (attr as TableAttribute).Schema + (attr as TableAttribute).TableName;
        Break;
      end;

    for prop in LRttiType.GetProperties do
    begin
      if prop.Visibility in [mvPublished, mvPublic] then
      begin
        name := prop.Name;
        for attr in prop.GetAttributes do
        begin
          if (attr is ColumnAttribute) and (ColumnAttribute(attr).IsPrimaryKey) then
          begin
            pk := name;
            Break;
          end;
        end;
      end;
    end;
  finally
    FRttiContext.Free;
  end;
  fdQry := CreateQuery;
  try
    fdQry.SQL.Clear;
    fdQry.SQL.Add('delete '+tableName+' where '+pk+'='+IntToStr(AId));
    fdQry.ExecSQL;
    Result := True;
  finally
    fdQry.Free;
  end;
end;

function TDMMain.GetList<T>(const AFilter: string; ASelect: string='*';const AOrderBy : string = ''): TDataset;
var
    FRttiContext: TRttiContext;
    LRttiType: TRttiType;
    m : TRttiMethod;
    prop : TRttiProperty;
    s : string;
    name : string;
    tableName : string;
    dbName : string;
    attr : TCustomAttribute;
var
  sql : string;
  pk : string;
  I: Integer;
  fdQry : TFDQuery;
begin
  Result := Nil;
  FRttiContext := TRttiContext.Create;
  try
    LRttiType := FRttiContext.GetType(TypeInfo(T));

    for attr in LRttiType.GetAttributes do
      if attr is TableAttribute then
      begin
        tableName := (attr as TableAttribute).Schema + (attr as TableAttribute).TableName;
        Break;
      end;

    for prop in LRttiType.GetProperties do
    begin
      if prop.Visibility in [mvPublished, mvPublic] then
      begin
        name := prop.Name;
        for attr in prop.GetAttributes do
        begin
          if (attr is ColumnAttribute) and (ColumnAttribute(attr).IsPrimaryKey) then
          begin
            pk := name;
            Break;
          end;
        end;
      end;
    end;
  finally
    FRttiContext.Free;
  end;

  if ASelect='' then
    ASelect := '*';

  if AFilter='' then
    sql := 'SELECT '+ASelect+' from '+tableName
  else
    sql := 'SELECT '+ASelect+' from '+tableName + ' where '+AFilter;

  if AOrderBy<>'' then
    sql := sql + ' Order By '+AOrderBy;

  fdQry := CreateQuery;
  fdQry.UpdateOptions.KeyFields := pk;
  Result := fdQry;
  fdQry.SQL.Add(sql);
  fdQry.Open;
end;

function TDMMain.GetList(const ASql : string; const AParams : Array of Variant; const ATypes: array of TFieldType) : TDataset;
var
  fdQry : TFDQuery;
  //I: Integer;
begin
  fdQry := CreateQuery; ///  TFDQuery.Create(Self);
  Result := fdQry;
  fdQry.Open(ASql, AParams, ATypes);
end;

function TDMMain.GetRecord<T>(id: integer; select: string): TDataset;
var
    FRttiContext: TRttiContext;
    LRttiType: TRttiType;
    m : TRttiMethod;
    prop : TRttiProperty;
    //adbp : array of TDBParam;
    //s : string;
    name : string;
    tableName : string;
    dbName : string;
    attr : TCustomAttribute;
var
  sql : string;
  pk : string;
  I: Integer;
  fdQry : TFDQuery;

begin
  Result := Nil;
  FRttiContext := TRttiContext.Create;
  try
    LRttiType := FRttiContext.GetType(TypeInfo(T));

    for attr in LRttiType.GetAttributes do
      if attr is TableAttribute then
      begin
        tableName := (attr as TableAttribute).Schema + (attr as TableAttribute).TableName;
        Break;
      end;
    pk := '';
    for prop in LRttiType.GetProperties do
    begin
      if prop.Visibility in [mvPublished, mvPublic] then
      begin
        for attr in prop.GetAttributes do
        begin
          if attr is ColumnAttribute then
          begin

            name := ColumnAttribute(attr).ColumnName;
            if name='' then
              name := prop.Name;
            if ColumnAttribute(attr).IsPrimaryKey then
            begin
              pk := name;
              Break;
            end;
          end;
        end;
      end;
      if pk<>'' then
        Break;
    end;

  finally
    FRttiContext.Free;
  end;

  if select='' then
    select := '*';

  fdQry := CreateQuery;
  fdQry.SQL.Add('select '+select+' from '+tableName+' where '+pk+'='+IntToStr(id));
  fdQry.Open;
  Result := fdQry;
end;

function TDMMain.GetRecord<T>(const where : string; const AParams : Array of Variant; select: string): TDataset;
var
    FRttiContext: TRttiContext;
    LRttiType: TRttiType;
    tableName : string;
    dbName : string;
    attr : TCustomAttribute;
var
  fdQry : TFDQuery;

begin
  Result := Nil;
  FRttiContext := TRttiContext.Create;
  try
    LRttiType := FRttiContext.GetType(TypeInfo(T));

    for attr in LRttiType.GetAttributes do
      if attr is TableAttribute then
      begin
        tableName := (attr as TableAttribute).Schema + (attr as TableAttribute).TableName;
        Break;
      end;


  finally
    FRttiContext.Free;
  end;

  if select='' then
    select := '*';

  fdQry := CreateQuery;
  if where='' then
    fdQry.Open('select '+select+' from '+tableName, [])
  else
  begin
    fdQry.Open('select '+select+' from '+tableName+' where '+where, AParams);
  end;
  //fdQry.Open;
  Result := fdQry;
end;

function TDMMain.GetServerUtcDateTime: TDateTime;
var fdQry : TFDQuery;
begin
  fdQry := CreateQuery;
  //// MySql için
  ///fdQry.SQL.Add('select utc_timestamp() as wdt');
  ///  MSSQL için
  try
    fdQry.SQL.Add('Select GETUTCDATE() as wdt'); // Bu hem tarih hem de UTC saati getiriyor...
    Result := fdQry.Fields[0].AsDateTime;
  finally
    fdQry.Free;
  end;
end;

function TDMMain.CreateQuery: TFDQuery;
begin
  Result := TFDQuery.Create(self);
  Result.Connection := MyDB;
end;


function TDMMain.TableName<T>: string;
var
  FRttiContext: TRttiContext;
  LRttiType: TRttiType;
  dbName : string;
  tableName : string;
  attr : TCustomAttribute;
begin
  Result := '';
  FRttiContext := TRttiContext.Create;
  try
    LRttiType := FRttiContext.GetType(TypeInfo(T));

    for attr in LRttiType.GetAttributes do
      if attr is TableAttribute then
      begin
        Result := (attr as TableAttribute).Schema + (attr as TableAttribute).TableName;
        //dbName := (attr as TableAttribute).DBName;
        Break;
      end;
  finally
    FRttiContext.Free;
  end;
end;


function TDMMain.LoginSystem(const AUsername, APassword: string): boolean;
var ds : TDataSet;
begin
  result := False;
  if AUsername='' then
    Exit;
  //ds := Self.GetRecord<TUser>('UserName='''+AUsername+'''');
  ds := Self.GetRecord<TUser>('UserName=:Username', [AUsername]);
  try
    if ds.RecordCount>0 then
    begin
      ds.First;
      Result := (ds.FieldByName('UserName').AsString=AUsername) and (ds.FieldByName('Pswd').AsString=APassword);
      FLoggedIn := Result;
      if Result then
      begin
        FLoggedUserId := ds.FieldByName('UserId').AsInteger;
        FLoggedUsername := ds.FieldByName('UserName').AsString;
      end
      else
      begin
        FLoggedUserId := -1;
      end;
    end;
  finally
    ds.Free;
  end;
end;

function TDMMain.IsUserAuthorized(const APermissions: string): boolean;
var
  perms : string;
  groups: string;
  ds : TDataSet;
  sr : string;
begin
  if APermissions='' then
  begin
    Result := True;
    exit;
  end;
  Result := False;
  perms := GetCascadedPermissions(aPermissions);
  groups := GroupsUserHas(LoggedUserId);

  ds := Self.GetList<TUserPermission>('(UserId='+IntToStr(LoggedUserId)+')');
  try
    ds.First;
    while not ds.Eof do
    begin
      if Instr(IntToStr(ds.FieldByName('PermissionId').AsInteger), perms, ',') then
      begin
        Result := True;
        Break;
      end;
      ds.Next;
    end;
  finally
    ds.Free;
  end;

  ds := Self.GetList<TGroupPermission>(sr + ' (GroupId in ('+groups+'))', '*');
  try
    ds.First;
    while not ds.Eof do
    begin
      if InStr(IntToStr(ds.FieldByName('PermissionId').AsInteger), perms, ',') then
      begin
        Result := True;
        Break;
      end;
      ds.Next;
    end;
  finally
    ds.Free;
  end;

end;



function TDMMain.GetCascadedPermissions(aPermission: string): string;
var
  ds : TDataSet;
  parents : string;
  s : string;
  idx : Integer;
  xs : string;
  ws : string;
begin
  Result := aPermission;
  if aPermission='' then
    Exit;
  ds := Self.GetList<TPermission>('PermissionId in ('+aPermission+')');
  try
    ds.First;
    while not ds.Eof do
    begin

      ws := IntToStr(ds.FieldByName('ParentId').AsInteger);
      if (ws<>'0') and (ws<>'') then
      begin
        if not(InStr(ws, parents, ',')) then
        begin
          if parents='' then
            parents := ws
          else
            parents := parents + ',' + ws;
        end;
      end;
      ds.Next;
    end;

    if (Result<>'') and (parents<>'') then
      Result := Result + ',';
    if (parents<>'') then
      Result := Result + parents;
  finally
    ds.Free;
  end;

  idx := Pos(',', parents);
  xs := '';
  while (parents<>'') do
  begin
    if idx=0 then
      idx := Length(parents)+1;
    s := Copy(parents, 0, idx - 1);

    Delete(parents, 1, idx);

    if (s<>'0') and (s<>'') then
    begin
      ws := GetCascadedPermissions(s);
      if (ws<>'') and (ws<>'0') then
      begin
        if xs='' then
          xs := ws
        else
          xs := xs + ',' + ws;
      end;
    end;
    idx := Pos(',', parents);
    if idx=0 then
      idx := Length(parents)+1;
  end;

  if xs<>'' then
  begin
    if Result<>'' then
      Result := Result + ',';
    Result := Result + xs;
  end;
end;

function TDMMain.GroupsUserHas(AUserId: Integer): string;
var
  ds : TDataSet;
begin
  Result := '';
  if aUserId<=0 then
    Exit;
  ds := self.GetList('select * from secGroupUser gu left join secGroup g on (g.GroupId=gu.GroupId) where gu.UserId='+IntToStr(AUserId), [], []);
  ds.First;
  try
    while not ds.Eof do
    begin
      if not(ds.FieldByName('GroupId').IsNull) and (ds.FieldByName('GroupId').AsInteger>0) then
      begin
        if Result='' then
          Result := ds.FieldByName('GroupId').AsString
        else
          Result := Result + ',' + ds.FieldByName('GroupId').AsString;
      end;
      ds.Next;
    end;
  finally
    ds.Free;
  end;
end;



end.
