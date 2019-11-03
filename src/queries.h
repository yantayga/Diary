#pragma once

// Create database tables
static const char CreateUnitTable[] = "CREATE TABLE IF NOT EXISTS unit (id INTEGER PRIMARY KEY AUTOINCREMENT, name VARCHAR(127) NOT NULL, shortName VARCHAR(10) NOT NULL)";
static const char CreateExerciseTable[] = "CREATE TABLE IF NOT EXISTS exercise (" \
  "id INTEGER PRIMARY KEY AUTOINCREMENT, " \
  "name VARCHAR(255) NOT NULL, " \
  "line INTEGER NOT NULL, " \
  "comments VARCHAR(255) NOT NULL, " \
  "active NUMERIC NOT NULL)";
static const char CreateSubExerciseTable[] = "CREATE TABLE IF NOT EXISTS subExercise (" \
  "id INTEGER PRIMARY KEY AUTOINCREMENT, " \
  "idExercise INTEGER NOT NULL, " \
  "name VARCHAR(255) NOT NULL, " \
  "paramsCount INTEGER NOT NULL DEFAULT (1), " \
  "param0Name VARCHAR(255), idUnit0 INTEGER, " \
  "param1Name VARCHAR(255), idUnit1 INTEGER, " \
  "param2Name VARCHAR(255), idUnit2 INTEGER, " \
  "comments VARCHAR(255) NOT NULL, " \
  "active INTEGER NOT NULL)";
static const char CreateDiaryTable[] = "CREATE TABLE IF NOT EXISTS diary (" \
  "id INTEGER PRIMARY KEY AUTOINCREMENT, exDate DATETIME NOT NULL, idExercise INTEGER NOT NULL, " \
  "param0 INTEGER, param1 INTEGER, param2 INTEGER, comments VARCHAR(255))";
static const char CreateParamTable[] = "CREATE TABLE IF NOT EXISTS parameter (" \
  "id INTEGER PRIMARY KEY AUTOINCREMENT, " \
  "name VARCHAR(255) NOT NULL, " \
  "valueMin INTEGER, " \
  "valueMax INTEGER, " \
  "idUnit INTEGER NOT NULL, " \
  "main INTEGER NOT NULL" \
  ")";
static const char CreateTrackingTable[] = "CREATE TABLE IF NOT EXISTS tracking (" \
  "id INTEGER PRIMARY KEY AUTOINCREMENT, " \
  "trDate DATETIME NOT NULL, " \
  "idParameter INTEGER NOT NULL, " \
  "value INTEGER NOT NULL, " \
  "comments VARCHAR(255)" \
  ")";
static const char CreateNotesTable[] = "CREATE TABLE IF NOT EXISTS notes (" \
  "noteDate DATETIME PRIMARY KEY, " \
  "note VARCHAR(10240)" \
  ")";
static const char CreateReminderTable[] = "CREATE TABLE IF NOT EXISTS reminder (" \
  "id INTEGER PRIMARY KEY AUTOINCREMENT, " \
  "type INTEGER NOT NULL, " \
  "idExercise INTEGER NOT NULL, " \
  "comments VARCHAR(255) NOT NULL" \
  ")";
static const char CreateFoodTable[] = "CREATE TABLE IF NOT EXISTS food (" \
  "id INTEGER PRIMARY KEY AUTOINCREMENT, " \
  "name VARCHAR(255), " \
  "idUnit INTEGER, " \
  "defaultAmount INTEGER, " \
  "comments VARCHAR(255), " \
  "active NUMERIC NOT NULL)";
static const char CreateFoodParameterPageTable[] = "CREATE TABLE IF NOT EXISTS foodParameterPage (" \
  "id INTEGER PRIMARY KEY AUTOINCREMENT, " \
  "name VARCHAR(255), " \
  "comments VARCHAR(255)" \
  ")";
