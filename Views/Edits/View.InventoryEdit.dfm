inherited InventoryEditForm: TInventoryEditForm
  Caption = 'InventoryEditForm'
  ClientHeight = 496
  ClientWidth = 599
  ExplicitWidth = 615
  ExplicitHeight = 535
  PixelsPerInch = 96
  TextHeight = 16
  inherited Panel21: TPanel
    Width = 599
    Height = 455
    ExplicitLeft = 40
    ExplicitTop = 3
    ExplicitWidth = 843
    ExplicitHeight = 455
    object lblInventoryName: TLabel
      Left = 74
      Top = 48
      Width = 99
      Height = 16
      Alignment = taRightJustify
      Caption = 'lblInventoryName'
      FocusControl = edInventoryName
    end
    object lblInventoryGroupId: TLabel
      Left = 62
      Top = 73
      Width = 111
      Height = 16
      Alignment = taRightJustify
      Caption = 'lblInventoryGroupId'
      FocusControl = edInventoryGroupId
    end
    object lblStoragePlace: TLabel
      Left = 85
      Top = 98
      Width = 88
      Height = 16
      Alignment = taRightJustify
      Caption = 'lblStoragePlace'
      FocusControl = edStoragePlace
    end
    object lblMeasurements: TLabel
      Left = 76
      Top = 148
      Width = 97
      Height = 16
      Alignment = taRightJustify
      Caption = 'lblMeasurements'
      FocusControl = edMeasurements
    end
    object lblBuyingPrice: TLabel
      Left = 95
      Top = 198
      Width = 78
      Height = 16
      Alignment = taRightJustify
      Caption = 'lblBuyingPrice'
      FocusControl = edBuyingPrice
    end
    object lblSellingPrice: TLabel
      Left = 94
      Top = 223
      Width = 79
      Height = 16
      Alignment = taRightJustify
      Caption = 'lblSellingPrice'
      FocusControl = edSellingPrice
    end
    object lblVatPercentage: TLabel
      Left = 77
      Top = 248
      Width = 96
      Height = 16
      Alignment = taRightJustify
      Caption = 'lblVatPercentage'
      FocusControl = edVatPercentage
    end
    object lblOtvAmount: TLabel
      Left = 97
      Top = 273
      Width = 76
      Height = 16
      Alignment = taRightJustify
      Caption = 'lblOtvAmount'
      FocusControl = edOtvAmount
    end
    object lblUnitDesc: TLabel
      Left = 111
      Top = 298
      Width = 62
      Height = 16
      Alignment = taRightJustify
      Caption = 'lblUnitDesc'
      FocusControl = edUnitDesc
    end
    object lblReorderPoint: TLabel
      Left = 86
      Top = 323
      Width = 87
      Height = 16
      Alignment = taRightJustify
      Caption = 'lblReorderPoint'
      FocusControl = edReorderPoint
    end
    object lblCurrencyTypeId: TLabel
      Left = 70
      Top = 174
      Width = 103
      Height = 16
      Alignment = taRightJustify
      Caption = 'lblCurrencyTypeId'
      FocusControl = edCurrencyTypeId
    end
    object lblBufferStock: TLabel
      Left = 95
      Top = 348
      Width = 78
      Height = 16
      Alignment = taRightJustify
      Caption = 'lblBufferStock'
      FocusControl = edBufferStock
    end
    object lblSpecCode: TLabel
      Left = 103
      Top = 123
      Width = 70
      Height = 16
      Alignment = taRightJustify
      Caption = 'lblSpecCode'
      FocusControl = edSpecCode
    end
    object lblInventoryCode: TLabel
      Left = 78
      Top = 23
      Width = 95
      Height = 16
      Alignment = taRightJustify
      Caption = 'lblInventoryCode'
      FocusControl = edInventoryCode
    end
    object edInventoryName: TDBEdit
      Left = 179
      Top = 45
      Width = 390
      Height = 24
      DataField = 'InventoryName'
      DataSource = DataSource1
      TabOrder = 1
    end
    object edStoragePlace: TDBEdit
      Left = 179
      Top = 95
      Width = 310
      Height = 24
      DataField = 'StoragePlace'
      DataSource = DataSource1
      TabOrder = 3
    end
    object edSpecCode: TDBEdit
      Left = 179
      Top = 120
      Width = 126
      Height = 24
      DataField = 'SpecCode'
      DataSource = DataSource1
      TabOrder = 4
    end
    object edMeasurements: TDBEdit
      Left = 179
      Top = 145
      Width = 310
      Height = 24
      DataField = 'Measurements'
      DataSource = DataSource1
      TabOrder = 5
    end
    object edBuyingPrice: TDBEdit
      Left = 179
      Top = 195
      Width = 126
      Height = 24
      HelpType = htKeyword
      DataField = 'BuyingPrice'
      DataSource = DataSource1
      TabOrder = 7
    end
    object edSellingPrice: TDBEdit
      Left = 179
      Top = 220
      Width = 126
      Height = 24
      DataField = 'SellingPrice'
      DataSource = DataSource1
      TabOrder = 8
    end
    object edVatPercentage: TDBEdit
      Left = 179
      Top = 245
      Width = 110
      Height = 24
      DataField = 'VatPercentage'
      DataSource = DataSource1
      TabOrder = 9
    end
    object edOtvAmount: TDBEdit
      Left = 179
      Top = 270
      Width = 110
      Height = 24
      DataField = 'OtvAmount'
      DataSource = DataSource1
      TabOrder = 10
    end
    object edUnitDesc: TDBEdit
      Left = 179
      Top = 295
      Width = 145
      Height = 24
      DataField = 'UnitDesc'
      DataSource = DataSource1
      TabOrder = 11
    end
    object edReorderPoint: TDBEdit
      Left = 179
      Top = 320
      Width = 110
      Height = 24
      DataField = 'ReorderPoint'
      DataSource = DataSource1
      TabOrder = 12
    end
    object edCurrencyTypeId: TDBLookupComboBox
      Left = 179
      Top = 170
      Width = 254
      Height = 24
      DataField = 'CurrencyTypeId'
      DataSource = DataSource1
      KeyField = 'CurrencyTypeId'
      ListField = 'CurrencyCode;CurrencyName'
      ListSource = dsCurrencyType
      TabOrder = 6
    end
    object edIsActive: TDBCheckBox
      Left = 179
      Top = 383
      Width = 182
      Height = 17
      Caption = 'edIsActive'
      DataField = 'IsActive'
      DataSource = DataSource1
      TabOrder = 14
    end
    object edInventoryGroupId: TDBLookupComboBox
      Left = 179
      Top = 70
      Width = 254
      Height = 24
      DataField = 'InventoryGroupId'
      DataSource = DataSource1
      KeyField = 'InventoryGroupId'
      ListField = 'InventoryGroupName'
      ListSource = dsInventoryGroup
      TabOrder = 2
    end
    object edBufferStock: TDBEdit
      Left = 179
      Top = 345
      Width = 110
      Height = 24
      DataField = 'BufferStock'
      DataSource = DataSource1
      TabOrder = 13
    end
    object edInventoryCode: TDBEdit
      Left = 179
      Top = 20
      Width = 190
      Height = 24
      DataField = 'InventoryCode'
      DataSource = DataSource1
      TabOrder = 0
    end
  end
  inherited Panel2: TPanel
    Top = 455
    Width = 599
    ExplicitTop = 455
    ExplicitWidth = 843
    inherited btnOk: TButton
      Left = 422
      Top = 6
      ExplicitLeft = 412
      ExplicitTop = 6
    end
    inherited btnCancel: TButton
      Left = 503
      Top = 6
      ExplicitLeft = 493
      ExplicitTop = 6
    end
  end
  inherited DataSource1: TDataSource
    Left = 528
    Top = 40
  end
  object dsCurrencyType: TDataSource
    Left = 536
    Top = 112
  end
  object dsInventoryGroup: TDataSource
    Left = 544
    Top = 208
  end
end
