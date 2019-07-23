unit View.PurchaseInvoiceList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, View.TemplateForm, Data.DB,
  Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, Vcl.Menus;

type
  TPurchaseInvoiceListForm = class(TTemplateForm)
    procedure btnDeleteClick(Sender: TObject);
  private
  protected
    procedure OpenDataset; override;
    function GetEditFormName : string; override;
  public
    { Public declarations }
  end;

var
  PurchaseInvoiceListForm: TPurchaseInvoiceListForm;

implementation
uses MainDM,
     Model.Declarations,
     Support.LanguageDictionary,
     Support.FabricationListForm;

{$R *.dfm}

{ TPurchaseInvoiceListForm }

procedure TPurchaseInvoiceListForm.btnDeleteClick(Sender: TObject);
begin
  if MessageDlg(MessageDictionary('').GetMessage('SConfirmToDelete'), mtWarning, [mbCancel, mbOk], 0)<>mrOk then
    Exit;
  DMMain.ExecSql('delete from '+DMMain.TableName<TPurchaseInvoiceDetail>+' where PurchaseInvoiceHeaderId=:PurchaseInvoiceHeaderId',
                  [fDataset.FieldByName('PurchaseInvoiceHeaderId').AsInteger], [ftInteger]);
  fDataset.Delete;
end;

function TPurchaseInvoiceListForm.GetEditFormName: string;
begin
  Result := 'TPurchaseInvoiceEditForm';
end;

procedure TPurchaseInvoiceListForm.OpenDataset;
begin
  fDataSet := DMMain.GetList<TPurchaseInvoiceHeader>('');
end;

var
  CreateForm : TFactoryMethodListForm<TTemplateForm>;

initialization

  CreateForm := function : TTemplateForm
     begin
       if not DMMain.IsUserAuthorized('1050,1051,1052,1053,1054') then
         raise Exception.Create(Support.LanguageDictionary.MessageDictionary().GetMessage('SNotAuthorized')+#13#10+'TPurchaseInvoiceListForm');
       Result := TPurchaseInvoiceListForm.Create(Application);
     end;

  MyFactoryListForm.RegisterForm<TPurchaseInvoiceListForm>('TPurchaseInvoiceListForm', CreateForm);

end.
