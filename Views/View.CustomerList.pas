unit View.CustomerList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, View.TemplateForm, Data.DB, Vcl.Grids,
  Vcl.DBGrids, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TCustomerListForm = class(TTemplateForm)
  private
    { Private declarations }
  protected
    procedure OpenDataset; override;
    function GetEditFormName : string; override;

  public
    { Public declarations }
  end;

var
  CustomerListForm: TCustomerListForm;

implementation
uses MainDM,
     Model.Declarations,
     Support.LanguageDictionary,
     Support.FabricationListForm;
{$R *.dfm}

{ TCustomerListForm }

function TCustomerListForm.GetEditFormName: string;
begin
  Result := 'TCustomerEditForm';
end;

procedure TCustomerListForm.OpenDataset;
begin
  fDataSet := DMMain.GetList<TCustomer>('');
end;

var
  CreateForm : TFactoryMethodListForm<TTemplateForm>;

initialization

  CreateForm := function : TTemplateForm
     begin
       if not DMMain.IsUserAuthorized('1010,1011,1012,1013,1014') then
         raise Exception.Create(Support.LanguageDictionary.MessageDictionary().GetMessage('SNotAuthorized')+#13#10+'TCustomerListForm');
       Result := TCustomerListForm.Create(Application);
     end;

  MyFactoryListForm.RegisterForm<TCustomerListForm>('TCustomerListForm', CreateForm);


end.
