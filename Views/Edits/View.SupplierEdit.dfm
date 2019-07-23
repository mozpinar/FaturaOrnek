inherited SupplierEditForm: TSupplierEditForm
  Caption = 'SupplierEditForm'
  ClientHeight = 437
  ClientWidth = 564
  ExplicitWidth = 580
  ExplicitHeight = 476
  PixelsPerInch = 96
  TextHeight = 16
  inherited Panel21: TPanel
    Width = 564
    Height = 396
    ExplicitLeft = 16
    ExplicitWidth = 564
    ExplicitHeight = 396
    object lblCurrencyTypeId: TLabel
      Left = 14
      Top = 292
      Width = 103
      Height = 16
      Alignment = taRightJustify
      Caption = 'lblCurrencyTypeId'
    end
    object lblContactEMail: TLabel
      Left = 31
      Top = 266
      Width = 86
      Height = 16
      Alignment = taRightJustify
      Caption = 'lblContactEMail'
    end
    object lblFax: TLabel
      Left = 84
      Top = 241
      Width = 33
      Height = 16
      Alignment = taRightJustify
      Caption = 'lblFax'
    end
    object lblPhone: TLabel
      Left = 69
      Top = 216
      Width = 48
      Height = 16
      Alignment = taRightJustify
      Caption = 'lblPhone'
    end
    object lblContactPerson: TLabel
      Left = 22
      Top = 191
      Width = 95
      Height = 16
      Alignment = taRightJustify
      Caption = 'lblContactPerson'
    end
    object lblCountry: TLabel
      Left = 60
      Top = 141
      Width = 57
      Height = 16
      Alignment = taRightJustify
      Caption = 'lblCountry'
    end
    object lblCity: TLabel
      Left = 83
      Top = 116
      Width = 34
      Height = 16
      Alignment = taRightJustify
      Caption = 'lblCity'
    end
    object lblAddressLine3: TLabel
      Left = 28
      Top = 91
      Width = 89
      Height = 16
      Alignment = taRightJustify
      Caption = 'lblAddressLine3'
    end
    object lblAddressLine2: TLabel
      Left = 28
      Top = 66
      Width = 89
      Height = 16
      Alignment = taRightJustify
      Caption = 'lblAddressLine2'
    end
    object lblAddressLine1: TLabel
      Left = 28
      Top = 41
      Width = 89
      Height = 16
      Alignment = taRightJustify
      Caption = 'lblAddressLine1'
    end
    object lblSupplierName: TLabel
      Left = 24
      Top = 16
      Width = 93
      Height = 16
      Alignment = taRightJustify
      Caption = 'lblSupplierName'
    end
    object lblPostCode: TLabel
      Left = 51
      Top = 166
      Width = 66
      Height = 16
      Alignment = taRightJustify
      Caption = 'lblPostCode'
    end
    object lblPaymentDueDate: TLabel
      Left = 7
      Top = 316
      Width = 110
      Height = 16
      Alignment = taRightJustify
      Caption = 'lblPaymentDueDate'
    end
    object edSupplierName: TDBEdit
      Left = 123
      Top = 13
      Width = 310
      Height = 24
      DataField = 'SupplierName'
      DataSource = DataSource1
      TabOrder = 0
    end
    object edIsActive: TDBCheckBox
      Left = 123
      Top = 365
      Width = 182
      Height = 17
      Caption = 'edIsActive'
      DataField = 'IsActive'
      DataSource = DataSource1
      TabOrder = 14
    end
    object edInBlackList: TDBCheckBox
      Left = 123
      Top = 342
      Width = 166
      Height = 17
      Caption = 'edInBlackList'
      DataField = 'InBlackList'
      DataSource = DataSource1
      TabOrder = 13
    end
    object edCurrencyTypeId: TDBLookupComboBox
      Left = 123
      Top = 288
      Width = 326
      Height = 24
      DataField = 'CurrencyTypeId'
      DataSource = DataSource1
      KeyField = 'CurrencyTypeId'
      ListField = 'CurrencyCode;CurrencyName'
      ListSource = dsCurrencyType
      TabOrder = 11
    end
    object edContactEMail: TDBEdit
      Left = 123
      Top = 263
      Width = 326
      Height = 24
      DataField = 'ContactEMail'
      DataSource = DataSource1
      TabOrder = 10
    end
    object edFax: TDBEdit
      Left = 123
      Top = 238
      Width = 145
      Height = 24
      DataField = 'Fax'
      DataSource = DataSource1
      TabOrder = 9
    end
    object edPhone: TDBEdit
      Left = 123
      Top = 213
      Width = 145
      Height = 24
      DataField = 'Phone'
      DataSource = DataSource1
      TabOrder = 8
    end
    object edContactPerson: TDBEdit
      Left = 123
      Top = 188
      Width = 310
      Height = 24
      DataField = 'ContactPerson'
      DataSource = DataSource1
      TabOrder = 7
    end
    object edCountry: TDBEdit
      Left = 123
      Top = 138
      Width = 238
      Height = 24
      DataField = 'Country'
      DataSource = DataSource1
      TabOrder = 5
    end
    object edCity: TDBEdit
      Left = 123
      Top = 113
      Width = 238
      Height = 24
      DataField = 'City'
      DataSource = DataSource1
      TabOrder = 4
    end
    object edAddressLine3: TDBEdit
      Left = 123
      Top = 88
      Width = 310
      Height = 24
      DataField = 'AddressLine3'
      DataSource = DataSource1
      TabOrder = 3
    end
    object edAddressLine2: TDBEdit
      Left = 123
      Top = 63
      Width = 310
      Height = 24
      DataField = 'AddressLine2'
      DataSource = DataSource1
      TabOrder = 2
    end
    object edAddressLine1: TDBEdit
      Left = 123
      Top = 38
      Width = 310
      Height = 24
      DataField = 'AddressLine1'
      DataSource = DataSource1
      TabOrder = 1
    end
    object edPostCode: TDBEdit
      Left = 123
      Top = 163
      Width = 238
      Height = 24
      DataField = 'PostCode'
      DataSource = DataSource1
      TabOrder = 6
    end
    object edPaymentDueDate: TDBEdit
      Left = 123
      Top = 313
      Width = 145
      Height = 24
      DataField = 'PaymentDueDate'
      DataSource = DataSource1
      TabOrder = 12
    end
  end
  inherited Panel2: TPanel
    Top = 396
    Width = 564
    ExplicitTop = 424
    ExplicitWidth = 712
    inherited btnOk: TButton
      Left = 340
      Top = 6
      ExplicitLeft = 340
      ExplicitTop = 6
    end
    inherited btnCancel: TButton
      Left = 437
      Top = 6
      ExplicitLeft = 437
      ExplicitTop = 6
    end
  end
  object dsCurrencyType: TDataSource
    Left = 472
    Top = 200
  end
end
