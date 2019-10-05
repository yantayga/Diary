unit ExpressionsEvauator;

interface

  function EvalFormula(AFormula: String; AMessage: String): String;

implementation

uses SysUtils, Dialogs;

type                  
  TCharClass = (ccSpace, ccMultOp, ccAddOp, ccDigit, ccPoint, ccOpenBra, ccCloseBra, ccErr);
  TItem = (iNone, iNum, iFloatNum, iAddExpr, iMultExpr, iOpenBra, iCloseBra);

  TToken = record
    i: TItem;
    case TItem of
      iNum: (n: integer;);
      iFloatNum: (d: Extended;);
      iMultExpr, iAddExpr: (c: Char);
  end;

  TTokens = array of TToken;

function GetCharClass(ch: Char): TCharClass;
begin
  case ch of
    ' ', #9, #13, #10: Result := ccSpace;
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9': Result := ccDigit;
    ',', '.': Result := ccPoint;
    '+', '-': Result := ccAddOp;
    '*', '/': Result := ccMultOp;
    '(': Result := ccOpenBra;
    ')': Result := ccCloseBra;
    else Result := ccErr;
  end;
end;

function ParseFormula(AFormula: String; var ATokens: TTokens): Boolean;
var
  c: TItem;
  cs: String;
  sc: TCharClass;
  i: Integer;
  formatSettings: TFormatSettings;

  procedure BeginState(newc: TItem; newcs: String);
  begin
    c := newc;
    cs := newcs;
  end;

  procedure AddCurrentItemAndReset(newc: TItem; newcs: String);
  begin
    SetLength(ATokens, Length(ATokens) + 1);
    ATokens[Length(ATokens) - 1].i := c;
    case c of
      iNum: TryStrToInt(cs, ATokens[Length(ATokens) - 1].n);
      iFloatNum: TryStrToFloat(cs, ATokens[Length(ATokens) - 1].d);
      iAddExpr, iMultExpr: ATokens[Length(ATokens) - 1].c := cs[1];
    end;
    BeginState(newc, newcs);
  end;

  procedure AddAndContinue(newc: TItem; addcs: String);
  begin
    c := newc;
    cs := cs + addcs;
  end;

begin
  Result := False;
  GetLocaleFormatSettings(0, formatSettings);
  c := iNone;
  for i := 1 to Length(AFormula) do begin
    sc := GetCharClass(AFormula[i]);
    if sc = ccErr then
      Exit;
    case c of
      iNone: case sc of
        ccSpace: ;
        ccDigit: BeginState(iNum, AFormula[i]);
        ccPoint: BeginState(iFloatNum, '0' + formatSettings.DecimalSeparator);
        ccAddOp: BeginState(iAddExpr, AFormula[i]);
        ccMultOp: BeginState(iMultExpr, AFormula[i]);
        ccOpenBra: BeginState(iOpenBra, AFormula[i]);
        ccCloseBra: BeginState(iCloseBra, AFormula[i]);
      end;
      iNum: case sc of
        ccSpace: AddCurrentItemAndReset(iNone, '');
        ccDigit: AddAndContinue(iNum, AFormula[i]);
        ccPoint: AddAndContinue(iFloatNum, formatSettings.DecimalSeparator);
        ccAddOp: AddCurrentItemAndReset(iAddExpr, AFormula[i]);
        ccMultOp: AddCurrentItemAndReset(iMultExpr, AFormula[i]);
        ccOpenBra: AddCurrentItemAndReset(iOpenBra, AFormula[i]);
        ccCloseBra: AddCurrentItemAndReset(iCloseBra, AFormula[i]);
      end;
      iFloatNum: case sc of
        ccSpace: AddCurrentItemAndReset(iNone, '');
        ccDigit: AddAndContinue(iFloatNum, AFormula[i]);
        ccPoint: Exit;
        ccAddOp: AddCurrentItemAndReset(iAddExpr, AFormula[i]);
        ccMultOp: AddCurrentItemAndReset(iMultExpr, AFormula[i]);
        ccOpenBra: AddCurrentItemAndReset(iOpenBra, AFormula[i]);
        ccCloseBra: AddCurrentItemAndReset(iCloseBra, AFormula[i]);
      end;
      iAddExpr, iMultExpr, iOpenBra, iCloseBra:  case sc of
        ccSpace: AddCurrentItemAndReset(iNone, '');
        ccDigit: AddCurrentItemAndReset(iNum, AFormula[i]);
        ccPoint: AddCurrentItemAndReset(iFloatNum, '0' + formatSettings.DecimalSeparator);
        ccAddOp: AddCurrentItemAndReset(iAddExpr, AFormula[i]);
        ccMultOp: AddCurrentItemAndReset(iMultExpr, AFormula[i]);
        ccOpenBra: AddCurrentItemAndReset(iOpenBra, AFormula[i]);
        ccCloseBra: AddCurrentItemAndReset(iCloseBra, AFormula[i]);
      end;
    end;
  end;
  if c <> iNone then
    AddCurrentItemAndReset(iNone, '');

  Result := True;
