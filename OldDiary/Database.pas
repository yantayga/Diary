unit Database;

interface

uses Classes, Series, LocalTypes;

  procedure BeginTransaction;
  procedure CommitTransaction;
  procedure RollbackTransaction;

  procedure CreateTables;

  procedure FetchUnitList(ARet: TStrings);

  procedure FetchExList(ARet: TStrings; AAll: Boolean);
  procedure FetchExInfo(AId: Integer; var AParamsCount: Integer;
    var AParam0Name, AParam0Unit, AParam1Name, AParam1Unit, AParam2Name, AParam2Unit, AComment, ALastComment: String);
  procedure AddExecution(ADate: TDateTime; AIdEx: Integer; AParam0, AParam1, AParam2: Double; AComment: String; var AId: Integer);

  procedure FetchParametersList(ARet: TStrings; AAll: Boolean);
  procedure FetchParameterInfo(AId: Integer; var AParamName: String);
  procedure AddTrackEvent(ADate: TDateTime; AIdParameter: Integer; AValue: Double; AComment: String);
  procedure FetchParameterSerie(ADateBegin, ADateEnd: TDateTime; AParameterId, ADaysForPoint: Integer; ASeries: TFastLineSeries);

  procedure FetchDayExercises(ADate: TDateTime; var ARetDE: TDayExercises);
  procedure FetchDayExerciseItems(ADate: TDateTime; AId: Integer; var ARetDE: TDayExerciseItems; var AName: String; var AComment: String);
  procedure FetchDayFood(ADate: TDateTime; var ARetDF: TDayFoods);
  procedure FetchDayParameters(ADate: TDateTime; var ARetDO: TDayOthers);

  procedure FetchNote(ADate: TDateTime; var ANote: String);
  procedure AddNote(ADate: TDateTime; ANote: String);

  procedure FetchFoodIntake(AId: Integer; var ADate: TDateTime; var AFoodId: Integer; var AAmount: Double; var AComment: String);
  procedure AddFoodIntake(ADate: TDateTime; AIdFood: Integer; AAmount: Double; AComment: String);
  procedure SaveFoodIntake(AId: Integer; ADate: TDateTime; AIdFood: Integer; AAmount: Double; AComment: String);
  procedure DeleteFoodIntake(AId: Integer);
  procedure FetchFoodList(ARet: TStrings; AAll: Boolean);
  procedure FetchFoodInfo(AId: Integer; var AUnitName: String; var AComment: String);
  procedure FetchFoodItemInfoById(AId: Integer; var AName: String; var AActive: Boolean;
    var ADefaultAmount: Double; var AUnit: Integer; var AComment: String);
  procedure FetchFoodItemInfoByIntake(AIntakeId: Integer; var AId: Integer; var AName: String;
    var AActive: Boolean; var ADefaultAmount: Double; var AUnit: Integer; var AComment: String);
  procedure SaveFoodItemInfoAndDeleteContent(AId: Integer; AName: String;
    AActive: Boolean; ADefaultAmount: Double; AUnit: Integer; AComment: String);
  procedure FetchFoodContent(AId: Integer; var AFoodParameterContents: TFoodParameterContents);
  procedure SaveFoodItemContent(AIdFood: Variant; AIdParameter: Integer; AValue: Extended);
  procedure FetchParameterPageList(ARet: TStrings);
  procedure FetchParameterPage(ADate: TDateTime; ASelected: String; var ARetDFP: TDayFoodParameters); overload;

  procedure SaveOptionToDatabase(AKey: String; AValue: String);
  function LoadOptionFromDatabase(AKey: String): String;

  procedure FetchTagList(ARet: TStrings; ADate: TDateTime);
  procedure AddTag(AName: String; APeriodBegin, APeriodEnd: TDateTime; AComment: String);

  procedure FetchReports(ARet: TStrings);
  procedure FetchReportData(AId: Integer; var AIni: String);
  procedure FetchReportQuery(AQuery: String; AVariables: TReportVars; AColumnsNumber: Integer; var AMatrix: TStringMatrix);

implementation

uses
  Windows, SysUtils, Variants, SQLite3, SQLite3Wrap;

