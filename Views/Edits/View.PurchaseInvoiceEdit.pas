unit View.PurchaseInvoiceEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, View.TemplateEdit, Data.DB,
  Vcl.StdCtrls, Vcl.ExtCtrls,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.DApt,
  FireDAC.Comp.Client,
  FireDAC.Comp.DataSet,
  Vcl.Grids,
  Vcl.DBGrids, Vcl.Mask, Vcl.DBCtrls, Vcl.Buttons, FireDAC.Stan.Async,
  Support.Consts;

type
  TPurchaseInvoiceEditForm = class(TTemplateEdit)
    Panel1: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    DBGrid1: TDBGrid;
    dsInvDetail: TDataSource;
    tblInvDetail: TFDMemTable;
    lblSupplier: TLabel;
    lblInvoiceDate: TLabel;
    lblSpecCode: TLabel;
    lblInvDescription: TLabel;
    lblCurrencyTypeId: TLabel;
    lblCurrencyRate: TLabel;
    lblVAT1: TLabel;
    lblVAT2: TLabel;
    lblVAT3: TLabel;
    lblTotalAmount: TLabel;
    lblDueDate: TLabel;
    edPaid: TDBCheckBox;
    edSupplierId: TDBLookupComboBox;
    btnFindSupplier: TSpeedButton;
    edInvoiceDate: TDBEdit;
    edSpecCode: TDBEdit;
    edInvDescription: TDBEdit;
    tblInvDetailPurchaseInvoiceDetailId: TIntegerField;
    tblInvDetailPurchaseInvoiceHeaderId: TIntegerField;
    tblInvDetailInventoryId: TIntegerField;
    tblInvDetailQuantity: TFloatField;
    tblInvDetailUnitPrice: TFloatField;
    tblInvDetailVatPercentage: TFloatField;
    tblInvDetailVatAmount: TFloatField;
    tblInvDetailOtvAmount: TFloatField;
    tblInvDetailTotalAmount: TFloatField;
    tblInvDetailSpecCode: TStringField;
    tblInvDetailLineDescription: TStringField;
    tblInvDetailInvoiceDate: TDateTimeField;
    tblInvDetailSupplierId: TIntegerField;
    tblInvDetailCurrencyTypeId: TIntegerField;
    tblInvDetailCurrencyRate: TFloatField;
    tblInvDetailInventoryName: TStringField;
    tblInvDetailInventoryCode: TStringField;
    dbtextVatPercentage1: TDBText;
    dbtextVatPercentage2: TDBText;
    dbtextVatPercentage3: TDBText;
    dbtextTotalAmount: TDBText;
    dbtextVatAmount1: TDBText;
    dbtextVatAmount2: TDBText;
    dbtextVatAmount3: TDBText;
    dsCurrencyType: TDataSource;
    edCurrencyTypeId: TDBLookupComboBox;
    edCurrencyRate: TDBEdit;
    edDueDate: TDBEdit;
    dsSupplier: TDataSource;
    tblInvDetailc_RowState: TIntegerField;
    lblInvoiceNumber: TLabel;
    edInvoiceNumber: TDBEdit;
    procedure btnOkClick(Sender: TObject);
    procedure tblInvDetailQuantityChange(Sender: TField);
    procedure tblInvDetailInventoryIdChange(Sender: TField);
    procedure tblInvDetailNewRecord(DataSet: TDataSet);
    procedure tblInvDetailBeforeDelete(DataSet: TDataSet);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure tblInvDetailVatPercentageChange(Sender: TField);
    procedure tblInvDetailVatAmountChange(Sender: TField);
    procedure tblInvDetailTotalAmountChange(Sender: TField);
    procedure tblInvDetailUnitPriceChange(Sender: TField);
    procedure tblInvDetailCurrencyTypeIdChange(Sender: TField);
    procedure tblInvDetailCurrencyRateChange(Sender: TField);
  private
    procedure tblPurchaseInvoiceSupplierIdChange(Sender: TField);
    procedure tblPurchaseInvoiceCurrencyTypeIdChange(Sender: TField);
    procedure tblPurchaseInvoiceCurrencyRateChange(Sender: TField);
    procedure tblPurchaseInvoiceInvoiceDateChange(Sender: TField);
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
  PurchaseInvoiceEditForm: TPurchaseInvoiceEditForm;

