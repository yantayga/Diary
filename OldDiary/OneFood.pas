unit OneFood;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Grids;

type
  TfrmOneFood = class(TForm)
    lblName: TLabel;
    edtName: TEdit;
    chkActive: TCheckBox;
    btnOk: TButton;
    btnCancel: TButton;
    mmoComments: TMemo;
    sgParameters: TStringGrid;
    lblUnit: TLabel;
    edtDefaultAmount: TEdit;
    cbbUnit: TComboBox;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure edtDefaultAmountExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    FIntakeId: Variant;
    FId: Integer;
  end;

  function EditFoodItemByIntake(AIntakeId: Variant): Boolean;
  function EditFoodItemById(AId: Variant): Boolean;

implementation

uses LocalTypes, DataBase, Options, ExpressionsEvauator;

{$R *.dfm}

function EditFoodItemByIntake(AIntakeId: Variant): Boolean;
var
  dlg: TfrmOneFood;
begin
  try
    dlg := TfrmOneFood.Create(nil);
    dlg.FIntakeId := AIntakeId;
    dlg.FId := 0;
    Result := dlg.ShowModal = idOk;
  finally
    if Assigned(dlg) then FreeAndNil(dlg);
  end;
end;

function EditFoodItemById(AId: Variant): Boolean;
var
  dlg: TfrmOneFood;
begin
  try
    dlg := TfrmOneFood.Create(nil);
    dlg.FIntakeId := 0;
    dlg.FId := AId;
    Result := dlg.ShowModal = idOk;
  finally
    if Assigned(dlg) then FreeAndNil(dlg);
  end;
end;

procedure TfrmOneFood.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmOneFood.btnOkClick(Sender: TObject);
var
  n: Double;
  i: Integer;
begin
  edtDefaultAmountExit(Sender);
  if Trim(edtName.Text) = '' then begin
    MessageDlg('Наименование не может быть пустым', mtError, [mbOk], -1);
    Exit;
  end;

  if not TryStrToFloat(edtDefaultAmount.Text, n) then begin
    MessageDlg('Неверное значение количества', mtError, [mbOk], -1);
    Exit;
  end;

  if cbbUnit.ItemIndex = -1 then begin
    MessageDlg('Неверное значение единицы измерения', mtError, [mbOk], -1);
    Exit;
  end;

  BeginTransaction;

  try
    SaveFoodItemInfoAndDeleteContent(FId, edtName.Text, chkActive.Checked,
      n, Integer(cbbUnit.Items.Objects[cbbUnit.ItemIndex]), mmoComments.Lines.Text);

    for i := 0 to sgParameters.RowCount - 1 do begin
      sgParameters.Cells[1, i] := EvalFormula(sgParameters.Cells[1, i], sgParameters.Cells[0, i]);
      SaveFoodItemContent(FId, Integer(sgParameters.Objects[0, i]), StrToFloat(sgParameters.Cells[1, i]));
    end;
  except on E:Exception do begin
      MessageDlg(E.Message, mtError, [mbOk], -1);
      RollbackTransaction;
      Exit;
    end;
  end;

  CommitTransaction;

  ModalResult := mrOk;
end;

procedure TfrmOneFood.edtDefaultAmountExit(Sender: TObject);
begin
  edtDefaultAmount.Text := EvalFormula(edtDefaultAmount.Text, 'количество');
end;

procedure TfrmOneFood.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveOptionBool('TfrmOneFood_chkActive.Checked', chkActive.Checked);
end;

procedure TfrmOneFood.FormCreate(Sender: TObject);
begin
  chkActive.Checked := LoadOptionBool('TfrmOneFood_chkActive.Checked', chkActive.Checked);
  sgParameters.ColWidths[0] := 230;
  sgParameters.ColWidths[1] := 80;
  FetchUnitList(cbbUnit.Items);
end;

procedure TfrmOneFood.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
    btnCancelClick(Sender);
end;

procedure TfrmOneFood.FormShow(Sender: TObject);
var
  AName, AComment: String;
  AActive: Boolean;
  ADefaultAmount: Double;
  AUnit: Integer;
  Parameters: TFoodParameterContents;
  i: Integer;
begin
  if (FIntakeId = 0) and (FId = 0) then
    Caption := 'Новый продукт'
  else
    Caption := 'Редактировать продукт';

  if FIntakeId = 0 then begin
    if FId <> 0 then
      FetchFoodItemInfoById(FId, AName, AActive, ADefaultAmount, AUnit, AComment)
  end else
    FetchFoodItemInfoByIntake(FIntakeId, FId, AName, AActive, ADefaultAmount, AUnit, AComment);
  edtName.Text := AName;
  chkActive.Checked := AActive;
  edtDefaultAmount.Text := FloatToStr(ADefaultAmount);
  for i := 0 to cbbUnit.Items.Count - 1 do
    if Integer(cbbUnit.Items.Objects[i]) = AUnit then begin
      cbbUnit.ItemIndex := i;
    end;
  mmoComments.Lines.Text := AComment;

  SetLength(Parameters, 0);
  FetchFoodContent(FId, Parameters);
  sgParameters.RowCount := Length(Parameters);
  for i := 0 to Length(Parameters) - 1 do begin
    sgParameters.Objects[0, i] := Pointer(Parameters[i].Id);
    sgParameters.Cells[0, i] := Parameters[i].Name + ', ' + Parameters[i].Unitname;
    if not Parameters[i].Main then
      sgParameters.Cells[0, i] := '*' + sgParameters.Cells[0, i];
    sgParameters.Cells[1, i] := FloatToStr(Parameters[i].Value);
  end;
end;

end.
