unit OneFoodIntake;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TfrmOneFoodIntake = class(TForm)
    lblAmount: TLabel;
    edtAmount: TEdit;
    btnOk: TButton;
    btnCancel: TButton;
    mmoComment: TMemo;
    edtExComment: TEdit;
    lblFoodList: TLabel;
    lblDate: TLabel;
    dtpDate: TDateTimePicker;
    lblUnit: TLabel;
    lblUnitName: TLabel;
    edtFilterName: TEdit;
    lstFoodList: TListBox;
    chkActive: TCheckBox;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lstFoodListClick(Sender: TObject);
    procedure lstFoodListDblClick(Sender: TObject);
    procedure edtFilterNameChange(Sender: TObject);
    procedure chkActiveClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure edtAmountExit(Sender: TObject);
  private
    FDefaultDate: TDate;
    FId: Integer;

    procedure FetchFoodItemsList(ASelected: Integer; AAll: Boolean);
  public
    { Public declarations }
  end;

  function AddNewFoodIntake(ADate: TDate): Boolean;
  function EditFoodIntake(AId: Integer): Boolean;

implementation

uses DataBase, LocalUtils, OneFood, ExpressionsEvauator;

{$R *.dfm}

function AddNewFoodIntake(ADate: TDate): Boolean;
var
  dlg: TfrmOneFoodIntake;
begin
  try
    dlg := TfrmOneFoodIntake.Create(nil);
    dlg.FId := 0;
    dlg.FDefaultDate := ADate;
    Result := dlg.ShowModal = idOk;
  finally
    if Assigned(dlg) then FreeAndNil(dlg);
  end;
end;

function EditFoodIntake(AId: Integer): Boolean;
var
  dlg: TfrmOneFoodIntake;
begin
  try
    dlg := TfrmOneFoodIntake.Create(nil);
    dlg.FId := AId;
    Result := dlg.ShowModal = idOk;
  finally
    if Assigned(dlg) then FreeAndNil(dlg);
  end;
end;


procedure TfrmOneFoodIntake.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmOneFoodIntake.btnOkClick(Sender: TObject);
var
  n: Double;
begin
  edtAmountExit(Sender);
  if lstFoodList.ItemIndex = -1 then begin
    MessageDlg('Выберите продукт', mtError, [mbOk], -1);
    Exit;
  end;

  if not TryStrToFloat(edtAmount.Text, n) then begin
    MessageDlg('Неверное значение', mtError, [mbOk], -1);
    Exit;
  end;

  if FId = 0 then
    AddFoodIntake(dtpDate.DateTime, Integer(lstFoodList.Items.Objects[lstFoodList.ItemIndex]),
      StrToFloatDef(edtAmount.Text, 0), edtExComment.Text)
  else
    SaveFoodIntake(FId, dtpDate.DateTime, Integer(lstFoodList.Items.Objects[lstFoodList.ItemIndex]),
      StrToFloatDef(edtAmount.Text, 0), edtExComment.Text);
  ModalResult := mrOk;
end;

procedure TfrmOneFoodIntake.chkActiveClick(Sender: TObject);
begin
  FetchFoodItemsList(lstFoodList.ItemIndex, chkActive.Checked);
end;

procedure TfrmOneFoodIntake.edtAmountExit(Sender: TObject);
begin
  edtAmount.Text := EvalFormula(edtAmount.Text, 'количество');
end;

procedure TfrmOneFoodIntake.edtFilterNameChange(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to lstFoodList.Count - 1 do
    if MatchPartialStringsNoCase(lstFoodList.Items[i], edtFilterName.Text) then begin
      lstFoodList.ItemIndex := i;
      break;
    end;
end;

procedure TfrmOneFoodIntake.FetchFoodItemsList(ASelected: Integer; AAll: Boolean);
begin
  lstFoodList.Clear;
  FetchFoodList(lstFoodList.Items, AAll);
  if lstFoodList.Items.Count > 0 then begin
    if ASelected < lstFoodList.Items.Count then
      lstFoodList.ItemIndex := ASelected
    else
      lstFoodList.ItemIndex := lstFoodList.Items.Count - 1;
    lstFoodListClick(lstFoodList);
  end;
end;

procedure TfrmOneFoodIntake.FormCreate(Sender: TObject);
begin
  FetchFoodItemsList(0, chkActive.Checked);
end;

procedure TfrmOneFoodIntake.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
    btnCancelClick(Sender);
end;

procedure TfrmOneFoodIntake.FormShow(Sender: TObject);
var
  AFoodId, i: Integer;
  AAmount: Double;
  AComment: String;
  ADate: TDateTime;
begin
  if FId > 0 then begin
    FetchFoodIntake(FId, ADate, AFoodId, AAmount, AComment);
    for i := 0 to lstFoodList.Count - 1 do
      if Integer(lstFoodList.Items.Objects[i]) = AFoodId then begin
        lstFoodList.ItemIndex := i;
        break;
      end;
    FDefaultDate := ADate;
    edtAmount.Text := FloatToStr(AAmount);
    edtExComment.Text := AComment;
  end;
  dtpDate.DateTime := FDefaultDate
end;

procedure TfrmOneFoodIntake.lstFoodListClick(Sender: TObject);
var
  AComment, AUnit: String;
begin
  FetchFoodInfo(Integer(lstFoodList.Items.Objects[lstFoodList.ItemIndex]), AUnit, AComment);
  mmoComment.Lines.Text := AComment;
  lblUnitName.Caption := AUnit;
end;

procedure TfrmOneFoodIntake.lstFoodListDblClick(Sender: TObject);
begin
  if EditFoodItemById(Integer(lstFoodList.Items.Objects[lstFoodList.ItemIndex])) then
    FetchFoodItemsList(lstFoodList.ItemIndex, chkActive.Checked);
end;

end.