resourcestring
  CreateUnitTable = 'CREATE TABLE IF NOT EXISTS unit (id INTEGER PRIMARY KEY AUTOINCREMENT, name VARCHAR(127) NOT NULL, shortName VARCHAR(10) NOT NULL)';
  CreateExerciseTable = 'CREATE TABLE IF NOT EXISTS exercise (' +
    'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
    'name VARCHAR(255) NOT NULL, ' +
    'line INTEGER NOT NULL, ' +
    'comments VARCHAR(255) NOT NULL, ' +
    'active NUMERIC NOT NULL)';
  CreateSubExerciseTable = 'CREATE TABLE IF NOT EXISTS subExercise (' +
    'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
    'idExercise INTEGER NOT NULL, ' +
    'name VARCHAR(255) NOT NULL, ' +
    'paramsCount INTEGER NOT NULL DEFAULT (1), ' +
    'param0Name VARCHAR(255), idUnit0 INTEGER, ' +
    'param1Name VARCHAR(255), idUnit1 INTEGER, ' +
    'param2Name VARCHAR(255), idUnit2 INTEGER, ' +
    'comments VARCHAR(255) NOT NULL, ' +
    'active INTEGER NOT NULL)';
  SelectExList = 'SELECT subExercise.id AS id, exercise.name || '': '' || subExercise.name AS name ' +
    'FROM exercise JOIN subExercise ON exercise.id=subExercise.idExercise ' +
    'WHERE exercise.active=1 AND (subExercise.active=1 OR subExercise.active=:active) ' +
    'ORDER BY exercise.line, exercise.name, subExercise.name';
  SelectExInfo = 'SELECT paramsCount, param0Name, param1Name, param2Name,' +
    ' u0.shortName AS unit0, u1.shortName AS unit1, u2.shortName AS unit2,' +
    ' (exercise.comments || X''0A'' || subExercise.comments) AS comments, ' +
    ' (SELECT diary.comments FROM diary WHERE diary.idExercise=:id AND diary.comments IS NOT NULL ORDER BY diary.exDate DESC LIMIT 1) AS lastCcomments ' +
    'FROM exercise ' +
    'JOIN subExercise ON exercise.id=subExercise.idExercise ' +
    'LEFT JOIN unit AS u0 ON u0.id=subExercise.idUnit0 ' +
    'LEFT JOIN unit AS u1 ON u1.id=subExercise.idUnit1 ' +
    'LEFT JOIN unit AS u2 ON u2.id=subExercise.idUnit2 ' +
    'WHERE subExercise.id=:id';

  CreateDiaryTable = 'CREATE TABLE IF NOT EXISTS diary (' +
    'id INTEGER PRIMARY KEY AUTOINCREMENT, exDate DATETIME NOT NULL, idExercise INTEGER NOT NULL, ' +
    'param0 INTEGER, param1 INTEGER, param2 INTEGER, comments VARCHAR(255))';
  SelectDiaryDayExs = 'SELECT subExercise.id AS id, exercise.name || '': '' || subExercise.name AS exerciseName, ' +
    'GROUP_CONCAT((diary.param0 || CASE diary.param1 WHEN 0 THEN '''' ELSE (''/'' || diary.param1) END || CASE diary.param2 WHEN 0 THEN '''' ELSE (''/'' || diary.param2) END), ''+'') || '' '' || ' +
    'u1.shortName || CASE subExercise.paramsCount WHEN 1 THEN '''' ELSE (''/'' || u2.shortName || CASE subExercise.paramsCount WHEN 2 THEN '''' ELSE (''/'' || u3.shortName) END) END AS param0, ' +
    'CASE COUNT(diary.param0) WHEN 1 THEN '''' ELSE (SUM(diary.param0) || ' +
      'CASE AVG(diary.param0)=MAX(diary.param0) WHEN 0 THEN (''/'' || ROUND(AVG(diary.param0),1) || ''/'' || MAX(diary.param0)) ELSE '''' END || '' '' || u1.shortName) ' +
    'END AS total ' +
    'FROM diary ' +
    'JOIN subExercise ON diary.idExercise=subExercise.id ' +
    'JOIN exercise ON subExercise.idExercise=exercise.id '+
    'LEFT JOIN unit AS u1 ON subExercise.idUnit0=u1.id ' +
    'LEFT JOIN unit AS u2 ON subExercise.idUnit1=u2.id ' +
    'LEFT JOIN unit AS u3 ON subExercise.idUnit2=u3.id ' +
    'WHERE diary.exDate=:date ' +
    'GROUP BY diary.idExercise ' +
    'ORDER BY exercise.line, exercise.name, subExercise.name';
  InsertOneExecution = 'INSERT INTO diary (exDate, idExercise, param0, param1, param2, comments) VALUES (:date, :idExercise, :param0, :param1, :param2, :comments)';

  SelectDiaryDayExsItems = 'SELECT diary.id AS id, ' +
    'diary.param0 || (CASE diary.param1 WHEN 0 THEN '''' ELSE (''/'' || diary.param1) END || CASE diary.param2 WHEN 0 THEN '''' ELSE (''/'' || diary.param2) END) || '' '' || ' +
    'u1.shortName || CASE subExercise.paramsCount WHEN 1 THEN '''' ELSE (''/'' || u2.shortName || CASE subExercise.paramsCount WHEN 2 THEN '''' ELSE (''/'' || u3.shortName) END) END AS param0, ' +
    'diary.comments, ' +
    'exercise.name || '': '' || subExercise.name AS exerciseName, exercise.comments || X''0A'' || subExercise.comments ' +
    'FROM diary ' +
    'JOIN subExercise ON diary.idExercise=subExercise.id ' +
    'JOIN exercise ON subExercise.idExercise=exercise.id '+
    'LEFT JOIN unit AS u1 ON subExercise.idUnit0=u1.id ' +
    'LEFT JOIN unit AS u2 ON subExercise.idUnit1=u2.id ' +
    'LEFT JOIN unit AS u3 ON subExercise.idUnit2=u3.id ' +
    'WHERE diary.exDate=:date AND subExercise.id=:id ' +
    'ORDER BY diary.id';

  CreateParamTable = 'CREATE TABLE IF NOT EXISTS parameter (' +
    'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
    'name VARCHAR(255) NOT NULL, ' +
    'valueMin INTEGER, ' +
    'valueMax INTEGER, ' +
    'idUnit INTEGER NOT NULL, ' +
    'main INTEGER NOT NULL' +
    ')';

  CreateTrackingTable = 'CREATE TABLE IF NOT EXISTS tracking (' +
    'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
    'trDate DATETIME NOT NULL, ' +
    'idParameter INTEGER NOT NULL, ' +
    'value INTEGER NOT NULL, ' +
    'comments VARCHAR(255)' +
    ')';

  SelectParametersList = 'SELECT parameter.id AS id, parameter.name AS name, parameter.main AS main ' +
    'FROM parameter ' +
    'ORDER BY parameter.name';
  SelectParameterInfo = 'SELECT unit.shortName AS paramName ' +
    'FROM parameter ' +
    'LEFT JOIN unit ON unit.id=parameter.idUnit ' +
    'WHERE parameter.id=:id';
  SelectDiaryDayTrackEvent = 'SELECT parameter.id AS id, parameter.name AS paramName, ' +
    '(SELECT tracking.value || '' '' || unit.shortName || ' +
    '(CASE tracking.value>NULLIF(parameter.valueMax, '''') WHEN 1 THEN '' (> '' || parameter.valueMax || '' '' || unit.shortName || '')'' ELSE '''' END) || ' +
    '(CASE tracking.value<NULLIF(parameter.valueMin, '''') WHEN 1 THEN '' (< '' || parameter.valueMin || '' '' || unit.shortName || '')'' ELSE '''' END)  ' +
    'FROM tracking ' +
    'LEFT JOIN unit ON parameter.idUnit=unit.id ' +
    'WHERE tracking.idParameter=parameter.id AND tracking.trDate<=:date ' +
    'ORDER BY tracking.trDate DESC LIMIT 1), ' +
    'parameter.main AS main ' +
    'FROM parameter ' +
    'ORDER BY parameter.name';
  InsertTrackEvent = 'INSERT INTO tracking (trDate, idParameter, value, comments) VALUES (:date, :idParameter, :value, :comments)';
  SelectParameterSeries = 'SELECT t1.trDate, AVG(t2.value) ' +
    'FROM tracking AS t1 ' +
    'LEFT JOIN tracking AS t2 ON (t2.idParameter=:id AND t2.trDate>=t1.trDate-:days AND t2.trDate<=t1.trDate) ' +
    'WHERE (t1.trDate BETWEEN :dateBegin AND :dateEnd) AND (t1.idParameter=:id) ' +
    'GROUP BY t1.trDate';

  CreateNotesTable = 'CREATE TABLE IF NOT EXISTS notes (' +
    'noteDate DATETIME PRIMARY KEY, ' +
    'note VARCHAR(10240)' +
    ')';
  InsertOneNote = 'INSERT OR REPLACE INTO notes (noteDate, note) VALUES (:date, :note)';
  SelectOneNote = 'SELECT note FROM notes WHERE noteDate=:date';

  CreateReminderTable = 'CREATE TABLE IF NOT EXISTS reminder (' +
    'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
    'type INTEGER NOT NULL, ' +
    'idExercise INTEGER NOT NULL, ' +
    'comments VARCHAR(255) NOT NULL' +
    ')';

  CreateFoodTable = 'CREATE TABLE IF NOT EXISTS food (' +
    'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
    'name VARCHAR(255), ' +
    'idUnit INTEGER, ' +
    'defaultAmount INTEGER, ' +
    'comments VARCHAR(255), ' +
    'active NUMERIC NOT NULL)';

  CreateFoodParameterPageTable = 'CREATE TABLE IF NOT EXISTS foodParameterPage (' +
    'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
    'name VARCHAR(255), ' +
    'comments VARCHAR(255)' +
    ')';

  CreateFoodParameterTable = 'CREATE TABLE IF NOT EXISTS foodParameter (' +
    'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
    'idSuperParameter INTEGER, ' +
    'idPage INTEGER NOT NULL, ' +
    'idUnit INTEGER NOT NULL, ' +
    'name VARCHAR(255), ' +
    'targetMin NUMERIC, ' +
    'targetMax NUMERIC, ' +
    'comments VARCHAR(255), ' +
    'main NUMERIC NOT NULL)';

  CreateFoodContentTable = 'CREATE TABLE IF NOT EXISTS foodContent (' +
    'idFood INTEGER, ' +
    'idParameter INTEGER, ' +
    'amount NUMERIC, ' +
    'comments VARCHAR(255)' +
    ')';

  CreateFoodIntakeTable = 'CREATE TABLE IF NOT EXISTS foodIntake (' +
    'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
    'fiDate DATETIME NOT NULL, ' +
    'idFood INTEGER NOT NULL, ' +
    'amount NUMERIC NOT NULL, ' +
    'comments VARCHAR(255)' +
    ')';

  SelectFoodDay = 'SELECT foodIntake.id AS id, food.name AS foodName, ' +
    'foodIntake.amount || '' '' || unit.shortName, ' +
    'foodIntake.comments AS comments ' +
    'FROM foodIntake ' +
    'JOIN food ON foodIntake.idFood=food.id '+
    'LEFT JOIN unit ON food.idUnit=unit.id ' +
    'WHERE foodIntake.fiDate=:date ' +
    'ORDER BY food.name';

  SelectFoodIntake = 'SELECT foodIntake.fiDate, foodIntake.idFood, foodIntake.amount, foodIntake.comments AS comments ' +
    'FROM foodIntake WHERE foodIntake.id=:id';

  InsertFoodIntake = 'INSERT INTO foodIntake (fiDate, idFood, amount, comments) VALUES (:date, :idFood, :amount, :comments)';

  UpdateFoodIntake = 'UPDATE foodIntake SET fiDate=:date, idFood=:idFood, amount=:amount, comments=:comments WHERE id=:idIntake';

  DeleteFoodIntakeById = 'DELETE FROM foodIntake WHERE foodIntake.id=:idIntake';

  SelectFoodList = 'SELECT food.id AS id, food.name AS name FROM food WHERE food.active=:active OR food.active=1 ORDER BY food.name';

  SelectFoodInfo = 'SELECT unit.shortName AS unitName, food.comments AS comments ' +
    'FROM food ' +
    'LEFT JOIN unit ON food.idUnit=unit.id ' +
    'WHERE food.id=:id';

  SelectFoodItemInfoById = 'SELECT food.name, food.active, food.defaultAmount, food.idUnit, food.comments AS comments ' +
    'FROM food ' +
    'WHERE food.id=:id';

  SelectFoodItemInfoByIntake = 'SELECT food.id, food.name, food.active, food.defaultAmount, food.idUnit, food.comments AS comments ' +
    'FROM food ' +
    'JOIN foodIntake ON foodIntake.idFood=food.id ' +
    'WHERE foodIntake.id=:id';

  InsertFoodInfo = 'INSERT INTO food (name, active, defaultAmount, idUnit, comments) VALUES (:name, :active, :defaultAmount, :idUnit, :comments)';

  UpdateFoodInfo = 'UPDATE food SET name=:name, active=:active, defaultAmount=:defaultAmount, idUnit=:idUnit, comments=:comment WHERE id=:id';

  UpdateFoodContent = 'INSERT OR REPLACE INTO foodContent (idFood, idParameter, amount) VALUES (:idFood, :idParameter, :amount)';

  DeleteFoodContent = 'DELETE FROM foodContent WHERE idFood=:idFood';

  SelectFoodItemContent = 'SELECT foodParameter.id, foodParameter.name, foodContent.amount, unit.shortName AS unitName, foodParameter.main AS main ' +
    'FROM foodParameter ' +
    'LEFT JOIN foodContent ON foodParameter.id=foodContent.idParameter AND foodContent.idFood=:id ' +
    'LEFT JOIN unit ON foodParameter.idUnit=unit.id ' +
    'ORDER BY IFNULL(foodParameter.idSuperParameter, foodParameter.id), foodParameter.idSuperParameter, foodParameter.name';

  SelectUnitList = 'SELECT unit.id AS id, unit.name AS name FROM unit ORDER BY unit.name';

  SelectParameterPageList = 'SELECT foodParameterPage.id AS id, foodParameterPage.name AS name FROM foodParameterPage ORDER BY foodParameterPage.id';

  SelectFoodPageDay = 'SELECT foodParameter.id AS id, ' +
    'foodParameter.idSuperParameter AS idParent, ' +
    'foodParameter.name AS name, ' +
    'foodParameter.targetMin AS targetMin, ' +
    'foodParameter.targetMax AS targetMax, ' +
    'SUM(foodContent.amount * foodIntake.amount / food.defaultAmount) AS amount, ' +
    'unit.shortName AS unitName, ' +
    'foodParameter.comments AS comments, ' +
    'foodParameter.idPage AS idPage, ' +
    'foodParameter.main AS main ' +
    'FROM foodParameter ' +
    'LEFT JOIN foodContent ON foodContent.idParameter=foodParameter.id ' +
    'LEFT JOIN food ON food.id=foodContent.idFood ' +
    'LEFT JOIN foodIntake ON foodContent.idFood=foodIntake.idFood AND foodIntake.fiDate=:date ' +
    'LEFT JOIN unit ON foodParameter.idUnit=unit.id ' +
    'GROUP BY foodParameter.id ' +
    'ORDER BY IFNULL(foodParameter.idSuperParameter, foodParameter.id), foodParameter.idSuperParameter, foodParameter.name';

  SelectSelectedFoodPageDay = 'SELECT foodParameter.id AS id, ' +
    'foodParameter.idSuperParameter AS idParent, ' +
    'foodParameter.name AS name, ' +
    'foodParameter.targetMin AS targetMin, ' +
    'foodParameter.targetMax AS targetMax, ' +
    'SUM(foodContent.amount * foodIntake.amount / food.defaultAmount) AS amount, ' +
    'unit.shortName AS unitName, ' +
    'foodParameter.comments AS comments, ' +
    'foodParameter.idPage AS idPage, ' +
    'foodParameter.main AS main ' +
    'FROM foodParameter ' +
    'LEFT JOIN foodContent ON foodContent.idParameter=foodParameter.id ' +
    'LEFT JOIN food ON food.id=foodContent.idFood ' +
    'LEFT JOIN foodIntake ON foodContent.idFood=foodIntake.idFood AND foodIntake.fiDate=:date AND foodIntake.id IN (:selected) ' +
    'LEFT JOIN unit ON foodParameter.idUnit=unit.id ' +
    'GROUP BY foodParameter.id ' +
    'ORDER BY IFNULL(foodParameter.idSuperParameter, foodParameter.id), foodParameter.idSuperParameter, foodParameter.name';

  CreateOptionsTable = 'CREATE TABLE IF NOT EXISTS options (key VARCHAR(64) PRIMARY KEY, value VARCHAR(255))';

  SetOption = 'INSERT OR REPLACE INTO options (key, value) VALUES (:key, :value)';
  GetOption = 'SELECT value FROM options WHERE key=:key';

  CreateTagTable = 'CREATE TABLE IF NOT EXISTS tag (' +
    'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
    'name VARCHAR(255) NOT NULL, ' +
    'autoReset INTEGER NOT NULL, ' +
    'comments VARCHAR(255)' +
    ')';

  CreateTagEventsTable = 'CREATE TABLE IF NOT EXISTS tagEvent (' +
    'idTag INTEGER NOT NULL, ' +
    'evDateBegin DATETIME NOT NULL, ' +
    'evDateEnd DATETIME, ' +  // including
    'comments VARCHAR(255) ' + // +1 - set, -1 - reset
    ')';

  SelectPresentTags = 'SELECT tag.id, tag.name, tag.autoReset, ' +
    'IFNULL(evDateBegin <= :date, -1), IFNULL(evDateEnd <= :date, -1), IFNULL(tag.name, '') | IFNULL(tagEvent.comments, '') ' +
    'FROM tag ' +
    'LEFT JOIN tagEvent ON tag.id=tagEvent.idTag ';

  CreateReportsTable = 'CREATE TABLE IF NOT EXISTS reports (' +
    'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
    'name VARCHAR(255), ' +
    'ini VARCHAR(10240) NOT NULL)';

  SelectReportList = 'SELECT reports.id, reports.name FROM reports ORDER BY name';

  GetReportIni = 'SELECT reports.ini FROM reports WHERE id=:id';

