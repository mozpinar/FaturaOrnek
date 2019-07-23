unit Model.CurrencyDaily;

interface
uses Data.DB, Model.Declarations, MainDM;
type
  TBuySale = (tbsBuying, tbsSelling);
  TCurrencyDailyModel = class
    class function GetARate(const ABS : TBuySale; const ACurrencyTypeId : Integer; const ADate : TDateTime) : Extended;
    class function Convert(const ABS : TBuySale; const ASourceId, ATargetId : Integer; const ADate : TDateTime) : Extended;
  end;
implementation

{ TCurrencyDailyModel }

class function TCurrencyDailyModel.GetARate(const ABS: TBuySale;
  const ACurrencyTypeId: Integer; const ADate: TDateTime): Extended;
var
  cds : TDataset;
begin
  if ACurrencyTypeId=0 then
    Result := 1
  else
  begin
    Result := -1;
    cds := DMMain.GetRecord<TCurrencyDaily>('CurrencyDate=:CurrencyDate and CurrencyTypeId=:CurrencyTypeId', [ADate, ACurrencyTypeId]);
    try
      if cds.RecordCount>0 then
        case ABS of
         tbsBuying: Result := cds.FieldByName('BuyingRate').AsFloat;
         tbsSelling: Result := cds.FieldByName('SellingRate').AsFloat;
        end;
    finally
      cds.Free;
    end;
  end;

end;

class function TCurrencyDailyModel.Convert(const ABS: TBuySale;
  const ASourceId, ATargetId: Integer; const ADate: TDateTime): Extended;
var
  src, tar : Extended;
  cds : TDataset;
begin
  Result := -1;
  src := GetARate(ABS, ASourceId, ADate);
  tar := GetARate(ABS, ATargetId, ADate);

  {cds := DMMain.GetRecord<TCurrencyDaily>('CurrencyDate=:CurrencyDate and CurrencyTypeId=:CurrencyTypeId', [ADate, ASourceId]);
  try
    if cds.RecordCount>0 then
      case ABS of
       tbsBuying: src := cds.FieldByName('BuyingRate').AsFloat;
       tbsSelling: src := cds.FieldByName('SellingRate').AsFloat;
      end;
  finally
    cds.Free;
  end;

  cds := DMMain.GetRecord<TCurrencyDaily>('CurrencyDate=:CurrencyDate and CurrencyTypeId=:CurrencyTypeId', [ADate, ATargetId]);
  try
    if cds.RecordCount>0 then
      case ABS of
       tbsBuying: tar := cds.FieldByName('BuyingRate').AsFloat;
       tbsSelling: tar := cds.FieldByName('SellingRate').AsFloat;
      end;
  finally
    cds.Free;
  end;
}
  if (tar>0) and (src>0) then
    Result := src / tar;
end;

end.
