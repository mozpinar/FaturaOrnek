unit View.LoginForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.jpeg;

type
  TLoginForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btnOk: TButton;
    btnCancel: TButton;
    labelUsername: TLabel;
    labelPassword: TLabel;
    edUsername: TEdit;
    edPassword: TEdit;
    Image1: TImage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
  private
    { Private declarations }
    OkToClose : Boolean;
    procedure UpdateLabelsText;
  public
    { Public declarations }
    function Login : boolean;
  end;


function ExecLogin : boolean;
implementation
uses
  Model.Declarations,
  Support.LanguageDictionary,
  MainDM,
  Support.Consts;
{$R *.dfm}

function ExecLogin : boolean;
begin
  with TLoginForm.Create(Application) do
  begin
    edPassword.Text := '';
    Result := Login;
  end;
end;
procedure TLoginForm.btnCancelClick(Sender: TObject);
begin
  OkToClose := True;
end;

procedure TLoginForm.btnOkClick(Sender: TObject);
begin
  OkToClose := False;
  if ((edUsername.Text='') or (edPassword.Text='')) then
    raise Exception.Create(Support.LanguageDictionary.MessageDictionary.GetMessage(SUsernameAndOrPasswordExpected));
  OkToClose := DMMain.LoginSystem(edUsername.Text, edPassword.Text);
  if not OkToClose then
    raise Exception.Create(Support.LanguageDictionary.MessageDictionary.GetMessage(SUsernameOrPasswordIsInvalid));
end;

procedure TLoginForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TLoginForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := OkToClose;
end;

function TLoginForm.Login: boolean;

begin
  UpdateLabelsText;
  Result := False;
  if ShowModal=mrOk then
  begin
     Result := True;
  end;
end;

procedure TLoginForm.UpdateLabelsText;
begin
  Caption := Support.LanguageDictionary.ComponentDictionary('').GetText(ClassName, 'Caption', Caption);
  labelUsername.Caption := Support.LanguageDictionary.ComponentDictionary('').GetText(ClassName, 'labelUsername.Caption', labelUsername.Caption);
  labelPassword.Caption := Support.LanguageDictionary.ComponentDictionary('').GetText(ClassName, 'labelPassword.Caption', labelPassword.Caption);
  edUsername.TextHint := Support.LanguageDictionary.ComponentDictionary('').GetText(ClassName, 'edUsername.TextHint', edUsername.TextHint);
  edPassword.TextHint := Support.LanguageDictionary.ComponentDictionary('').GetText(ClassName, 'edPassword.TextHint', edPassword.TextHint);
  btnOk.Caption := Support.LanguageDictionary.ComponentDictionary('').GetText(ClassName, 'btnOk.Caption', btnOk.Caption);
  btnCancel.Caption := Support.LanguageDictionary.ComponentDictionary('').GetText(ClassName, 'btnCancel.Caption', btnCancel.Caption);
end;

//initialization
  //MainDM.ExecLoginForm := ExecLogin;
end.
