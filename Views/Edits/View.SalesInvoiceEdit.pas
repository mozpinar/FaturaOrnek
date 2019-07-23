unit View.SalesInvoiceEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, View.TemplateEdit, Data.DB,
  Vcl.StdCtrls, Vcl.ExtCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Vcl.Grids, Vcl.DBGrids, Vcl.DBCtrls, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.Mask, Vcl.Buttons,
  FireDAC.DApt,
  Support.Consts;

type
  TSalesInvoiceEditForm = class(TTemplateEdit)
    Panel1: TPanel;
    lblCustomerId: TLabel;
    lblInvoiceDate: TLabel;
    lblSpecCode: TLabel;
    lblInvDescription: TLabel;
    lblCurrencyTypeId: TLabel;
    lblCurrencyRate: TLabel;
    lblDueDate: TLabel;
    btnFindCustomer: TSpeedButton;
    lblInvoiceNumber: TLabel;
    edPaid: TDBCheckBox;
    edCustomerId: TDBLookupComboBox;
    edInvoiceDate: TDBEdit;
    edSpecCode: TDBEdit;
    edInvDescription: TDBEdit;
    edCurrencyTypeId: TDBLookupComboBox;
    edCurrencyRate: TDBEdit;
    edDueDate: TDBEdit;
    edInvoiceNumber: TDBEdit;
    tblInvDetail: TFDMemTable;
    tblInvDetailSalesInvoiceDetailId: TIntegerField;
    tblInvDetailSalesInvoiceHeaderId: TIntegerField;
    tblInvDetailInventoryId: TIntegerField;
    tblInvDetailInventoryName: TStringField;
    tblInvDetailQuantity: TFloatField;
    tblInvDetailUnitPrice: TFloatField;
    tblInvDetailVatPercentage: TFloatField;
    tblInvDetailVatAmount: TFloatField;
    tblInvDetailOtvAmount: TFloatField;
    tblInvDetailTotalAmount: TFloatField;
    tblInvDetailSpecCode: TStringField;
    tblInvDetailLineDescription: TStringField;
    tblInvDetailInvoiceDate: TDateTimeField;
    tblInvDetailCustomerId: TIntegerField;
    tblInvDetailCurrencyTypeId: TIntegerField;
    tblInvDetailCurrencyRate: TFloatField;
    tblInvDetailInventoryCode: TStringField;
    tblInvDetailc_RowState: TIntegerField;
    dsInvDetail: TDataSource;
    Panel3: TPanel;
    lblVAT1: TLabel;
    lblVAT2: TLabel;
    lblVAT3: TLabel;
    lblTotalAmount: TLabel;
    dbtextVatPercentage1: TDBText;
    dbtextVatPercentage2: TDBText;
    dbtextVatPercentage3: TDBText;
    dbtextTotalAmount: TDBText;
    dbtextVatAmount1: TDBText;
    dbtextVatAmount2: TDBText;
    dbtextVatAmount3: TDBText;
    Panel4: TPanel;
    DBGrid1: TDBGrid;
    dsCustomer: TDataSource;
    dsCurrencyType: TDataSource;
    procedure btnOkClick(Sender: TObject);
    procedure tblInvDetailInventoryIdChange(Sender: TField);
    procedure tblInvDetailQuantityChange(Sender: TField);
    procedure tblInvDetailUnitPriceChange(Sender: TField);
    procedure tblInvDetailVatPercentageChange(Sender: TField);
    procedure tblInvDetailVatAmountChange(Sender: TField);
    procedure tblInvDetailTotalAmountChange(Sender: TField);
    procedure tblInvDetailCurrencyTypeIdChange(Sender: TField);
    procedure tblInvDetailCurrencyRateChange(Sender: TField);
    procedure tblInvDetailNewRecord(DataSet: TDataSet);
    procedure tblInvDetailBeforeDelete(DataSet: TDataSet);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
    procedure tblSalesInvoiceCustomerIdChange(Sender: TField);
    procedure tblSalesInvoiceCurrencyTypeIdChange(Sender: TField);
    procedure tblSalesInvoiceCurrencyRateChange(Sender: TField);
    procedure tblSalesInvoiceInvoiceDateChange(Sender: TField);
  protected
    class function RequiredPermission(cmd: TBrowseFormCommand) : string; override;
    procedure OnInsert(DataSet: TDataSet); override;
    procedure OnEdit(DataSet: TDataSet); override;
    procedure BeforePost(DataSet: TDataSet); override;
    procedure AfterPost(DataSet: TDataSet); override;
    procedure FormLoaded; override;
    class function GetFormName : string; override;
  protected
    tblInventory : TDataset;
    TblPrepared : Boolean;
    procedure RecalculateAllLines;
    procedure CalcInvoiceTotal;
  public
    { Public declarations }
  end;

