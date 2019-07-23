unit View.TemplateEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Vcl.StdCtrls, Data.DB, Vcl.DBCtrls, Vcl.DBGrids, Vcl.DBCGrids,
  Support.Consts;

type
  TTemplateEdit = class(TForm)
    Panel21: TPanel;
    DataSource1: TDataSource;
    Panel2: TPanel;
    btnOk: TButton;
    btnCancel: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FOkToClose : Boolean;

    FDataset: TDataset;
    FCmd : TBrowseFormCommand;
  protected
    class procedure CheckAuthorize(cmd : TBrowseFormCommand); virtual;
    class function RequiredPermission(cmd: TBrowseFormCommand) : string; virtual;
    procedure CloseForm; virtual;

    function AddNew : Boolean; virtual;
    function EditCurrent : Boolean; virtual;

    procedure ViewCurrent; virtual;

    procedure OnInsert(DataSet: TDataSet); virtual; abstract;
    procedure OnEdit(DataSet: TDataSet); virtual; abstract;
    procedure BeforePost(DataSet: TDataSet); virtual;
    procedure AfterPost(DataSet: TDataSet); virtual;
    procedure FormLoaded; virtual;
    procedure UpdateLabelsText; virtual;

    class function GetFormName : string; virtual;

    property Cmd: TBrowseFormCommand read FCmd;
  public
    constructor Create(const aCmd : TBrowseFormCommand;
                              aDataset : TDataset);
    //class function ExecEdit(const aCmd : TBrowseFormCommand;
    //                          aDataset : TDataset) : boolean; virtual; abstract;
    property Dataset: TDataset read FDataset write FDataset;
  end;

implementation
uses MainDM, Support.LanguageDictionary;
{$R *.dfm}

function TTemplateEdit.AddNew: Boolean;
begin
  Result := False;
  DataSource1.DataSet.Append;
  FormLoaded;  //!!!!!!!!!!!!!!
  UpdateLabelsText;

  try
    if ShowModal=mrOk then
    begin
      DataSource1.DataSet.Post;
      Result := True;
    end
    else
      DataSource1.DataSet.Cancel;
  except
    on e:Exception do
    begin
      DataSource1.DataSet.Cancel;
      raise Exception.Create(e.Message);
    end;

  end;

end;

procedure TTemplateEdit.AfterPost(DataSet: TDataSet);
begin
end;

procedure TTemplateEdit.BeforePost(DataSet: TDataSet);
begin
end;

procedure TTemplateEdit.btnCancelClick(Sender: TObject);
begin
  DataSource1.DataSet.Cancel;
  FOkToClose := True;
  Close;
end;

procedure TTemplateEdit.btnOkClick(Sender: TObject);
begin
  FOkToClose := False;
  DataSource1.DataSet.Post;
  FOkToClose := True;
  Close;
end;

