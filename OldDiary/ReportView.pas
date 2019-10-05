unit ReportView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, SHDocVw;

type
  TfrmReportView = class(TForm)
    wbReportView: TWebBrowser;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    FFileName: String;
  end;

  procedure OpenReportFile(AFileName: String);

implementation

{$R *.dfm}

procedure OpenReportFile(AFileName: String);
var
  dlg: TfrmReportView;
begin
  try
    dlg := TfrmReportView.Create(nil);
    dlg.FFileName := AFileName;
    dlg.ShowModal;
  finally
    if Assigned(dlg) then FreeAndNil(dlg);
  end;
end;

procedure TfrmReportView.FormShow(Sender: TObject);
begin
  wbReportView.Navigate(FFileName);
end;

end.
