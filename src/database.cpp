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

	_delphiDateBegin.setDate(1899, 12, 30);
}

qint64 Database::toDelphiDate(QDate date)
{
	return _delphiDateBegin.daysTo(date);
}

QDate Database::fromDelphiDate(qint64 days)
{
	return _delphiDateBegin.addDays(days);
}

int Database::getLastInsertedId()
{
	QSqlQuery queryId;
	queryId.exec("SELECT last_insert_rowid()");
	if(queryId.next())
	{
		return queryId.value(0).toInt();
	}

	return -1;
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

IdToString Database::fetchExList(bool all)
{
	IdToString result;
	QSqlQuery query;
	query.prepare(SelectExList);
	query.bindValue(":active", all?0:1);
	query.exec();
	while(query.next())
	{
		result.insert(query.value(0).toInt(), query.value(1).toString());
	}
	return result;
}

void Database::fetchExInfo(int id, QStringList &paramNames, QStringList &paramUnits, QString &comment, QString &lastComment)
{
	QSqlQuery query;
	query.prepare(SelectExInfo);
	query.bindValue(":id", id);
	query.exec();
	if(query.next())
	{
		int paramsCount = query.value(0).toInt();
		for (int i = 0; i < paramsCount; ++i)
		{
			paramNames << query.value(i + 1).toString();
			paramUnits << query.value(i + 4).toString();
		}
		comment = query.value(7).toString();
		lastComment = query.value(8).toString();
	}
}

int Database::addExecution(const QDate date, int idEx, double param0, double param1, double param2, const QString &comment)
{
	QSqlQuery query, queryId;
	query.prepare(InsertOneExecution);
	query.bindValue(":date", toDelphiDate(date));
	query.bindValue(":idExercise", idEx);
	query.bindValue(":param0", param0);
	query.bindValue(":param1", param1);
	query.bindValue(":param2", param2);
	query.bindValue(":comments", comment);
	query.exec();
	return getLastInsertedId();
}

DayExercises Database::fetchDayExercises(const QDate date)
{
	DayExercises result;
	QSqlQuery query;
	query.prepare(SelectDiaryDayExs);
	query.bindValue(":date", toDelphiDate(date));
	query.exec();
	while(query.next())
	{
		DayExercise day;
		day.id = query.value(0).toInt();
		day.name = query.value(1).toString();
		day.params = query.value(2).toString();
		day.total = query.value(3).toString();
		result.append(day);
	}
	return result;
}

DayExerciseItems Database::fetchDayExerciseItems(const QDate date, int id, QString& name, QString& comment)
{
	DayExerciseItems result;
	QSqlQuery query;
	query.prepare(SelectDiaryDayExsItems);
	query.bindValue(":date", toDelphiDate(date));
	query.bindValue(":id", id);
	query.exec();
	while(query.next())
	{
		DayExerciseItem dayItem;
		dayItem.id = query.value(0).toInt();
		dayItem.params = query.value(1).toString();
		dayItem.comments = query.value(2).toString();
		result.append(dayItem);
		if (!name.length())
		{
			name = query.value(3).toString();
			comment = query.value(4).toString();
		}
	}
	return result;
}

DayFoods Database::fetchDayFood(const QDate date)
{
	DayFoods result;
	QSqlQuery query;
	query.prepare(SelectFoodDay);
	query.bindValue(":date", toDelphiDate(date));
	query.exec();
	while(query.next())
	{
		DayFood dayFood;
		dayFood.id = query.value(0).toInt();
		dayFood.name = query.value(1).toString();
		dayFood.amount = query.value(2).toString();
		dayFood.comments = query.value(3).toString();
		result.append(dayFood);
	}
	return result;
}

bool Database::fetchFoodIntake(int id, QDate& date, int& idFood, double& amount, QString& comment)
{
	QSqlQuery query;
	query.prepare(SelectFoodIntake);
	query.bindValue(":id", id);
	query.exec();
	if(query.next())
	{
		date = fromDelphiDate(query.value(0).toInt());
		idFood = query.value(1).toInt();
		amount = query.value(2).toDouble();
		comment = query.value(3).toString();
		return true;
	}

	return false;
}

int Database::addFoodIntake(const QDate date, int idFood, double amount, const QString &comment)
{
	QSqlQuery query;
	query.prepare(InsertFoodIntake);
	query.bindValue(":date", toDelphiDate(date));
	query.bindValue(":idFood", idFood);
	query.bindValue(":amount", amount);
	query.bindValue(":comments", comment);
	query.exec();
	return getLastInsertedId();
}

void Database::saveFoodIntake(int id, const QDate date, int idFood, double amount, const QString& comment)
{
	QSqlQuery query;
	query.prepare(UpdateFoodIntake);
	query.bindValue(":date", toDelphiDate(date));
	query.bindValue(":idIntake", id);
	query.bindValue(":idFood", idFood);
	query.bindValue(":amount", amount);
	query.bindValue(":comments", comment);
	query.exec();
}

IdToString Database::fetchFoodList(bool all)
{
	IdToString result;
	QSqlQuery query;
	query.prepare(SelectFoodList);
	query.bindValue(":active", all?0:1);
	query.exec();
	while(query.next())
	{
		result.insert(query.value(0).toInt(), query.value(1).toString());
	}
	return result;
}

IdToString Database::fetchParameterPageList()
{
	IdToString result;
	QSqlQuery query;
	query.prepare(SelectParameterPageList);
	query.exec();
	while(query.next())
	{
		result.insert(query.value(0).toInt(), query.value(1).toString());
	}
	return result;
}

DayFoodParameters Database::fetchParameterPage(const QDate date, const QString& selected)
{
	DayFoodParameters result;
	QSqlQuery query;
	if (selected.isEmpty())
	{
		query.prepare(SelectFoodPageDay);
	}
	else
	{
		QString sql = SelectSelectedFoodPageDay;
		sql.replace(":selected", selected);
		query.prepare(sql);
	}
	query.bindValue(":date", toDelphiDate(date));
	query.exec();
	while(query.next())
	{
		DayFoodParameter dayFood;
		dayFood.id = query.value(0).toInt();
		dayFood.idParent = query.value(1).toInt();
		dayFood.name = query.value(2).toString();
		dayFood.targetMin = query.value(3).toDouble();
		dayFood.targetMax = query.value(4).toDouble();
		dayFood.amount = query.value(5).toDouble();
		dayFood.unitM = query.value(6).toString();
		dayFood.comments = query.value(7).toString();
		dayFood.idPage = query.value(8).toInt();
		dayFood.isMain = query.value(9).toInt() == 1;
		result.append(dayFood);
	}
	return result;
}

void Database::saveOptionToDatabase(const QString &key, const QString &value)
{
	QSqlQuery query;
	query.prepare(SetOption);
	query.bindValue(":key", key);
	query.bindValue(":value", value);
	query.exec();
}

QString Database::loadOptionFromDatabase(const QString &key, const QString &defaultValue)
{
	QString result = defaultValue;
	QSqlQuery query;
	query.prepare(GetOption);
	query.bindValue(":key", key);
	query.exec();
	if(query.next())
	{
		result = query.value(0).toString();
	}
	return result;
}

