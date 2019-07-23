unit View.CustomerEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, View.TemplateEdit, Data.DB,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.DBCtrls, Vcl.Mask,
  Support.Consts;

type
  TCustomerEditForm = class(TTemplateEdit)
    lblCustomerName: TLabel;
    lblAddressLine1: TLabel;
    lblAddressLine2: TLabel;
    lblAddressLine3: TLabel;
    lblCity: TLabel;
    lblCountry: TLabel;
    lblContactPerson: TLabel;
    lblPhone: TLabel;
    lblFax: TLabel;
    lblContactEMail: TLabel;
    lblCurrencyTypeId: TLabel;
    edCustomerName: TDBEdit;
    edAddressLine1: TDBEdit;
    edAddressLine2: TDBEdit;
    edAddressLine3: TDBEdit;
    edCity: TDBEdit;
    edCountry: TDBEdit;
    edContactPerson: TDBEdit;
    edPhone: TDBEdit;
    edFax: TDBEdit;
    edContactEMail: TDBEdit;
    edCurrencyTypeId: TDBLookupComboBox;
    dsCurrencyType: TDataSource;
    edInBlackList: TDBCheckBox;
    edIsActive: TDBCheckBox;
    edPaymentDueDate: TDBEdit;
    lblPaymentDueDate: TLabel;
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  protected
    class function RequiredPermission(cmd: TBrowseFormCommand) : string; override;
    procedure OnInsert(DataSet: TDataSet); override;
    procedure OnEdit(DataSet: TDataSet); override;
    procedure BeforePost(DataSet: TDataSet); override;
    procedure AfterPost(DataSet: TDataSet); override;
    procedure FormLoaded; override;
    procedure UpdateLabelsText; override;

    class function GetFormName : string; override;
  public
    { Public declarations }
  end;

var
  CustomerEditForm: TCustomerEditForm;

implementation
uses MainDM, Model.Declarations, Support.FabricationEditForm, Support.LanguageDictionary;
{$R *.dfm}

{ TCustomerEditForm }

procedure TCustomerEditForm.AfterPost(DataSet: TDataSet);
begin
  inherited;

end;

procedure TCustomerEditForm.BeforePost(DataSet: TDataSet);
begin
  inherited;

end;

procedure TCustomerEditForm.FormDestroy(Sender: TObject);
begin
  inherited;
  dsCurrencyType.Free;
end;

procedure TCustomerEditForm.FormLoaded;
begin
  inherited;
  dsCurrencyType.DataSet := DMMain.GetList<TCurrencyType>('');
end;

class function TCustomerEditForm.GetFormName: string;
begin
  Result := 'TCustomerEditForm';
end;

procedure TCustomerEditForm.OnEdit(DataSet: TDataSet);
begin
  inherited;

end;

procedure TCustomerEditForm.OnInsert(DataSet: TDataSet);
begin
  inherited;

end;

class function TCustomerEditForm.RequiredPermission(
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

procedure TCustomerEditForm.UpdateLabelsText;
begin
  inherited;
  lblCustomerName.Caption := ComponentDictionary('').GetText(TCustomerEditForm.ClassName, 'lblCustomerName.Caption');
  lblAddressLine1.Caption := ComponentDictionary('').GetText(TCustomerEditForm.ClassName, 'lblAddressLine1.Caption');
  lblAddressLine2.Caption := ComponentDictionary('').GetText(TCustomerEditForm.ClassName, 'lblAddressLine2.Caption');
  lblAddressLine3.Caption := ComponentDictionary('').GetText(TCustomerEditForm.ClassName, 'lblAddressLine3.Caption');
  lblCity.Caption := ComponentDictionary('').GetText(TCustomerEditForm.ClassName, 'lblCity.Caption');
  lblCountry.Caption := ComponentDictionary('').GetText(TCustomerEditForm.ClassName, 'lblCountry.Caption');
  lblContactPerson.Caption := ComponentDictionary('').GetText(TCustomerEditForm.ClassName, 'lblContactPerson.Caption');
  lblPhone.Caption := ComponentDictionary('').GetText(TCustomerEditForm.ClassName, 'lblPhone.Caption');
  lblFax.Caption := ComponentDictionary('').GetText(TCustomerEditForm.ClassName, 'lblFax.Caption');
  lblContactEMail.Caption := ComponentDictionary('').GetText(TCustomerEditForm.ClassName, 'lblContactEMail.Caption');
  lblCurrencyTypeId.Caption := ComponentDictionary('').GetText(TCustomerEditForm.ClassName, 'lblCurrencyTypeId.Caption');
  lblPaymentDueDate.Caption := ComponentDictionary('').GetText(TCustomerEditForm.ClassName, 'lblPaymentDueDate.Caption');
  edInBlackList.Caption := ComponentDictionary('').GetText(TCustomerEditForm.ClassName, 'edInBlackList.Caption');
  edIsActive.Caption := ComponentDictionary('').GetText(TCustomerEditForm.ClassName, 'edIsActive.Caption');
end;

function CreateCustomerEditForm(ACmd : TBrowseFormCommand; ADs : TDataset; Params : Array of Variant) : TForm;
begin
  Result := TCustomerEditForm.Create(aCmd, aDs);
end;

initialization
  MyFactoryEditForm.RegisterForm<TCustomerEditForm>(TCustomerEditForm.GetFormName, CreateCustomerEditForm);
end.