static const char CreateFoodParameterTable[] = "CREATE TABLE IF NOT EXISTS foodParameter (" \
  "id INTEGER PRIMARY KEY AUTOINCREMENT, " \
  "idSuperParameter INTEGER, " \
  "idPage INTEGER NOT NULL, " \
  "idUnit INTEGER NOT NULL, " \
  "name VARCHAR(255), " \
  "targetMin NUMERIC, " \
  "targetMax NUMERIC, " \
  "comments VARCHAR(255), " \
  "main NUMERIC NOT NULL)";
static const char CreateFoodContentTable[] = "CREATE TABLE IF NOT EXISTS foodContent (" \
  "idFood INTEGER, " \
  "idParameter INTEGER, " \
  "amount NUMERIC, " \
  "comments VARCHAR(255)" \
  ")";
static const char CreateFoodIntakeTable[] = "CREATE TABLE IF NOT EXISTS foodIntake (" \
  "id INTEGER PRIMARY KEY AUTOINCREMENT, " \
  "fiDate DATETIME NOT NULL, " \
  "idFood INTEGER NOT NULL, " \
  "amount NUMERIC NOT NULL, " \
  "comments VARCHAR(255)" \
  ")";
static const char CreateOptionsTable[] = "CREATE TABLE IF NOT EXISTS options (key VARCHAR(64) PRIMARY KEY, value VARCHAR(255))";
static const char CreateTagTable[] = "CREATE TABLE IF NOT EXISTS tag (" \
  "id INTEGER PRIMARY KEY AUTOINCREMENT, " \
  "name VARCHAR(255) NOT NULL, " \
  "autoReset INTEGER NOT NULL, " \
  "comments VARCHAR(255)" \
  ")";
static const char CreateTagEventsTable[] = "CREATE TABLE IF NOT EXISTS tagEvent (" \
  "idTag INTEGER NOT NULL, " \
  "evDateBegin DATETIME NOT NULL, " \
  "evDateEnd DATETIME, " \
  "comments VARCHAR(255) " \
  ")";
static const char CreateReportsTable[] = "CREATE TABLE IF NOT EXISTS reports (" \
  "id INTEGER PRIMARY KEY AUTOINCREMENT, " \
  "name VARCHAR(255), " \
  "ini VARCHAR(10240) NOT NULL)";



static const char SelectExList[] = "SELECT subExercise.id AS id, exercise.name || ': ' || subExercise.name AS name " \
  "FROM exercise JOIN subExercise ON exercise.id=subExercise.idExercise " \
  "WHERE exercise.active=1 AND (subExercise.active=1 OR subExercise.active=:active) " \
  "ORDER BY exercise.line, exercise.name, subExercise.name";
static const char SelectExInfo[] = "SELECT paramsCount, param0Name, param1Name, param2Name," \
  " u0.shortName AS unit0, u1.shortName AS unit1, u2.shortName AS unit2," \
  " (exercise.comments || X'0A' || subExercise.comments) AS comments, " \
  " (SELECT diary.comments FROM diary WHERE diary.idExercise=:id AND diary.comments IS NOT NULL ORDER BY diary.exDate DESC LIMIT 1) AS lastCcomments " \
  "FROM exercise " \
  "JOIN subExercise ON exercise.id=subExercise.idExercise " \
  "LEFT JOIN unit AS u0 ON u0.id=subExercise.idUnit0 " \
  "LEFT JOIN unit AS u1 ON u1.id=subExercise.idUnit1 " \
  "LEFT JOIN unit AS u2 ON u2.id=subExercise.idUnit2 " \
  "WHERE subExercise.id=:id";

