unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, ActnList, Menus, ImgList, ExtCtrls, StdCtrls,
  Chart, Series, Reports;

type
  TfrmMain = class(TForm)
    sbMain: TStatusBar;
    tbMain: TToolBar;
    tbAdd: TToolButton;
    tbSeparator2: TToolButton;
    mnuMain: TMainMenu;
    mniFile: TMenuItem;
    mniClose: TMenuItem;
    mniExercises: TMenuItem;
    mniExList: TMenuItem;
    mniAddExercise: TMenuItem;
    mniDelExercise: TMenuItem;
    alMain: TActionList;
    actClose: TAction;
    actAddExecution: TAction;
    ilMain: TImageList;
    actAddTrackEvent: TAction;
    tbAddTrackEvent: TToolButton;
    pnlLeft: TPanel;
    mcDay: TMonthCalendar;
    pcMain: TPageControl;
    tabExercises: TTabSheet;
    tabFood: TTabSheet;
    tabParameters: TTabSheet;
    lvOthersList: TListView;
    lvFoodList: TListView;
    tbSeparator1: TToolButton;
    tbAddFood: TToolButton;
    tabNotes: TTabSheet;
    mmoNotes: TMemo;
    tabSchedule: TTabSheet;
    lvSchedule: TListView;
    pnlParameterOptions: TPanel;
    chkShowAllParameters: TCheckBox;
    actAddFoodIntake: TAction;
    splFood: TSplitter;
    pgParameterGroups: TPageControl;
    mnuPopupFood: TPopupMenu;
    mniEditFootItem: TMenuItem;
    actEditFoodByIntake: TAction;
    mniAddFoodIntake: TMenuItem;
    mniFood: TMenuItem;
    mniMainAddFoodInake: TMenuItem;
    mniMainEditFood: TMenuItem;
    actEditFoodIntake: TAction;
    mniEditFoodIntake: TMenuItem;
    chkShowAllFoodParameters: TCheckBox;
    actDeleteFoodIntake: TAction;
    mniDeleteFoodIntake: TMenuItem;
    tabRepors: TTabSheet;
    tbSeparator3: TToolButton;
    tbAddScheduleItem: TToolButton;
    actAddScheduleItem: TAction;
    actAddTag: TAction;
    mnuPopupTags: TPopupMenu;
    mniAddTag: TMenuItem;
    mniEmptyLine: TMenuItem;
    lvTags: TListView;
    lvExList: TListView;
    splTag: TSplitter;
    splExeecise: TSplitter;
    pnlExercise: TPanel;
    mmoExComment: TMemo;
    lvExersizeItems: TListView;
    splExercizeItems: TSplitter;
    pnlExName: TPanel;
    splParameters: TSplitter;
    pnlParametersGraphics: TPanel;
    chkParametersChartStartDate: TCheckBox;
    chkParametersChartEndDate: TCheckBox;
    dtChartStart: TDateTimePicker;
    dtChartEnd: TDateTimePicker;
    lblChartDates: TLabel;
    lblChartDaysForPoint: TLabel;
    edtChartDaysForPoint: TEdit;
    chkShowParametersGraph: TCheckBox;
    mmoPermanentNote: TMemo;
    splNotes: TSplitter;
    lstReports: TListBox;
    pnlReportParameters: TPanel;
    btnDoReport: TButton;
    procedure tbNowClick(Sender: TObject);
    procedure actCloseExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure actAddExecutionExecute(Sender: TObject);
    procedure actAddTrackEventExecute(Sender: TObject);
    procedure mcDayClick(Sender: TObject);
    procedure mmoNotesExit(Sender: TObject);
    procedure chkShowAllParametersClick(Sender: TObject);
    procedure actAddFoodIntakeExecute(Sender: TObject);
    procedure lvFoodListSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure actEditFoodByIntakeExecute(Sender: TObject);
    procedure actEditFoodByIntakeUpdate(Sender: TObject);
    procedure actEditFoodIntakeUpdate(Sender: TObject);
    procedure actEditFoodIntakeExecute(Sender: TObject);
    procedure chkShowAllFoodParametersClick(Sender: TObject);
    procedure actDeleteFoodIntakeExecute(Sender: TObject);
    procedure actDeleteFoodIntakeUpdate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure lvFoodListDblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure pgParameterGroupsResize(Sender: TObject);
    procedure actAddTagExecute(Sender: TObject);
    procedure lvExListSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure pnlParametersGraphicsResize(Sender: TObject);
    procedure lvOthersListSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure chkParametersChartStartDateClick(Sender: TObject);
    procedure dtChartStartChange(Sender: TObject);
    procedure edtChartDaysForPointChange(Sender: TObject);
    procedure chkShowParametersGraphClick(Sender: TObject);
    procedure tabReporsResize(Sender: TObject);
    procedure lstReportsClick(Sender: TObject);
    procedure btnDoReportClick(Sender: TObject);
  private
    chrParameters: TChart;
    chrParametersSeries: TFastLineSeries;
    FCurrentReport: TReport;

    procedure LoadOptions;
    procedure LoadColumnsOptions(AListView: TListView);

    procedure SaveOptions;
    procedure SaveColumnsOptions(AListView: TListView);
    

    procedure UpdateExercisesPage(ASelectedId: Integer);
    procedure UpdateExerciseItems;
    procedure UpdateTags;
    procedure UpdateFoodPage;
    procedure UpdateFoodParameters;
    procedure UpdateParametersPage;
    procedure CreateReports;
    procedure DrawParametersChart;
    procedure UpdateAllPages;
    procedure MyDrawItem(Sender: TCustomListView; Item: TListItem; Rect: TRect;
      State: TOwnerDrawState);
  public
    { Public declarations }
  end;

  TMyListView = class(ComCtrls.TListView)
  private
     procedure CNMeasureItem(var Msg : TWMMeasureItem); message CN_MEASUREITEM;
  end;