implementation
uses MainDM,
     Model.Declarations,
     Support.LanguageDictionary,
     Support.FabricationEditForm,
     Model.CurrencyDaily;

{$R *.dfm}

{ TPurchaseInvoiceEditForm }

procedure TPurchaseInvoiceEditForm.AfterPost(DataSet: TDataSet);
begin
  inherited;

end;

procedure TPurchaseInvoiceEditForm.BeforePost(DataSet: TDataSet);
begin
  inherited;

end;

procedure TPurchaseInvoiceEditForm.btnOkClick(Sender: TObject);
var
  ds : TDataset;
  bm : TBookmark;
begin
  DMMain.MyDB.StartTransaction;
  try
    TblPrepared := False;
    if (DataSource1.DataSet.FieldByName('CurrencyTypeId').AsInteger=-1) or
       (DataSource1.DataSet.FieldByName('CurrencyTypeId').AsInteger=0) then
      DataSource1.DataSet.FieldByName('CurrencyTypeId').Clear;

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
        tblInvDetailPurchaseInvoiceHeaderId.Value := DataSource1.DataSet.FieldByName('PurchaseInvoiceHeaderId').AsInteger;
        tblInvDetailInvoiceDate.Value := DataSource1.DataSet.FieldByName('InvoiceDate').AsDateTime;

        tblInvDetailInvoiceDate.Value := DataSource1.DataSet.FieldByName('InvoiceDate').AsDateTime;
        tblInvDetailSupplierId.Value := DataSource1.DataSet.FieldByName('SupplierId').AsInteger;
        tblInvDetail.Post;

        case tblInvDetailc_RowState.AsInteger of
        0 : DMMain.UpdateRecord<TPurchaseInvoiceDetail>(tblInvDetailPurchaseInvoiceDetailId.Value, tblInvDetail, False);
        1 : DMMain.AppendRecord<TPurchaseInvoiceDetail>(tblInvDetail, False);
        -1 : DMMain.DeleteRecord<TPurchaseInvoiceDetail>(tblInvDetailPurchaseInvoiceDetailId.Value);
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
    Raise;
  end;

end;

procedure TPurchaseInvoiceEditForm.CalcInvoiceTotal;
begin

end;

procedure TPurchaseInvoiceEditForm.DBGrid1KeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (ssCtrl in Shift) and (Key=VK_DELETE) then
  begin
    tblInvDetail.Edit;
    tblInvDetailc_RowState.Value := -1;
    tblInvDetail.Post;
    tblInvDetail.Edit;
  end;
end;

procedure TPurchaseInvoiceEditForm.FormCreate(Sender: TObject);
begin
  inherited;
  TblPrepared := False;
end;

procedure TPurchaseInvoiceEditForm.FormLoaded;
var
  tblInvoice : TDataset;
