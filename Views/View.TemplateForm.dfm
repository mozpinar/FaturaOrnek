object TemplateForm: TTemplateForm
  Left = 0
  Top = 0
  Caption = 'TemplateForm'
  ClientHeight = 515
  ClientWidth = 765
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel11: TPanel
    Left = 0
    Top = 0
    Width = 765
    Height = 474
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 4
    Caption = 'Panel11'
    TabOrder = 0
    object DBGrid1: TDBGrid
      Left = 4
      Top = 4
      Width = 757
      Height = 466
      Align = alClient
      DataSource = DataSource1
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      ReadOnly = True
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnDblClick = DBGrid1DblClick
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 474
    Width = 765
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btnAdd: TButton
      Left = 4
      Top = 6
      Width = 75
      Height = 25
      Caption = 'btnAdd'
      TabOrder = 0
      OnClick = btnAddClick
    end
    object btnEdit: TButton
      Left = 85
      Top = 6
      Width = 75
      Height = 25
      Caption = 'btnEdit'
      TabOrder = 1
      OnClick = btnEditClick
    end
    object btnDelete: TButton
      Left = 166
      Top = 6
      Width = 75
      Height = 25
      Caption = 'btnDelete'
      TabOrder = 2
      OnClick = btnDeleteClick
    end
    object btnView: TButton
      Left = 247
      Top = 6
      Width = 75
      Height = 25
      Caption = 'btnView'
      TabOrder = 3
      OnClick = btnViewClick
    end
  end
  object DataSource1: TDataSource
    Left = 200
    Top = 72
  end
  object popupmnuGrid: TPopupMenu
    Left = 168
    Top = 168
    object menutemGridProperties1: TMenuItem
      Caption = 'menuitemGridProperties'
      OnClick = menuitemGridProperties1Click
    end
  end
end
