inherited SalesInvoiceEditForm: TSalesInvoiceEditForm
  Caption = 'SalesInvoiceEditForm'
  ClientHeight = 703
  ClientWidth = 1151
  ExplicitWidth = 1167
  ExplicitHeight = 742
  PixelsPerInch = 96
  TextHeight = 16
  inherited Panel21: TPanel
    Width = 1151
    Height = 662
    ExplicitWidth = 1151
    ExplicitHeight = 662
    object Panel1: TPanel
      Left = 4
      Top = 4
      Width = 1143
      Height = 149
      Align = alTop
      BevelInner = bvLowered
      BevelOuter = bvNone
      BorderWidth = 2
      TabOrder = 0
      object lblCustomerId: TLabel
        Left = 37
        Top = 16
        Width = 79
        Height = 16
        Alignment = taRightJustify
        Caption = 'lblCustomerId'
      end
      object lblInvoiceDate: TLabel
        Left = 37
        Top = 39
        Width = 79
        Height = 16
        Alignment = taRightJustify
        Caption = 'lblInvoiceDate'
      end
      object lblSpecCode: TLabel
        Left = 46
        Top = 89
        Width = 70
        Height = 16
        Alignment = taRightJustify
        Caption = 'lblSpecCode'
      end
      object lblInvDescription: TLabel
        Left = 23
        Top = 114
        Width = 93
        Height = 16
        Alignment = taRightJustify
        Caption = 'lblInvDescription'
      end
      object lblCurrencyTypeId: TLabel
        Left = 438
        Top = 16
        Width = 103
        Height = 16
        Alignment = taRightJustify
        Caption = 'lblCurrencyTypeId'
      end
      object lblCurrencyRate: TLabel
        Left = 451
        Top = 39
        Width = 90
        Height = 16
        Alignment = taRightJustify
        Caption = 'lblCurrencyRate'
      end
      object lblDueDate: TLabel
        Left = 480
        Top = 64
        Width = 61
        Height = 16
        Alignment = taRightJustify
        Caption = 'lblDueDate'
      end
      object btnFindCustomer: TSpeedButton
        Left = 379
        Top = 11
        Width = 25
        Height = 24
        Glyph.Data = {
          CA010000424DCA01000000000000760000002800000022000000110000000100
          0400000000005401000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0033333333FFFF
          FFFFF3333333333333333300000033333333BFBFBFBFB3333333333333333300
          000033333333FFFFFFFFF33333333F3333333300000033333330BFBFBFBFB333
          33338FF3333333000000333333010FFFFFFFF333333888FF3333330000003333
          330180BFBFBFB3333338888FF3333300000033333301180FFFFFF33333388888
          3F3333000000333330811190BFBFB3333388888383F333000000333330771999
          0FFFF33333833833383F330000003333077FF9999033333338333333FF833300
          0000333077FFFF0003333333833333F888333300000033077FFF003333333338
          333338833333330000003077FFF033333333338333338333333333000000077F
          FF093333333338F33338333333333300000007FFF09333333333383F33833333
          33333300000030FF0333333333333383F8333333333333000000330033333333
          3333333883333333333333000000}
        NumGlyphs = 2
      end
      object lblInvoiceNumber: TLabel
        Left = 18
        Top = 64
        Width = 98
        Height = 16
        Alignment = taRightJustify
        Caption = 'lblInvoiceNumber'
      end
      object edPaid: TDBCheckBox
        Left = 888
        Top = 17
        Width = 137
        Height = 17
        Caption = 'edPaid'
        DataField = 'Paid'
        DataSource = DataSource1
        TabOrder = 8
      end
      object edCustomerId: TDBLookupComboBox
        Left = 122
        Top = 11
        Width = 255
        Height = 24
        DataField = 'CustomerId'
        DataSource = DataSource1
        KeyField = 'CustomerId'
        ListField = 'CustomerName'
        ListFieldIndex = 1
        ListSource = dsCustomer
        TabOrder = 0
      end
      object edInvoiceDate: TDBEdit
        Left = 122
        Top = 36
        Width = 135
        Height = 24
        DataField = 'InvoiceDate'
        DataSource = DataSource1
        TabOrder = 1
      end
      object edSpecCode: TDBEdit
        Left = 122
        Top = 86
        Width = 135
        Height = 24
        DataField = 'SpecCode'
        DataSource = DataSource1
        TabOrder = 3
      end
      object edInvDescription: TDBEdit
        Left = 122
        Top = 111
        Width = 727
        Height = 24
        DataField = 'InvDescription'
        DataSource = DataSource1
        TabOrder = 4
      end
      object edCurrencyTypeId: TDBLookupComboBox
        Left = 547
        Top = 11
        Width = 302
        Height = 24
        DataField = 'CurrencyTypeId'
        DataSource = DataSource1
        KeyField = 'CurrencyTypeId'
        ListField = 'CurrencyCode;CurrencyName'
        ListSource = dsCurrencyType
        TabOrder = 5
      end
      object edCurrencyRate: TDBEdit
        Left = 547
        Top = 36
        Width = 135
        Height = 24
        DataField = 'CurrencyRate'
        DataSource = DataSource1
        TabOrder = 6
      end
      object edDueDate: TDBEdit
        Left = 547
        Top = 61
        Width = 135
        Height = 24
        DataField = 'DueDate'
        DataSource = DataSource1
        TabOrder = 7
      end
      object edInvoiceNumber: TDBEdit
        Left = 122
        Top = 61
        Width = 135
        Height = 24
        DataField = 'InvoiceNumber'
        DataSource = DataSource1
        TabOrder = 2
      end
    end
    object Panel3: TPanel
      Left = 4
      Top = 556
      Width = 1143
      Height = 102
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object lblVAT1: TLabel
        Left = 690
        Top = 3
        Width = 44
        Height = 16
        Alignment = taRightJustify
        Caption = 'lblVAT1'
      end
      object lblVAT2: TLabel
        Left = 690
        Top = 25
        Width = 44
        Height = 16
        Alignment = taRightJustify
        Caption = 'lblVAT2'
      end
      object lblVAT3: TLabel
        Left = 690
        Top = 47
        Width = 44
        Height = 16
        Alignment = taRightJustify
        Caption = 'lblVAT3'
      end
      object lblTotalAmount: TLabel
        Left = 624
        Top = 69
        Width = 110
        Height = 19
        Alignment = taRightJustify
        Caption = 'lblTotalAmount'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object dbtextVatPercentage1: TDBText
        Left = 768
        Top = 2
        Width = 65
        Height = 17
        DataField = 'VatPercentage1'
        DataSource = DataSource1
      end
      object dbtextVatPercentage2: TDBText
        Left = 768
        Top = 25
        Width = 65
        Height = 17
        DataField = 'VatPercentage2'
        DataSource = DataSource1
      end
      object dbtextVatPercentage3: TDBText
        Left = 768
        Top = 46
        Width = 65
        Height = 17
        DataField = 'VatPercentage3'
        DataSource = DataSource1
      end
      object dbtextTotalAmount: TDBText
        Left = 864
        Top = 69
        Width = 121
        Height = 17
        Alignment = taRightJustify
        DataField = 'TotalAmount'
        DataSource = DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object dbtextVatAmount1: TDBText
        Left = 864
        Top = 3
        Width = 121
        Height = 17
        Alignment = taRightJustify
        DataField = 'VatAmount1'
        DataSource = DataSource1
      end
      object dbtextVatAmount2: TDBText
        Left = 864
        Top = 25
        Width = 121
        Height = 17
        Alignment = taRightJustify
        DataField = 'VatAmount2'
        DataSource = DataSource1
      end
      object dbtextVatAmount3: TDBText
        Left = 864
        Top = 46
        Width = 121
        Height = 17
        Alignment = taRightJustify
        DataField = 'VatAmount3'
        DataSource = DataSource1
      end
    end
    object Panel4: TPanel
      Left = 4
      Top = 153
      Width = 1143
      Height = 403
      Align = alClient
      BevelInner = bvLowered
      BevelOuter = bvNone
      BorderWidth = 2
      TabOrder = 2
      object DBGrid1: TDBGrid
        Left = 3
        Top = 3
        Width = 1137
        Height = 397
        Align = alClient
        BorderStyle = bsNone
        Ctl3D = True
        DataSource = dsInvDetail
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
        ParentCtl3D = False
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -13
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnKeyDown = DBGrid1KeyDown
        Columns = <
          item
            Expanded = False
            FieldName = 'InventoryCode'
            Title.Alignment = taCenter
            Width = 125
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'InventoryName'
            Title.Alignment = taCenter
            Width = 244
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Quantity'
            Title.Alignment = taCenter
            Width = 77
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'UnitPrice'
            Title.Alignment = taRightJustify
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'VatPercentage'
            Title.Alignment = taCenter
            Width = 101
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'VatAmount'
            Title.Alignment = taCenter
            Width = 85
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'TotalAmount'
            Title.Alignment = taCenter
            Width = 97
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'SpecCode'
            Title.Alignment = taCenter
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'LineDescription'
            Visible = True
          end>
      end
    end
  end
  inherited Panel2: TPanel
    Top = 662
    Width = 1151
    ExplicitTop = 662
    ExplicitWidth = 1151
    inherited btnOk: TButton
      Left = 938
      ExplicitLeft = 938
    end
    inherited btnCancel: TButton
      Left = 1051
      ExplicitLeft = 1051
    end
  end
  object tblInvDetail: TFDMemTable
    BeforeDelete = tblInvDetailBeforeDelete
    OnNewRecord = tblInvDetailNewRecord
    FieldDefs = <>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 672
    Top = 160
    object tblInvDetailSalesInvoiceDetailId: TIntegerField
      FieldName = 'SalesInvoiceDetailId'
    end
    object tblInvDetailSalesInvoiceHeaderId: TIntegerField
      FieldName = 'SalesInvoiceHeaderId'
    end
    object tblInvDetailInventoryId: TIntegerField
      FieldName = 'InventoryId'
      OnChange = tblInvDetailInventoryIdChange
    end
    object tblInvDetailInventoryCode: TStringField
      FieldKind = fkLookup
      FieldName = 'InventoryCode'
      LookupKeyFields = 'InventoryId'
      LookupResultField = 'InventoryCode'
      KeyFields = 'InventoryId'
      Size = 30
      Lookup = True
    end
    object tblInvDetailInventoryName: TStringField
      FieldKind = fkLookup
      FieldName = 'InventoryName'
      LookupKeyFields = 'InventoryId'
      LookupResultField = 'InventoryName'
      KeyFields = 'InventoryId'
      Size = 50
      Lookup = True
    end
    object tblInvDetailQuantity: TFloatField
      FieldName = 'Quantity'
      OnChange = tblInvDetailQuantityChange
    end
    object tblInvDetailUnitPrice: TFloatField
      FieldName = 'UnitPrice'
      OnChange = tblInvDetailUnitPriceChange
    end
    object tblInvDetailVatPercentage: TFloatField
      FieldName = 'VatPercentage'
      OnChange = tblInvDetailVatPercentageChange
    end
    object tblInvDetailVatAmount: TFloatField
      FieldName = 'VatAmount'
      OnChange = tblInvDetailVatAmountChange
    end
    object tblInvDetailOtvAmount: TFloatField
      FieldName = 'OtvAmount'
    end
    object tblInvDetailTotalAmount: TFloatField
      FieldName = 'TotalAmount'
      OnChange = tblInvDetailTotalAmountChange
    end
    object tblInvDetailSpecCode: TStringField
      FieldName = 'SpecCode'
    end
    object tblInvDetailLineDescription: TStringField
      FieldName = 'LineDescription'
      Size = 100
    end
    object tblInvDetailInvoiceDate: TDateTimeField
      FieldName = 'InvoiceDate'
    end
    object tblInvDetailCustomerId: TIntegerField
      FieldName = 'CustomerId'
    end
    object tblInvDetailCurrencyTypeId: TIntegerField
      FieldName = 'CurrencyTypeId'
      OnChange = tblInvDetailCurrencyTypeIdChange
    end
    object tblInvDetailCurrencyRate: TFloatField
      FieldName = 'CurrencyRate'
      OnChange = tblInvDetailCurrencyRateChange
    end
    object tblInvDetailc_RowState: TIntegerField
      FieldName = 'c_RowState'
    end
  end
  object dsInvDetail: TDataSource
    DataSet = tblInvDetail
    Left = 560
    Top = 160
  end
  object dsCustomer: TDataSource
    Left = 308
    Top = 60
  end
  object dsCurrencyType: TDataSource
    Left = 760
    Top = 24
  end
end
