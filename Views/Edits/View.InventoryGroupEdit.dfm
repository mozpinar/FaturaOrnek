inherited InventoryGroupEditForm: TInventoryGroupEditForm
  Caption = 'InventoryGroupEditForm'
  ClientHeight = 173
  ExplicitHeight = 212
  PixelsPerInch = 96
  TextHeight = 16
  inherited Panel21: TPanel
    Height = 132
    object lblInventoryGroupName: TLabel
      Left = 64
      Top = 56
      Width = 133
      Height = 16
      Alignment = taRightJustify
      Caption = 'lblInventoryGroupName'
    end
    object edInventoryGroupName: TDBEdit
      Left = 203
      Top = 53
      Width = 366
      Height = 24
      DataField = 'InventoryGroupName'
      DataSource = DataSource1
      TabOrder = 0
    end
  end
  inherited Panel2: TPanel
    Top = 132
    inherited btnOk: TButton
      Left = 376
      Top = 6
      ExplicitLeft = 376
      ExplicitTop = 6
    end
    inherited btnCancel: TButton
      Left = 473
      Top = 6
      ExplicitLeft = 473
      ExplicitTop = 6
    end
  end
end
