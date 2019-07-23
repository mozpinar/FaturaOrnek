unit View.UserEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, View.TemplateEdit, Data.DB,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.DBCtrls, Vcl.Mask,
  Support.Consts, Vcl.Buttons;

type
  TUserEditForm = class(TTemplateEdit)
    edUserName: TDBEdit;
    edPswd: TDBEdit;
    lblPswd: TLabel;
    lblUserName: TLabel;
    edIsActive: TDBCheckBox;
    ListBox1: TListBox;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    ListBox2: TListBox;
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
  UserEditForm: TUserEditForm;

implementation
uses MainDM, Model.Declarations, Support.FabricationEditForm, Support.LanguageDictionary;

{$R *.dfm}

{ TUserEditForm }

procedure TUserEditForm.AfterPost(DataSet: TDataSet);
begin
  inherited;

end;

procedure TUserEditForm.BeforePost(DataSet: TDataSet);
begin
  inherited;

end;

procedure TUserEditForm.FormLoaded;
begin
  inherited;

end;

class function TUserEditForm.GetFormName: string;
begin

end;

procedure TUserEditForm.OnEdit(DataSet: TDataSet);
begin
  inherited;

end;

procedure TUserEditForm.OnInsert(DataSet: TDataSet);
begin
  inherited;

end;

class function TUserEditForm.RequiredPermission(
  cmd: TBrowseFormCommand): string;
begin

end;

end.
