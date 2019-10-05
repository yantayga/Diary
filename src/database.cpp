#include "database.h"
#include "queries.h"

Database::Database()
    : _db(QSqlDatabase::addDatabase("QSQLITE"))
{
    static const char  DbName[] = "diary.db";
    _db.setDatabaseName(DbName);
    if (!_db.open())
    {
        qWarning() << "Cannot open database " << DbName;
    }
}

bool Database::beginTransaction()
{
    if (!_db.transaction())
    {
        qWarning() << "Cannot begin transacton";
        return false;
    }
    return true;
}

void Database::commitTransaction()
{
    _db.commit();
}

void Database::rollbackTransaction()
{
    _db.rollback();
}


void Database::createTables()
{
    QSqlQuery query;
    query.exec(CreateUnitTable);
    query.exec(CreateExerciseTable);
    query.exec(CreateSubExerciseTable);
    query.exec(CreateDiaryTable);
    query.exec(CreateParamTable);
    query.exec(CreateTrackingTable);
    query.exec(CreateNotesTable);
    query.exec(CreateReminderTable);
    query.exec(CreateFoodTable);
    query.exec(CreateFoodParameterPageTable);
    query.exec(CreateFoodParameterTable);
    query.exec(CreateFoodContentTable);
    query.exec(CreateFoodIntakeTable);
    query.exec(CreateOptionsTable);
    query.exec(CreateFoodTable);
    query.exec(CreateTagTable);
    query.exec(CreateTagEventsTable);
    query.exec(CreateReportsTable);
}


