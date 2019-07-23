unit View.InventoryGroupList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, View.TemplateForm, Data.DB, Vcl.Menus,
  Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls;

type
  TInventoryGroupListForm = class(TTemplateForm)
  private
  protected
    procedure OpenDataset; override;
    function GetEditFormName : string; override;
  public
    { Public declarations }
  end;

var
  InventoryGroupListForm: TInventoryGroupListForm;

implementation
uses MainDM,
     Model.Declarations,
     Support.LanguageDictionary,
     Support.FabricationListForm;

{$R *.dfm}

{ TInventoryGroupListForm }

function TInventoryGroupListForm.GetEditFormName: string;
begin
  Result := 'TInventoryGroupEditForm';

end;

procedure TInventoryGroupListForm.OpenDataset;
begin
  fDataSet := DMMain.GetList<TInventoryGroup>('');
end;

var
  CreateForm : TFactoryMethodListForm<TTemplateForm>;

initialization

  CreateForm := function : TTemplateForm
     begin
       if not DMMain.IsUserAuthorized('1030,1031,1032,1033,1034') then
         raise Exception.Create(Support.LanguageDictionary.MessageDictionary().GetMessage('SNotAuthorized')+#13#10+'TInventoryGroupListForm');
       Result := TInventoryGroupListForm.Create(Application);
     end;

  MyFactoryListForm.RegisterForm<TInventoryGroupListForm>('TInventoryGroupListForm', CreateForm);



end.
