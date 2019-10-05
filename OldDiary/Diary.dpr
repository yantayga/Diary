program Diary;

uses
  Forms,
  Main in 'Main.pas' {frmMain},
  SQLite3 in 'sqlite\SQLite3.pas',
  SQLite3Utils in 'sqlite\SQLite3Utils.pas',
  SQLite3Wrap in 'sqlite\SQLite3Wrap.pas',
  Database in 'Database.pas',
  ExercisesList in 'ExercisesList.pas' {Form1},
  OneExercise in 'OneExercise.pas' {Form2},
  OneExecution in 'OneExecution.pas' {frmOneExecution},
  OneTrackEvent in 'OneTrackEvent.pas' {frmTrackEvent},
  OneFoodIntake in 'OneFoodIntake.pas' {frmOneFoodIntake},
  OneFood in 'OneFood.pas' {frmOneFood},
  OneTag in 'OneTag.pas' {frmOneTag},
  ReportView in 'ReportView.pas' {frmReportView},
  LocalUtils in 'LocalUtils.pas',
  ExpressionsEvauator in 'ExpressionsEvauator.pas',
  Options in 'Options.pas',
  Reports in 'Reports.pas',
  LocalTypes in 'LocalTypes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
