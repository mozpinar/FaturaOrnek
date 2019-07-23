object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'MainForm'
  ClientHeight = 630
  ClientWidth = 1057
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object pagekChildren: TPageControl
    Left = 0
    Top = 0
    Width = 872
    Height = 611
    Align = alClient
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 872
    Top = 0
    Width = 185
    Height = 611
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 1
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 611
    Width = 1057
    Height = 19
    Panels = <>
  end
  object MainMenu1: TMainMenu
    Left = 632
    Top = 24
    object Customers1: TMenuItem
      Caption = 'Customers'
      OnClick = Customers1Click
    end
    object Suppliers1: TMenuItem
      Caption = 'Suppliers'
      OnClick = Suppliers1Click
    end
    object Inventory1: TMenuItem
      Caption = 'Inventory'
      OnClick = Inventory1Click
    end
    object Invoices1: TMenuItem
      Caption = 'Invoices'
      object PurchaseInvoice1: TMenuItem
        Caption = 'Purchase Invoice'
        OnClick = PurchaseInvoice1Click
      end
      object SalesInvoice1: TMenuItem
        Caption = 'Sales Invoice'
        OnClick = SalesInvoice1Click
      end
    end
    object InventoryGroups1: TMenuItem
      Caption = 'InventoryGroups'
      OnClick = InventoryGroups1Click
    end
    object Currency1: TMenuItem
      Caption = 'Currency'
      object CurrencyTypes1: TMenuItem
        Caption = 'Currency Types'
        OnClick = CurrencyTypes1Click
      end
      object DailyCurrencyValues1: TMenuItem
        Caption = 'Daily Currency Values'
        OnClick = DailyCurrencyValues1Click
      end
    end
    object Security1: TMenuItem
      Caption = 'Security'
      object Users1: TMenuItem
        Caption = 'Users'
        OnClick = Users1Click
      end
      object Groups1: TMenuItem
        Caption = 'Groups'
      end
      object Permissions1: TMenuItem
        Caption = 'Permissions'
      end
    end
  end
end
