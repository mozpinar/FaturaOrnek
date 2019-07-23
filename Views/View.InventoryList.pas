unit View.InventoryList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, View.TemplateForm, Data.DB,
  Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, Vcl.Menus;

type
  TInventoryListForm = class(TTemplateForm)
  private
    procedure InventoryGroupIdGetText(Sender: TField; var Text: string;DisplayText: Boolean);
  protected
    procedure OpenDataset; override;
    function GetEditFormName : string; override;
  public
    { Public declarations }
  end;

var
  InventoryListForm: TInventoryListForm;

implementation
uses MainDM,
     Model.Declarations,
     Support.LanguageDictionary,
     Support.FabricationListForm;

{$R *.dfm}

{ TTemplateForm1 }

function TInventoryListForm.GetEditFormName: string;
begin
  Result := 'TInventoryEditForm';
end;

procedure TInventoryListForm.InventoryGroupIdGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
var ds : TDataset;
begin
  ds := DMMain.GetRecord<TInventoryGroup>(Sender.AsInteger);
  try
    Text := ds.FieldByName('InventoryGroupName').AsString;
  finally
    ds.Free;
  end;
end;

procedure TInventoryListForm.OpenDataset;
begin
  fDataSet := DMMain.GetList<TInventory>('');
  fDataSet.FieldByName('InventoryGroupId').OnGetText := InventoryGroupIdGetText;
end;

var
  CreateForm : TFactoryMethodListForm<TTemplateForm>;

initialization

  CreateForm := function : TTemplateForm
     begin
       if not DMMain.IsUserAuthorized('1040,1041,1042,1043,1044') then
         raise Exception.Create(Support.LanguageDictionary.MessageDictionary().GetMessage('SNotAuthorized')+#13#10+'TInventoryListForm');
       Result := TInventoryListForm.Create(Application);
     end;

  MyFactoryListForm.RegisterForm<TInventoryListForm>('TInventoryListForm', CreateForm);


end.
