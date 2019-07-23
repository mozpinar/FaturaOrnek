unit View.CurrencyTypeList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, View.TemplateForm, Data.DB, Vcl.Menus,
  Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls;

type
  TCurrencyTypeListForm = class(TTemplateForm)
  private
  protected
    procedure OpenDataset; override;
    function GetEditFormName : string; override;
  public
    { Public declarations }
  end;

var
  CurrencyTypeListForm: TCurrencyTypeListForm;

implementation
uses MainDM,
     Model.Declarations,
     Support.LanguageDictionary,
     Support.FabricationListForm;


{$R *.dfm}

{ TCurrencyTypeListForm }

function TCurrencyTypeListForm.GetEditFormName: string;
begin
  Result := 'TCurrencyTypeEditForm';
end;

procedure TCurrencyTypeListForm.OpenDataset;
begin
  fDataSet := DMMain.GetList<TCurrencyType>('');
end;

var
  CreateForm : TFactoryMethodListForm<TTemplateForm>;

initialization

  CreateForm := function : TTemplateForm
     begin
       if not DMMain.IsUserAuthorized('510,511,512,513,514') then
         raise Exception.Create(Support.LanguageDictionary.MessageDictionary().GetMessage('SNotAuthorized')+#13#10+'TCurrencyTypeListForm');
       Result := TCurrencyTypeListForm.Create(Application);
     end;

  MyFactoryListForm.RegisterForm<TCurrencyTypeListForm>('TCurrencyTypeListForm', CreateForm);

end.