var
  FDB: TSQLite3Database;

procedure BeginTransaction;
begin
  FDB.BeginTransaction;
end;

procedure CommitTransaction;
begin
  FDB.Commit;
end;

procedure RollbackTransaction;
begin
  FDB.Rollback;
end;

procedure CreateTables;
var
  sl: TStringList;
  i: Integer;
  commited: Boolean;
resourcestring
  sInitScript = 'init.sql';
begin
  // Create tables
  FDB.Execute(CreateUnitTable);

  FDB.Execute(CreateExerciseTable);
  FDB.Execute(CreateSubExerciseTable);
  FDB.Execute(CreateDiaryTable);

  FDB.Execute(CreateParamTable);
  FDB.Execute(CreateTrackingTable);

  FDB.Execute(CreateNotesTable);

  FDB.Execute(CreateFoodTable);
  FDB.Execute(CreateFoodParameterTable);
  FDB.Execute(CreateFoodParameterPageTable);
  FDB.Execute(CreateFoodContentTable);
  FDB.Execute(CreateFoodParameterTable);
  FDB.Execute(CreateFoodIntakeTable);
  FDB.Execute(CreateTagTable);
  FDB.Execute(CreateTagEventsTable);
  FDB.Execute(CreateOptionsTable);
  FDB.Execute(CreateReportsTable);

  // Initialization script
  commited := False;
  if FileExists(sInitScript) then begin
    try
      FDB.BeginTransaction;
      sl := TStringList.Create;
      sl.LoadFromFile(sInitScript);
      for i := 0 to sl.Count - 1 do
        FDB.Execute(sl[i]);
      FDB.Commit;
      commited := True;
    finally
      if Assigned(sl) then FreeAndNil(sl);
      if not commited then
        FDB.Rollback;
    end;
    RenameFile(sInitScript, sInitScript + '.old');
  end;