begin
  inherited;
  dsCurrencyType.DataSet := DMMain.GetList<TCurrencyType>('');

  dsSupplier.DataSet := DMMain.GetList<TSupplier>('');

  lblSupplier.Caption := ComponentDictionary('').GetText(TPurchaseInvoiceEditForm.ClassName, 'lblSupplier.Caption');
  lblInvoiceDate.Caption := ComponentDictionary('').GetText(TPurchaseInvoiceEditForm.ClassName, 'lblInvoiceDate.Caption');
  lblInvoiceNumber.Caption := ComponentDictionary('').GetText(TPurchaseInvoiceEditForm.ClassName, 'lblInvoiceNumber.Caption');
  lblSpecCode.Caption := ComponentDictionary('').GetText(TPurchaseInvoiceEditForm.ClassName, 'lblSpecCode.Caption');
  lblInvDescription.Caption := ComponentDictionary('').GetText(TPurchaseInvoiceEditForm.ClassName, 'lblInvDescription.Caption');
  lblCurrencyTypeId.Caption := ComponentDictionary('').GetText(TPurchaseInvoiceEditForm.ClassName, 'lblCurrencyTypeId.Caption');
  lblCurrencyRate.Caption := ComponentDictionary('').GetText(TPurchaseInvoiceEditForm.ClassName, 'lblCurrencyRate.Caption');
  lblDueDate.Caption := ComponentDictionary('').GetText(TPurchaseInvoiceEditForm.ClassName, 'lblDueDate.Caption');
  edPaid.Caption := ComponentDictionary('').GetText(TPurchaseInvoiceEditForm.ClassName, 'edPaid.Caption');

  lblVAT1.Caption := ComponentDictionary('').GetText(TPurchaseInvoiceEditForm.ClassName, 'lblVAT1.Caption');
  lblVAT2.Caption := ComponentDictionary('').GetText(TPurchaseInvoiceEditForm.ClassName, 'lblVAT2.Caption');
  lblVAT3.Caption := ComponentDictionary('').GetText(TPurchaseInvoiceEditForm.ClassName, 'lblVAT3.Caption');
  lblTotalAmount.Caption := ComponentDictionary('').GetText(TPurchaseInvoiceEditForm.ClassName, 'lblTotalAmount.Caption');

  GridColumnDictionary.AssignGridColumnTitles(ClassName, DBGrid1);

  tblInventory := DMMain.GetList<TInventory>('');
  tblInvoice := DMMain.GetList<TPurchaseInvoiceDetail>('PurchaseInvoiceHeaderId='+IntToStr(DataSource1.DataSet.FieldByName('PurchaseInvoiceHeaderId').AsInteger));

  TDateTimeField(DataSource1.DataSet.FieldByName('InvoiceDate')).EditMask := '!99/99/0000;1;_';
  TDateTimeField(DataSource1.DataSet.FieldByName('InvoiceDate')).DisplayFormat := 'dd/mm/yyyy';

  tblInvDetailInventoryName.LookupDataSet := tblInventory;
  tblInvDetailInventoryCode.LookupDataSet := tblInventory;

  DataSource1.DataSet.FieldByName('SupplierId').OnChange := tblPurchaseInvoiceSupplierIdChange;
  DataSource1.DataSet.FieldByName('CurrencyTypeId').OnChange := tblPurchaseInvoiceCurrencyTypeIdChange;
  DataSource1.DataSet.FieldByName('CurrencyRate').OnChange := tblPurchaseInvoiceCurrencyRateChange;
  DataSource1.DataSet.FieldByName('InvoiceDate').OnChange := tblPurchaseInvoiceInvoiceDateChange;

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

class function TPurchaseInvoiceEditForm.GetFormName: string;
begin
  Result := 'TPurchaseInvoiceEditForm';
end;

procedure TPurchaseInvoiceEditForm.OnEdit(DataSet: TDataSet);
begin
  inherited;

end;

