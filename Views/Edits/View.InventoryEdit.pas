unit View.InventoryEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, View.TemplateEdit, Data.DB,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.DBCtrls, Vcl.Mask,
  Support.Consts;

type
  TInventoryEditForm = class(TTemplateEdit)
    edInventoryName: TDBEdit;
    edStoragePlace: TDBEdit;
    edSpecCode: TDBEdit;
    edMeasurements: TDBEdit;
    edBuyingPrice: TDBEdit;
    edSellingPrice: TDBEdit;
    edVatPercentage: TDBEdit;
    edOtvAmount: TDBEdit;
    edUnitDesc: TDBEdit;
    edReorderPoint: TDBEdit;
    edCurrencyTypeId: TDBLookupComboBox;
    edIsActive: TDBCheckBox;
    lblInventoryName: TLabel;
    lblInventoryGroupId: TLabel;
    lblStoragePlace: TLabel;
    lblMeasurements: TLabel;
    lblBuyingPrice: TLabel;
    lblSellingPrice: TLabel;
    lblVatPercentage: TLabel;
    lblOtvAmount: TLabel;
    lblUnitDesc: TLabel;
    lblReorderPoint: TLabel;
    lblCurrencyTypeId: TLabel;
    edInventoryGroupId: TDBLookupComboBox;
    dsCurrencyType: TDataSource;
    dsInventoryGroup: TDataSource;
    lblBufferStock: TLabel;
    edBufferStock: TDBEdit;
    lblSpecCode: TLabel;
    lblInventoryCode: TLabel;
    edInventoryCode: TDBEdit;
  private
  protected
    class function RequiredPermission(cmd: TBrowseFormCommand) : string; override;
    procedure OnInsert(DataSet: TDataSet); override;
    procedure OnEdit(DataSet: TDataSet); override;
    procedure BeforePost(DataSet: TDataSet); override;
    procedure AfterPost(DataSet: TDataSet); override;
    procedure FormLoaded; override;

    class function GetFormName : string; override;
  public
    { Public declarations }
  end;

var
  InventoryEditForm: TInventoryEditForm;

implementation
uses MainDM, Model.Declarations, Support.FabricationEditForm,
     Support.LanguageDictionary;

{$R *.dfm}

{ TInventoryEditForm }

procedure TInventoryEditForm.AfterPost(DataSet: TDataSet);
begin
  inherited;

end;

procedure TInventoryEditForm.BeforePost(DataSet: TDataSet);
begin
  inherited;

end;

procedure TInventoryEditForm.FormLoaded;
begin
  inherited;

  dsCurrencyType.DataSet := DMMain.GetList<TCurrencyType>('');
  dsInventoryGroup.DataSet := DMMain.GetList<TInventoryGroup>('');

  lblInventoryCode.Caption := ComponentDictionary('').GetText(TInventoryEditForm.ClassName, 'lblInventoryCode.Caption');
  lblInventoryName.Caption := ComponentDictionary('').GetText(TInventoryEditForm.ClassName, 'lblInventoryName.Caption');
  lblInventoryGroupId.Caption := ComponentDictionary('').GetText(TInventoryEditForm.ClassName, 'lblInventoryGroupId.Caption');
  lblStoragePlace.Caption := ComponentDictionary('').GetText(TInventoryEditForm.ClassName, 'lblStoragePlace.Caption');
  lblSpecCode.Caption := ComponentDictionary('').GetText(TInventoryEditForm.ClassName, 'lblSpecCode.Caption');
  lblMeasurements.Caption := ComponentDictionary('').GetText(TInventoryEditForm.ClassName, 'lblMeasurements.Caption');
  lblCurrencyTypeId.Caption := ComponentDictionary('').GetText(TInventoryEditForm.ClassName, 'lblCurrencyTypeId.Caption');
  lblBuyingPrice.Caption := ComponentDictionary('').GetText(TInventoryEditForm.ClassName, 'lblBuyingPrice.Caption');
  lblSellingPrice.Caption := ComponentDictionary('').GetText(TInventoryEditForm.ClassName, 'lblSellingPrice.Caption');
  lblVatPercentage.Caption := ComponentDictionary('').GetText(TInventoryEditForm.ClassName, 'lblVatPercentage.Caption');
  lblOtvAmount.Caption := ComponentDictionary('').GetText(TInventoryEditForm.ClassName, 'lblOtvAmount.Caption');
  lblUnitDesc.Caption := ComponentDictionary('').GetText(TInventoryEditForm.ClassName, 'lblUnitDesc.Caption');
  lblReorderPoint.Caption := ComponentDictionary('').GetText(TInventoryEditForm.ClassName, 'lblReorderPoint.Caption');
  lblBufferStock.Caption := ComponentDictionary('').GetText(TInventoryEditForm.ClassName, 'lblBufferStock.Caption');
  edIsActive.Caption := ComponentDictionary('').GetText(TInventoryEditForm.ClassName, 'edIsActive.Caption');
end;

class function TInventoryEditForm.GetFormName: string;
begin
  Result := 'TInventoryEditForm';
end;

procedure TInventoryEditForm.OnEdit(DataSet: TDataSet);
begin
  inherited;

end;

procedure TInventoryEditForm.OnInsert(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('IsActive').AsBoolean := True;
end;

class function TInventoryEditForm.RequiredPermission(
  cmd: TBrowseFormCommand): string;
begin
  Result := '>????<';
  case cmd of
    efcmdAdd: Result := '1040,1041';
    efcmdEdit: Result := '1040,1042';
    efcmdDelete: Result := '1040,1043';
    efcmdViewDetail: Result := '1040,1044';
  end;
end;

function CreateInventoryEditForm(ACmd : TBrowseFormCommand; ADs : TDataset; Params : Array of Variant) : TForm;
begin
  Result := TInventoryEditForm.Create(aCmd, aDs);
end;

initialization
  MyFactoryEditForm.RegisterForm<TInventoryEditForm>(TInventoryEditForm.GetFormName, CreateInventoryEditForm);

end.
