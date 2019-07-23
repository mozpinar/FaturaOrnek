object ServerAccessForm: TServerAccessForm
  Left = 546
  Top = 375
  BorderStyle = bsDialog
  Caption = 'ServerAccessForm'
  ClientHeight = 258
  ClientWidth = 409
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 409
    Height = 217
    Align = alClient
    BevelInner = bvLowered
    BevelOuter = bvNone
    BorderWidth = 4
    TabOrder = 0
    ExplicitLeft = -8
    ExplicitTop = -6
    ExplicitHeight = 183
    object Label1: TLabel
      Left = 56
      Top = 35
      Width = 60
      Height = 13
      Caption = 'Server name'
    end
    object lblUsername: TLabel
      Left = 96
      Top = 99
      Width = 51
      Height = 13
      Caption = 'User name'
    end
    object lblPassword: TLabel
      Left = 101
      Top = 131
      Width = 46
      Height = 13
      Caption = 'Password'
    end
    object Label2: TLabel
      Left = 39
      Top = 171
      Width = 77
      Height = 13
      Alignment = taRightJustify
      Caption = 'Database Name'
    end
    object edUsername: TEdit
      Left = 152
      Top = 96
      Width = 209
      Height = 21
      TabOrder = 1
      Text = 'edUsername'
    end
    object edPassword: TEdit
      Left = 152
      Top = 128
      Width = 209
      Height = 21
      PasswordChar = '*'
      TabOrder = 2
      Text = 'edPassword'
    end
    object edUseWinAuth: TCheckBox
      Left = 56
      Top = 64
      Width = 193
      Height = 17
      Caption = 'Use windows authentication'
      TabOrder = 0
      OnClick = edUseWinAuthClick
    end
    object edServer: TEdit
      Left = 122
      Top = 32
      Width = 209
      Height = 21
      TabOrder = 3
      Text = 'edServer'
    end
    object edDatabaseName: TEdit
      Left = 122
      Top = 168
      Width = 209
      Height = 21
      TabOrder = 4
      Text = 'edDatabaseName'
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 217
    Width = 409
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 183
    object BitBtn1: TBitBtn
      Left = 224
      Top = 8
      Width = 75
      Height = 25
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
    end
    object BitBtn2: TBitBtn
      Left = 312
      Top = 8
      Width = 75
      Height = 25
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
    end
  end
end