var
  frmMain: TfrmMain;

implementation

uses LocalTypes, DataBase, Options, LocalUtils,
     OneExecution, OneTrackEvent, OneFoodIntake, OneFood, OneTag;

{$R *.dfm}

procedure TfrmMain.actAddExecutionExecute(Sender: TObject);
var
  AId: Integer;
begin
  if AddNewExecution(mcDay.Date, AId) then
    UpdateExercisesPage(AId);
end;

procedure TfrmMain.actAddTagExecute(Sender: TObject);
begin
  if AddNewTag then
    UpdateTags;
end;

procedure TfrmMain.actAddTrackEventExecute(Sender: TObject);
begin
  if AddNewTrackEvent(mcDay.Date, chkShowAllParameters.Checked) then
    UpdateParametersPage;
end;

procedure TfrmMain.actCloseExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.actDeleteFoodIntakeExecute(Sender: TObject);
var
  Id: Integer;
begin
  if Assigned(lvFoodList.Selected) then
    Id := Integer(lvFoodList.Selected.Data)
  else
    Exit;
  if ConfirmAction('Действительно удалить?') then begin
    DeleteFoodIntake(Id);
    UpdateFoodPage;
  end;
end;

procedure TfrmMain.actDeleteFoodIntakeUpdate(Sender: TObject);
begin
  actDeleteFoodIntake.Enabled := Assigned(lvFoodList.Selected);
end;

procedure TfrmMain.actEditFoodByIntakeExecute(Sender: TObject);
var
  Id: Integer;
begin
  Id := 0;
  if Assigned(lvFoodList.Selected) then
    Id := Integer(lvFoodList.Selected.Data);
  if EditFoodItemByIntake(Id) then
    UpdateFoodPage;
end;

procedure TfrmMain.actEditFoodByIntakeUpdate(Sender: TObject);
begin
  if Assigned(lvFoodList.Selected) then
    actEditFoodByIntake.Caption := 'Редактировать продукт'
  else
    actEditFoodByIntake.Caption := 'Добавить продукт'
end;

procedure TfrmMain.actEditFoodIntakeExecute(Sender: TObject);
var
  Id: Integer;
begin
  Id := 0;
  if Assigned(lvFoodList.Selected) then
    Id := Integer(lvFoodList.Selected.Data);
  if EditFoodIntake(Id) then
    UpdateFoodPage;