class procedure TTemplateEdit.CheckAuthorize(cmd: TBrowseFormCommand);
begin
  if not DMMain.IsUserAuthorized(RequiredPermission(cmd)) then
    raise Exception.Create(Support.LanguageDictionary.MessageDictionary().GetMessage('SNotAuthorized')+#13#10+ClassName);
end;

class function TTemplateEdit.RequiredPermission(cmd: TBrowseFormCommand): string;
begin
  result := '';
end;

procedure TTemplateEdit.UpdateLabelsText;
begin
  btnCancel.Caption := ComponentDictionary('').GetText('TTemplateEdit', 'btnCancel.Caption');
  btnOk.Caption := ComponentDictionary('').GetText('TTemplateEdit', 'btnOk.Caption');
end;

procedure TTemplateEdit.CloseForm;
begin
  if DataSource1.DataSet.State in [dsInsert, dsEdit] then
    DataSource1.DataSet.Cancel;
end;

constructor TTemplateEdit.Create(const aCmd: TBrowseFormCommand;
  aDataset: TDataset);
var
  I: Integer;
begin
  inherited Create(Application);
  FCmd := aCmd;
  CheckAuthorize(aCmd);

  FDataset := aDataset;
  DataSource1.DataSet := FDataset;
  FDataset.BeforePost := BeforePost;
  FDataset.AfterPost := AfterPost;
  FDataset.OnNewRecord := OnInsert;
  FDataset.AfterEdit := OnEdit;

  try
    case aCmd of
      efcmdAdd : FDataset.Append;
      efcmdEdit : if FDataset.RecordCount>0 then
                  begin
                    FDataset.Edit;
                  end
                  else
                    raise Exception.Create(SNoRecordFound);
      efcmdViewDetail : if FDataset.RecordCount<=0 then
                          raise Exception.Create(SNoRecordFound)
                        else
                        begin
                          btnOk.Visible := False;
                          for I := 0 to Panel21.ControlCount-1 do
                            if (Panel21.Controls[I]<>btnOk) and (Panel21.Controls[I]<>btnCancel) and (Panel21.Controls[I]<>Panel2) then
                              if Panel21.Controls[I] is TDBGrid then
                                (Panel21.Controls[I] as TDBGrid).ReadOnly := True
                              else
                              if Panel21.Controls[I] is TDBNavigator then
                                (Panel21.Controls[I] as TDBNavigator).Enabled := False
                              else
                              if Panel21.Controls[I] is TDBEdit then
                                (Panel21.Controls[I] as TDBEdit).ReadOnly := True
                              else
                              if Panel21.Controls[I] is TDBMemo then
                                (Panel21.Controls[I] as TDBMemo).ReadOnly := True
                              else
                              if Panel21.Controls[I] is TDBImage then
                                (Panel21.Controls[I] as TDBImage).ReadOnly := True
                              else
                              if Panel21.Controls[I] is TDBListBox then
                                (Panel21.Controls[I] as TDBListBox).ReadOnly := True
                              else
                              if Panel21.Controls[I] is TDBComboBox then
                                (Panel21.Controls[I] as TDBComboBox).ReadOnly := True
                              else
                              if Panel21.Controls[I] is TDBCheckBox then
                                (Panel21.Controls[I] as TDBCheckBox).ReadOnly := True
                              else
                              if Panel21.Controls[I] is TDBRadioGroup then
                                (Panel21.Controls[I] as TDBRadioGroup).ReadOnly := True
                              else
                              if Panel21.Controls[I] is TDBLookupListBox then
                                (Panel21.Controls[I] as TDBLookupListBox).ReadOnly := True
                              else
                              if Panel21.Controls[I] is TDBLookupComboBox then
                                (Panel21.Controls[I] as TDBLookupComboBox).ReadOnly := True
                              else
                              if Panel21.Controls[I] is TDBRichEdit then
                                (Panel21.Controls[I] as TDBRichEdit).ReadOnly := True
                              else
                              if Panel21.Controls[I] is TDBCtrlGrid then
                                (Panel21.Controls[I] as TDBCtrlGrid).Enabled := False
                              else
                                Panel21.Controls[I].Enabled := False;

                          btnCancel.Caption := ComponentDictionary('').GetText('TTemplateEdit', 'btnClose.Caption');
                          //Panel21.Enabled := False;
                        end;
    end;
    SendMessage(Application.MainForm.Handle, wm_ShowClientWindow, NativeUInt(self), self.Handle);
    FormLoaded;
    UpdateLabelsText;
    ShowModal;
  finally
    FDataset.BeforePost := Nil;
    FDataset.AfterPost := Nil;
    FDataset.OnNewRecord := Nil;
    FDataset.AfterEdit := Nil;

  end;
end;

function TTemplateEdit.EditCurrent: Boolean;
begin
  Result := False;
  if DataSource1.DataSet.RecordCount<=0 then
    Exit;
  DataSource1.DataSet.Edit;
  FormLoaded;  //!!!!!!!!!!!!!!!
  UpdateLabelsText;
  try
    if ShowModal=mrOk then
    begin
      DataSource1.DataSet.Post;
      Result := True;
    end
    else
      DataSource1.DataSet.Cancel;
  except
    on e:Exception do
    begin
      DataSource1.DataSet.Cancel;
      raise Exception.Create(e.Message);
    end;
  end;
end;


procedure TTemplateEdit.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CloseForm;
  Action := caFree;
end;

procedure TTemplateEdit.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := FOkToClose;
end;

procedure TTemplateEdit.FormCreate(Sender: TObject);
begin
  FOkToClose := True;
end;

procedure TTemplateEdit.FormDestroy(Sender: TObject);
begin
  SendMessage(Application.MainForm.Handle, wm_CloseClient, Integer(self), self.Handle);
end;

procedure TTemplateEdit.FormLoaded;
begin
end;

class function TTemplateEdit.GetFormName: string;
begin
  Result := '';
end;

procedure TTemplateEdit.ViewCurrent;
begin
  FormLoaded;  //!!!!!!!!!!!!!
  UpdateLabelsText;
  ShowModal;
end;

end.