end;

procedure FetchExList(ARet: TStrings; AAll: Boolean);
var
  stmt: TSQLite3Statement;
begin
  stmt := FDB.Prepare(SelectExList);
  if AAll then
    stmt.BindInt(':active', 0)
  else
    stmt.BindInt(':active', 1);
  while stmt.Step = SQLITE_ROW do
    ARet.AddObject(stmt.ColumnText(1), Pointer(stmt.ColumnInt(0)));
  FreeAndNil(stmt);
end;

procedure FetchExInfo(AId: Integer; var AParamsCount: Integer;
  var AParam0Name, AParam0Unit, AParam1Name, AParam1Unit, AParam2Name, AParam2Unit, AComment, ALastComment: String);
var
  stmt: TSQLite3Statement;
begin
  stmt := FDB.Prepare(SelectExInfo);
  stmt.BindInt(':id', AId);
  if stmt.Step = SQLITE_ROW then begin
    AParamsCount := stmt.ColumnInt(0);
    AParam0Name := stmt.ColumnText(1);
    AParam1Name := stmt.ColumnText(2);
    AParam2Name := stmt.ColumnText(3);
    AParam0Unit := stmt.ColumnText(4);
    AParam1Unit := stmt.ColumnText(5);
    AParam2Unit := stmt.ColumnText(6);
    AComment := stmt.ColumnText(7);
    ALastComment := stmt.ColumnText(8);
  end;
  FreeAndNil(stmt);