static const char SelectDiaryDayExs[] = "SELECT subExercise.id AS id, exercise.name || ': ' || subExercise.name AS exerciseName, " \
  "GROUP_CONCAT((diary.param0 || CASE diary.param1 WHEN 0 THEN '' ELSE ('/' || diary.param1) END || CASE diary.param2 WHEN 0 THEN '' ELSE ('/' || diary.param2) END), '+') || ' ' || " \
  "u1.shortName || CASE subExercise.paramsCount WHEN 1 THEN '' ELSE ('/' || u2.shortName || CASE subExercise.paramsCount WHEN 2 THEN '' ELSE ('/' || u3.shortName) END) END AS param0, " \
  "CASE COUNT(diary.param0) WHEN 1 THEN '' ELSE (SUM(diary.param0) || " \
  "CASE AVG(diary.param0)=MAX(diary.param0) WHEN 0 THEN ('/' || ROUND(AVG(diary.param0),1) || '/' || MAX(diary.param0)) ELSE '' END || ' ' || u1.shortName) " \
  "END AS total " \
  "FROM diary " \
  "JOIN subExercise ON diary.idExercise=subExercise.id " \
  "JOIN exercise ON subExercise.idExercise=exercise.id " \
  "LEFT JOIN unit AS u1 ON subExercise.idUnit0=u1.id " \
  "LEFT JOIN unit AS u2 ON subExercise.idUnit1=u2.id " \
  "LEFT JOIN unit AS u3 ON subExercise.idUnit2=u3.id " \
  "WHERE diary.exDate=:date " \
  "GROUP BY diary.idExercise " \
  "ORDER BY exercise.line, exercise.name, subExercise.name";
static const char InsertOneExecution[] = "INSERT INTO diary (exDate, idExercise, param0, param1, param2, comments) VALUES (:date, :idExercise, :param0, :param1, :param2, :comments)";

static const char SelectDiaryDayExsItems[] = "SELECT diary.id AS id, " \
  "diary.param0 || (CASE diary.param1 WHEN 0 THEN '' ELSE ('/' || diary.param1) END || CASE diary.param2 WHEN 0 THEN '' ELSE ('/' || diary.param2) END) || ' ' || " \
  "u1.shortName || CASE subExercise.paramsCount WHEN 1 THEN '' ELSE ('/' || u2.shortName || CASE subExercise.paramsCount WHEN 2 THEN '' ELSE ('/' || u3.shortName) END) END AS param0, " \
  "diary.comments, " \
  "exercise.name || ': ' || subExercise.name AS exerciseName, exercise.comments || X'0A' || subExercise.comments " \
  "FROM diary " \
  "JOIN subExercise ON diary.idExercise=subExercise.id " \
  "JOIN exercise ON subExercise.idExercise=exercise.id " \
  "LEFT JOIN unit AS u1 ON subExercise.idUnit0=u1.id " \
  "LEFT JOIN unit AS u2 ON subExercise.idUnit1=u2.id " \
  "LEFT JOIN unit AS u3 ON subExercise.idUnit2=u3.id " \
  "WHERE diary.exDate=:date AND subExercise.id=:id " \
  "ORDER BY diary.id";

static const char SelectParametersList[] = "SELECT parameter.id AS id, parameter.name AS name, parameter.main AS main " \
  "FROM parameter " \
  "ORDER BY parameter.name";
static const char SelectParameterInfo[] = "SELECT unit.shortName AS paramName " \
  "FROM parameter " \
  "LEFT JOIN unit ON unit.id=parameter.idUnit " \
  "WHERE parameter.id=:id";
static const char SelectDiaryDayTrackEvent[] = "SELECT parameter.id AS id, parameter.name AS paramName, " \
  "(SELECT tracking.value || ' ' || unit.shortName || " \
  "(CASE tracking.value>NULLIF(parameter.valueMax, '') WHEN 1 THEN ' (> ' || parameter.valueMax || ' ' || unit.shortName || ')' ELSE '' END) || " \
  "(CASE tracking.value<NULLIF(parameter.valueMin, '') WHEN 1 THEN ' (< ' || parameter.valueMin || ' ' || unit.shortName || ')' ELSE '' END)  " \
  "FROM tracking " \
  "LEFT JOIN unit ON parameter.idUnit=unit.id " \
  "WHERE tracking.idParameter=parameter.id AND tracking.trDate<=:date " \
  "ORDER BY tracking.trDate DESC LIMIT 1), " \
  "parameter.main AS main " \
  "FROM parameter " \
  "ORDER BY parameter.name";
