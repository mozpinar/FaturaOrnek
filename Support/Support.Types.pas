unit Support.Types;

interface
uses
  System.Generics.Collections, Graphics, Classes;


type
  TFontInfo = record
    Name : string;
    Charset : TFontCharset;
    Size : integer;
    Color : TColor;
    Style : TFontStyles;
  end;

  TGridColInfo = class
    Index : integer;
    Caption : string;
    FieldName : string;
    Font : TFontInfo;
    Color : TColor;
    Alignment : TAlignment;
    ColWidth : Integer;
    Format : string;
    Mask : string;
    ReadOnly : boolean;
    Visible : boolean;
    TitleCaption : string;
    TitleColor : TColor;
    TitleAlignment : TAlignment;
    TitleFont : TFontInfo;
  end;

  TGridInfo = class
    Color : TColor;
    FixedColor : TColor;
    Font : TFontInfo;
    TitleFont : TFontInfo;
    ShowRowLines : Boolean;
    ShowColLines : Boolean;
    Columns : TObjectList<TGridColInfo>;
  end;


implementation

end.