end;

procedure FetchParametersList(ARet: TStrings; AAll: Boolean);
var
  stmt: TSQLite3Statement;
begin
  stmt := FDB.Prepare(SelectParametersList);
  while stmt.Step = SQLITE_ROW do begin
    if (stmt.ColumnInt(2) <> 1) and not AAll then
      Continue;
    ARet.AddObject(stmt.ColumnText(1), Pointer(stmt.ColumnInt(0)));
  end;
  FreeAndNil(stmt);
end;

procedure FetchParameterInfo(AId: Integer; var AParamName: String);
var
  stmt: TSQLite3Statement;
begin
  stmt := FDB.Prepare(SelectParameterInfo);
  stmt.BindInt(':id', AId);
  if stmt.Step = SQLITE_ROW then begin
    AParamName := stmt.ColumnText(0);
  end;
  FreeAndNil(stmt);
end;

procedure AddTrackEvent(ADate: TDateTime; AIdParameter: Integer; AValue: Double; AComment: String);
var
  stmt: TSQLite3Statement;
begin
  stmt := FDB.Prepare(InsertTrackEvent);
  stmt.BindInt(':date', Trunc(ADate));
  stmt.BindInt(':idParameter', AIdParameter);
  stmt.BindDouble(':value', AValue);
  stmt.BindText(':comments', AComment);
  stmt.Step;
  FreeAndNil(stmt);
end;

procedure FetchParameterSerie(ADateBegin, ADateEnd: TDateTime; AParameterId, ADaysForPoint: Integer; ASeries: TFastLineSeries);
var
  stmt: TSQLite3Statement;
begin
  stmt := FDB.Prepare(SelectParameterSeries);
  stmt.BindInt(':dateBegin', Trunc(ADateBegin));
  stmt.BindInt(':dateEnd', Trunc(ADateEnd));
  stmt.BindInt(':id', AParameterId);
  stmt.BindInt(':days', ADaysForPoint);
  while stmt.Step = SQLITE_ROW do begin
    ASeries.AddXY(stmt.ColumnInt(0), stmt.ColumnDouble(1))
  end;
  FreeAndNil(stmt);
end;

procedure FetchDayExercises(ADate: TDateTime; var ARetDE: TDayExercises);
var
  stmt: TSQLite3Statement;
  i: Integer;