var
  SalesInvoiceEditForm: TSalesInvoiceEditForm;

implementation
uses MainDM,
     Model.Declarations,
     Support.LanguageDictionary,
     Support.FabricationEditForm,
     Model.CurrencyDaily;

{$R *.dfm}

{ TSalesInvoiceEditForm }

procedure TSalesInvoiceEditForm.AfterPost(DataSet: TDataSet);
begin
  inherited;

end;

procedure TSalesInvoiceEditForm.BeforePost(DataSet: TDataSet);
begin
  inherited;

end;

procedure TSalesInvoiceEditForm.btnOkClick(Sender: TObject);
var
  ds : TDataset;
  bm : TBookmark;
begin
  DMMain.MyDB.StartTransaction;
  try
    inherited;
    TblPrepared := False;
    tblInvDetail.DisableControls;
    try
      bm := tblInvDetail.GetBookmark;
      tblInvDetail.Filtered := False;
      tblInvDetail.First;
      while not tblInvDetail.Eof do
      begin
        tblInvDetail.Edit;
        tblInvDetailSalesInvoiceHeaderId.Value := DataSource1.DataSet.FieldByName('SalesInvoiceHeaderId').AsInteger;
        tblInvDetailInvoiceDate.Value := DataSource1.DataSet.FieldByName('InvoiceDate').AsDateTime;

        tblInvDetailInvoiceDate.Value := DataSource1.DataSet.FieldByName('InvoiceDate').AsDateTime;
        tblInvDetailCustomerId.Value := DataSource1.DataSet.FieldByName('CustomerId').AsInteger;
        tblInvDetail.Post;

        case tblInvDetailc_RowState.AsInteger of
        0 : DMMain.UpdateRecord<TSalesInvoiceDetail>(tblInvDetailSalesInvoiceDetailId.Value, tblInvDetail, False);
        1 : DMMain.AppendRecord<TSalesInvoiceDetail>(tblInvDetail, False);
        -1 : DMMain.DeleteRecord<TSalesInvoiceDetail>(tblInvDetailSalesInvoiceDetailId.Value);
        end;

        tblInvDetail.Next;
      end;
    finally
      tblInvDetail.Filtered := True;
      tblInvDetail.GotoBookmark(bm);
      tblInvDetail.FreeBookmark(bm);
      tblInvDetail.EnableControls;
    end;
    DMMain.MyDB.Commit;
  except
    TblPrepared := True;
    DMMain.MyDB.Rollback;
  end;

end;

procedure TSalesInvoiceEditForm.CalcInvoiceTotal;
begin

end;

procedure TSalesInvoiceEditForm.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssCtrl in Shift) and (Key=VK_DELETE) then
  begin
    tblInvDetail.Edit;
    tblInvDetailc_RowState.Value := -1;
    tblInvDetail.Post;
    tblInvDetail.Edit;
  end;
end;

procedure TSalesInvoiceEditForm.FormCreate(Sender: TObject);
begin
  inherited;
  TblPrepared := False;
end;

procedure TSalesInvoiceEditForm.FormLoaded;
var
  tblInvoice : TDataset;
