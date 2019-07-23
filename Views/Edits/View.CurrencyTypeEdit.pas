unit View.CurrencyTypeEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, View.TemplateEdit, Data.DB,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Mask, Vcl.DBCtrls,
  Support.Consts;


type
  TCurrencyTypeEditForm = class(TTemplateEdit)
    lblCurrencyCode: TLabel;
    lblCurrencyName: TLabel;
    edCurrencyCode: TDBEdit;
    edCurrencyName: TDBEdit;
  private
  protected
    class function RequiredPermission(cmd: TBrowseFormCommand) : string; override;
    procedure OnInsert(DataSet: TDataSet); override;
    procedure OnEdit(DataSet: TDataSet); override;
    procedure BeforePost(DataSet: TDataSet); override;
    procedure AfterPost(DataSet: TDataSet); override;
    procedure FormLoaded; override;

    class function GetFormName : string; override;
  public
    { Public declarations }
  end;

var
  CurrencyTypeEditForm: TCurrencyTypeEditForm;

implementation
uses MainDM,
     Model.Declarations,
     Support.LanguageDictionary,
     Support.FabricationEditForm;

{$R *.dfm}

{ TCurrencyTypeEditForm }

procedure TCurrencyTypeEditForm.AfterPost(DataSet: TDataSet);
begin
  inherited;

end;

procedure TCurrencyTypeEditForm.BeforePost(DataSet: TDataSet);
begin
  inherited;

end;

procedure TCurrencyTypeEditForm.FormLoaded;
begin
  inherited;

  lblCurrencyCode.Caption := ComponentDictionary('').GetText(TCurrencyTypeEditForm.ClassName, 'lblCurrencyCode.Caption');
  lblCurrencyName.Caption := ComponentDictionary('').GetText(TCurrencyTypeEditForm.ClassName, 'lblCurrencyName.Caption');

end;

class function TCurrencyTypeEditForm.GetFormName: string;
begin
  Result := 'TCurrencyTypeEditForm';
end;

procedure TCurrencyTypeEditForm.OnEdit(DataSet: TDataSet);
begin
  inherited;

end;

procedure TCurrencyTypeEditForm.OnInsert(DataSet: TDataSet);
begin
  inherited;

end;

class function TCurrencyTypeEditForm.RequiredPermission(
  cmd: TBrowseFormCommand): string;
begin
  Result := '>????<';
  case cmd of
    efcmdAdd: Result := '510,511';
    efcmdEdit: Result := '510,512';
    efcmdDelete: Result := '510,513';
    efcmdViewDetail: Result := '510,514';
  end;
end;


function CreateCurrencyTypeEditForm(ACmd : TBrowseFormCommand; ADs : TDataset; Params : Array of Variant) : TForm;
begin
  Result := TCurrencyTypeEditForm.Create(aCmd, aDs);
end;

initialization
  MyFactoryEditForm.RegisterForm<TCurrencyTypeEditForm>(TCurrencyTypeEditForm.GetFormName, CreateCurrencyTypeEditForm);

end.