end;

procedure TfrmMain.actEditFoodIntakeUpdate(Sender: TObject);
begin
  actEditFoodIntake.Enabled := Assigned(lvFoodList.Selected);
end;

procedure TfrmMain.btnDoReportClick(Sender: TObject);
begin
  if Assigned(FCurrentReport) then
    FCurrentReport.Generate;
end;

procedure TfrmMain.actAddFoodIntakeExecute(Sender: TObject);
begin
  if AddNewFoodIntake(mcDay.Date) then
    UpdateFoodPage;
end;

procedure TfrmMain.chkShowAllParametersClick(Sender: TObject);
begin
  UpdateParametersPage;
end;

procedure TfrmMain.chkShowParametersGraphClick(Sender: TObject);
begin
  DrawParametersChart;
end;

procedure TfrmMain.CreateReports;
begin
  FetchReports(lstReports.Items);
end;

procedure TfrmMain.DrawParametersChart;
var
  dBegin, dEnd: TDateTime;
  n: Integer;
begin
  pnlParametersGraphics.Visible := chkShowParametersGraph.Checked;
  if not pnlParametersGraphics.Visible then
    Exit;
  chrParameters.Visible := Assigned(lvOthersList.Selected) and TryStrToInt(edtChartDaysForPoint.Text, n);
  if not chrParameters.Visible then
    Exit;

  if chkParametersChartStartDate.Checked then
    dBegin := dtChartStart.Date
  else
    dBegin := 0;
  if chkParametersChartEndDate.Checked then
    dEnd := dtChartEnd.Date
  else
    dEnd := MaxDateTime;

  chrParametersSeries.Clear;
  FetchParameterSerie(dBegin, dEnd, Integer(lvOthersList.Selected.Data), n, chrParametersSeries);
end;

procedure TfrmMain.dtChartStartChange(Sender: TObject);
begin
  DrawParametersChart;
end;

procedure TfrmMain.edtChartDaysForPointChange(Sender: TObject);
begin
  DrawParametersChart;
end;

procedure TfrmMain.chkParametersChartStartDateClick(Sender: TObject);
begin
  DrawParametersChart;
end;

procedure TfrmMain.chkShowAllFoodParametersClick(Sender: TObject);
begin
  UpdateFoodParameters;
end;

procedure TfrmMain.UpdateFoodParameters;
var
  li: TListItem;
  FPData: TDayFoodParameters;
  i, j: Integer;
  TabSheet: TTabSheet;
  ListView: TMyListView;
  SelectedItems: String;
begin
  SelectedItems := '';
  for i := 0 to lvFoodList.Items.Count - 1 do begin
    li := lvFoodList.Items[i];
    if li.Selected then
      if SelectedItems = '' then
        SelectedItems := IntToStr(Integer(li.Data))
      else
        SelectedItems := SelectedItems + ',' + IntToStr(Integer(li.Data));
  end;

  SetLength(FPData, 0);
  FetchParameterPage(mcDay.Date, SelectedItems, FPData);
  for i := 0 to pgParameterGroups.PageCount - 1 do begin
    TabSheet := pgParameterGroups.Pages[i];
    ListView := TMyListView(TabSheet.Tag);
    LockWindowUpdate(ListView.Handle);
    ListView.Items.Clear;
    for j := 0 to Length(FPData) - 1 do begin
      if FPData[j].IdPage <> Cardinal(ListView.Tag) then
        continue;
      if not FPData[j].IsMain and not chkShowAllFoodParameters.Checked then
        continue;
      li := ListView.Items.Add;
      li.Data := Pointer(FPData[j].Id);
      li.Caption := FPData[j].Name;
      if FPData[j].IdParent > 0 then
        li.Caption := '  |- ' + li.Caption;
      li.SubItems.Add(FloatToStr(SmartRound(FPData[j].Amount)));
      li.SubItems.Add(FPData[j].UnitM);
      li.SubItems.Add(FloatToStr(FPData[j].TargetMin));
      li.SubItems.Add(FloatToStr(FPData[j].TargetMax));
    end;
    LockWindowUpdate(0);
  end;
