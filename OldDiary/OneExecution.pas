unit OneExecution;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TfrmOneExecution = class(TForm)
    lblParam0: TLabel;
    edtParam0: TEdit;
    lblUnit0: TLabel;
    btnOk: TButton;
    btnCancel: TButton;
    lblParam1: TLabel;
    edtParam1: TEdit;
    lblUnit1: TLabel;
    mmoComment: TMemo;
    edtExComment: TEdit;
    lblDate: TLabel;
    dtpDate: TDateTimePicker;
    lblParam2: TLabel;
    edtParam2: TEdit;
    lblUnit2: TLabel;
    lstExList: TListBox;
    chkShowAll: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure edtParam0Exit(Sender: TObject);
    procedure edtParam1Exit(Sender: TObject);
    procedure edtParam2Exit(Sender: TObject);
    procedure lstExListClick(Sender: TObject);
    procedure edtExCommentKeyPress(Sender: TObject; var Key: Char);
    procedure chkShowAllClick(Sender: TObject);
  private
    FDefaultDate: TDate;
    FCommentEdited: Boolean;
    FId: Integer;

    procedure DoFetchExList(ASelected: Integer);
  public
    { Public declarations }
  end;

function AddNewExecution(ADate: TDate; var AId: Integer): Boolean;

implementation

uses Math, DataBase, ExpressionsEvauator;

{$R *.dfm}

function AddNewExecution(ADate: TDate; var AId: Integer): Boolean;
var
  dlg: TfrmOneExecution;
begin
  try
    dlg := TfrmOneExecution.Create(nil);
    dlg.FDefaultDate := ADate;
    Result := dlg.ShowModal = idOk;
    AId := dlg.FId;
  finally
    if Assigned(dlg) then FreeAndNil(dlg);
  end;
end;

procedure TfrmOneExecution.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmOneExecution.btnOkClick(Sender: TObject);
var
  n: Double;
begin
  if lblParam0.Visible then begin
    edtParam0Exit(Sender);
    if not TryStrToFloat(edtParam0.Text, n) then begin
      MessageDlg('Неверное значение', mtError, [mbOk], -1);
      Exit;
    end;
  end;

  if lblParam1.Visible then
    edtParam1Exit(Sender);
  if lblParam2.Visible then
    edtParam2Exit(Sender);

  AddExecution(dtpDate.DateTime, Integer(lstExList.Items.Objects[lstExList.ItemIndex]),
    StrToFloatDef(edtParam0.Text, 0), StrToFloatDef(edtParam1.Text, 0),
    StrToFloatDef(edtParam2.Text, 0), edtExComment.Text, FId);
  FId := Integer(lstExList.Items.Objects[lstExList.ItemIndex]);
  ModalResult := mrOk;
end;

procedure TfrmOneExecution.chkShowAllClick(Sender: TObject);
begin
  DoFetchExList(lstExList.ItemIndex);
end;

procedure TfrmOneExecution.lstExListClick(Sender: TObject);
var
  AParamsCount: Integer;
  AParam0Name, AParam0Unit, AParam1Name, AParam1Unit, AParam2Name, AParam2Unit, AComment, ALastComment: String;
begin
  if lstExList.ItemIndex = -1 then
    Exit;

  FetchExInfo(Integer(lstExList.Items.Objects[lstExList.ItemIndex]),
    AParamsCount, AParam0Name, AParam0Unit, AParam1Name, AParam1Unit, AParam2Name, AParam2Unit, AComment, ALastComment);
  mmoComment.Lines.Text := AComment;
  if AParamsCount > 0 then begin
    lblParam0.Visible := True;
    lblParam0.Caption := AParam0Name;
    edtParam0.Visible := True;
    lblUnit0.Visible := True;
    lblUnit0.Caption := AParam0Unit;
  end else begin
    lblParam0.Visible := False;
    edtParam0.Visible := False;
    lblUnit0.Visible := False;
  end;

  lblParam1.Visible := AParamsCount > 1;
  edtParam1.Visible := AParamsCount > 1;
  lblUnit1.Visible := AParamsCount > 1;

  lblParam1.Caption := AParam1Name;
  lblUnit1.Caption := AParam1Unit;

  lblParam2.Visible := AParamsCount > 2;
  edtParam2.Visible := AParamsCount > 2;
  lblUnit2.Visible := AParamsCount > 2;

  lblParam2.Caption := AParam2Name;
  lblUnit2.Caption := AParam2Unit;

  if not FCommentEdited then
    edtExComment.Text := ALastComment;
end;

procedure TfrmOneExecution.edtExCommentKeyPress(Sender: TObject; var Key: Char);
begin
  FCommentEdited := True;
end;

procedure TfrmOneExecution.edtParam0Exit(Sender: TObject);
begin
  edtParam0.Text := EvalFormula(edtParam0.Text, lblParam0.Caption);
end;

procedure TfrmOneExecution.edtParam1Exit(Sender: TObject);
begin
  edtParam1.Text := EvalFormula(edtParam1.Text, lblParam1.Caption);
end;

procedure TfrmOneExecution.edtParam2Exit(Sender: TObject);
begin
  edtParam2.Text := EvalFormula(edtParam2.Text, lblParam2.Caption);
end;

procedure TfrmOneExecution.DoFetchExList(ASelected: Integer);
begin
  lstExList.Clear;
  FetchExList(lstExList.Items, chkShowAll.Checked);
  lstExList.ItemIndex := Min(ASelected, lstExList.Items.Count-1);
  lstExListClick(lstExList);
end;

procedure TfrmOneExecution.FormCreate(Sender: TObject);
begin
  FCommentEdited := False;
  DoFetchExList(0);
end;

procedure TfrmOneExecution.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
    btnCancelClick(Sender);
end;

procedure TfrmOneExecution.FormShow(Sender: TObject);
begin
  dtpDate.DateTime := FDefaultDate;
end;

end.