static const char InsertTrackEvent[] = "INSERT INTO tracking (trDate, idParameter, value, comments) VALUES (:date, :idParameter, :value, :comments)";
static const char SelectParameterSeries[] = "SELECT t1.trDate, AVG(t2.value) " \
  "FROM tracking AS t1 " \
  "LEFT JOIN tracking AS t2 ON (t2.idParameter=:id AND t2.trDate>=t1.trDate-:days AND t2.trDate<=t1.trDate) " \
  "WHERE (t1.trDate BETWEEN :dateBegin AND :dateEnd) AND (t1.idParameter=:id) " \
  "GROUP BY t1.trDate";

static const char InsertOneNote[] = "INSERT OR REPLACE INTO notes (noteDate, note) VALUES (:date, :note)";
static const char SelectOneNote[] = "SELECT note FROM notes WHERE noteDate=:date";

static const char SelectFoodDay[] = "SELECT foodIntake.id AS id, food.name AS foodName, " \
	"foodIntake.amount || ' ' || unit.shortName, " \
	"foodIntake.comments AS comments " \
	"FROM foodIntake " \
	"JOIN food ON foodIntake.idFood=food.id " \
	"LEFT JOIN unit ON food.idUnit=unit.id " \
	"WHERE foodIntake.fiDate=:date " \
	"ORDER BY food.name";

static const char SelectFoodIntake[] = "SELECT foodIntake.fiDate, foodIntake.idFood, foodIntake.amount, foodIntake.comments AS comments " \
  "FROM foodIntake WHERE foodIntake.id=:id";

static const char InsertFoodIntake[] = "INSERT INTO foodIntake (fiDate, idFood, amount, comments) VALUES (:date, :idFood, :amount, :comments)";

static const char UpdateFoodIntake[] = "UPDATE foodIntake SET fiDate=:date, idFood=:idFood, amount=:amount, comments=:comments WHERE id=:idIntake";

static const char DeleteFoodIntakeById[] = "DELETE FROM foodIntake WHERE foodIntake.id=:idIntake";

static const char SelectFoodList[] = "SELECT food.id AS id, food.name AS name FROM food WHERE food.active=:active OR food.active=1 ORDER BY food.name";

static const char SelectFoodInfo[] = "SELECT unit.shortName AS unitName, food.comments AS comments " \
	"FROM food " \
	"LEFT JOIN unit ON food.idUnit=unit.id " \
	"WHERE food.id=:id";

static const char SelectFoodItemInfoById[] = "SELECT food.name, food.active, food.defaultAmount, food.idUnit, food.comments AS comments " \
	"FROM food " \
	"WHERE food.id=:id";

static const char SelectFoodItemInfoByIntake[] = "SELECT food.id, food.name, food.active, food.defaultAmount, food.idUnit, food.comments AS comments " \
	"FROM food " \
	"JOIN foodIntake ON foodIntake.idFood=food.id " \
	"WHERE foodIntake.id=:id";

static const char InsertFoodInfo[] = "INSERT INTO food (name, active, defaultAmount, idUnit, comments) VALUES (:name, :active, :defaultAmount, :idUnit, :comments)";

static const char UpdateFoodInfo[] = "UPDATE food SET name=:name, active=:active, defaultAmount=:defaultAmount, idUnit=:idUnit, comments=:comment WHERE id=:id";

static const char UpdateFoodContent[] = "INSERT OR REPLACE INTO foodContent (idFood, idParameter, amount) VALUES (:idFood, :idParameter, :amount)";

static const char DeleteFoodContent[] = "DELETE FROM foodContent WHERE idFood=:idFood";