begin
  stmt := FDB.Prepare(SelectDiaryDayExs);
  stmt.BindInt(':date', Trunc(ADate));
  i := 0;
  while stmt.Step = SQLITE_ROW do begin
    SetLength(ARetDE, i + 1);
    ARetDE[i].Id := stmt.ColumnInt(0);
    ARetDE[i].Name := stmt.ColumnText(1);
    ARetDE[i].Params := stmt.ColumnText(2);
    ARetDE[i].Total := stmt.ColumnText(3);
    Inc(i);
  end;
  FreeAndNil(stmt);
end;

procedure FetchDayExerciseItems(ADate: TDateTime; AId: Integer; var ARetDE: TDayExerciseItems; var AName: String; var AComment: String);
var
  stmt: TSQLite3Statement;
  i: Integer;
begin
  stmt := FDB.Prepare(SelectDiaryDayExsItems);
  stmt.BindInt(':date', Trunc(ADate));
  stmt.BindInt(':id', AId);
  i := 0;
  while stmt.Step = SQLITE_ROW do begin
    SetLength(ARetDE, i + 1);
    ARetDE[i].Id := stmt.ColumnInt(0);
    ARetDE[i].Params := stmt.ColumnText(1);
    ARetDE[i].Comments := stmt.ColumnText(2);
    if i = 0 then begin
      AName := stmt.ColumnText(3);
      AComment := stmt.ColumnText(4);
    end;
    Inc(i);
  end;
  FreeAndNil(stmt);
end;

procedure FetchDayFood(ADate: TDateTime; var ARetDF: TDayFoods);
var
  stmt: TSQLite3Statement;
  i: Integer;
begin
  stmt := FDB.Prepare(SelectFoodDay);
  stmt.BindInt(':date', Trunc(ADate));
  i := 0;
  while stmt.Step = SQLITE_ROW do begin
    SetLength(ARetDF, i + 1);
    ARetDF[i].Id := stmt.ColumnInt(0);
    ARetDF[i].Name := stmt.ColumnText(1);
    ARetDF[i].Amount := stmt.ColumnText(2);
    ARetDF[i].Comment := stmt.ColumnText(3);
    Inc(i);
  end;
  FreeAndNil(stmt);
end;

procedure FetchDayParameters(ADate: TDateTime; var ARetDO: TDayOthers);
var
  stmt: TSQLite3Statement;
  i: Integer;
begin
  stmt := FDB.Prepare(SelectDiaryDayTrackEvent);
  stmt.BindInt(':date', Trunc(ADate));
  i := 0;
  while stmt.Step = SQLITE_ROW do begin
    SetLength(ARetDO, i + 1);
    ARetDO[i].Id := stmt.ColumnInt(0);
    ARetDO[i].Name := stmt.ColumnText(1);
    ARetDO[i].Value := stmt.ColumnText(2);
    //ARetDO[i].Comment := stmt.ColumnText(3);
    ARetDO[i].Main := stmt.ColumnInt(3) <> 0;
    Inc(i);
  end;
  FreeAndNil(stmt);
end;

procedure AddExecution(ADate: TDateTime; AIdEx: Integer; AParam0, AParam1, AParam2: Double; AComment: String; var AId: Integer);
var
  stmt: TSQLite3Statement;
begin
  stmt := FDB.Prepare(InsertOneExecution);
  stmt.BindInt(':date', Trunc(ADate));
  stmt.BindInt(':idExercise', AIdEx);
  stmt.BindDouble(':param0', AParam0);
  stmt.BindDouble(':param1', AParam1);
  stmt.BindDouble(':param2', AParam2);
  stmt.BindText(':comments', AComment);
  stmt.Step;
  AId := FDB.LastInsertRowID;
  FreeAndNil(stmt);
end;

procedure FetchNote(ADate: TDateTime; var ANote: String);
var
  stmt: TSQLite3Statement;
begin
  stmt := FDB.Prepare(SelectOneNote);
  stmt.BindInt(':date', Trunc(ADate));
  if stmt.Step = SQLITE_ROW then begin
    ANote := stmt.ColumnText(0);
  end;
  FreeAndNil(stmt);
end;


procedure AddNote(ADate: TDateTime; ANote: String);
var
  stmt: TSQLite3Statement;
begin
  stmt := FDB.Prepare(InsertOneNote);
  stmt.BindInt(':date', Trunc(ADate));
  stmt.BindText(':note', ANote);
  stmt.Step;
  FreeAndNil(stmt);
end;

procedure FetchFoodIntake(AId: Integer; var ADate: TDateTime; var AFoodId: Integer; var AAmount: Double; var AComment: String);
var
  stmt: TSQLite3Statement;
begin
  stmt := FDB.Prepare(SelectFoodIntake);
  stmt.BindInt(':id', AId);
  if stmt.Step = SQLITE_ROW then begin
    ADate := stmt.ColumnInt(0);
    AFoodId := stmt.ColumnInt(1);
    AAmount := stmt.ColumnDouble(2);
    AComment := stmt.ColumnText(3);
  end;
  FreeAndNil(stmt);
end;


procedure AddFoodIntake(ADate: TDateTime; AIdFood: Integer; AAmount: Double; AComment: String);
var
  stmt: TSQLite3Statement;
begin
  stmt := FDB.Prepare(InsertFoodIntake);
  stmt.BindInt(':date', Trunc(ADate));
  stmt.BindInt(':idFood', AIdFood);
  stmt.BindDouble(':amount', AAmount);
  stmt.BindText(':comments', AComment);
  stmt.Step;
  FreeAndNil(stmt);
end;

procedure SaveFoodIntake(AId: Integer; ADate: TDateTime; AIdFood: Integer; AAmount: Double; AComment: String);
var
  stmt: TSQLite3Statement;