end;

procedure TfrmMain.UpdateTags;
var
  sl: TStringList;
  i: Integer;
  li: TListItem;
begin
  LockWindowUpdate(lvTags.Handle);
  lvTags.Items.Clear;
  sl := TStringList.Create;
  FetchTagList(sl, mcDay.Date);
  for i := 0 to sl.Count - 1 do begin
    li := lvTags.Items.Add;
    li.Data := sl.Objects[i];
    li.Caption := sl[i];
  end;
  LockWindowUpdate(0);
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveOptions;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  chrParameters := TChart.Create(pnlParametersGraphics);
  chrParameters.Parent := pnlParametersGraphics;
  chrParameters.Align := alBottom;
  chrParameters.BevelInner := bvNone;
  chrParameters.BevelOuter := bvNone;
  chrParameters.BevelWidth := 1;
  chrParameters.AllowZoom := True;
  chrParameters.View3D := False;
  chrParameters.Legend.Visible := False;

  chrParametersSeries := TFastLineSeries.Create(chrParameters);
  chrParametersSeries.ParentChart := chrParameters;
  chrParametersSeries.XValues.DateTime := True;

  CreateTables;
end;

procedure TfrmMain.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_INSERT: begin
      case pcMain.ActivePageIndex of
        0: actAddExecution.Execute;
        1: actAddFoodIntake.Execute;  
        2: actAddTrackEvent.Execute;
        3: actAddScheduleItem.Execute;  
      end;
    end;  
    VK_DELETE: begin
      case pcMain.ActivePageIndex of
        1: actDeleteFoodIntake.Execute;  
      end;
    end;
  end;
end;

procedure TfrmMain.FormShow(Sender: TObject);
var
  FoodParametersPages: TStrings;
  i: Integer;
  TabSheet: TTabSheet;
  ListView: TListView;
begin
  LoadOptions;

  mcDay.Date := Now;

  dtChartStart.Date := Now;
  dtChartEnd.Date := Now;

  FoodParametersPages := TStringList.Create;
  FetchParameterPageList(FoodParametersPages);
  for i := 0 to FoodParametersPages.Count - 1 do begin
    TabSheet := TTabSheet.Create(pgParameterGroups);
    TabSheet.Caption := FoodParametersPages[i];
    TabSheet.PageControl := pgParameterGroups;
    ListView := TMyListView.Create(TabSheet);
    ListView.Align := alClient;
    ListView.Parent := TabSheet;
    ListView.Tag := Integer(FoodParametersPages.Objects[i]);
    ListView.Columns.Add;
    ListView.Columns.Add;
    ListView.Columns.Add;
    ListView.Columns.Add;
    ListView.Column[0].Width := 180;
    ListView.Column[0].MinWidth := 100;
    ListView.Column[0].MaxWidth := 300;
    ListView.Column[1].Width := 80;
    ListView.Column[1].MinWidth := 80;
    ListView.Column[1].MaxWidth := 80;
    ListView.Column[2].Width := 1;
    ListView.Column[2].MinWidth := 1;
    ListView.Column[2].MaxWidth := 1;
    ListView.Column[3].Width := 300;
    ListView.Column[3].MinWidth := 300;
    ListView.Column[3].MaxWidth := 100000;
    ListView.Name := 'lvFoodParametersPages' + IntToStr(i);
    LoadColumnsOptions(ListView);
    ListView.ViewStyle := vsReport;
    ListView.OwnerDraw := True;
    ListView.ReadOnly := True;
    ListView.HideSelection := True;
    ListView.OnDrawItem := MyDrawItem;
    TabSheet.Tag := Integer(ListView);
  end;
  FoodParametersPages.Free;

  UpdateAllPages;
  DrawParametersChart;
  CreateReports;
end;

procedure TfrmMain.LoadColumnsOptions(AListView: TListView);
var
  i: Integer;
begin
  for i := 0 to AListView.Columns.Count - 1 do
    AListView.Column[i].Width := LoadOptionInt('MainForm_' + AListView.Name + '_ColWidth_' + IntToStr(i), AListView.Column[i].Width);
