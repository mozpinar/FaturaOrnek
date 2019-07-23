inherited UserEditForm: TUserEditForm
  Caption = 'UserEditForm'
  ClientHeight = 400
  ClientWidth = 624
  ExplicitWidth = 640
  ExplicitHeight = 439
  PixelsPerInch = 96
  TextHeight = 16
  inherited Panel21: TPanel
    Width = 624
    Height = 359
    object lblPswd: TLabel
      Left = 73
      Top = 64
      Width = 43
      Height = 16
      Alignment = taRightJustify
      Caption = 'lblPswd'
    end
    object lblUserName: TLabel
      Left = 44
      Top = 39
      Width = 72
      Height = 16
      Alignment = taRightJustify
      Caption = 'lblUserName'
    end
    object SpeedButton1: TSpeedButton
      Left = 296
      Top = 168
      Width = 23
      Height = 22
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        3333333333333333333333333333333333333333333FF3333333333333003333
        3333333333773FF3333333333309003333333333337F773FF333333333099900
        33333FFFFF7F33773FF30000000999990033777777733333773F099999999999
        99007FFFFFFF33333F7700000009999900337777777F333F7733333333099900
        33333333337F3F77333333333309003333333333337F77333333333333003333
        3333333333773333333333333333333333333333333333333333333333333333
        3333333333333333333333333333333333333333333333333333}
      NumGlyphs = 2
    end
    object SpeedButton2: TSpeedButton
      Left = 296
      Top = 208
      Width = 23
      Height = 22
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        3333333333333FF3333333333333003333333333333F77F33333333333009033
        333333333F7737F333333333009990333333333F773337FFFFFF330099999000
        00003F773333377777770099999999999990773FF33333FFFFF7330099999000
        000033773FF33777777733330099903333333333773FF7F33333333333009033
        33333333337737F3333333333333003333333333333377333333333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        3333333333333333333333333333333333333333333333333333}
      NumGlyphs = 2
    end
    object edUserName: TDBEdit
      Left = 122
      Top = 36
      Width = 415
      Height = 24
      DataField = 'UserName'
      DataSource = DataSource1
      TabOrder = 0
    end
    object edPswd: TDBEdit
      Left = 122
      Top = 61
      Width = 415
      Height = 24
      DataField = 'Pswd'
      DataSource = DataSource1
      TabOrder = 1
    end
    object edIsActive: TDBCheckBox
      Left = 104
      Top = 96
      Width = 97
      Height = 17
      Caption = 'edIsActive'
      DataField = 'IsActive'
      DataSource = DataSource1
      TabOrder = 2
    end
    object ListBox1: TListBox
      Left = 32
      Top = 136
      Width = 250
      Height = 217
      TabOrder = 3
    end
    object ListBox2: TListBox
      Left = 336
      Top = 136
      Width = 250
      Height = 217
      TabOrder = 4
    end
  end
  inherited Panel2: TPanel
    Top = 359
    Width = 624
    inherited btnOk: TButton
      Left = 411
    end
    inherited btnCancel: TButton
      Left = 524
    end
  end
end
