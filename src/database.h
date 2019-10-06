#pragma once

#include <QtSql>

#include "commontypes.h"

class Database
{
private:
    QSqlDatabase _db;
    QDate _delphiDateBegin;

    qint64 toDelphiDate(QDate date);
public:
    Database();

    void createTables();

    bool beginTransaction();
    void commitTransaction();
    void rollbackTransaction();

// TODO: Implement those all

    QStringList FetchUnitList();

    IdToString fetchExList(bool All);
    void fetchExInfo(int id, QStringList& paramNames, QStringList& paramUnits, QString& comment, QString& lastComment);
    void addExecution(const QDate date, int idEx, double param0, double param1, double param2, const QString& comment, int& id);

    QStringList FetchParametersList(bool All);
    void FetchParameterInfo(int Id, QString& ParamName);
    void AddTrackEvent(const QDate Date, int IdParameter, double Value, const QString& Comment);
    void FetchParameterSerie(QDate DateBegin, QDate DateEnd, int ParameterId, int DaysForPoint, QStringList& Series);

    DayExercises fetchDayExercises(const QDate date);
    DayExerciseItems fetchDayExerciseItems(const QDate date, int id, QString& name, QString& comment);
    void FetchDayFood(const QDate Date, DayFoods& RetDF);
    void FetchDayParameters(const QDate Date, DayOthers& RetDO);

    void FetchNote(const QDate Date, QString& Note);
    void AddNote(const QDate Date, const QString& Note);

    void FetchFoodIntake(int Id, QDate& Date, int& FoodId, double& Amount, QString& Comment);
    void AddFoodIntake(const QDate Date, int IDFood, double Amount, const QString& Comment);
    void SaveFoodIntake(int Id, const QDate Date, int IDFood, double Amount, const QString& Comment);
    void DeleteFoodIntake(int Id);
    QStringList FetchFoodList(bool All);
    void FetchFoodInfo(int Id, QString& UnitName, QString& Comment);
    void FetchFoodItemInfoById(int Id, QString& Name, bool& Active,
      double& DefaultAmount, int& Unit, QString& Comment);
    void FetchFoodItemInfoByIntake(int IntakeId, int& Id, QString& Name,
      bool& Active, double& DefaultAmount, int& Unit, QString& Comment);
    void SaveFoodItemInfoAndDeleteContent(int Id,const QString& Name,
      bool Active, double DefaultAmount, int Unit, const QString& Comment);
    void FetchFoodContent(int Id, FoodParameterContents& FoodParameterContents);
    void SaveFoodItemContent(int IdFood, int IdParameter, double Value);
    QStringList FetchParameterPageList();
    void FetchParameterPage(const QDate Date, const QString& Selected, DayFoodParameters& RetDFP);

    void saveOptionToDatabase(const QString& key, const QString& value);
    QString loadOptionFromDatabase(const QString& key, const QString& defaultValue);

    QStringList FetchTagList(QDate Date);
    void AddTag(const QString& Name, QDate PeriodBegin, QDate PeriodEnd, const QString& Comment);

    QStringList FetchReports();
    void FetchReportData(int Id, QString& Ini);
    //void FetchReportQuery(AQuery: String; Variables: TReportVars; ColumnsNumber: Integer; var Matrix: TStringMatrix);
};

