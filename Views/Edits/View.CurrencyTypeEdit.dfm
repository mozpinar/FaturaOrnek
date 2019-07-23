inherited CurrencyTypeEditForm: TCurrencyTypeEditForm
  Caption = 'CurrencyTypeEditForm'
  ClientHeight = 150
  ClientWidth = 520
  ExplicitWidth = 536
  ExplicitHeight = 189
  PixelsPerInch = 96
  TextHeight = 16
  inherited Panel21: TPanel
    Width = 520
    Height = 109
    ExplicitTop = 3
    ExplicitWidth = 868
    ExplicitHeight = 422
    object lblCurrencyCode: TLabel
      Left = 53
      Top = 19
      Width = 93
      Height = 16
      Alignment = taRightJustify
      Caption = 'lblCurrencyCode'
    end
    object lblCurrencyName: TLabel
      Left = 49
      Top = 51
      Width = 97
      Height = 16
      Alignment = taRightJustify
      Caption = 'lblCurrencyName'
    end
    object edCurrencyCode: TDBEdit
      Left = 152
      Top = 16
      Width = 89
      Height = 24
      DataField = 'CurrencyCode'
      DataSource = DataSource1
      TabOrder = 0
    end
    object edCurrencyName: TDBEdit
      Left = 152
      Top = 48
      Width = 321
      Height = 24
      DataField = 'CurrencyName'
      DataSource = DataSource1
      TabOrder = 1
    end
  end
  inherited Panel2: TPanel
    Top = 109
    Width = 520
    inherited btnOk: TButton
      Left = 307
    end
    inherited btnCancel: TButton
      Left = 398
      ExplicitLeft = 398
    end
  end
  inherited DataSource1: TDataSource
    Left = 296
    Top = 0
  end
end