begin
  stmt := FDB.Prepare(UpdateFoodIntake);
  stmt.BindInt(':idIntake', AId);
  stmt.BindInt(':date', Trunc(ADate));
  stmt.BindInt(':idFood', AIdFood);
  stmt.BindDouble(':amount', AAmount);
  stmt.BindText(':comments', AComment);
  stmt.Step;
  FreeAndNil(stmt);
end;

procedure DeleteFoodIntake(AId: Integer);
var
  stmt: TSQLite3Statement;
begin
  stmt := FDB.Prepare(DeleteFoodIntakeById);
  stmt.BindInt(':idIntake', AId);
  stmt.Step;
  FreeAndNil(stmt);
end;

procedure FetchFoodList(ARet: TStrings; AAll: Boolean);
var
  stmt: TSQLite3Statement;
begin
  stmt := FDB.Prepare(SelectFoodList);
  if AAll then
    stmt.BindInt(':active', 0)
  else
    stmt.BindInt(':active', 1);
  while stmt.Step = SQLITE_ROW do begin
    ARet.AddObject(stmt.ColumnText(1), Pointer(stmt.ColumnInt(0)));
  end;
  FreeAndNil(stmt);
end;

procedure FetchFoodInfo(AId: Integer; var AUnitName: String; var AComment: String);
var
  stmt: TSQLite3Statement;
begin
  stmt := FDB.Prepare(SelectFoodInfo);
  stmt.BindInt(':id', AId);
  if stmt.Step = SQLITE_ROW then begin
    AUnitName := stmt.ColumnText(0);
    AComment := stmt.ColumnText(1);
  end;
  FreeAndNil(stmt);
end;

procedure FetchFoodItemInfoById(AId: Integer; var AName: String; var AActive: Boolean; var ADefaultAmount: Double; var AUnit: Integer; var AComment: String);
var
  stmt: TSQLite3Statement;
begin
  stmt := FDB.Prepare(SelectFoodItemInfoById);
  stmt.BindInt(':id', AId);
  if stmt.Step = SQLITE_ROW then begin
    AName := stmt.ColumnText(0);
    AActive := stmt.ColumnInt(1) = 1;
    ADefaultAmount := stmt.ColumnDouble(2);
    AUnit := stmt.ColumnInt(3);
    AComment := stmt.ColumnText(4);
  end;
  FreeAndNil(stmt);
end;


procedure FetchFoodItemInfoByIntake(AIntakeId: Integer; var AId: Integer; var AName: String; var AActive: Boolean; var ADefaultAmount: Double; var AUnit: Integer; var AComment: String);
var
  stmt: TSQLite3Statement;
begin
  stmt := FDB.Prepare(SelectFoodItemInfoByIntake);
  stmt.BindInt(':id', AIntakeId);
  if stmt.Step = SQLITE_ROW then begin
    AId := stmt.ColumnInt(0);
    AName := stmt.ColumnText(1);
    AActive := stmt.ColumnInt(2) = 1;
    ADefaultAmount := stmt.ColumnDouble(3);
    AUnit := stmt.ColumnInt(4);
    AComment := stmt.ColumnText(5);
  end;
  FreeAndNil(stmt);
end;

procedure SaveFoodItemInfoAndDeleteContent(AId: Integer; AName: String; AActive: Boolean; ADefaultAmount: Double; AUnit: Integer; AComment: String);
var
  stmt: TSQLite3Statement;
begin
  if AId = 0 then
    stmt := FDB.Prepare(InsertFoodInfo)
  else begin
    stmt := FDB.Prepare(UpdateFoodInfo);
    stmt.BindInt(':id', AId);
  end;
  if AActive then
    stmt.BindInt(':active', 1)
  else
    stmt.BindInt(':active', 0);
  stmt.BindDouble(':defaultAmount', ADefaultAmount);
  stmt.BindInt(':idUnit', AUnit);
  stmt.BindText(':comment', AComment);
  stmt.BindText(':name', AName);
  stmt.Step;
  FreeAndNil(stmt);

  stmt := FDB.Prepare(DeleteFoodContent);
  stmt.BindInt(':idFood', AId);
  stmt.Step;
  FreeAndNil(stmt);
end;

procedure FetchFoodContent(AId: Integer; var AFoodParameterContents: TFoodParameterContents);
var
  stmt: TSQLite3Statement;
  i: Integer;
begin
  stmt := FDB.Prepare(SelectFoodItemContent);
  stmt.BindInt(':id', AId);
  i := 0;
  while stmt.Step = SQLITE_ROW do begin
    SetLength(AFoodParameterContents, i + 1);
    AFoodParameterContents[i].Id := stmt.ColumnInt(0);
    AFoodParameterContents[i].Name := stmt.ColumnText(1);
    AFoodParameterContents[i].Value := stmt.ColumnDouble(2);
    AFoodParameterContents[i].Unitname := stmt.ColumnText(3);
    AFoodParameterContents[i].Main := stmt.ColumnInt(4) = 1;
    Inc(i);
  end;
  FreeAndNil(stmt);
end;

procedure SaveFoodItemContent(AIdFood: Variant; AIdParameter: Integer; AValue: Extended);
var
  stmt: TSQLite3Statement;
begin
  if AValue = 0 then
    Exit;
  stmt := FDB.Prepare(UpdateFoodContent);
  stmt.BindDouble(':amount', AValue);
  stmt.BindInt(':idFood', AIdFood);
  stmt.BindInt(':idParameter', AIdParameter);
  stmt.Step;
  FreeAndNil(stmt);
end;

procedure FetchUnitList(ARet: TStrings);
var
  stmt: TSQLite3Statement;
begin
  stmt := FDB.Prepare(SelectUnitList);
  while stmt.Step = SQLITE_ROW do begin
    ARet.AddObject(stmt.ColumnText(1), Pointer(stmt.ColumnInt(0)));
  end;
  FreeAndNil(stmt);