end;

procedure TfrmMain.LoadOptions;
begin
  Width := LoadOptionInt('MainForm_Width', Width);
  Height := LoadOptionInt('MainForm_Height', Height);
  pcMain.ActivePageIndex := LoadOptionInt('MainForm_ActivePage', pcMain.ActivePageIndex);
  lvTags.Height := LoadOptionInt('MainForm_lvTags_Height', lvTags.Height);

  LoadColumnsOptions(lvExList);
  pnlExercise.Height := LoadOptionInt('MainForm_pnlExercise_Height', pnlExercise.Height);
  LoadColumnsOptions(lvExersizeItems);
  mmoExComment.Width := LoadOptionInt('MainForm_mmoExComment_Width', mmoExComment.Width);

  LoadColumnsOptions(lvFoodList);
  lvFoodList.Height := LoadOptionInt('MainForm_lvFoodList_Height', lvFoodList.Height);

  LoadColumnsOptions(lvOthersList);
  pnlParametersGraphics.Height := LoadOptionInt('MainForm_pnlParametersGraphics_Height', pnlParametersGraphics.Height);
  chkShowParametersGraph.Checked := LoadOptionBool('MainForm_chkShowParametersGraph_Checked', chkShowParametersGraph.Checked);

  LoadColumnsOptions(lvSchedule);

  mmoPermanentNote.Lines.Text := LoadOptionString('PermanentNote', '');
  mmoPermanentNote.Height := LoadOptionInt('MainForm_mmoPermanentNote_Height', mmoPermanentNote.Height);
end;

procedure TfrmMain.SaveColumnsOptions(AListView: TListView);
var
  i: Integer;
begin
  for i := 0 to AListView.Columns.Count - 1 do
    SaveOptionInt('MainForm_' + AListView.Name + '_ColWidth_' + IntToStr(i), AListView.Column[i].Width);
end;

procedure TfrmMain.SaveOptions;
var
  i: Integer;
begin
  BeginTransaction;

  SaveOptionInt('MainForm_Width', Width);
  SaveOptionInt('MainForm_Height', Height);
  SaveOptionInt('MainForm_ActivePage', pcMain.ActivePageIndex);
  SaveOptionInt('MainForm_lvTags_Height', lvTags.Height);

  SaveColumnsOptions(lvExList);
  SaveOptionInt('MainForm_pnlExercise_Height', pnlExercise.Height);
  SaveColumnsOptions(lvExersizeItems);
  SaveOptionInt('MainForm_mmoExComment_Width', mmoExComment.Width);

  SaveColumnsOptions(lvFoodList);
  SaveOptionInt('MainForm_lvFoodList_Height', lvFoodList.Height);
  for i := 0 to pgParameterGroups.PageCount - 1 do
    SaveColumnsOptions(TMyListView(pgParameterGroups.Pages[i].Tag));

  SaveColumnsOptions(lvOthersList);
  SaveOptionInt('MainForm_pnlParametersGraphics_Height', pnlParametersGraphics.Height);
  SaveOptionBool('MainForm_chkShowParametersGraph_Checked', chkShowParametersGraph.Checked);

  SaveColumnsOptions(lvSchedule);

  SaveOptionString('PermanentNote', mmoPermanentNote.Lines.Text);
  SaveOptionInt('MainForm_mmoPermanentNote_Height', mmoPermanentNote.Height);

  CommitTransaction;
end;

procedure TfrmMain.lstReportsClick(Sender: TObject);
var
  iniData: String;
begin
  if Assigned(FCurrentReport) then
    FreeAndNil(FCurrentReport);
  if lstReports.ItemIndex <> -1 then begin
    FetchReportData(Integer(lstReports.Items.Objects[lstReports.ItemIndex]), iniData);
    FCurrentReport := TReport.CreateFromString(iniData);
    FCurrentReport.CreateControls(pnlReportParameters);
  end;
end;

procedure TfrmMain.lvExListSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  UpdateExerciseItems;
end;

procedure TfrmMain.lvFoodListDblClick(Sender: TObject);
begin
  actEditFoodIntake.Execute;
end;

