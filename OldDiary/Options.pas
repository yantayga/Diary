unit Options;

interface

procedure SaveOptionString(AKey: String; AValue: String);
procedure SaveOptionInt(AKey: String; AValue: Integer);
procedure SaveOptionDouble(AKey: String; AValue: Extended);
procedure SaveOptionBool(AKey: String; AValue: Boolean);

function LoadOptionString(AKey: String; ADefault: String): String;
function LoadOptionInt(AKey: String; ADefault: Integer): Integer;
function LoadOptionDouble(AKey: String; ADefault: Extended): Extended;
function LoadOptionBool(AKey: String; ADefault: Boolean): Boolean;

implementation

uses SysUtils, Database;

procedure SaveOptionString(AKey: String; AValue: String);
begin
  SaveOptionToDatabase(AKey, AValue);
end;

procedure SaveOptionInt(AKey: String; AValue: Integer);
begin
  SaveOptionToDatabase(AKey, IntToStr(AValue));
end;

procedure SaveOptionDouble(AKey: String; AValue: Extended);
begin
  SaveOptionToDatabase(AKey, FloatToStr(AValue));
end;

procedure SaveOptionBool(AKey: String; AValue: Boolean);
begin
  SaveOptionToDatabase(AKey, BoolToStr(AValue, True));
end;

function LoadOptionString(AKey: String; ADefault: String): String;
begin
  Result := LoadOptionFromDatabase(AKey);
  if Result = '' then
    Result := ADefault;
end;

function LoadOptionInt(AKey: String; ADefault: Integer): Integer;
begin
  if not TryStrToInt(LoadOptionFromDatabase(AKey), Result) then
    Result := ADefault;
end;

function LoadOptionDouble(AKey: String; ADefault: Extended): Extended;
begin
  if not TryStrToFloat(LoadOptionFromDatabase(AKey), Result) then
    Result := ADefault;
end;

function LoadOptionBool(AKey: String; ADefault: Boolean): Boolean;
var
  Value: String;
begin
  Result := ADefault;
  Value := LowerCase(LoadOptionFromDatabase(AKey));
  if (Value = '1') or (Value = 'true') then
    Result := True
  else if (Value = '0') or (Value = 'false') then
    Result := False;
end;

end.
