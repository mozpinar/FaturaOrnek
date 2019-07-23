inherited UserListForm: TUserListForm
  Caption = 'UserListForm'
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel11: TPanel
    inherited DBGrid1: TDBGrid
      Columns = <
        item
          Expanded = False
          FieldName = 'UserId'
          Width = 75
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'UserName'
          Width = 232
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'IsActive'
          Width = 88
          Visible = True
        end>
    end
  end
end