procedure TfrmMain.lvFoodListSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  UpdateFoodParameters;
end;

procedure TfrmMain.lvOthersListSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  DrawParametersChart;
end;

procedure TfrmMain.MyDrawItem(Sender: TCustomListView; Item: TListItem;
  Rect: TRect; State: TOwnerDrawState);
var
  rc: TRect;
  s: String;
  a, b1, b2: Real;
  pcnt1, pcnt2: Integer;
begin
  SetBkMode(Sender.Canvas.Handle, TRANSPARENT);
  Sender.Canvas.Pen.Color := clGreen;
  if odSelected in State then
    Sender.Canvas.Brush.Color := clSkyBlue
  else
    Sender.Canvas.Brush.Color := RGB(220,220,220);
  rc := Rect;
  rc.Right := Sender.ClientWidth;
  Sender.Canvas.FillRect(rc);

  Sender.Canvas.Font.Color := clBlack;
  rc.Right := Sender.Column[0].Width;
  s := Item.Caption;
  Sender.Canvas.TextRect(rc, s, [tfEndEllipsis, tfSingleLine, tfLeft, tfVerticalCenter]);

  rc.Left := rc.Left + Sender.Column[0].Width;
  rc.Right := rc.Left + Sender.Column[1].Width + Sender.Column[2].Width;
  s := Item.SubItems[0] + ' ' + Item.SubItems[1];
  Sender.Canvas.TextRect(rc, s, [tfPathEllipsis, tfSingleLine, tfLeft, tfVerticalCenter]);

  rc.Left := rc.Left + Sender.Column[1].Width + Sender.Column[2].Width;
  rc.Right := Sender.ClientWidth;
  a := StrToFloat(Item.SubItems[0]);
  b1 := StrToFloat(Item.SubItems[2]);
  b2 := StrToFloat(Item.SubItems[3]);
  if b1 > 0 then begin
    pcnt1 := Round(100.0 * a / b1);
    if b2 > 0 then
      pcnt2 := Round(100.0 * a / b2)
    else
      pcnt2 := 0;
    Sender.Canvas.Brush.Color := clGray;
    rc.Right := Sender.ClientWidth;
    Sender.Canvas.FillRect(rc);
    if pcnt1 < 100 then
      Sender.Canvas.Brush.Color := RGB(44,83,123)
    else if pcnt2 >= 100 then
      Sender.Canvas.Brush.Color := RGB(122,44,54)
    else
      Sender.Canvas.Brush.Color := RGB(17,65,10);
    Sender.Canvas.Font.Style := [fsBold];
    Sender.Canvas.Refresh;
    Sender.Canvas.Font.Color := clWhite;
    if pcnt2 >= 100 then
      Sender.Canvas.Font.Color := clYellow
    else
      Sender.Canvas.Font.Color := clWhite;
    rc.Right := rc.Left + ((rc.Right - rc.Left) * pcnt1) div 100;
    Sender.Canvas.FillRect(rc);
    Sender.Canvas.Brush.Color := RGB(200,200,200);
    rc.Right := Sender.Width;
    Sender.Canvas.FrameRect(rc);
    if Item.SubItems[3] = '0' then
      s := IntToStr(pcnt1) + '% (' + Item.SubItems[2] + ')'
    else
      s := IntToStr(pcnt1) + '% (' + Item.SubItems[2] + ' - ' + Item.SubItems[3] + ')';
    Sender.Canvas.Brush.Style := bsClear;
    Sender.Canvas.TextRect(rc, s, [tfEndEllipsis, tfSingleLine, tfCenter, tfVerticalCenter]);
  end else begin
    Sender.Canvas.Brush.Color := RGB(180,180,180);
    Sender.Canvas.FillRect(rc);
  end;
end;

procedure TfrmMain.pgParameterGroupsResize(Sender: TObject);
begin
  chkShowAllFoodParameters.Top := pgParameterGroups.Top + 2;
  chkShowAllFoodParameters.Left := pgParameterGroups.Left + pgParameterGroups.Width - chkShowAllFoodParameters.Width - 6;
end;