end;

procedure FetchParameterPageList(ARet: TStrings);
var
  stmt: TSQLite3Statement;
begin
  stmt := FDB.Prepare(SelectParameterPageList);
  while stmt.Step = SQLITE_ROW do begin
    ARet.AddObject(stmt.ColumnText(1), Pointer(stmt.ColumnInt(0)));
  end;
  FreeAndNil(stmt);
end;

procedure FetchParameterPage(ADate: TDateTime; ASelected: String; var ARetDFP: TDayFoodParameters);
var
  stmt: TSQLite3Statement;
  i: Integer;
  s: String;
begin
  if ASelected <> '' then begin
    s := SelectSelectedFoodPageDay;
    s := StringReplace(SelectSelectedFoodPageDay, ':selected', ASelected, []);
    stmt := FDB.Prepare(s);
  end else
    stmt := FDB.Prepare(SelectFoodPageDay);
  stmt.BindInt(':date', Trunc(ADate));
  i := 0;
  while stmt.Step = SQLITE_ROW do begin
    SetLength(ARetDFP, i + 1);
    ARetDFP[i].Id := stmt.ColumnInt(0);
    ARetDFP[i].IdParent := stmt.ColumnInt(1);
    ARetDFP[i].Name := stmt.ColumnText(2);
    ARetDFP[i].TargetMin := stmt.ColumnDouble(3);
    ARetDFP[i].TargetMax := stmt.ColumnDouble(4);
    ARetDFP[i].Amount := stmt.ColumnDouble(5);
    ARetDFP[i].UnitM := stmt.ColumnText(6);
    ARetDFP[i].Comment := stmt.ColumnText(7);
    ARetDFP[i].IdPage := stmt.ColumnInt(8);
    ARetDFP[i].IsMain := stmt.ColumnInt(9) = 1;
    Inc(i);
  end;
  FreeAndNil(stmt);
end;

procedure SaveOptionToDatabase(AKey: String; AValue: String);
var
  stmt: TSQLite3Statement;
begin
  stmt := FDB.Prepare(SetOption);
  stmt.BindText(':key', AKey);
  stmt.BindText(':value', AValue);
  stmt.Step;
  FreeAndNil(stmt);
end;

function LoadOptionFromDatabase(AKey: String): String;
var
  stmt: TSQLite3Statement;
begin
  stmt := FDB.Prepare(GetOption);
  stmt.BindText(':key', AKey);
  if stmt.Step = SQLITE_ROW then begin
    Result := stmt.ColumnText(0);
  end;
  FreeAndNil(stmt);
end;

procedure FetchTagList(ARet: TStrings; ADate: TDateTime);
var
  stmt: TSQLite3Statement;
  s: string;
begin
  stmt := FDB.Prepare(SelectPresentTags);
  stmt.BindInt(':date', Trunc(ADate));
  while stmt.Step = SQLITE_ROW do begin
    s := stmt.ColumnText(0) + '/' + stmt.ColumnText(1) + '/' + stmt.ColumnText(2) + '/' + stmt.ColumnText(3) + '/' + stmt.ColumnText(4) + '/' + stmt.ColumnText(5);
    ARet.AddObject(s, Pointer(stmt.ColumnInt(0)));
  end;
  FreeAndNil(stmt);
end;

procedure AddTag(AName: String; APeriodBegin, APeriodEnd: TDateTime; AComment: String);
var
  stmt: TSQLite3Statement;
begin
  stmt := FDB.Prepare('');
  stmt.Step;
  FreeAndNil(stmt);
end;

procedure FetchReports(ARet: TStrings);
var
  stmt: TSQLite3Statement;
begin
  stmt := FDB.Prepare(SelectReportList);
  while stmt.Step = SQLITE_ROW do
    ARet.AddObject(stmt.ColumnText(1), Pointer(stmt.ColumnInt(0)));
  FreeAndNil(stmt);
end;

procedure FetchReportData(AId: Integer; var AIni: String);
var
  stmt: TSQLite3Statement;
begin
  stmt := FDB.Prepare(GetReportIni);
  stmt.BindInt(':id', AId);
  if stmt.Step = SQLITE_ROW then begin
    AIni := stmt.ColumnText(0);
  end;
  FreeAndNil(stmt);
end;

procedure FetchReportQuery(AQuery: String; AVariables: TReportVars; AColumnsNumber: Integer; var AMatrix: TStringMatrix);
var
  stmt: TSQLite3Statement;
  i, j: Integer;
begin
  stmt := FDB.Prepare(AQuery);
  for i := 0 to Length(AVariables) - 1 do begin
    case AVariables[i].VarType of
      vtInteger : stmt.BindInt(':' + AVariables[i].Name, AVariables[i].ValInt);
      vtDate : stmt.BindDouble(':' + AVariables[i].Name, Round(AVariables[i].ValDate));
      vtFlag : if AVariables[i].ValBool then
          stmt.BindInt(':' + AVariables[i].Name, 1)
        else
          stmt.BindInt(':' + AVariables[i].Name, 0);
    end;
  end;
  i := 0;
  while stmt.Step = SQLITE_ROW do begin
    SetLength(AMatrix, i + 1);
    SetLength(AMatrix[i], AColumnsNumber);
    for j := 0 to AColumnsNumber - 1 do
      AMatrix[i][j] := stmt.ColumnText(j);
    Inc(i);
  end;
  FreeAndNil(stmt);
end;

initialization
  FDB := TSQLite3Database.Create;
  FDB.Open('diary.db');

finalization
  if Assigned(FDB) then begin
    FDB.Close;
    FreeAndNil(FDB);
  end;

end.