end;

function EvalTokensInternal(ATokens: TTokens; AStart: Integer; AEnd: Integer; var ARes: TToken): Boolean;
var
  i, j: Integer;
  hasMult: Boolean;
  stack: TTokens;

  function FindCloseBraketFor(p: Integer): Integer;
  begin
    for Result := 0 to AEnd do
      if ATokens[Result].i = iCloseBra then
        Exit;
    Result := 0;
  end;

  function FloatOp(AOp: Char; A1: Extended; A2: Extended): TToken;
  begin
    Result.i := iFloatNum;
    case AOp of
      '+': Result.d := A1 + A2; 
      '-': Result.d := A1 - A2; 
      '*': Result.d := A1 * A2; 
      '/': if A2 <> 0 then
          Result.d := A1 / A2
        else
          Result.i := iNone;
      else Result.i := iNone;
    end;
  end;
  
  function IntOp(AOp: Char; A1: Integer; A2: Integer): TToken;
  begin
    Result.i := iNum;
    case AOp of
      '+': Result.n := A1 + A2; 
      '-': Result.n := A1 - A2; 
      '*': Result.n := A1 * A2; 
      '/': if A2 <> 0 then begin
          Result.i := iFloatNum;
          Result.d := A1 / A2; 
        end else
          Result.i := iNone
      else Result.i := iNone;
    end;
  end;

  function Perform(A1: TToken; AOp: TToken; A2: TToken): TToken;
  begin
    if not (A1.i in [iNum, iFloatNum]) or not (A2.i in [iNum, iFloatNum]) then
      Exit;
        
    case AOp.i of
      iAddExpr, iMultExpr: if (A1.i = iFloatNum) or (A2.i = iFloatNum) then begin
          if A1.i = iNum then
            A1.d := A1.n;
          if A2.i = iNum then
            A2.d := A2.n;
          Result := FloatOp(AOp.c, A1.d, A2.d) 
        end else
          Result := IntOp(AOp.c, A1.n, A2.n);
    end;
  end;

  procedure PutOnTop(ATok: TToken);
  begin
    SetLength(stack, Length(stack) + 1);
    stack[Length(stack) - 1] := ATok;
  end;

  function GetTop: TToken;
  begin
    Result := stack[Length(stack) - 1];
    SetLength(stack, Length(stack) - 1);
  end;

  procedure PutOnTopAndSetMult(ATok: TToken);
  begin
    PutOnTop(ATok);
    hasMult := (ATok.i = iMultExpr);
  end;

  procedure PutOnTopAndTryCollapse(ATok: TToken);
  var
    n1, op, n2: TToken;
  begin
    PutOnTop(ATok);
    if hasMult then begin
      n2 := GetTop;
      op := GetTop;
      n1 := GetTop;
      PutOnTop(Perform(n1, op, n2));
      hasMult := False;
    end;
  end;

begin
  Result := False;
  hasMult := False;
  i := AStart;
  while i < AEnd do begin
    case ATokens[i].i of
      iNone: ;
      iOpenBra: begin
        j := FindCloseBraketFor(i);
        if (j > i) and EvalTokensInternal(ATokens, i + 1, j, ARes) then begin
          PutOnTopAndTryCollapse(ARes);
          i := j + 1;
          continue;
        end else
          Exit;
      end;
      iNum, iFloatNum: PutOnTopAndTryCollapse(ATokens[i]);
      iAddExpr, iMultExpr: PutOnTopAndSetMult(ATokens[i]);
      iCloseBra: Exit;
    end;
    Inc(i);
  end;

  for i := 1 to Length(stack) - 1 do
    if stack[i].i in [iAddExpr, iMultExpr] then begin
      if i+1 < Length(stack) then
        stack[i+1] := Perform(stack[i-1], stack[i], stack[i+1]);
    end;

  Result := Length(stack) > 0;
  if Result then
    ARes := stack[Length(stack) - 1];
end;

function EvalTokens(ATokens: TTokens; AStart: Integer; AEnd: Integer; var ARes: String): Boolean;
var
  item: TToken;
begin
  Result := EvalTokensInternal(ATokens, AStart, AEnd, item);
  if Result then
    case item.i of
      iNum: ARes := IntToStr(item.n);
      iFloatNum: ARes := FloatToStr(item.d);
      else Result := False;
    end;
end;

function EvalFormula(AFormula: String; AMessage: String): String;
var
  tokens: TTokens;
  res: String;
begin
  AFormula := Trim(AFormula);
  if AFormula = '' then begin
    Result := AFormula;
    Exit;
  end;

  if ParseFormula(AFormula, tokens) and EvalTokens(tokens, 0, Length(tokens), res) then
    Result := res
  else begin
    MessageDlg('Ошибка в выражении "' + AMessage + '": ' + AFormula, mtError, [mbOk], -1);
    Result := AFormula;
  end;
end;



end.
