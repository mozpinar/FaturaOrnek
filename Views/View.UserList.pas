unit View.UserList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, View.TemplateForm, Data.DB, Vcl.Menus,
  Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls;

type
  TUserListForm = class(TTemplateForm)
  private
  protected
    procedure OpenDataset; override;
    function GetEditFormName : string; override;
  public
    { Public declarations }
  end;

var
  UserListForm: TUserListForm;

implementation
uses MainDM,
     Model.Declarations,
     Support.LanguageDictionary,
     Support.FabricationListForm;

{$R *.dfm}
var
  CreateForm : TFactoryMethodListForm<TTemplateForm>;

{ TUserListForm }

function TUserListForm.GetEditFormName: string;
begin
  Result := 'TUserEditForm';
end;

procedure TUserListForm.OpenDataset;
begin
  fDataSet := DMMain.GetList<TUser>('');

end;

initialization

  CreateForm := function : TTemplateForm
     begin
       if not DMMain.IsUserAuthorized('101,102,103,104,105') then
         raise Exception.Create(Support.LanguageDictionary.MessageDictionary().GetMessage('SNotAuthorized')+#13#10+'TUserListForm');
       Result := TUserListForm.Create(Application);
     end;

  MyFactoryListForm.RegisterForm<TUserListForm>('TUserListForm', CreateForm);


end.
