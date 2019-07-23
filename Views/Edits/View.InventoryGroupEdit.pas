unit View.InventoryGroupEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, View.TemplateEdit, Data.DB,
  Vcl.StdCtrls, Vcl.ExtCtrls,
  Support.Consts, Vcl.Mask, Vcl.DBCtrls;

type
  TInventoryGroupEditForm = class(TTemplateEdit)
    lblInventoryGroupName: TLabel;
    edInventoryGroupName: TDBEdit;
  private
  protected
    class function RequiredPermission(cmd: TBrowseFormCommand) : string; override;
    procedure OnInsert(DataSet: TDataSet); override;
    procedure OnEdit(DataSet: TDataSet); override;
    procedure BeforePost(DataSet: TDataSet); override;
    procedure AfterPost(DataSet: TDataSet); override;
    procedure FormLoaded; override;
    procedure UpdateLabelsText; override;

    class function GetFormName : string; override;
  public
  end;

var
  InventoryGroupEditForm: TInventoryGroupEditForm;

implementation
uses MainDM, Model.Declarations, Support.FabricationEditForm, Support.LanguageDictionary;

{$R *.dfm}

{ TInventoryGroupEditForm }

procedure TInventoryGroupEditForm.AfterPost(DataSet: TDataSet);
begin
  inherited;

end;

procedure TInventoryGroupEditForm.BeforePost(DataSet: TDataSet);
begin
  inherited;

end;

procedure TInventoryGroupEditForm.FormLoaded;
begin
  inherited;

end;

class function TInventoryGroupEditForm.GetFormName: string;
begin
  Result := 'TInventoryGroupEditForm';
end;

procedure TInventoryGroupEditForm.OnEdit(DataSet: TDataSet);
begin
  inherited;

end;

procedure TInventoryGroupEditForm.OnInsert(DataSet: TDataSet);
begin
  inherited;

end;

class function TInventoryGroupEditForm.RequiredPermission(
  cmd: TBrowseFormCommand): string;
begin
  Result := '>????<';
  case cmd of
    efcmdAdd: Result := '1030,1031';
    efcmdEdit: Result := '1030,1032';
    efcmdDelete: Result := '1030,1033';
    efcmdViewDetail: Result := '1030,1034';
  end;
end;

procedure TInventoryGroupEditForm.UpdateLabelsText;
begin
  inherited;
  lblInventoryGroupName.Caption := ComponentDictionary('').GetText(TInventoryGroupEditForm.ClassName, 'lblInventoryGroupName.Caption');
end;


function CreateCustomerGroupEditForm(ACmd : TBrowseFormCommand; ADs : TDataset; Params : Array of Variant) : TForm;
begin
  Result := TInventoryGroupEditForm.Create(aCmd, aDs);
end;

initialization
  MyFactoryEditForm.RegisterForm<TInventoryGroupEditForm>(TInventoryGroupEditForm.GetFormName, CreateCustomerGroupEditForm);

end.
