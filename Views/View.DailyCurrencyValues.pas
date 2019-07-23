unit View.DailyCurrencyValues;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, View.TemplateForm, Data.DB, Vcl.Menus,
  Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, Vcl.ComCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TDailyCurrencyValuesForm = class(TTemplateForm)
    Panel3: TPanel;
    lblCurrencyDate: TLabel;
    edCurrencyDate: TDateTimePicker;
    tblCurrencyRates: TFDMemTable;
    tblCurrencyRatesCurrencyDailyRateId: TIntegerField;
    tblCurrencyRatesCurrencyDate: TDateField;
    tblCurrencyRatesCurrencyTypeId: TIntegerField;
    tblCurrencyRatesCurrencyCode: TStringField;
    tblCurrencyRatesCurrencyName: TStringField;
    tblCurrencyRatesBuyingRate: TFloatField;
    tblCurrencyRatesSellingRate: TFloatField;
    btnSave: TButton;
    procedure edCurrencyDateChange(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
  protected
    TblPrepared : Boolean;
    procedure OpenDataset; override;
    function GetEditFormName : string; override;
  public
    { Public declarations }
  end;

var
  DailyCurrencyValuesForm: TDailyCurrencyValuesForm;

implementation
uses MainDM,
     Model.Declarations,
     Support.LanguageDictionary,
     Support.FabricationListForm;

{$R *.dfm}

var
  CreateForm : TFactoryMethodListForm<TTemplateForm>;

{ TDailyCurrencyValuesForm }

procedure TDailyCurrencyValuesForm.btnSaveClick(Sender: TObject);
var bm : TBookmark;
  tc : TCurrencyDaily;
begin
  bm := tblCurrencyRates.GetBookmark;
  tblCurrencyRates.DisableControls;
  try
    tblCurrencyRates.First;
    while not tblCurrencyRates.Eof do
    begin
      if not(tblCurrencyRatesBuyingRate.IsNull and tblCurrencyRatesSellingRate.IsNull) then
      begin
        tc := TCurrencyDaily.Create;
        try
          if tblCurrencyRatesCurrencyDailyRateId.IsNull then
          begin
            tc.CurrencyDate := edCurrencyDate.Date;
            tc.CurrencyTypeId := tblCurrencyRatesCurrencyTypeId.AsInteger;
            tc.BuyingRate := tblCurrencyRatesBuyingRate.AsFloat;
            tc.SellingRate := tblCurrencyRatesSellingRate.AsFloat;
            DMMain.AppendRecord<TCurrencyDaily>(tc);
          end
          else
          begin
            tc.CurrencyDailyRateId := tblCurrencyRatesCurrencyDailyRateId.AsInteger;
            tc.CurrencyDate := tblCurrencyRatesCurrencyDate.AsDateTime;
            tc.CurrencyTypeId := tblCurrencyRatesCurrencyTypeId.AsInteger;
            tc.BuyingRate := tblCurrencyRatesBuyingRate.AsFloat;
            tc.SellingRate := tblCurrencyRatesSellingRate.AsFloat;
            DMMain.UpdateRecord<TCurrencyDaily>(tc.CurrencyDailyRateId, tc);
          end;
        finally
          tc.Free;
        end;
      end;
      tblCurrencyRates.Next;
    end;
  finally

    tblCurrencyRates.EnableControls;
    tblCurrencyRates.GotoBookmark(bm);
    tblCurrencyRates.FreeBookmark(bm);
  end;
end;

procedure TDailyCurrencyValuesForm.edCurrencyDateChange(Sender: TObject);
begin
  fDataset.DisableControls;
  try
    OpenDataset;
  finally
    fDataset.EnableControls;
  end;
end;

procedure TDailyCurrencyValuesForm.FormCreate(Sender: TObject);
begin
  inherited;
  edCurrencyDate.Date := Date;

  lblCurrencyDate.Caption := ComponentDictionary('').GetText(ClassName, 'lblCurrencyDate.Caption');
  btnSave.Caption := ComponentDictionary('').GetText(ClassName, 'btnSave.Caption');
end;

function TDailyCurrencyValuesForm.GetEditFormName: string;
begin
  Result := '';
end;

procedure TDailyCurrencyValuesForm.OpenDataset;
var ds : TDataset;
begin
  TblPrepared := False;
  ds := DMMain.GetList('select CD.CurrencyDailyRateId, CD.CurrencyDate, C.CurrencyTypeId, '+
                       ' C.CurrencyCode as CurrencyCode, C.CurrencyName as CurrencyName, CD.BuyingRate, CD.SellingRate '+
                       ' from '+DMMain.TableName<TCurrencyType>+' C left outer join '+DMMain.TableName<TCurrencyDaily>+' CD on (CD.CurrencyTypeId=C.CurrencyTypeId and CD.CurrencyDate=:CurrencyDate)', [edCurrencyDate.Date], [ftDate]);
                       //'''+Format('MM/dd/yyyy', edCurrencyDate.Date])+'''');

  tblCurrencyRates.Open;
  try
    TblPrepared := False;
    tblCurrencyRates.EmptyDataSet;
    tblCurrencyRates.CopyDataSet(ds);

    fDataset := tblCurrencyRates;
    DataSource1.DataSet := tblCurrencyRates;
  finally
    TblPrepared := True;
    ds.Free;
  end;


  {fDataSet := DMMain.GetList('select CD.CurrencyDailyRateId, CD.CurrencyDate, CD.CurrencyTypeId, '+
                          ' C.CurrencyCode as CurrencyCode, C.CurrencyName as CurrencyName, CD.BuyingRate, CD.SellingRate '+
                          ' from '+DMMain.TableName<TCurrencyDaily>+' CD left outer join '+DMMain.TableName<TCurrencyType>+' C on (C.CurrencyTypeId=CD.CurrencyTypeId) '+
                          ' where CurrencyDate='''+FormatDateTime('MM/dd/yyyy', edCurrencyDate.Date)+'''');}
end;

initialization

  CreateForm := function : TTemplateForm
     begin
       if not DMMain.IsUserAuthorized('520,521,522,523') then
         raise Exception.Create(Support.LanguageDictionary.MessageDictionary().GetMessage('SNotAuthorized')+#13#10+'TDailyCurrencyValuesForm');
       Result := TDailyCurrencyValuesForm.Create(Application);
     end;

  MyFactoryListForm.RegisterForm<TDailyCurrencyValuesForm>('TDailyCurrencyValuesForm', CreateForm);


end.
