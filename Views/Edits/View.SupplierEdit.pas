unit View.SupplierEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, View.TemplateEdit, Vcl.StdCtrls,
  Vcl.DBCtrls, Vcl.Mask, Data.DB, Vcl.ExtCtrls,
  Support.Consts;

type
  TSupplierEditForm = class(TTemplateEdit)
    edSupplierName: TDBEdit;
    edIsActive: TDBCheckBox;
    edInBlackList: TDBCheckBox;
    edCurrencyTypeId: TDBLookupComboBox;
    edContactEMail: TDBEdit;
    edFax: TDBEdit;
    edPhone: TDBEdit;
    edContactPerson: TDBEdit;
    edCountry: TDBEdit;
    edCity: TDBEdit;
    edAddressLine3: TDBEdit;
    edAddressLine2: TDBEdit;
    edAddressLine1: TDBEdit;
    lblCurrencyTypeId: TLabel;
    lblContactEMail: TLabel;
    lblFax: TLabel;
    lblPhone: TLabel;
    lblContactPerson: TLabel;
    lblCountry: TLabel;
    lblCity: TLabel;
    lblAddressLine3: TLabel;
    lblAddressLine2: TLabel;
    lblAddressLine1: TLabel;
    lblSupplierName: TLabel;
    dsCurrencyType: TDataSource;
    edPostCode: TDBEdit;
    lblPostCode: TLabel;
    edPaymentDueDate: TDBEdit;
    lblPaymentDueDate: TLabel;
  private
    { Private declarations }
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
  SupplierEditForm: TSupplierEditForm;

implementation
uses MainDM, Model.Declarations, Support.FabricationEditForm, Support.LanguageDictionary;

{$R *.dfm}

{ TSupplierEditForm }

procedure TSupplierEditForm.AfterPost(DataSet: TDataSet);
begin
  inherited;

end;

procedure TSupplierEditForm.BeforePost(DataSet: TDataSet);
begin
  inherited;

end;

procedure TSupplierEditForm.FormLoaded;
begin
  inherited;
  dsCurrencyType.DataSet := DMMain.GetList<TCurrencyType>('');

  lblSupplierName.Caption := ComponentDictionary('').GetText(TSupplierEditForm.ClassName, 'lblSupplierName.Caption');
  lblAddressLine1.Caption := ComponentDictionary('').GetText(TSupplierEditForm.ClassName, 'lblAddressLine1.Caption');
  lblAddressLine2.Caption := ComponentDictionary('').GetText(TSupplierEditForm.ClassName, 'lblAddressLine2.Caption');
  lblAddressLine3.Caption := ComponentDictionary('').GetText(TSupplierEditForm.ClassName, 'lblAddressLine3.Caption');
  lblCity.Caption := ComponentDictionary('').GetText(TSupplierEditForm.ClassName, 'lblCity.Caption');
  lblCountry.Caption := ComponentDictionary('').GetText(TSupplierEditForm.ClassName, 'lblCountry.Caption');
  lblContactPerson.Caption := ComponentDictionary('').GetText(TSupplierEditForm.ClassName, 'lblContactPerson.Caption');
  lblPhone.Caption := ComponentDictionary('').GetText(TSupplierEditForm.ClassName, 'lblPhone.Caption');
  lblFax.Caption := ComponentDictionary('').GetText(TSupplierEditForm.ClassName, 'lblFax.Caption');
  lblContactEMail.Caption := ComponentDictionary('').GetText(TSupplierEditForm.ClassName, 'lblContactEMail.Caption');
  lblCurrencyTypeId.Caption := ComponentDictionary('').GetText(TSupplierEditForm.ClassName, 'lblCurrencyTypeId.Caption');
  lblPaymentDueDate.Caption := ComponentDictionary('').GetText(TSupplierEditForm.ClassName, 'lblPaymentDueDate.Caption');
  edInBlackList.Caption := ComponentDictionary('').GetText(TSupplierEditForm.ClassName, 'edInBlackList.Caption');
  edIsActive.Caption := ComponentDictionary('').GetText(TSupplierEditForm.ClassName, 'edIsActive.Caption');
end;

class function TSupplierEditForm.GetFormName: string;
begin
  Result := 'TSupplierEditForm';
end;

procedure TSupplierEditForm.OnEdit(DataSet: TDataSet);
begin
  inherited;

end;

procedure TSupplierEditForm.OnInsert(DataSet: TDataSet);
begin
  inherited;

end;

class function TSupplierEditForm.RequiredPermission(
  cmd: TBrowseFormCommand): string;
begin
  Result := '>????<';
  case cmd of
    efcmdAdd: Result := '1010,1011';
    efcmdEdit: Result := '1010,1012';
    efcmdDelete: Result := '1010,1013';
    efcmdViewDetail: Result := '1010,1014';
  end;
end;

function CreateSupplierEditForm(ACmd : TBrowseFormCommand; ADs : TDataset; Params : Array of Variant) : TForm;
begin
  Result := TSupplierEditForm.Create(aCmd, aDs);
end;

initialization
  MyFactoryEditForm.RegisterForm<TSupplierEditForm>(TSupplierEditForm.GetFormName, CreateSupplierEditForm);

end.
