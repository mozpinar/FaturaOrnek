unit View.MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ExtCtrls, Vcl.ComCtrls,

  Support.Consts;

type
  TMainForm = class(TForm)
    pagekChildren: TPageControl;
    Panel1: TPanel;
    MainMenu1: TMainMenu;
    Suppliers1: TMenuItem;
    Customers1: TMenuItem;
    Inventory1: TMenuItem;
    Invoices1: TMenuItem;
    PurchaseInvoice1: TMenuItem;
    SalesInvoice1: TMenuItem;
    StatusBar1: TStatusBar;
    Security1: TMenuItem;
    Users1: TMenuItem;
    Groups1: TMenuItem;
    Permissions1: TMenuItem;
    Currency1: TMenuItem;
    CurrencyTypes1: TMenuItem;
    DailyCurrencyValues1: TMenuItem;
    InventoryGroups1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure Customers1Click(Sender: TObject);
    procedure Suppliers1Click(Sender: TObject);
    procedure Inventory1Click(Sender: TObject);
    procedure PurchaseInvoice1Click(Sender: TObject);
    procedure SalesInvoice1Click(Sender: TObject);
    procedure CurrencyTypes1Click(Sender: TObject);
    procedure DailyCurrencyValues1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure InventoryGroups1Click(Sender: TObject);
    procedure Users1Click(Sender: TObject);
  private
    fClientFormCount : Integer;
    procedure ActivateNewListForm(const name : string);
    function SetNewForm(const aTabName: string; aForm: TForm): Integer;
    procedure wmCloseClient(var Msg: TMessage); message wm_CloseClient;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}
uses Support.FabricationListForm, IniFiles, MainDM, View.TemplateForm,
  Support.LanguageDictionary;

function GetFormName(const ARegisterName : string) : string;
var IniF : TIniFile;
begin
  IniF := TIniFile.Create(DMMain.IniFName);
  try
    Result := IniF.ReadString('Form Names', ARegisterName, ARegisterName);
  finally
    IniF.Free;
  end;
end;

procedure TMainForm.ActivateNewListForm(const name: string);
var
  f : TTemplateForm;
  s : string;
  cpt : string;

begin
  s := name;
  s := GetFormName(s);

  f := MyFactoryListForm.GetForm(s);

  cpt := f.Caption;

  f.Name := 'TFRM'+IntToStr(SetNewForm(cpt, f));

  f.Show;
end;

procedure TMainForm.SalesInvoice1Click(Sender: TObject);
begin
  ActivateNewListForm('TSalesInvoiceListForm');
end;

function TMainForm.SetNewForm(const aTabName : string; aForm : TForm) : Integer;
var
  ts : TTabSheet;
begin
  ts := TTabSheet.Create(self);
  ts.PageControl := pagekChildren;
  ts.Caption := aTabName;

  pagekChildren.ActivePage := ts;

  fClientFormCount := fClientFormCount + 1;

  ts.Name := 'TS'+IntToStr(fClientFormCount);

  aForm.Parent := ts;
  aForm.Align := alClient;
  aForm.BorderStyle := bsNone;

  ts.Tag := aForm.Handle;   ///!!!!!!!!!!!!!!! Important

  Result := fClientFormCount;
end;

procedure TMainForm.Suppliers1Click(Sender: TObject);
begin
  ActivateNewListForm('TSupplierListForm');
end;

procedure TMainForm.Users1Click(Sender: TObject);
begin
  ActivateNewListForm('TUserListForm');
end;

procedure TMainForm.wmCloseClient(var Msg: TMessage);
var
  i : integer;
begin
  for i:=0 to pagekChildren.PageCount-1 do
    if pagekChildren.Pages[i].Tag=Msg.lParam then
    begin
      pagekChildren.Pages[i].Free;
      Exit;
    end;
end;

procedure TMainForm.CurrencyTypes1Click(Sender: TObject);
begin
  ActivateNewListForm('TCurrencyTypeListForm');
end;

procedure TMainForm.Customers1Click(Sender: TObject);
begin
  ActivateNewListForm('TCustomerListForm');
  //with TCustomerListForm.Create(Application) do
    //Show;
end;

procedure TMainForm.DailyCurrencyValues1Click(Sender: TObject);
begin
  ActivateNewListForm('TDailyCurrencyValuesForm');
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  fClientFormCount := 0;
  DMMain := TDMMain.Create(Application);

  DMMain.LoggedIn := DMMain.ExecuteLogin;
  if not DMMain.LoggedIn then
  begin
    Close;
    Halt;
  end;

  Caption := ComponentDictionary('').GetText(ClassName, 'Caption');
  Customers1.Caption := ComponentDictionary('').GetText(ClassName, 'Customers1.Caption');
  Suppliers1.Caption := ComponentDictionary('').GetText(ClassName, 'Suppliers1.Caption');
  Inventory1.Caption := ComponentDictionary('').GetText(ClassName, 'Inventory1.Caption');
  Invoices1.Caption := ComponentDictionary('').GetText(ClassName, 'Invoices1.Caption');
  InventoryGroups1.Caption := ComponentDictionary('').GetText(ClassName, 'InventoryGroups1.Caption');
  Currency1.Caption := ComponentDictionary('').GetText(ClassName, 'Currency1.Caption');
  Security1.Caption := ComponentDictionary('').GetText(ClassName, 'Security1.Caption');
  PurchaseInvoice1.Caption := ComponentDictionary('').GetText(ClassName, 'PurchaseInvoice1.Caption');
  SalesInvoice1.Caption := ComponentDictionary('').GetText(ClassName, 'SalesInvoice1.Caption');
  CurrencyTypes1.Caption := ComponentDictionary('').GetText(ClassName, 'CurrencyTypes1.Caption');
  DailyCurrencyValues1.Caption := ComponentDictionary('').GetText(ClassName, 'DailyCurrencyValues1.Caption');
  Users1.Caption := ComponentDictionary('').GetText(ClassName, 'Users1.Caption');
  Groups1.Caption := ComponentDictionary('').GetText(ClassName, 'Groups1.Caption');
  Permissions1.Caption := ComponentDictionary('').GetText(ClassName, 'Permissions1.Caption');
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  ts : TTabSheet;
begin
  if (Shift=[]) and (Key=vk_Escape) then
  begin
    Key := 0;
    if pagekChildren.PageCount<=0 then
      Exit;

    if (pagekChildren.ActivePage<>Nil) and (pagekChildren.ActivePage.ControlCount>0) then
    begin
      if pagekChildren.ActivePage.Controls[0] is TForm then
        (pagekChildren.ActivePage.Controls[0] as TForm).Close;
    end;
  end;
end;

procedure TMainForm.Inventory1Click(Sender: TObject);
begin
  ActivateNewListForm('TInventoryListForm');
end;

procedure TMainForm.InventoryGroups1Click(Sender: TObject);
begin
  ActivateNewListForm('TInventoryGroupListForm');
end;

procedure TMainForm.PurchaseInvoice1Click(Sender: TObject);
begin
  ActivateNewListForm('TPurchaseInvoiceListForm');
end;

end.
