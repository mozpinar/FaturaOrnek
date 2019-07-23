inherited DailyCurrencyValuesForm: TDailyCurrencyValuesForm
  Caption = 'DailyCurrencyValuesForm'
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel11: TPanel
    Top = 81
    Height = 393
    ExplicitTop = 81
    ExplicitHeight = 393
    inherited DBGrid1: TDBGrid
      Height = 385
      Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      ReadOnly = False
      OnDblClick = nil
      Columns = <
        item
          Expanded = False
          FieldName = 'CurrencyCode'
          ReadOnly = True
          Width = 96
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CurrencyName'
          ReadOnly = True
          Width = 192
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'BuyingRate'
          Title.Alignment = taRightJustify
          Width = 113
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'SellingRate'
          Title.Alignment = taRightJustify
          Width = 129
          Visible = True
        end>
    end
  end
  inherited Panel1: TPanel
    Enabled = False
    Visible = False
  end
  object Panel3: TPanel [2]
    Left = 0
    Top = 0
    Width = 765
    Height = 81
    Align = alTop
    BevelInner = bvLowered
    BevelOuter = bvNone
    BorderWidth = 2
    TabOrder = 2
    object lblCurrencyDate: TLabel
      Left = 32
      Top = 30
      Width = 77
      Height = 13
      Alignment = taRightJustify
      Caption = 'lblCurrencyDate'
    end
    object edCurrencyDate: TDateTimePicker
      Left = 113
      Top = 26
      Width = 186
      Height = 21
      Date = 43657.666940486110000000
      Time = 43657.666940486110000000
      TabOrder = 0
      OnChange = edCurrencyDateChange
    end
    object btnSave: TButton
      Left = 352
      Top = 25
      Width = 75
      Height = 25
      Caption = 'btnSave'
      TabOrder = 1
      OnClick = btnSaveClick
    end
  end
  inherited DataSource1: TDataSource
    Left = 328
    Top = 40
  end
  inherited popupmnuGrid: TPopupMenu
    Left = 256
    Top = 208
  end
  object tblCurrencyRates: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 288
    Top = 145
    object tblCurrencyRatesCurrencyDailyRateId: TIntegerField
      FieldName = 'CurrencyDailyRateId'
    end
    object tblCurrencyRatesCurrencyDate: TDateField
      FieldName = 'CurrencyDate'
    end
    object tblCurrencyRatesCurrencyTypeId: TIntegerField
      FieldName = 'CurrencyTypeId'
    end
    object tblCurrencyRatesCurrencyCode: TStringField
      FieldName = 'CurrencyCode'
      Size = 10
    end
    object tblCurrencyRatesCurrencyName: TStringField
      FieldName = 'CurrencyName'
      Size = 50
    end
    object tblCurrencyRatesBuyingRate: TFloatField
      FieldName = 'BuyingRate'
      DisplayFormat = '0.00000;#.#####;#'
    end
    object tblCurrencyRatesSellingRate: TFloatField
      FieldName = 'SellingRate'
      DisplayFormat = '0.00000;#.#####;#'
    end
  end
end
