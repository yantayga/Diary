unit OneTrackEvent;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TfrmTrackEvent = class(TForm)
    lblDate: TLabel;
    dtpDate: TDateTimePicker;
    lblExList: TLabel;
    lblParam0: TLabel;
    edtParam0: TEdit;
    lblUnit0: TLabel;
    edtExComment: TEdit;
    btnOk: TButton;
    btnCancel: TButton;
    chkAll: TCheckBox;
    lstParameters: TListBox;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure chkAllClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure edtParam0Exit(Sender: TObject);
    procedure lstParametersClick(Sender: TObject);
  private
    FDefaultDate: TDate;
    FInitShowAll: Boolean;
  public
    { Public declarations }
  end;

function AddNewTrackEvent(ADate: TDate; AShowAll: Boolean): Boolean;

implementation

uses Database,ExpressionsEvauator;

{$R *.dfm}

function AddNewTrackEvent(ADate: TDate; AShowAll: Boolean): Boolean;
var
  dlg: TfrmTrackEvent;
begin
  try
    dlg := TfrmTrackEvent.Create(nil);
    dlg.FDefaultDate := ADate;
    dlg.FInitShowAll := AShowAll;
    Result := dlg.ShowModal = idOk;
  finally
    if Assigned(dlg) then FreeAndNil(dlg);
  end;
end;


procedure TfrmTrackEvent.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmTrackEvent.btnOkClick(Sender: TObject);
var
  n: Double;
begin
  edtParam0Exit(Sender);
  if not TryStrToFloat(edtParam0.Text, n) then begin
    MessageDlg('Неверное значение', mtError, [mbOk], -1);
    Exit;
  end;

  AddTrackEvent(dtpDate.DateTime, Integer(lstParameters.Items.Objects[lstParameters.ItemIndex]),
    StrToFloatDef(edtParam0.Text, 0), edtExComment.Text);
  ModalResult := mrOk;
end;

procedure TfrmTrackEvent.chkAllClick(Sender: TObject);
var
  SavedIndex : Pointer;
  i: Integer;
begin
  SavedIndex := nil;
  if lstParameters.ItemIndex <> -1 then
    SavedIndex := lstParameters.Items.Objects[lstParameters.ItemIndex];
  lstParameters.Clear;
  FetchParametersList(lstParameters.Items, chkAll.Checked);
  for i := 0 to lstParameters.Items.Count - 1 do
    if lstParameters.Items.Objects[i] = SavedIndex then begin
      lstParameters.ItemIndex := i;
      break;
    end;
end;

procedure TfrmTrackEvent.edtParam0Exit(Sender: TObject);
begin
  edtParam0.Text := EvalFormula(edtParam0.Text, 'значение');
end;

procedure TfrmTrackEvent.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
    btnCancelClick(Sender);
end;

procedure TfrmTrackEvent.FormShow(Sender: TObject);
begin
  dtpDate.DateTime := FDefaultDate;
  chkAll.Checked := FInitShowAll;
  FetchParametersList(lstParameters.Items, chkAll.Checked);
  if lstParameters.Items.Count > 0 then begin
    lstParameters.ItemIndex := 0;
    lstParametersClick(lstParameters);
  end;
end;

procedure TfrmTrackEvent.lstParametersClick(Sender: TObject);
var
  AParamName: String;
begin
  FetchParameterInfo(Integer(lstParameters.Items.Objects[lstParameters.ItemIndex]), AParamName);
  lblUnit0.Caption := AParamName;
end;

end.
