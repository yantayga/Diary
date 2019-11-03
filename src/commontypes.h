#pragma once

#include <QString>
#include <QList>
#include <QMap>

typedef QMap<int, QString> IdToString;

struct DayExercise
{
  int id;
  QString name;
  QString params;
  QString total;
};

typedef QList<DayExercise> DayExercises;

struct DayExerciseItem
{
  int id;
  QString params;
  QString comments;
};

typedef QList<DayExerciseItem> DayExerciseItems;

struct DayFood
{
  int id;
  QString name;
  QString amount;
  QString comments;
};

typedef QList<DayFood> DayFoods;

struct DayFoodParameter
{
  int idPage;;
  int id;
  int idParent;
  QString name;
  double argetMin;
  double argetMax;
  double amount;
  QString unitM;
  QString comments;
  bool isMain;
};

typedef QList<DayFoodParameter> DayFoodParameters;

struct DayOther
{
  int id;
  QString name;
  double value;
  bool main;
  //QString comments;
};

typedef QList<DayOther> DayOthers;

struct FoodParameterContent
{
  int id;
  QString name;
  double value;
  QString unitName;
  bool main;
};

typedef QList<FoodParameterContent> FoodParameterContents;

struct TagEvent
{
  int id;
  QString name;
  bool IsAutoReset;
  bool IsChecked;
  bool IsChangedToday;
  QString comments;
};

typedef QList<TagEvent> TagEvents;

enum class VarType
{
    vtInteger,
    vtDate,
    vtFlag,
};

struct ReportVar
{
  QString name;
  QString displayName;
  bool IsNullable;
  VarType varType;
  union
  {
    int valInt;
    QDate valDate;
    bool valBool;
  };
};

typedef QList<ReportVar> ReportVars;
typedef QList<QStringList> StringMatrix;

