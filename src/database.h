#pragma once

#include <QtSql>

#include "commontypes.h"

class Database
{
private:
    QSqlDatabase _db;

public:
    Database();

    void createTables();

    bool beginTransaction();
    void commitTransaction();
    void rollbackTransaction();

// TODO: Implement those all

    QStringList FetchUnitList();

    QStringList FetchExList(bool All);
    void FetchExInfo(int Id, int& ParamsCount,
        QString& Param0Name, QString& Param0Unit, QString& Param1Name, QString& Param1Unit,
        QString& Param2Name, QString& Param2Unit, QString& Comment, QString& LastComment);
    void AddExecution(const QDate Date, int IdEx, double Param0, double Param1, double Param2, const QString& Comment, int& Id);

    QStringList FetchParametersList(bool All);
    void FetchParameterInfo(int Id, QString& ParamName);
    void AddTrackEvent(const QDate Date, int IdParameter, double Value, const QString& Comment);
    void FetchParameterSerie(QDate DateBegin, QDate DateEnd, int ParameterId, int DaysForPoint, QStringList& Series);

    void FetchDayExercises(const QDate Date, DayExercises& RetDE);
    void FetchDayExerciseItems(const QDate Date, int Id, DayExerciseItems& RetDE, QString& Name, QString& Comment);
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

    void SaveOptionToDatabase(const QString& Key, const QString& Value);
    QString LoadOptionFromDatabase(const QString& Key);

    QStringList FetchTagList(QDate Date);
    void AddTag(const QString& Name, QDate PeriodBegin, QDate PeriodEnd, const QString& Comment);

    QStringList FetchReports();
    void FetchReportData(int Id, QString& Ini);
    //void FetchReportQuery(AQuery: String; Variables: TReportVars; ColumnsNumber: Integer; var Matrix: TStringMatrix);
};

