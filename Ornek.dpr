program Ornek;

uses
  Vcl.Forms,
  View.MainForm in 'View.MainForm.pas' {MainForm},
  MainDM in 'MainDM.pas' {DMMain: TDataModule},
  View.TemplateForm in 'Views\View.TemplateForm.pas' {TemplateForm},
  Support.Consts in 'Support\Support.Consts.pas',
  Support.LanguageDictionary in 'Support\Support.LanguageDictionary.pas',
  View.TemplateEdit in 'Views\Edits\View.TemplateEdit.pas' {TemplateEdit},
  Support.Attributes in 'Support\Support.Attributes.pas',
  Model.Declarations in 'Models\Model.Declarations.pas',
  View.CustomerList in 'Views\View.CustomerList.pas' {CustomerListForm},
  View.ServerAccess in 'Views\View.ServerAccess.pas' {ServerAccessForm},
  Support.FabricationListForm in 'Support\Support.FabricationListForm.pas',
  View.LoginForm in 'Views\View.LoginForm.pas' {LoginForm},
  View.CustomerEdit in 'Views\Edits\View.CustomerEdit.pas' {CustomerEditForm},
  Support.FabricationEditForm in 'Support\Support.FabricationEditForm.pas',
  View.SupplierEdit in 'Views\Edits\View.SupplierEdit.pas' {SupplierEditForm},
  View.SupplierList in 'Views\View.SupplierList.pas' {SupplierListForm},
  View.InventoryList in 'Views\View.InventoryList.pas' {InventoryListForm},
  View.InventoryEdit in 'Views\Edits\View.InventoryEdit.pas' {InventoryEditForm},
  View.PurchaseInvoiceList in 'Views\View.PurchaseInvoiceList.pas' {PurchaseInvoiceListForm},
  View.PurchaseInvoiceEdit in 'Views\Edits\View.PurchaseInvoiceEdit.pas' {PurchaseInvoiceEditForm},
  View.GridColumnSettings in 'Views\View.GridColumnSettings.pas' {GridPropertySettingsForm},
  Support.Types in 'Support\Support.Types.pas',
  View.SalesInvoiceList in 'Views\View.SalesInvoiceList.pas' {SalesInvoiceListForm},
  View.SalesInvoiceEdit in 'Views\Edits\View.SalesInvoiceEdit.pas' {SalesInvoiceEditForm},
  View.CurrencyTypeList in 'Views\View.CurrencyTypeList.pas' {CurrencyTypeListForm},
  View.CurrencyTypeEdit in 'Views\Edits\View.CurrencyTypeEdit.pas' {CurrencyTypeEditForm},
  View.DailyCurrencyValues in 'Views\View.DailyCurrencyValues.pas' {DailyCurrencyValuesForm},
  Model.CurrencyDaily in 'Models\Model.CurrencyDaily.pas',
  View.InventoryGroupList in 'Views\View.InventoryGroupList.pas' {InventoryGroupListForm},
  View.InventoryGroupEdit in 'Views\Edits\View.InventoryGroupEdit.pas' {InventoryGroupEditForm},
  View.UserList in 'Views\View.UserList.pas' {UserListForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TInventoryGroupListForm, InventoryGroupListForm);
  Application.CreateForm(TInventoryGroupEditForm, InventoryGroupEditForm);
  Application.CreateForm(TUserListForm, UserListForm);
  Application.Run;
end.
