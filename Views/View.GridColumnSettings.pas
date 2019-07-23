unit View.GridColumnSettings;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, Buttons, ExtCtrls, Vcl.DBGrids, Vcl.DBCtrls,
  Vcl.Mask, Data.DB,
  Vcl.ComCtrls,
  System.Generics.Collections,
  System.IniFiles,
  Support.Types;

type
  TGridPropertySettingsForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btnOk: TBitBtn;
    btnCancel: TBitBtn;
    FDlg: TFontDialog;
    ClDlg: TColorDialog;
    Splitter2: TSplitter;
    Panel3: TPanel;
    edVisible: TCheckBox;
    edReadOnly: TCheckBox;
    edFontView: TLabel;
    lblFont: TLabel;
    Label5: TLabel;
    lblMask: TLabel;
    lblFormat: TLabel;
    lblCaption: TLabel;
    lvDBGridItems: TListView;
    lblCaptionFont: TLabel;
    edCaptionFont: TLabel;
    edCaption: TEdit;
    edFormat: TEdit;
    edMask: TEdit;
    edWidth: TEdit;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Splitter1: TSplitter;
    lblGridColor: TLabel;
    edGridColor: TColorBox;
    lblGridFixedColor: TLabel;
    edRowLines: TCheckBox;
    edColLines: TCheckBox;
    edGridFixedColor: TColorBox;
    edGridFont: TLabel;
    lblGridFont: TLabel;
    lblGridTitleFont: TLabel;
    edGridTitleFont: TLabel;
    procedure edFontPropsChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lvDBGridItemsChanging(Sender: TObject; Item: TListItem;
      Change: TItemChange; var AllowChange: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lvDBGridItemsSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure lvDBGridItemsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure btnOkClick(Sender: TObject);
    procedure lvDBGridItemsItemChecked(Sender: TObject; Item: TListItem);
    procedure edGridColorChange(Sender: TObject);
    procedure edGridFixedColorChange(Sender: TObject);
    procedure edRowLinesClick(Sender: TObject);
    procedure edColLinesClick(Sender: TObject);
    procedure edGridFontClick(Sender: TObject);
  private
    { Private declarations }
    FirstTime : Boolean;
    GridInfo : TGridInfo;
    DBGrid : TDBGrid;
    LastItemSelected : TListItem;
    IniFileName : string;
    IniSection : string;
    procedure Build;
    procedure MoveSelectionToScreen(lvi : TListItem);
    procedure SaveScreenToCurrentItem(lvi : TListItem);
    procedure SaveToGridAndIni;
  public
    { Public declarations }
    class function Run(ADBGrid : TDBGrid; const AIniName, ASection : String) : Boolean;
    class function LoadFromIniFile(ADBGrid : TDBGrid; const AIniName, ASection : String) : Boolean;
  end;

implementation

{$R *.DFM}
{function SetGridProperties(DGrid : TDBGrid; const AIniName, ASection : String) : Boolean;
var
  GridPropertySettingsForm: TGridPropertySettingsForm;
begin
  GridPropertySettingsForm := TGridPropertySettingsForm.Create(Application);
  Try
    Result := ColSelForm.Run(DGrid , AIniName, ASection);
  Finally
     ColSelForm.Free;
  end;
end;}
class function TGridPropertySettingsForm.Run(ADBGrid : TDBGrid; const AIniName, ASection : String) : Boolean;
begin
  With TGridPropertySettingsForm.Create(Application) do
  try
    DBGrid := ADBGrid;
    IniFileName := AIniName;
    IniSection := ASection;
    FirstTime := True;
    Build;
    MoveSelectionToScreen(lvDBGridItems.Items[0]);
    Result := ShowModal=mrOK;
    if Result then
    begin
      SaveToGridAndIni;
    end;
  finally
    Free;
  end;
end;


procedure TGridPropertySettingsForm.SaveScreenToCurrentItem(lvi : TListItem);
var
  gci : TGridColInfo;
begin
  if lvi=Nil then
    Exit;
  gci := lvi.Data;
  gci.Caption := edCaption.Text;
  gci.TitleFont.Name := edCaptionFont.Font.Name;
  gci.TitleFont.Charset := edCaptionFont.Font.Charset;
  gci.TitleFont.Size := edCaptionFont.Font.Size;
  gci.TitleFont.Color := edCaptionFont.Font.Color;
  gci.TitleFont.Style := edCaptionFont.Font.Style;

  gci.Format := edFormat.Text;
  gci.Mask := edMask.Text;
  if trim(edWidth.Text)<>'' then
    gci.ColWidth := StrToInt(edWidth.Text);

  gci.Font.Name := edFontView.Font.Name;
  gci.Font.Charset := edFontView.Font.Charset;
  gci.Font.Size := edFontView.Font.Size;
  gci.Font.Color := edFontView.Font.Color;
  gci.Font.Style := edFontView.Font.Style;

  gci.ReadOnly := edReadOnly.Checked;
  gci.Visible := edVisible.Checked;
end;

function SetToInt(const aSet;const Size:integer):integer;
begin
  Result := 0;
  Move(aSet, Result, Size);
end;

procedure IntToSet(const Value:integer;var aSet;const Size:integer);
begin
  Move(Value, aSet, Size);
end;

procedure TGridPropertySettingsForm.SaveToGridAndIni;
var
  I : Integer;
  gci : TGridColInfo;
  lvi : TListItem;
  ini : TIniFile;
begin
  DBGrid.Color := GridInfo.Color;
  DBGrid.FixedColor := GridInfo.FixedColor;
  DBGrid.Font.Name := GridInfo.Font.Name;
  DBGrid.Font.Charset := GridInfo.Font.Charset;
  DBGrid.Font.Size := GridInfo.Font.Size;
  DBGrid.Font.Color := GridInfo.Font.Color;
  DBGrid.Font.Style := GridInfo.Font.Style;
  DBGrid.Font.Name := GridInfo.TitleFont.Name;
  DBGrid.Font.Charset := GridInfo.TitleFont.Charset;
  DBGrid.Font.Size := GridInfo.TitleFont.Size;
  DBGrid.Font.Color := GridInfo.TitleFont.Color;
  DBGrid.Font.Style := GridInfo.TitleFont.Style;
  if GridInfo.ShowRowLines then
    DBGrid.Options := DBGrid.Options + [dgRowLines];
  if GridInfo.ShowColLines then
    DBGrid.Options := DBGrid.Options + [dgColLines];



  for I := 0 to DBGrid.Columns.Count-1 do
  begin
    gci := GridInfo.Columns[I];

    //DBGrid.Columns[I].Index := gci.Index;  // Index burada deðiþmediði için atamaya gerek yok!
    //DBGrid.Columns[I].FieldName := gci.FieldName;  // FieldName burada deðiþmediði için atamaya gerek yok!


    DBGrid.Columns[I].Font.Name := gci.Font.Name;
    DBGrid.Columns[I].Font.Charset := gci.Font.Charset;
    DBGrid.Columns[I].Font.Size := gci.Font.Size;
    DBGrid.Columns[I].Font.Color := gci.Font.Color;
    DBGrid.Columns[I].Font.Style := gci.Font.Style;
    DBGrid.Columns[I].Color := gci.Color;
    DBGrid.Columns[I].Width := gci.ColWidth;

    if DBGrid.Columns[I].Field<>Nil then
    begin
      DBGrid.Columns[I].Field.Alignment := gci.Alignment;
      if (DBGrid.Columns[I].Field is TFloatField) then
      begin
        (DBGrid.Columns[I].Field as TNumericField).DisplayFormat := gci.Format;
        (DBGrid.Columns[I].Field as TNumericField).EditMask := gci.Mask;
      end
      else
      if (DBGrid.Columns[I].Field is TDateTimeField) then
      begin
        (DBGrid.Columns[I].Field as TDateTimeField).DisplayFormat := gci.Format;
        (DBGrid.Columns[I].Field as TDateTimeField).EditMask := gci.Mask;
      end;
    end;
    DBGrid.Columns[I].ReadOnly := gci.ReadOnly;
    DBGrid.Columns[I].Visible := gci.Visible;
    DBGrid.Columns[I].Title.Caption := gci.TitleCaption;
    DBGrid.Columns[I].Title.Color := gci.TitleColor;
    DBGrid.Columns[I].Title.Alignment := gci.TitleAlignment;

    DBGrid.Columns[I].Title.Font.Name := gci.TitleFont.Name;
    DBGrid.Columns[I].Title.Font.Charset := gci.TitleFont.Charset;
    DBGrid.Columns[I].Title.Font.Size := gci.TitleFont.Size;
    DBGrid.Columns[I].Title.Font.Color := gci.TitleFont.Color;
    DBGrid.Columns[I].Title.Font.Style := gci.TitleFont.Style;
  end;

  ini := TIniFile.Create(IniFileName);
  try
    ini.WriteInteger(IniSection, 'Color', GridInfo.Color);
    ini.WriteInteger(IniSection, 'FixedColor', GridInfo.FixedColor);
    ini.WriteString(IniSection, 'Font.Name', GridInfo.Font.Name);
    ini.WriteInteger(IniSection, 'Font.Charset', GridInfo.Font.Charset);
    ini.WriteInteger(IniSection, 'Font.Size', GridInfo.Font.Size);
    ini.WriteInteger(IniSection, 'Font.Color', GridInfo.Font.Color);
    ini.WriteInteger(IniSection, 'Font.Style', SetToInt(GridInfo.Font.Style, SizeOf(GridInfo.Font.Style)));
    ini.WriteString(IniSection,  'TitleFont.Name', GridInfo.TitleFont.Name);
    ini.WriteInteger(IniSection, 'TitleFont.Charset', GridInfo.TitleFont.Charset);
    ini.WriteInteger(IniSection, 'TitleFont.Size', GridInfo.TitleFont.Size);
    ini.WriteInteger(IniSection, 'TitleFont.Color', GridInfo.TitleFont.Color);
    ini.WriteInteger(IniSection, 'TitleFont.Style', SetToInt(GridInfo.TitleFont.Style, SizeOf(GridInfo.Font.Style)));
    ini.WriteBool(IniSection, 'ShowRowLines', GridInfo.ShowRowLines);
    ini.WriteBool(IniSection, 'ShowColLines', GridInfo.ShowColLines);
    ini.WriteInteger(IniSection, 'ColumnCount', DBGrid.Columns.Count);
    for I := 0 to DBGrid.Columns.Count-1 do
    begin
      gci := GridInfo.Columns[I];

      ini.WriteInteger(IniSection,  'Items['+IntToStr(I)+'].Index', gci.Index);   //!!!!!!!!!! Önemli
      ini.WriteString(IniSection,  'Items['+IntToStr(I)+'].Font.Name', gci.Font.Name);
      ini.WriteInteger(IniSection, 'Items['+IntToStr(I)+'].Font.Charset', gci.Font.Charset);
      ini.WriteInteger(IniSection, 'Items['+IntToStr(I)+'].Font.Size', gci.Font.Size);
      ini.WriteInteger(IniSection, 'Items['+IntToStr(I)+'].Font.Color', gci.Font.Color);
      ini.WriteInteger(IniSection, 'Items['+IntToStr(I)+'].Font.Style', SetToInt(gci.Font.Style, SizeOf(gci.Font.Style)));

      ini.WriteInteger(IniSection, 'Items['+IntToStr(I)+'].Color', gci.Color);
      ini.WriteInteger(IniSection, 'Items['+IntToStr(I)+'].ColWidth', gci.ColWidth);

      if DBGrid.Columns[I].Field<>Nil then
      begin
        ini.WriteInteger(IniSection, 'Items['+IntToStr(I)+'].Alignment', Integer(gci.Alignment));
        ini.WriteString(IniSection,  'Items['+IntToStr(I)+'].Format', gci.Format);
        ini.WriteString(IniSection,  'Items['+IntToStr(I)+'].Mask', gci.Mask);
      end;

      ini.WriteBool(IniSection, 'Items['+IntToStr(I)+'].Visible', gci.Visible);
      ini.WriteString(IniSection,  'Items['+IntToStr(I)+'].TitleCaption', gci.TitleCaption);
      ini.WriteInteger(IniSection, 'Items['+IntToStr(I)+'].TitleColor', gci.TitleColor);
      ini.WriteInteger(IniSection, 'Items['+IntToStr(I)+'].TitleAlignment', Integer(gci.TitleAlignment));

      ini.WriteString(IniSection,  'Items['+IntToStr(I)+'].TitleFont.Name', gci.TitleFont.Name);
      ini.WriteInteger(IniSection, 'Items['+IntToStr(I)+'].TitleFont.Charset', gci.TitleFont.Charset);
      ini.WriteInteger(IniSection, 'Items['+IntToStr(I)+'].TitleFont.Size', gci.TitleFont.Size);
      ini.WriteInteger(IniSection, 'Items['+IntToStr(I)+'].TitleFont.Color', gci.TitleFont.Color);
      ini.WriteInteger(IniSection, 'Items['+IntToStr(I)+'].TitleFont.Style', SetToInt(gci.TitleFont.Style, SizeOf(gci.TitleFont.Style)));
    end;
  finally
    ini.Free;
  end;
end;

procedure TGridPropertySettingsForm.btnOkClick(Sender: TObject);
begin
  SaveScreenToCurrentItem(lvDBGridItems.Selected);
end;

procedure TGridPropertySettingsForm.Build;
var lvi : TListItem;
  I: Integer;
  gci : TGridColInfo;
begin
  LastItemSelected := Nil;
  GridInfo := TGridInfo.Create;

  edGridColor.Color := DBGrid.Color;
  edGridFixedColor.Color := DBGrid.FixedColor;
  edGridFont.Font.Assign(DBGrid.Font);
  edRowLines.Checked := dgRowLines in DBGrid.Options;
  edColLines.Checked := dgColLines in DBGrid.Options;
  edGridTitleFont.Font.Assign(DBGrid.TitleFont);

  GridInfo.Color := DBGrid.Color;
  GridInfo.FixedColor := DBGrid.FixedColor;
  GridInfo.Font.Name := DBGrid.Font.Name;
  GridInfo.Font.Charset := DBGrid.Font.Charset;
  GridInfo.Font.Size := DBGrid.Font.Size;
  GridInfo.Font.Color := DBGrid.Font.Color;
  GridInfo.Font.Style := DBGrid.Font.Style;
  GridInfo.TitleFont.Name := DBGrid.Font.Name;
  GridInfo.TitleFont.Charset := DBGrid.Font.Charset;
  GridInfo.TitleFont.Size := DBGrid.Font.Size;
  GridInfo.TitleFont.Color := DBGrid.Font.Color;
  GridInfo.TitleFont.Style := DBGrid.Font.Style;
  GridInfo.ShowRowLines := dgRowLines in DBGrid.Options;
  GridInfo.ShowColLines := dgColLines in DBGrid.Options;

  GridInfo.Columns := TObjectList<TGridColInfo>.Create;

  for I := 0 to DBGrid.Columns.Count-1 do
  begin
    gci := TGridColInfo.Create;
    gci.Index := DBGrid.Columns[I].Index;
    gci.FieldName := DBGrid.Columns[I].FieldName;

    gci.Caption := DBGrid.Columns[I].Title.Caption;
    if DBGrid.Columns[I].Field<>Nil then
      gci.Caption := DBGrid.Columns[I].FieldName;

    gci.Font.Name := DBGrid.Columns[I].Font.Name;
    gci.Font.Charset := DBGrid.Columns[I].Font.Charset;
    gci.Font.Size := DBGrid.Columns[I].Font.Size;
    gci.Font.Color := DBGrid.Columns[I].Font.Color;
    gci.Font.Style := DBGrid.Columns[I].Font.Style;
    gci.Color := DBGrid.Columns[I].Color;
    gci.ColWidth := DBGrid.Columns[I].Width;

    gci.Alignment := DBGrid.Columns[I].DefaultAlignment;
    if DBGrid.Columns[I].Field<>Nil then
    begin
      gci.Alignment := DBGrid.Columns[I].Field.Alignment;
      if (DBGrid.Columns[I].Field is TFloatField) then
      begin
        gci.Format := (DBGrid.Columns[I].Field as TNumericField).DisplayFormat;
        gci.Mask := (DBGrid.Columns[I].Field as TNumericField).EditMask;
      end
      else
      if (DBGrid.Columns[I].Field is TDateTimeField) then
      begin
        gci.Format := (DBGrid.Columns[I].Field as TDateTimeField).DisplayFormat;
        gci.Mask := (DBGrid.Columns[I].Field as TDateTimeField).EditMask;
      end;
    end;
    gci.ReadOnly := DBGrid.Columns[I].ReadOnly;
    gci.Visible := DBGrid.Columns[I].Visible;
    gci.TitleCaption := DBGrid.Columns[I].Title.Caption;
    gci.TitleColor := DBGrid.Columns[I].Title.Color;
    gci.TitleAlignment := DBGrid.Columns[I].Title.Alignment;

    gci.TitleFont.Name := DBGrid.Columns[I].Title.Font.Name;
    gci.TitleFont.Charset := DBGrid.Columns[I].Title.Font.Charset;
    gci.TitleFont.Size := DBGrid.Columns[I].Title.Font.Size;
    gci.TitleFont.Color := DBGrid.Columns[I].Title.Font.Color;
    gci.TitleFont.Style := DBGrid.Columns[I].Title.Font.Style;
    GridInfo.Columns.Add(gci);

    lvi := lvDBGridItems.Items.Add;
    lvi.Data := gci;
    lvi.Caption := gci.TitleCaption;
    lvi.Checked := gci.Visible;
  end;
end;

procedure TGridPropertySettingsForm.edColLinesClick(Sender: TObject);
begin
  GridInfo.ShowColLines := edColLines.Checked;
end;

procedure TGridPropertySettingsForm.edFontPropsChange(Sender: TObject);
begin
//
end;

procedure TGridPropertySettingsForm.edGridColorChange(Sender: TObject);
begin
  GridInfo.Color := edGridColor.Color;
end;

procedure TGridPropertySettingsForm.edGridFixedColorChange(Sender: TObject);
begin
  GridInfo.FixedColor := edGridFixedColor.Color;
end;

procedure TGridPropertySettingsForm.edGridFontClick(Sender: TObject);
begin
  FDlg.Font.Assign(edGridFont.Font);
  if FDlg.Execute then
  begin
    edGridFont.Font.Assign(FDlg.Font);
    GridInfo.Font.Name := FDlg.Font.Name;
    GridInfo.Font.Charset := FDlg.Font.Charset;
    GridInfo.Font.Size := FDlg.Font.Size;
    GridInfo.Font.Color := FDlg.Font.Color;
    GridInfo.Font.Style := FDlg.Font.Style;
  end;

end;

procedure TGridPropertySettingsForm.edRowLinesClick(Sender: TObject);
begin
  GridInfo.ShowRowLines := edRowLines.Checked;
end;

procedure TGridPropertySettingsForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveScreenToCurrentItem(lvDBGridItems.Selected);
end;

procedure TGridPropertySettingsForm.FormDestroy(Sender: TObject);
begin
  GridInfo.Columns.Free;
  GridInfo.Free;
end;

class function TGridPropertySettingsForm.LoadFromIniFile(ADBGrid: TDBGrid;
  const AIniName, ASection: String): Boolean;
var
  ini : TIniFile;
  I : Integer;
  style : TFontStyles;
  b : Boolean;
  ColCount : Integer;
  col : TColumn;
begin
   ini := TIniFile.Create(AIniName);
  try
    if not ini.SectionExists(ASection) then
      Exit;
    ADBGrid.Color := ini.ReadInteger(ASection, 'Color', ADBGrid.Color);
    ADBGrid.FixedColor := ini.ReadInteger(ASection, 'FixedColor', ADBGrid.FixedColor);
    ADBGrid.Font.Name := ini.ReadString(ASection, 'Font.Name', ADBGrid.Font.Name);
    ADBGrid.Font.Charset := ini.ReadInteger(ASection, 'Font.Charset', ADBGrid.Font.Charset);
    ADBGrid.Font.Size := ini.ReadInteger(ASection, 'Font.Size', ADBGrid.Font.Size);
    ADBGrid.Font.Color := ini.ReadInteger(ASection, 'Font.Color', ADBGrid.Font.Color);
    style := ADBGrid.Font.Style;
    IntToSet(ini.ReadInteger(ASection, 'Font.Style', SetToInt(style, SizeOf(ADBGrid.Font.Style))), style, SizeOf(ADBGrid.Font.Style));
    ADBGrid.Font.Style := style;
    ADBGrid.TitleFont.Name := ini.ReadString(ASection,  'TitleFont.Name', ADBGrid.TitleFont.Name);
    ADBGrid.TitleFont.Charset := ini.ReadInteger(ASection, 'TitleFont.Charset', ADBGrid.TitleFont.Charset);
    ADBGrid.TitleFont.Size := ini.ReadInteger(ASection, 'TitleFont.Size', ADBGrid.TitleFont.Size);
    ADBGrid.TitleFont.Color := ini.ReadInteger(ASection, 'TitleFont.Color', ADBGrid.TitleFont.Color);
    style := ADBGrid.TitleFont.Style;
    IntToSet(ini.ReadInteger(ASection, 'TitleFont.Style', SetToInt(style, SizeOf(ADBGrid.Font.Style))), style, SizeOf(ADBGrid.Font.Style));
    ADBGrid.TitleFont.Style := style;
    b := ini.ReadBool(ASection, 'ShowRowLines', dgRowLines in ADBGrid.Options);
    if b then
      ADBGrid.Options := ADBGrid.Options + [dgRowLines]
    else
      ADBGrid.Options := ADBGrid.Options - [dgRowLines];


    b := ini.ReadBool(ASection, 'ShowColLines', dgColLines in ADBGrid.Options);
    if b then
      ADBGrid.Options := ADBGrid.Options + [dgCOlLines]
    else
      ADBGrid.Options := ADBGrid.Options - [dgColLines];

    {ColCount := ini.WriteInteger(ASection, 'ColumnCount', 0);
    if ColCount<=0 then
      Exit;

    while ADBGrid.Columns.Count>0 do
      ADBGrid.Columns.Delete(0);
    }
    for I := 0 to ColCount do
    begin
      {col := ADBGrid.Columns.Add;
      col.ID := ini.ReadInteger(ASection,  'Items['+IntToStr(I)+'].Index', I);
      col.FieldName := ini.ReadInteger(ASection, 'Items['+IntToStr(I)+'].FieldName', '');
      col.Color := ini.ReadInteger(ASection, 'Items['+IntToStr(I)+'].Color', 0);
      col.Width := ini.ReadInteger(ASection, 'Items['+IntToStr(I)+'].ColWidth', 50);

      col.Font.Name := ini.ReadString(ASection,  'Items['+IntToStr(I)+'].Font.Name', '');
      col.Font.Charset := ini.ReadInteger(ASection, 'Items['+IntToStr(I)+'].Font.Charset', ADBGrid.Columns[I].Font.Charset);
      col.Font.Size := ini.ReadInteger(ASection, 'Items['+IntToStr(I)+'].Font.Size', ADBGrid.Columns[I].Font.Size);
      col.Font.Color := ini.ReadInteger(ASection, 'Items['+IntToStr(I)+'].Font.Color', ADBGrid.Columns[I].Font.Color);
      //style := ADBGrid.Columns[I].Font.Style;
      IntToSet(ini.ReadInteger(ASection, 'Items['+IntToStr(I)+'].Font.Style', 0), style, SizeOf(col.Font.Style));
      col.Font.Style := style;


      if ADBGrid.Columns[I].Field<>Nil then
      begin
        ADBGrid.Columns[I].Alignment := TAlignment(ini.ReadInteger(ASection, 'Items['+IntToStr(I)+'].Alignment', Integer(ADBGrid.Columns[I].Alignment)));
        if (ADBGrid.Columns[I].Field is TFloatField) then
        begin
          (ADBGrid.Columns[I].Field as TNumericField).DisplayFormat := ini.ReadString(ASection,  'Items['+IntToStr(I)+'].Format', TFloatField(ADBGrid.Columns[I].Field).DisplayFormat);
          (ADBGrid.Columns[I].Field as TNumericField).EditMask := ini.ReadString(ASection,  'Items['+IntToStr(I)+'].Mask', TFloatField(ADBGrid.Columns[I].Field).EditMask);
        end
        else
        if (ADBGrid.Columns[I].Field is TDateTimeField) then
        begin
          (ADBGrid.Columns[I].Field as TDateTimeField).DisplayFormat := ini.ReadString(ASection,  'Items['+IntToStr(I)+'].Format', TDateTimeField(ADBGrid.Columns[I].Field).DisplayFormat);
          (ADBGrid.Columns[I].Field as TDateTimeField).EditMask := ini.ReadString(ASection,  'Items['+IntToStr(I)+'].Mask', TDateTimeField(ADBGrid.Columns[I].Field).EditMask);
        end;
      end;

      ADBGrid.Columns[I].Visible := ini.ReadBool(ASection, 'Items['+IntToStr(I)+'].Visible', ADBGrid.Columns[I].Visible);
      ADBGrid.Columns[I].Title.Caption := ini.ReadString(ASection,  'Items['+IntToStr(I)+'].TitleCaption', ADBGrid.Columns[I].Title.Caption);
      ADBGrid.Columns[I].Title.Color := ini.ReadInteger(ASection, 'Items['+IntToStr(I)+'].TitleColor', ADBGrid.Columns[I].Title.Color);
      ADBGrid.Columns[I].Title.Alignment := TAlignment(ini.ReadInteger(ASection, 'Items['+IntToStr(I)+'].TitleAlignment', Integer(ADBGrid.Columns[I].Title.Alignment)));

      ADBGrid.Columns[I].Title.Font.Name := ini.ReadString(ASection,  'Items['+IntToStr(I)+'].TitleFont.Name', ADBGrid.Columns[I].Title.Font.Name);
      ADBGrid.Columns[I].Title.Font.Charset := ini.ReadInteger(ASection, 'Items['+IntToStr(I)+'].TitleFont.Charset', ADBGrid.Columns[I].Title.Font.Charset);
      ADBGrid.Columns[I].Title.Font.Size := ini.ReadInteger(ASection, 'Items['+IntToStr(I)+'].TitleFont.Size', ADBGrid.Columns[I].Title.Font.Size);
      ADBGrid.Columns[I].Title.Font.Color := ini.ReadInteger(ASection, 'Items['+IntToStr(I)+'].TitleFont.Color', ADBGrid.Columns[I].Title.Font.Color);
      style := ADBGrid.Columns[I].Title.Font.Style;
      IntToSet(ini.ReadInteger(ASection, 'Items['+IntToStr(I)+'].TitleFont.Style', SetToInt(style, SizeOf(style))), style, SizeOf(style));
      ADBGrid.Columns[I].Title.Font.Style := style;
      }


      ADBGrid.Columns[I].Index := ini.ReadInteger(ASection,  'Items['+IntToStr(I)+'].Index', ADBGrid.Columns[I].Index);

      ADBGrid.Columns[I].Color := ini.ReadInteger(ASection, 'Items['+IntToStr(I)+'].Color', ADBGrid.Columns[I].Color);
      ADBGrid.Columns[I].Width := ini.ReadInteger(ASection, 'Items['+IntToStr(I)+'].ColWidth', ADBGrid.Columns[I].Width);
      //exit;
      ADBGrid.Columns[I].Font.Name := ini.ReadString(ASection,  'Items['+IntToStr(I)+'].Font.Name', ADBGrid.Columns[I].Font.Name);
      ADBGrid.Columns[I].Font.Charset := ini.ReadInteger(ASection, 'Items['+IntToStr(I)+'].Font.Charset', ADBGrid.Columns[I].Font.Charset);
      ADBGrid.Columns[I].Font.Size := ini.ReadInteger(ASection, 'Items['+IntToStr(I)+'].Font.Size', ADBGrid.Columns[I].Font.Size);
      ADBGrid.Columns[I].Font.Color := ini.ReadInteger(ASection, 'Items['+IntToStr(I)+'].Font.Color', ADBGrid.Columns[I].Font.Color);
      style := ADBGrid.Columns[I].Font.Style;
      IntToSet(ini.ReadInteger(ASection, 'Items['+IntToStr(I)+'].Font.Style', SetToInt(style, SizeOf(ADBGrid.Columns[I].Font.Style))), style, SizeOf(ADBGrid.Columns[I].Font.Style));
      ADBGrid.Columns[I].Font.Style := style;

      if ADBGrid.Columns[I].Field<>Nil then
      begin
        ADBGrid.Columns[I].Alignment := TAlignment(ini.ReadInteger(ASection, 'Items['+IntToStr(I)+'].Alignment', Integer(ADBGrid.Columns[I].Alignment)));
        if (ADBGrid.Columns[I].Field is TFloatField) then
        begin
          (ADBGrid.Columns[I].Field as TNumericField).DisplayFormat := ini.ReadString(ASection,  'Items['+IntToStr(I)+'].Format', TFloatField(ADBGrid.Columns[I].Field).DisplayFormat);
          (ADBGrid.Columns[I].Field as TNumericField).EditMask := ini.ReadString(ASection,  'Items['+IntToStr(I)+'].Mask', TFloatField(ADBGrid.Columns[I].Field).EditMask);
        end
        else
        if (ADBGrid.Columns[I].Field is TDateTimeField) then
        begin
          (ADBGrid.Columns[I].Field as TDateTimeField).DisplayFormat := ini.ReadString(ASection,  'Items['+IntToStr(I)+'].Format', TDateTimeField(ADBGrid.Columns[I].Field).DisplayFormat);
          (ADBGrid.Columns[I].Field as TDateTimeField).EditMask := ini.ReadString(ASection,  'Items['+IntToStr(I)+'].Mask', TDateTimeField(ADBGrid.Columns[I].Field).EditMask);
        end;
      end;

      ADBGrid.Columns[I].Visible := ini.ReadBool(ASection, 'Items['+IntToStr(I)+'].Visible', ADBGrid.Columns[I].Visible);
      ADBGrid.Columns[I].Title.Caption := ini.ReadString(ASection,  'Items['+IntToStr(I)+'].TitleCaption', ADBGrid.Columns[I].Title.Caption);
      ADBGrid.Columns[I].Title.Color := ini.ReadInteger(ASection, 'Items['+IntToStr(I)+'].TitleColor', ADBGrid.Columns[I].Title.Color);
      ADBGrid.Columns[I].Title.Alignment := TAlignment(ini.ReadInteger(ASection, 'Items['+IntToStr(I)+'].TitleAlignment', Integer(ADBGrid.Columns[I].Title.Alignment)));

      ADBGrid.Columns[I].Title.Font.Name := ini.ReadString(ASection,  'Items['+IntToStr(I)+'].TitleFont.Name', ADBGrid.Columns[I].Title.Font.Name);
      ADBGrid.Columns[I].Title.Font.Charset := ini.ReadInteger(ASection, 'Items['+IntToStr(I)+'].TitleFont.Charset', ADBGrid.Columns[I].Title.Font.Charset);
      ADBGrid.Columns[I].Title.Font.Size := ini.ReadInteger(ASection, 'Items['+IntToStr(I)+'].TitleFont.Size', ADBGrid.Columns[I].Title.Font.Size);
      ADBGrid.Columns[I].Title.Font.Color := ini.ReadInteger(ASection, 'Items['+IntToStr(I)+'].TitleFont.Color', ADBGrid.Columns[I].Title.Font.Color);
      style := ADBGrid.Columns[I].Title.Font.Style;
      IntToSet(ini.ReadInteger(ASection, 'Items['+IntToStr(I)+'].TitleFont.Style', SetToInt(style, SizeOf(style))), style, SizeOf(style));
      ADBGrid.Columns[I].Title.Font.Style := style;

    end;
  finally
    ini.Free;
  end;

end;

procedure TGridPropertySettingsForm.lvDBGridItemsChange(Sender: TObject;
  Item: TListItem; Change: TItemChange);
begin
  ShowMessage('lvDBGridItemsChange');
  MoveSelectionToScreen(Item);
end;

procedure TGridPropertySettingsForm.lvDBGridItemsChanging(Sender: TObject; Item: TListItem;
  Change: TItemChange; var AllowChange: Boolean);
begin
  ShowMessage('lvDBGridItemsChanging');
  if not FirstTime then
    SaveScreenToCurrentItem(Item);
  FirstTime := False;
end;

procedure TGridPropertySettingsForm.lvDBGridItemsItemChecked(Sender: TObject;
  Item: TListItem);
begin
  if (Item<>Nil) and (Item.Data<>Nil) then
  begin
    if lvDBGridItems.Selected = Item then
    begin
      edVisible.Checked := Item.Checked;
      TGridColInfo(Item.Data).Visible := Item.Checked;
    end
    else
    begin
      TGridColInfo(Item.Data).Visible := Item.Checked;
      lvDBGridItems.Selected := Item;
    end;
  end;
end;

procedure TGridPropertySettingsForm.lvDBGridItemsSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  if LastItemSelected<>Nil then
    SaveScreenToCurrentItem(LastItemSelected);
  MoveSelectionToScreen(Item);
end;

procedure TGridPropertySettingsForm.MoveSelectionToScreen(lvi: TListItem);
var
  gci : TGridColInfo;
begin
  LastItemSelected := lvi;
  gci := lvi.Data;
  edCaption.Text := gci.Caption;
  edCaptionFont.Font.Name := gci.TitleFont.Name;
  edCaptionFont.Font.Charset := gci.TitleFont.Charset;
  edCaptionFont.Font.Size := gci.TitleFont.Size;
  edCaptionFont.Font.Color := gci.TitleFont.Color;
  edCaptionFont.Font.Style := gci.TitleFont.Style;

  edFormat.Text := gci.Format;
  edMask.Text := gci.Mask;
  edWidth.Text := IntToStr(gci.ColWidth);

  edFontView.Font.Name := gci.Font.Name;
  edFontView.Font.Charset := gci.Font.Charset;
  edFontView.Font.Size := gci.Font.Size;
  edFontView.Font.Color := gci.Font.Color;
  edFontView.Font.Style := gci.Font.Style;

  edReadOnly.Checked := gci.ReadOnly;
  edVisible.Checked := gci.Visible;
end;

end.
