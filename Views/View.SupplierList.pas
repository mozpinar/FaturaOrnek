unit View.SupplierList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, View.TemplateForm, Data.DB,
  Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, Vcl.Menus;

type
  TSupplierListForm = class(TTemplateForm)
  private
    { Private declarations }
  protected
    procedure OpenDataset; override;
    function GetEditFormName : string; override;
  public
    { Public declarations }
  end;

var
  SupplierListForm: TSupplierListForm;

implementation
uses MainDM,
     Model.Declarations,
     Support.LanguageDictionary,
     Support.FabricationListForm;

{$R *.dfm}

{ TTemplateForm1 }

function TSupplierListForm.GetEditFormName: string;
begin
  Result := 'TSupplierEditForm';
end;

procedure TSupplierListForm.OpenDataset;
begin
  fDataSet := DMMain.GetList<TSupplier>('');
end;
var
  CreateForm : TFactoryMethodListForm<TTemplateForm>;

initialization

  CreateForm := function : TTemplateForm
     begin
       if not DMMain.IsUserAuthorized('1020,1021,1022,1023,1024') then
         raise Exception.Create(Support.LanguageDictionary.MessageDictionary().GetMessage('SNotAuthorized')+#13#10+'TSupplierListForm');
       Result := TSupplierListForm.Create(Application);
     end;

  MyFactoryListForm.RegisterForm<TSupplierListForm>('TSupplierListForm', CreateForm);


end.