begin
  inherited;
  dsCurrencyType.DataSet := DMMain.GetList<TCurrencyType>('');

  dsCustomer.DataSet := DMMain.GetList<TCustomer>('');

  lblCustomerId.Caption := ComponentDictionary('').GetText(TSalesInvoiceEditForm.ClassName, 'lblCustomerId.Caption');
  lblInvoiceDate.Caption := ComponentDictionary('').GetText(TSalesInvoiceEditForm.ClassName, 'lblInvoiceDate.Caption');
  lblInvoiceNumber.Caption := ComponentDictionary('').GetText(TSalesInvoiceEditForm.ClassName, 'lblInvoiceNumber.Caption');
  lblSpecCode.Caption := ComponentDictionary('').GetText(TSalesInvoiceEditForm.ClassName, 'lblSpecCode.Caption');
  lblInvDescription.Caption := ComponentDictionary('').GetText(TSalesInvoiceEditForm.ClassName, 'lblInvDescription.Caption');
  lblCurrencyTypeId.Caption := ComponentDictionary('').GetText(TSalesInvoiceEditForm.ClassName, 'lblCurrencyTypeId.Caption');
  lblCurrencyRate.Caption := ComponentDictionary('').GetText(TSalesInvoiceEditForm.ClassName, 'lblCurrencyRate.Caption');
  lblDueDate.Caption := ComponentDictionary('').GetText(TSalesInvoiceEditForm.ClassName, 'lblDueDate.Caption');
  edPaid.Caption := ComponentDictionary('').GetText(TSalesInvoiceEditForm.ClassName, 'edPaid.Caption');

  lblVAT1.Caption := ComponentDictionary('').GetText(TSalesInvoiceEditForm.ClassName, 'lblVAT1.Caption');
  lblVAT2.Caption := ComponentDictionary('').GetText(TSalesInvoiceEditForm.ClassName, 'lblVAT2.Caption');
  lblVAT3.Caption := ComponentDictionary('').GetText(TSalesInvoiceEditForm.ClassName, 'lblVAT3.Caption');
  lblTotalAmount.Caption := ComponentDictionary('').GetText(TSalesInvoiceEditForm.ClassName, 'lblTotalAmount.Caption');

  GridColumnDictionary.AssignGridColumnTitles(ClassName, DBGrid1);

  tblInventory := DMMain.GetList<TInventory>('');
  tblInvoice := DMMain.GetList<TSalesInvoiceDetail>('SalesInvoiceHeaderId='+IntToStr(DataSource1.DataSet.FieldByName('SalesInvoiceHeaderId').AsInteger));

  TDateTimeField(DataSource1.DataSet.FieldByName('InvoiceDate')).EditMask := '!99/99/0000;1;_';
  TDateTimeField(DataSource1.DataSet.FieldByName('InvoiceDate')).DisplayFormat := 'dd/mm/yyyy';

  tblInvDetailInventoryName.LookupDataSet := tblInventory;
  tblInvDetailInventoryCode.LookupDataSet := tblInventory;

  DataSource1.DataSet.FieldByName('CustomerId').OnChange := tblSalesInvoiceCustomerIdChange;
  DataSource1.DataSet.FieldByName('CurrencyTypeId').OnChange := tblSalesInvoiceCurrencyTypeIdChange;
  DataSource1.DataSet.FieldByName('CurrencyRate').OnChange := tblSalesInvoiceCurrencyRateChange;
  DataSource1.DataSet.FieldByName('InvoiceDate').OnChange := tblSalesInvoiceInvoiceDateChange;

  tblInvDetail.Open;
  try
    TblPrepared := False;
    tblInvDetail.CopyDataSet(tblInvoice);
    tblInvDetail.Filter := (' (c_RowState>=0 or c_RowState is null) ');
    tblInvDetail.Filtered := True;
  finally
    TblPrepared := True;
    tblInvoice.Free;
    //if DataSource1.DataSet.State in [dsInsert, dsEdit]
      //DataSource1.DataSet.Cancel;
  end;

