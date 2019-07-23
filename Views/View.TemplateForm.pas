unit View.TemplateForm;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.UITypes,
  System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Data.DB, Vcl.Grids, Vcl.DBGrids,
  View.TemplateEdit,
  Vcl.ExtCtrls,
  Support.Consts, Vcl.StdCtrls, Vcl.Menus;

type
  TTemplateForm = class(TForm)
    Panel11: TPanel;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    btnAdd: TButton;
    btnEdit: TButton;
    btnDelete: TButton;
    btnView: TButton;
    popupmnuGrid: TPopupMenu;
    menutemGridProperties1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnViewClick(Sender: TObject);
    procedure menuitemGridProperties1Click(Sender: TObject);
  private
    FOkToClose : Boolean;
  protected
    fDataset : TDataset;

    procedure FormLoaded; virtual;

    procedure UpdateLabelsText; virtual;

    procedure OpenDataset; virtual; abstract;
    procedure DeleteCurrent; virtual;

    procedure Print; virtual; abstract;

    function PrepareEditForm(cmd : TBrowseFormCommand) : TTemplateEdit; virtual;
    function GetPKName : string; virtual;

    function GetEditForm(ACmd: TBrowseFormCommand): TTemplateEdit;
    function GetEditFormName : string; virtual; abstract;
  public

    procedure Refresh; virtual;
    procedure OrderCommand(command : TBrowseFormCommand; var res : Variant); virtual;
  end;

implementation
uses MainDM, Support.LanguageDictionary, Support.FabricationEditForm,
   View.GridColumnSettings;
{$R *.dfm}

procedure TTemplateForm.DeleteCurrent;
begin
  if MessageDlg(MessageDictionary('').GetMessage('SConfirmToDelete'), mtWarning, [mbCancel, mbOk], 0)<>mrOk then
    Exit;
  fDataset.Delete;
end;

procedure TTemplateForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;

procedure TTemplateForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := FOkToClose;
end;

procedure TTemplateForm.FormCreate(Sender: TObject);
begin
  FOkToClose := True;

  TGridPropertySettingsForm.LoadFromIniFile(DBGrid1, DMMain.IniFName, ClassName+'_Grid');
  OpenDataset;
  DataSource1.DataSet := fDataset;
  UpdateLabelsText;
end;

procedure TTemplateForm.FormDestroy(Sender: TObject);
begin
  PostMessage(Application.MainForm.Handle, wm_CloseClient, Integer(self), self.Handle);
end;

procedure TTemplateForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Shift=[]) and (Key=vk_Escape) then
  begin
    Key := 0;
    Close;
  end;
end;

procedure TTemplateForm.FormLoaded;
begin
end;

procedure TTemplateForm.FormShow(Sender: TObject);
begin
  FormLoaded;
end;

function TTemplateForm.GetPKName: string;
begin
  Result := '';
end;

procedure TTemplateForm.menuitemGridProperties1Click(Sender: TObject);
begin
  //TGridPropertySettingsForm.Run(DBGrid1, DMMain.IniFName, ClassName+'_Grid');
end;

procedure TTemplateForm.btnAddClick(Sender: TObject);
var v : Variant;
begin
  OrderCommand(efcmdAdd, v);
end;

procedure TTemplateForm.btnDeleteClick(Sender: TObject);
var v : Variant;
begin
  OrderCommand(efcmdDelete, v);
end;

procedure TTemplateForm.btnEditClick(Sender: TObject);
var v : Variant;
begin
  OrderCommand(efcmdEdit, v);
end;

procedure TTemplateForm.btnViewClick(Sender: TObject);
var v : Variant;
begin
  OrderCommand(efcmdViewDetail, v);
end;

procedure TTemplateForm.DBGrid1DblClick(Sender: TObject);
var v1 : Variant;
begin
  OrderCommand(TBrowseFormCommand.efcmdEdit, v1);
end;

procedure TTemplateForm.OrderCommand(command: TBrowseFormCommand; var res : Variant);
begin
  res := Null;
  case command of
    efcmdNext: fDataset.Next;
    efcmdPrev: fDataset.Prior;
    efcmdFirst: fDataset.First;
    efcmdLast: fDataset.Last;
    efcmdAdd: res := NativeUInt(PrepareEditForm(command));
    efcmdDelete: DeleteCurrent;
    efcmdEdit: res := NativeUInt(PrepareEditForm(command));
    efcmdViewDetail : res := NativeUInt(PrepareEditForm(command));
    efcmdClose: ;
    efcmdRefresh: Refresh;
    efcmdFind : ;
    efcmdPrint : ;
    efcmdActivateFilter : ;
    efcmdBuildFilter : ;
    efcmdDeactivateFilter : ;
  end;
end;

function TTemplateForm.PrepareEditForm(cmd: TBrowseFormCommand): TTemplateEdit;
begin
  Result := GetEditForm(cmd);
end;

procedure TTemplateForm.Refresh;
var
  PKname : string;
  PK : string;
begin
  PKname := GetPKName;
  if PKname<>'' then
    pk := fDataset.FieldByName(PKname).AsString;
  fDataset.Close;
  OpenDataset;
  if PKname<>'' then
    fDataset.Locate(PKname, PK, []);
end;

procedure TTemplateForm.UpdateLabelsText;
begin
  Caption := ComponentDictionary('').GetText(ClassName, 'Caption');
  GridColumnDictionary.AssignGridColumnTitles(ClassName, DBGrid1);

  btnAdd.Caption := ComponentDictionary('').GetText('TTemplateForm', 'btnAdd.Caption');
  btnEdit.Caption := ComponentDictionary('').GetText('TTemplateForm', 'btnEdit.Caption');
  btnDelete.Caption := ComponentDictionary('').GetText('TTemplateForm', 'btnDelete.Caption');
  btnView.Caption := ComponentDictionary('').GetText('TTemplateForm', 'btnView.Caption');
end;


function TTemplateForm.GetEditForm(ACmd: TBrowseFormCommand): TTemplateEdit;
var f : TForm;
begin
  f := MyFactoryEditForm.GetForm(GetEditFormName,  ACmd, fDataset, []);
  if f is TTemplateEdit then
    Result := (f as TTemplateEdit)
  else
    Result := Nil;
end;



end.
