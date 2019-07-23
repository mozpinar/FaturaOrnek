unit View.SalesInvoiceList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, View.TemplateForm, Data.DB, Vcl.Menus,
  Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls;

type
  TSalesInvoiceListForm = class(TTemplateForm)
    procedure btnDeleteClick(Sender: TObject);
  private
  protected
    procedure OpenDataset; override;
    function GetEditFormName : string; override;
  public
    { Public declarations }
  end;

var
  SalesInvoiceListForm: TSalesInvoiceListForm;

implementation
uses MainDM,
     Model.Declarations,
     Support.LanguageDictionary,
     Support.FabricationListForm;

{$R *.dfm}

{ TSalesInvoiceListForm }

procedure TSalesInvoiceListForm.btnDeleteClick(Sender: TObject);
begin
  if MessageDlg(MessageDictionary('').GetMessage('SConfirmToDelete'), mtWarning, [mbCancel, mbOk], 0)<>mrOk then
    Exit;
  DMMain.ExecSql('delete from '+DMMain.TableName<TPurchaseInvoiceDetail>+' where PurchaseInvoiceHeaderId=:PurchaseInvoiceHeaderId',
                  [fDataset.FieldByName('PurchaseInvoiceHeaderId').AsInteger], [ftInteger]);
  fDataset.Delete;
end;

function TSalesInvoiceListForm.GetEditFormName: string;
begin
  Result := 'TSalesInvoiceEditForm';
end;

procedure TSalesInvoiceListForm.OpenDataset;
begin
  fDataSet := DMMain.GetList<TSalesInvoiceHeader>('');
end;

var
  CreateForm : TFactoryMethodListForm<TTemplateForm>;

initialization

  CreateForm := function : TTemplateForm
     begin
       if not DMMain.IsUserAuthorized('1060,1061,1062,1063,1064') then
         raise Exception.Create(Support.LanguageDictionary.MessageDictionary().GetMessage('SNotAuthorized')+#13#10+'TSalesInvoiceListForm');
       Result := TSalesInvoiceListForm.Create(Application);
     end;

  MyFactoryListForm.RegisterForm<TSalesInvoiceListForm>('TSalesInvoiceListForm', CreateForm);
end.
