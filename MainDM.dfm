object DMMain: TDMMain
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 303
  Width = 403
  object MyDB: TFDConnection
    Params.Strings = (
      'Database=dbSampleThis'
      'User_Name=sa'
      'Password=3e5t_3e5t'
      'Server=.\SQLEXPRESS'
      'DriverID=MSSQL')
    ResourceOptions.AssignedValues = [rvParamCreate, rvParamExpand]
    LoginPrompt = False
    Transaction = FDTransaction1
    Left = 32
    Top = 24
  end
  object FDPhysMSSQLDriverLink1: TFDPhysMSSQLDriverLink
    Left = 168
    Top = 24
  end
  object FDTable1: TFDTable
    Connection = MyDB
    UpdateOptions.UpdateTableName = 'dbSampleThis.dbo.PurchaseInvoiceHeader'
    TableName = 'dbSampleThis.dbo.PurchaseInvoiceHeader'
    Left = 272
    Top = 144
  end
  object FDTransaction1: TFDTransaction
    Connection = MyDB
    Left = 280
    Top = 48
  end
  object FDQuery1: TFDQuery
    Connection = MyDB
    ResourceOptions.AssignedValues = [rvParamCreate, rvParamExpand]
    ResourceOptions.ParamCreate = False
    ResourceOptions.ParamExpand = False
    Left = 320
    Top = 216
  end
end