end;

class function TSalesInvoiceEditForm.GetFormName: string;
begin
  Result := 'TSalesInvoiceEditForm';
end;

procedure TSalesInvoiceEditForm.OnEdit(DataSet: TDataSet);
begin
  inherited;

end;

procedure TSalesInvoiceEditForm.OnInsert(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('Paid').AsBoolean := False;
  DataSet.FieldByName('InvoiceDate').AsDateTime := Date;
end;

procedure TSalesInvoiceEditForm.RecalculateAllLines;
var
  bm : TBookmark;
begin
  if not TblPrepared then
    Exit;
  //wTotal := 0;
  bm := tblInvDetail.GetBookmark;
  tblInvDetail.DisableControls;
  try
    tblInvDetail.First;
    while not tblInvDetail.Eof do
    begin
      tblInvDetail.Edit;
      if tblInvDetailCurrencyTypeId.AsInteger=DataSource1.DataSet.FieldByName('CurrencyTypeId').AsInteger then
        tblInvDetailCurrencyRate.AsFloat:= DataSource1.DataSet.FieldByName('CurrencyRate').AsFloat
      else
        tblInvDetailCurrencyRate.AsFloat := TCurrencyDailyModel.GetARate(TBuySale.tbsSelling, tblInvDetailCurrencyTypeId.AsInteger, edInvoiceDate.Field.AsDateTime);
      tblInvDetail.Next;
    end;
  finally
    tblInvDetail.GotoBookmark(bm);
    tblInvDetail.FreeBookmark(bm);
    if tblInvDetail.RecordCount>0 then
      tblInvDetail.Edit;
    tblInvDetail.EnableControls;
  end;
end;

class function TSalesInvoiceEditForm.RequiredPermission(
  cmd: TBrowseFormCommand): string;
begin
  Result := '>????<';
  case cmd of
    efcmdAdd: Result := '1060,1061';
    efcmdEdit: Result := '1060,1062';
    efcmdDelete: Result := '1060,1063';
    efcmdViewDetail: Result := '1060,1064';
  end;
end;


procedure TSalesInvoiceEditForm.tblInvDetailBeforeDelete(DataSet: TDataSet);
begin
  Abort;
end;

procedure TSalesInvoiceEditForm.tblInvDetailCurrencyRateChange(Sender: TField);
begin
  if not TblPrepared then
    Exit;
  if not tblInventory.Locate('InventoryId', tblInvDetailInventoryId.AsInteger, []) then
    Exit;
  tblInvDetail.Edit;
  if tblInvDetailCurrencyTypeId.AsInteger=DataSource1.DataSet.FieldByName('CurrencyTypeId').AsInteger then
    tblInvDetailUnitPrice.Assign(tblInventory.FieldByName('BuyingPrice'))
  else
    tblInvDetailUnitPrice.AsFloat := tblInventory.FieldByName('BuyingPrice').AsFloat *
                  TCurrencyDailyModel.Convert(TBuySale.tbsSelling, tblInventory.FieldByName('CurrencyTypeId').AsInteger,
                  DataSource1.DataSet.FieldByName('CurrencyTypeId').AsInteger, edInvoiceDate.Field.AsDateTime);
end;

procedure TSalesInvoiceEditForm.tblInvDetailCurrencyTypeIdChange(
  Sender: TField);
begin
  if not TblPrepared then
    Exit;
  tblInvDetail.Edit;
  tblInvDetailCurrencyRate.AsFloat := TCurrencyDailyModel.GetARate(TBuySale.tbsSelling, tblInvDetailCurrencyTypeId.AsInteger, edInvoiceDate.Field.AsDateTime);
end;

procedure TSalesInvoiceEditForm.tblInvDetailInventoryIdChange(Sender: TField);
begin
  if not TblPrepared then
    Exit;

  tblInvDetail.Edit;
  tblInvDetailCurrencyTypeId.Assign(tblInventory.FieldByName('CurrencyTypeId'));
  tblInvDetail.Edit;
  if tblInventory.FieldByName('CurrencyTypeId').AsInteger=DataSource1.DataSet.FieldByName('CurrencyTypeId').AsInteger then
    tblInvDetailUnitPrice.Assign(tblInventory.FieldByName('BuyingPrice'))
  else
    tblInvDetailUnitPrice.AsFloat := tblInventory.FieldByName('BuyingPrice').AsFloat *
                  TCurrencyDailyModel.Convert(TBuySale.tbsSelling, tblInventory.FieldByName('CurrencyTypeId').AsInteger,
                  DataSource1.DataSet.FieldByName('CurrencyTypeId').AsInteger, edInvoiceDate.Field.AsDateTime);
  tblInvDetail.Edit;
  tblInvDetailVatPercentage.Assign(tblInventory.FieldByName('VatPercentage'));

end;

procedure TSalesInvoiceEditForm.tblInvDetailNewRecord(DataSet: TDataSet);
begin
  if TblPrepared then
    tblInvDetailc_RowState.Value := 1;
end;

procedure TSalesInvoiceEditForm.tblInvDetailQuantityChange(Sender: TField);
begin
  if not TblPrepared then
    Exit;
  tblInvDetail.Edit;
  tblInvDetailVatAmount.AsFloat := Round(tblInvDetailQuantity.AsFloat * tblInvDetailUnitPrice.AsFloat * tblInvDetailVatPercentage.AsFloat) / 100;
  tblInvDetail.Edit;
  tblInvDetailTotalAmount.AsFloat := tblInvDetailQuantity.AsFloat * tblInvDetailUnitPrice.AsFloat + tblInvDetailVatAmount.AsFloat;
end;

procedure TSalesInvoiceEditForm.tblInvDetailTotalAmountChange(Sender: TField);
var
  bm : TBookmark;
  wTotal : Extended;
begin
  if not TblPrepared then
    Exit;
  TblPrepared := False;
  tblInvDetail.Edit;
  tblInvDetailTotalAmount.AsFloat := Round(tblInvDetailTotalAmount.AsFloat * 100)/100;
  TblPrepared := True;
  wTotal := 0;
  bm := tblInvDetail.GetBookmark;
  tblInvDetail.DisableControls;
  try
    tblInvDetail.First;
    while not tblInvDetail.Eof do
    begin
      wTotal := wTotal + tblInvDetailTotalAmount.Value;
      tblInvDetail.Next;
    end;
    DataSource1.DataSet.FieldByName('TotalAmount').AsFloat := wTotal;
  finally
    tblInvDetail.GotoBookmark(bm);
    tblInvDetail.FreeBookmark(bm);
    if tblInvDetail.RecordCount>0 then
      tblInvDetail.Edit;
    tblInvDetail.EnableControls;
  end;
end;

procedure TSalesInvoiceEditForm.tblInvDetailUnitPriceChange(Sender: TField);
begin
  if not TblPrepared then
    Exit;
  TblPrepared := False;
  tblInvDetailUnitPrice.AsFloat := Round(tblInvDetailUnitPrice.AsFloat * 10000) / 10000;
  TblPrepared := True;
  tblInvDetail.Edit;
  tblInvDetailVatAmount.AsFloat := Round(tblInvDetailQuantity.AsFloat * tblInvDetailUnitPrice.AsFloat * tblInvDetailVatPercentage.AsFloat) / 100;
  tblInvDetail.Edit;
  tblInvDetailTotalAmount.AsFloat := tblInvDetailQuantity.AsFloat * tblInvDetailUnitPrice.AsFloat + tblInvDetailVatAmount.AsFloat;
end;

procedure TSalesInvoiceEditForm.tblInvDetailVatAmountChange(Sender: TField);
var
  bm : TBookmark;
  vatper : array[1..3] of Extended;
  vatamt : array[1..3] of Extended;
  I: Integer;
begin
  if not TblPrepared then
    Exit;
  tblInvDetailTotalAmount.AsFloat := tblInvDetailQuantity.AsFloat * tblInvDetailUnitPrice.AsFloat + tblInvDetailVatAmount.AsFloat;
  vatper[1] := 0;
  vatper[2] := 0;
  vatper[3] := 0;
  vatamt[1] := 0;
  vatper[2] := 0;
  vatper[3] := 0;

  bm := tblInvDetail.GetBookmark;
  try
    tblInvDetail.First;
    while not tblInvDetail.Eof do
    begin
      if tblInvDetailVatAmount.Value>0 then
      begin
        for I := 1 to 3 do
          if (tblInvDetailVatPercentage.Value=vatper[I]) or (vatper[I]=0) then
          begin
            vatper[I] := tblInvDetailVatPercentage.Value;
            vatamt[I] := vatamt[I] + tblInvDetailVatAmount.Value;
            Break;
          end;
      end;
      tblInvDetail.Next;
    end;
    DataSource1.DataSet.FieldByName('VatPercentage1').AsFloat := vatper[1];
    DataSource1.DataSet.FieldByName('VatPercentage2').AsFloat := vatper[2];
    DataSource1.DataSet.FieldByName('VatPercentage3').AsFloat := vatper[3];
    DataSource1.DataSet.FieldByName('VatAmount1').AsFloat := vatamt[1];
    DataSource1.DataSet.FieldByName('VatAmount2').AsFloat := vatamt[2];
    DataSource1.DataSet.FieldByName('VatAmount3').AsFloat := vatamt[3];
  finally
    tblInvDetail.GotoBookmark(bm);
    tblInvDetail.FreeBookmark(bm);
    if tblInvDetail.RecordCount>0 then
      tblInvDetail.Edit;
  end;
end;

procedure TSalesInvoiceEditForm.tblInvDetailVatPercentageChange(Sender: TField);
begin
  if not TblPrepared then
    Exit;
  tblInvDetailVatAmount.AsFloat := Round(tblInvDetailQuantity.AsFloat * tblInvDetailUnitPrice.AsFloat * tblInvDetailVatPercentage.AsFloat) / 100;
end;

procedure TSalesInvoiceEditForm.tblSalesInvoiceCurrencyRateChange(
  Sender: TField);
begin
  RecalculateAllLines;
end;

procedure TSalesInvoiceEditForm.tblSalesInvoiceCurrencyTypeIdChange(
  Sender: TField);
begin
  edCurrencyRate.Field.AsFloat := TCurrencyDailyModel.GetARate(TBuySale.tbsSelling, edCurrencyTypeId.Field.AsInteger, edInvoiceDate.Field.AsDateTime);
end;

procedure TSalesInvoiceEditForm.tblSalesInvoiceInvoiceDateChange(
  Sender: TField);
begin
  tblSalesInvoiceCurrencyTypeIdChange(Sender);
end;

procedure TSalesInvoiceEditForm.tblSalesInvoiceCustomerIdChange(
  Sender: TField);
var
  cds : TDataset;
begin
  cds := DMMain.GetRecord<TCustomer>(DataSource1.DataSet.FieldByName('CustomerId').AsInteger);
  try
    if cds.RecordCount>0 then
    begin
      edCurrencyTypeId.Field.AsInteger := cds.FieldByName('CurrencyTypeId').AsInteger;
      edDueDate.Field.AsInteger := cds.FieldByName('PaymentDueDate').AsInteger;
    end
    else
    begin
      edCurrencyTypeId.Field.Clear;
      edDueDate.Field.Clear;
    end;

  finally
    cds.Free;
  end;
end;

function CreateSalesInvoiceEditForm(ACmd : TBrowseFormCommand; ADs : TDataset; Params : Array of Variant) : TForm;
begin
  Result := TSalesInvoiceEditForm.Create(aCmd, aDs);
end;

initialization
  MyFactoryEditForm.RegisterForm<TSalesInvoiceEditForm>(TSalesInvoiceEditForm.GetFormName, CreateSalesInvoiceEditForm);

end.
