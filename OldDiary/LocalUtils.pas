unit LocalUtils;

interface

  function MatchPartialStringsNoCase(AWhere: String; ASubString: String): Boolean;
  function ConfirmAction(AMessage: String): Boolean;
  function SmartRound(AArg: Extended): Extended;

implementation

uses SysUtils, Dialogs, Controls, Math;

function MatchPartialStringsNoCase(AWhere: String; ASubString: String): Boolean;
begin
  Result := Pos(UpperCase(ASubString, loUserLocale), UpperCase(AWhere, loUserLocale)) > 0;
end;

function SmartRound(AArg: Extended): Extended;
var
  z, m: Integer;
begin
  try
    if AArg = 0 then
      Result := 0
    else if Abs(AArg) < 1 then begin
      z := -Round(Log10(AArg))+1;
      m := Round(Power(10, z));
      Result := Round(AArg * m) / m;
    end else if Abs(AArg) < 10 then
      Result := Round(AArg * 100) / 100
    else if Abs(AArg) < 100 then
      Result := Round(AArg * 10) / 10
    else
      Result := Round(AArg);
  except
    Result := 0;
  end;
end;

function ConfirmAction(AMessage: String): Boolean;
begin
  Result := MessageDlg(AMessage, mtConfirmation, [mbOK, mbCancel], -1) = mrOK;
end;

end.