procedure TfrmMain.pnlParametersGraphicsResize(Sender: TObject);
begin
  chrParameters.Height := pnlParametersGraphics.ClientHeight - 40;
end;

procedure TfrmMain.mcDayClick(Sender: TObject);
begin
  UpdateAllPages;
end;

procedure TfrmMain.mmoNotesExit(Sender: TObject);
begin
  AddNote(mcDay.Date, mmoNotes.Lines.Text);
end;

procedure TfrmMain.tabReporsResize(Sender: TObject);
begin
  btnDoReport.Top := tabRepors.Height - 50;
end;

procedure TfrmMain.tbNowClick(Sender: TObject);
begin
  mcDay.Date := Now;
end;

procedure TfrmMain.UpdateAllPages;
var
  Note: String;
begin
  UpdateExercisesPage(-1);
  UpdateTags;
  UpdateFoodPage;
  UpdateParametersPage;

  FetchNote(mcDay.Date, Note);
  mmoNotes.Lines.Text := Note;
end;

procedure TfrmMain.UpdateExerciseItems;
var
  AData: TDayExerciseItems;
  li: TListItem;
  i: Integer;
  AName, AComment: String;
begin
  lvExersizeItems.Items.Clear;
  if not Assigned(lvExList.Selected) then begin
    pnlExName.Caption := '';
    mmoExComment.Lines.Text := '';
    Exit;
  end;
  FetchDayExerciseItems(mcDay.Date, Integer(lvExList.Selected.Data), AData, AName, AComment);
  for i := 0 to Length(AData) - 1 do begin
    li := lvExersizeItems.Items.Add;
    li.Data := Pointer(AData[i].Id);
    li.Caption := AData[i].Params;
    li.SubItems.Add(AData[i].Comments);
  end;
  pnlExName.Caption := AName + ' (всего ' + IntToStr(Length(AData)) + ')';
  mmoExComment.Lines.Text := AComment;
end;

procedure TfrmMain.UpdateExercisesPage(ASelectedId: Integer);
var
  AData: TDayExercises;
  li: TListItem;
  i: Integer;
begin
  if (ASelectedId = -1) and Assigned(lvExList.Selected) then
    ASelectedId := Integer(lvExList.Selected.Data);
  FetchDayExercises(mcDay.Date, AData);
  lvExList.Items.Clear;
  for i := 0 to Length(AData) - 1 do begin
    li := lvExList.Items.Add;
    if AData[i].Id = Cardinal(ASelectedId) then
      lvExList.Selected := li;
    li.Data := Pointer(AData[i].Id);
    li.Caption := AData[i].Name;
    li.SubItems.Add(AData[i].Params);
    li.SubItems.Add(AData[i].Total);
  end;
  UpdateExerciseItems;
end;

procedure TfrmMain.UpdateFoodPage;
var
  FData: TDayFoods;
  li: TListItem;
  i: Integer;
begin
  FetchDayFood(mcDay.Date, FData);
  lvFoodList.Items.Clear;
  for i := 0 to Length(FData) - 1 do begin
    li := lvFoodList.Items.Add;
    li.Data := Pointer(FData[i].Id);
    li.Caption := FData[i].Name;
    li.SubItems.Add(FData[i].Amount);
    li.SubItems.Add(FData[i].Comment);
  end;
  UpdateFoodParameters;
end;

procedure TfrmMain.UpdateParametersPage;
var
  OData: TDayOthers;
  li: TListItem;
  i: Integer;
begin
  FetchDayParameters(mcDay.Date, OData);

  lvOthersList.Items.Clear;
  for i := 0 to Length(OData) - 1 do begin
    if not OData[i].Main and not chkShowAllParameters.Checked then
      continue;
    li := lvOthersList.Items.Add;
    li.Data := Pointer(OData[i].Id);
    li.Caption := OData[i].Name;
    li.SubItems.Add(OData[i].Value);
    //li.SubItems.Add(OData[i].Comment);
  end;
end;

{ TMyListView }

procedure TMyListView.CNMeasureItem(var Msg: TWMMeasureItem);
begin
  Msg.MeasureItemStruct^.ItemHeight := 22;
  Msg.Result := 1;
end;

end.
