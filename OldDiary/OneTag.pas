unit OneTag;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmOneTag = class(TForm)
    btnCancel: TButton;
    btnOk: TButton;
    lblName: TLabel;
    edtName: TEdit;
    chkAutoReset: TCheckBox;
    mmoComments: TMemo;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function AddNewTag: Boolean;


implementation

{$R *.dfm}

function AddNewTag: Boolean;
var
  dlg: TfrmOneTag;
begin
  try
    dlg := TfrmOneTag.Create(nil);
    Result := dlg.ShowModal = idOk;
  finally
    if Assigned(dlg) then FreeAndNil(dlg);
  end;
end;

procedure TfrmOneTag.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmOneTag.btnOkClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

end.
