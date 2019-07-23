unit View.ServerAccess;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, IniFiles;

type
  TServerAccessForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    lblUsername: TLabel;
    lblPassword: TLabel;
    edUsername: TEdit;
    edPassword: TEdit;
    edUseWinAuth: TCheckBox;
    edServer: TEdit;
    edDatabaseName: TEdit;
    Label2: TLabel;
    procedure edUseWinAuthClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function Run(var aServerName, aUsername, aPassword : String;var aUseWinAuth : Boolean; var ADatabaseName : string) : Boolean;
  end;
function ServerLoginParams(var aServerName, aUsername, aPassword : String;var aUseWinAuth : Boolean; var ADatabaseName : string) : Boolean;
//var
//  frmLogin: TfrmLogin;

implementation

{$R *.dfm}
uses MainDM;
function ServerLoginParams(var aServerName, aUsername, aPassword : String;var aUseWinAuth : Boolean; var ADatabaseName : string) : Boolean;
begin
  With TServerAccessForm.Create(Application) do
    try
      Result := Run(aServerName, aUsername, aPassword, aUseWinAuth, ADatabaseName);
    finally
      Free
    end;
end;
{ TfrmLogin }

function TServerAccessForm.Run(var aServerName, aUsername,
  aPassword: String;var aUseWinAuth : Boolean; var ADatabaseName : string): Boolean;
var ini : TIniFile;
begin
    edServer.Text := aServerName;
    edUsername.Text := aUsername;
    edPassword.Text := aPassword;
    edUseWinAuth.Checked := aUseWinAuth;
    edDatabaseName.Text := ADatabaseName;
    edUseWinAuthClick(Nil);
    Result := ShowModal = mrOK;
    if Result then
    begin
      aServerName := edServer.Text;
      aUsername := edUsername.Text;
      aPassword := edPassword.Text;
      aUseWinAuth := edUseWinAuth.Checked;
      ADatabaseName := edDatabaseName.Text;
    end;
end;

procedure TServerAccessForm.edUseWinAuthClick(Sender: TObject);
begin
  edUsername.Enabled := not edUseWinAuth.Checked;
  edPassword.Enabled := not edUseWinAuth.Checked;
  lblUsername.Enabled := not edUseWinAuth.Checked;
  lblPassword.Enabled := not edUseWinAuth.Checked;
end;

end.
