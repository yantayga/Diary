unit Reports;

interface

uses Classes, Controls, SysUtils, IniFiles, ComCtrls, StdCtrls, ExtCtrls,
     LocalTypes, Database;

type
  TReport=class
    private
      FName: String;
      FVariables: TReportVars;
      FColumns: array of String;
      FQuery: String;
      FPanel: TPanel;

      constructor CreateFromIniObject(AIniFile: TCustomIniFile);
      function FetchVariableValue(ACtrl: TWinControl; var AVar: TReportVar): Boolean;
      function VariableToString(AVar: TReportVar): String;
      function SubstituteVarValues(ASrc: String): String;
      function ReadControls: Boolean;
    public
      procedure CreateControls(AParent: TWinControl);
      procedure Generate;

      constructor CreateFromFile(AFileName: String);
      constructor CreateFromString(ABlob: String);
      destructor Free;
  end;

implementation

uses Forms,
     ReportView, Options;

{ TReport }

procedure TReport.CreateControls(AParent: TWinControl);
const
  dh = 10;
  dw = 20;
var
  i, t: Integer;
  ctrlName: String;
  lbl : TLabel;
  ctrl: TWinControl;
begin
  FPanel := TPanel.Create(AParent);
  FPanel.Parent := AParent;
  FPanel.Align := alClient;
  FPanel.BorderStyle := bsNone;
  t := 10;
  ctrl := nil;
  for i := 0 to Length(FVariables) - 1 do begin
    lbl := TLabel.Create(FPanel);
    lbl.Parent := FPanel;
    lbl.Name := 'lblVariable' + IntToStr(i);
    lbl.Caption := FVariables[i].DisplayName + ': ';
    lbl.AutoSize := False;
    lbl.Top := t;
    lbl.Left := 10;
    lbl.Width := 150;
    ctrlName := 'ctlVariable' + IntToStr(i);
    case FVariables[i].VarType of
      vtInteger: begin
        ctrl := TEdit.Create(FPanel);
        (ctrl as TEdit).Text := LoadOptionString('Report_Variable' + ctrlName, '0');
      end;
      vtDate: begin
        ctrl := TDateTimePicker.Create(FPanel);
        (ctrl as TDateTimePicker).DateTime := LoadOptionDouble('Report_Variable' + ctrlName, Now());
      end;
      vtFlag: begin
        ctrl := TCheckBox.Create(FPanel);
        (ctrl as TCheckBox).Checked := LoadOptionBool('Report_Variable' + ctrlName, False);
        (ctrl as TCheckBox).Caption := ' ';
      end;
      else
        continue;
    end;
    ctrl.Top := t;
    ctrl.Left := lbl.Left + lbl.Width + dw;
    ctrl.Width := 100;
    ctrl.Parent := FPanel;
    ctrl.Name := ctrlName;
    Inc(t, dh + ctrl.Height);
  end;
end;

constructor TReport.CreateFromFile(AFileName: String);
var
  iniFile: TIniFile;
begin
  try
    iniFile := TIniFile.Create(AFileName);
    CreateFromIniObject(iniFile);
  finally
    if Assigned(iniFile) then FreeAndNil(iniFile);
  end;
end;

constructor TReport.CreateFromIniObject(AIniFile: TCustomIniFile);
var
  i, n: Integer;
  vt: String;
begin
  FName := AIniFile.ReadString('Common', 'Name', '');
  FQuery := AIniFile.ReadString('Common', 'Query', '');

  n := AIniFile.ReadInteger('Variables', 'Count', 0);
  SetLength(FVariables, n);
  for i := 0 to n - 1 do begin
    FVariables[i].Name := AIniFile.ReadString('Variables', 'Name' + IntToStr(i), '');
    FVariables[i].DisplayName := AIniFile.ReadString('Variables', 'DisplayName' + IntToStr(i), '');
    FVariables[i].IsNullable := AIniFile.ReadBool('Variables', 'IsNullable' + IntToStr(i), False);
    vt := AIniFile.ReadString('Variables', 'VarType' + IntToStr(i), 'Integer');
    if vt = 'Integer' then
      FVariables[i].VarType := vtInteger
    else if vt = 'Date' then
      FVariables[i].VarType := vtDate
    else if vt = 'Flag' then
      FVariables[i].VarType := vtFlag;
  end;

  n := AIniFile.ReadInteger('Columns', 'Count', 0);
  SetLength(FColumns, n);
  for i := 0 to n - 1 do begin
    FColumns[i] := AIniFile.ReadString('Columns', 'Name' + IntToStr(i), '');
  end;