procedure TPurchaseInvoiceEditForm.OnInsert(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('Paid').AsBoolean := False;
  DataSet.FieldByName('InvoiceDate').AsDateTime := Date;
end;

procedure TPurchaseInvoiceEditForm.RecalculateAllLines;
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

class function TPurchaseInvoiceEditForm.RequiredPermission(
  cmd: TBrowseFormCommand): string;
begin
  Result := '>????<';
  case cmd of
    efcmdAdd: Result := '1050,1051';
    efcmdEdit: Result := '1050,1052';
    efcmdDelete: Result := '1050,1053';
    efcmdViewDetail: Result := '1050,1054';
  end;
end;

procedure TPurchaseInvoiceEditForm.tblInvDetailBeforeDelete(DataSet: TDataSet);
begin
  Abort;
end;

procedure TPurchaseInvoiceEditForm.tblInvDetailCurrencyRateChange(
  Sender: TField);
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

procedure TPurchaseInvoiceEditForm.tblInvDetailCurrencyTypeIdChange(
  Sender: TField);
begin
  if not TblPrepared then
    Exit;
  tblInvDetail.Edit;
  tblInvDetailCurrencyRate.AsFloat := TCurrencyDailyModel.GetARate(TBuySale.tbsSelling, tblInvDetailCurrencyTypeId.AsInteger, edInvoiceDate.Field.AsDateTime);
end;

procedure TPurchaseInvoiceEditForm.tblInvDetailInventoryIdChange(
  Sender: TField);
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

procedure TPurchaseInvoiceEditForm.tblInvDetailNewRecord(DataSet: TDataSet);
begin
  if TblPrepared then
    tblInvDetailc_RowState.Value := 1;
end;

procedure TPurchaseInvoiceEditForm.tblInvDetailQuantityChange(Sender: TField);
begin
  if not TblPrepared then
    Exit;
  tblInvDetail.Edit;
  tblInvDetailVatAmount.AsFloat := Round(tblInvDetailQuantity.AsFloat * tblInvDetailUnitPrice.AsFloat * tblInvDetailVatPercentage.AsFloat) / 100;
  tblInvDetail.Edit;
  tblInvDetailTotalAmount.AsFloat := tblInvDetailQuantity.AsFloat * tblInvDetailUnitPrice.AsFloat + tblInvDetailVatAmount.AsFloat;
end;

procedure TPurchaseInvoiceEditForm.tblInvDetailTotalAmountChange(
  Sender: TField);
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

procedure TPurchaseInvoiceEditForm.tblInvDetailUnitPriceChange(Sender: TField);
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

procedure TPurchaseInvoiceEditForm.tblInvDetailVatAmountChange(Sender: TField);
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

procedure TPurchaseInvoiceEditForm.tblInvDetailVatPercentageChange(
  Sender: TField);
begin
  if not TblPrepared then
    Exit;
  tblInvDetailVatAmount.AsFloat := Round(tblInvDetailQuantity.AsFloat * tblInvDetailUnitPrice.AsFloat * tblInvDetailVatPercentage.AsFloat) / 100;
end;

procedure TPurchaseInvoiceEditForm.tblPurchaseInvoiceCurrencyRateChange(
  Sender: TField);
begin
  RecalculateAllLines;
end;

procedure TPurchaseInvoiceEditForm.tblPurchaseInvoiceCurrencyTypeIdChange(
  Sender: TField);
//var
  //cds : TDataset;
begin
  if not edCurrencyTypeId.Field.IsNull then
    edCurrencyRate.Field.AsFloat := TCurrencyDailyModel.GetARate(TBuySale.tbsSelling, edCurrencyTypeId.Field.AsInteger, edInvoiceDate.Field.AsDateTime);
  {cds := DMMain.GetRecord<TCurrencyDaily>('CurrencyDate=:CurrencyDate and CurrencyTypeId=:CurrencyTypeId', [edInvoiceDate.Field.AsDateTime, edCurrencyTypeId.Field.AsInteger]);
  try
    if cds.RecordCount>0 then
      edCurrencyRate.Field.AsFloat := cds.FieldByName('SellingRate').AsFloat
    else
      edCurrencyRate.Field.Clear;
  finally
    cds.Free;
  end;}
end;

procedure TPurchaseInvoiceEditForm.tblPurchaseInvoiceInvoiceDateChange(
  Sender: TField);
begin
  tblPurchaseInvoiceCurrencyTypeIdChange(Sender);
end;

procedure TPurchaseInvoiceEditForm.tblPurchaseInvoiceSupplierIdChange(
  Sender: TField);
var
  cds : TDataset;
begin
  cds := DMMain.GetRecord<TSupplier>(DataSource1.DataSet.FieldByName('SupplierId').AsInteger);
  try
    if cds.RecordCount>0 then
    begin
      edCurrencyTypeId.Field.Assign(cds.FieldByName('CurrencyTypeId'));
      edDueDate.Field.Assign(cds.FieldByName('PaymentDueDate'));
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

function CreatePurchaseInvoiceEditForm(ACmd : TBrowseFormCommand; ADs : TDataset; Params : Array of Variant) : TForm;
begin
  Result := TPurchaseInvoiceEditForm.Create(aCmd, aDs);
end;

initialization
  MyFactoryEditForm.RegisterForm<TPurchaseInvoiceEditForm>(TPurchaseInvoiceEditForm.GetFormName, CreatePurchaseInvoiceEditForm);

end.