static const char SelectFoodItemContent[] = "SELECT foodParameter.id, foodParameter.name, foodContent.amount, unit.shortName AS unitName, foodParameter.main AS main " \
	"FROM foodParameter " \
	"LEFT JOIN foodContent ON foodParameter.id=foodContent.idParameter AND foodContent.idFood=:id " \
	"LEFT JOIN unit ON foodParameter.idUnit=unit.id " \
	"ORDER BY IFNULL(foodParameter.idSuperParameter, foodParameter.id), foodParameter.idSuperParameter, foodParameter.name";

static const char SelectUnitList[] = "SELECT unit.id AS id, unit.name AS name FROM unit ORDER BY unit.name";

static const char SelectParameterPageList[] = "SELECT foodParameterPage.id AS id, foodParameterPage.name AS name FROM foodParameterPage ORDER BY foodParameterPage.id";

static const char SelectFoodPageDay[] = "SELECT foodParameter.id AS id, " \
	"foodParameter.idSuperParameter AS idParent, " \
	"foodParameter.name AS name, " \
	"foodParameter.targetMin AS targetMin, " \
	"foodParameter.targetMax AS targetMax, " \
	"SUM(foodContent.amount * foodIntake.amount / food.defaultAmount) AS amount, " \
	"unit.shortName AS unitName, " \
	"foodParameter.comments AS comments, " \
	"foodParameter.idPage AS idPage, " \
	"foodParameter.main AS main " \
	"FROM foodParameter " \
	"LEFT JOIN foodContent ON foodContent.idParameter=foodParameter.id " \
	"LEFT JOIN food ON food.id=foodContent.idFood " \
	"LEFT JOIN foodIntake ON foodContent.idFood=foodIntake.idFood AND foodIntake.fiDate=:date " \
	"LEFT JOIN unit ON foodParameter.idUnit=unit.id " \
	"GROUP BY foodParameter.id " \
	"ORDER BY IFNULL(foodParameter.idSuperParameter, foodParameter.id), foodParameter.idSuperParameter, foodParameter.name";

static const char SelectSelectedFoodPageDay[] = "SELECT foodParameter.id AS id, " \
	"foodParameter.idSuperParameter AS idParent, " \
	"foodParameter.name AS name, " \
	"foodParameter.targetMin AS targetMin, " \
	"foodParameter.targetMax AS targetMax, " \
	"SUM(foodContent.amount * foodIntake.amount / food.defaultAmount) AS amount, " \
	"unit.shortName AS unitName, " \
	"foodParameter.comments AS comments, " \
	"foodParameter.idPage AS idPage, " \
	"foodParameter.main AS main " \
	"FROM foodParameter " \
	"LEFT JOIN foodContent ON foodContent.idParameter=foodParameter.id " \
	"LEFT JOIN food ON food.id=foodContent.idFood " \
	"LEFT JOIN foodIntake ON foodContent.idFood=foodIntake.idFood AND foodIntake.fiDate=:date AND foodIntake.id IN (:selected) " \
	"LEFT JOIN unit ON foodParameter.idUnit=unit.id " \
	"GROUP BY foodParameter.id " \
	"ORDER BY IFNULL(foodParameter.idSuperParameter, foodParameter.id), foodParameter.idSuperParameter, foodParameter.name";


static const char SetOption[] = "INSERT OR REPLACE INTO options (key, value) VALUES (:key, :value)";
static const char GetOption[] = "SELECT value FROM options WHERE key=:key";

static const char SelectPresentTags[] = "SELECT tag.id, tag.name, tag.autoReset, " \
  "IFNULL(evDateBegin <= :date, -1), IFNULL(evDateEnd <= :date, -1), IFNULL(tag.name, ') | IFNULL(tagEvent.comments, ') " \
  "FROM tag " \
  "LEFT JOIN tagEvent ON tag.id=tagEvent.idTag ";

static const char SelectReportList[] = "SELECT reports.id, reports.name FROM reports ORDER BY name";

static const char GetReportIni[] = "SELECT reports.ini FROM reports WHERE id=:id";