end;

constructor TReport.CreateFromString(ABlob: String);
var
  iniFile: TMemIniFile;
  sl: TStringList;
begin
  try
    iniFile := TMemIniFile.Create('tmp.ini');
    sl := TStringList.Create;
    sl.Text := ABlob;
    iniFile.SetStrings(sl);
    CreateFromIniObject(iniFile);
  finally
    if Assigned(sl) then FreeAndNil(sl);
    if Assigned(iniFile) then FreeAndNil(iniFile);
  end;
end;

function TReport.FetchVariableValue(ACtrl: TWinControl; var AVar: TReportVar): Boolean;
begin
  Result := True;
  case AVar.VarType of
    vtInteger: begin
      Result := TryStrToInt((ACtrl as TEdit).Text, AVar.ValInt);
      if Result then
        SaveOptionInt('Report_Variable' + ACtrl.Name, AVar.ValInt);
    end;
    vtDate: begin
      AVar.ValDate := (ACtrl as TDateTimePicker).DateTime;
      SaveOptionDouble('Report_Variable' + ACtrl.Name, AVar.ValDate);
    end;
    vtFlag: begin
      AVar.ValBool := (ACtrl as TCheckBox).Checked;
      SaveOptionBool('Report_Variable' + ACtrl.Name, AVar.ValBool);
    end;
    else
      Result := False;
  end;
end;

destructor TReport.Free;
begin
  if Assigned(FPanel) then FreeAndNil(FPanel);
end;

procedure TReport.Generate;
var
  AMatrix: TStringMatrix;
  i, j: Integer;
  FileName: String;
  f: TStringList;
const
  TableRow = '<tr>%s</tr>';
  TableData = '<td>%s</td>';
begin
  if not ReadControls then
    Exit;

  FetchReportQuery(FQuery, FVariables, Length(FColumns), AMatrix);

  f := TStringList.Create;

  f.Add(Format('<center><b>%s</b></center><br><br>', [SubstituteVarValues(FName)]));
  f.Add('<table border="1px solid black">');

  for i := 0 to Length(FColumns) - 1 do begin
    f.Add(Format('<th>%s</th>', [FColumns[i]]));
  end;
  for i := 0 to Length(AMatrix) - 1 do begin
    f.Add('<tr>');
    for j := 0 to Length(FColumns) - 1 do
      f.Add(Format('<td>&nbsp;%s</td>', [AMatrix[i][j]]));
    f.Add('</tr>');
  end;

  f.Add('</table>');

  FileName := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + '.report.html';
  f.SaveToFile(FileName);
  OpenReportFile(FileName);
end;

function TReport.ReadControls: Boolean;
var
  i: Integer;
  ctrl: TWinControl;
begin
  Result := False;
  if not Assigned(FPanel) then
    Exit;

  for i := 0 to Length(FVariables) - 1 do begin
    ctrl := FPanel.FindComponent('ctlVariable' + IntToStr(i)) as TWinControl;
    if not FetchVariableValue(ctrl, FVariables[i]) then
      Exit;
  end;

  Result := True;
end;

function TReport.SubstituteVarValues(ASrc: String): String;
var
  i: Integer;
begin
  Result := ASrc;
  for i := 0 to Length(FVariables) - 1 do
    Result := StringReplace(Result, ':' + FVariables[i].Name, VariableToString(FVariables[i]), [rfReplaceAll]);
end;

function TReport.VariableToString(AVar: TReportVar): String;
begin
  Result := '';
  case AVar.VarType of
    vtInteger: Result := IntToStr(AVar.ValInt);
    vtDate: Result := DateToStr(AVar.ValDate);
    vtFlag: Result := BoolToStr(AVar.ValBool, True);
  end;
end;

end.
