#include "mainwindow.h"
#include "oneexecutiondialog.h"
#include "onefoodintakedialog.h"
#include "ui_mainwindow.h"

#include "progresslikepainter.h"

#include <QLabel>
#include <QTableWidget>

MainWindow::MainWindow(QWidget *parent)
	: QMainWindow(parent)
	, ui(new Ui::MainWindow)
{
	ui->setupUi(this);
	_db.createTables();

	initTableWidgets();
	dateChanged(QDate::currentDate());
}

MainWindow::~MainWindow()
{
	delete ui;
}

void MainWindow::exerciseSelectionChanged()
{
	QTableWidget* table = findChild<QTableWidget*>("tableExcercises");
	if (table->selectedRanges().count() == 0)
	{
		QLabel* total = findChild<QLabel*>("totalExercises");
		total->setText(QString(""));
		QTableWidget* table = findChild<QTableWidget*>("tableExerciseDetails");
		table->setRowCount(0);
		return;
	}
	int row = table->selectedRanges().at(0).topRow();
	QTableWidgetItem* pItem = table->item(row, 0);
	int id = pItem->data(Qt::UserRole).toInt();
	updateExerciseDetails(getActualDate(), id);
}

void MainWindow::foodSelectionChanged()
{
	int id = -1;
	QTableWidget* table = findChild<QTableWidget*>("tableFoodIncome");
	if (table->selectedRanges().count() != 0)
	{
		int row = table->selectedRanges().at(0).topRow();
		QTableWidgetItem* pItem = table->item(row, 0);
		id = pItem->data(Qt::UserRole).toInt();
	}
	updateFoodDetails(getActualDate(), id);
}

void MainWindow::onAddExecise()
{
	OneExecutionDialog dlg(nullptr, _db, getActualDate());
	if (dlg.exec() == QDialog::Accepted)
	{
		updateExercises(getActualDate());
	}
}

void MainWindow::onAddFoodIntake()
{
	OneFoodIntakeDialog dlg(nullptr, _db, getActualDate(), -1);
	if (dlg.exec() == QDialog::Accepted)
	{
		updateFood(getActualDate());
	}
}

void MainWindow::onEditFoodIntake(int row, int)
{
	QTableWidget* table = findChild<QTableWidget*>("tableFoodIncome");
	QTableWidgetItem* pItem = table->item(row, 0);
	int id = pItem->data(Qt::UserRole).toInt();

	OneFoodIntakeDialog dlg(nullptr, _db, getActualDate(), id);
	if (dlg.exec() == QDialog::Accepted)
	{
		updateFood(getActualDate());
	}
}

void MainWindow::updateExercises(QDate date)
{
	DayExercises es = _db.fetchDayExercises(date);
	QTableWidget* table = findChild<QTableWidget*>("tableExcercises");
	table->setRowCount(es.count());
	for (int i = 0; i < es.count(); ++i)
	{
		const DayExercise& d = es.at(i);
		QTableWidgetItem* pItem = new QTableWidgetItem(d.name);
		pItem->setData(Qt::UserRole, d.id);
		table->setItem(i, 0, pItem);
		table->setItem(i, 1, new QTableWidgetItem(d.params));
		table->setItem(i, 2, new QTableWidgetItem(d.total));
	}
	exerciseSelectionChanged();
}

void MainWindow::updateExerciseDetails(QDate date, int id)
{
	QString name, comments;
	DayExerciseItems esi = _db.fetchDayExerciseItems(date, id, name, comments);

	QLabel* total = findChild<QLabel*>("totalExercises");
	total->setText(QString("%1: всего %2").arg(name, QString::number(esi.count())));

	QTableWidget* table = findChild<QTableWidget*>("tableExerciseDetails");
	table->setRowCount(esi.count());
	for (int i = 0; i < esi.count(); ++i)
	{
		const DayExerciseItem& d = esi.at(i);
		table->setItem(i, 0, new QTableWidgetItem(d.params));
		table->setItem(i, 1, new QTableWidgetItem(d.comments));
	}
}

void MainWindow::updateFood(QDate date)
{
	DayFoods fs = _db.fetchDayFood(date);
	QTableWidget* table = findChild<QTableWidget*>("tableFoodIncome");
	table->setRowCount(fs.count());
	for (int i = 0; i < fs.count(); ++i)
	{
		const DayFood& d = fs.at(i);
		QTableWidgetItem* pItem = new QTableWidgetItem(d.name);
		pItem->setData(Qt::UserRole, d.id);
		table->setItem(i, 0, pItem);
		table->setItem(i, 1, new QTableWidgetItem(d.amount));
		//table->setItem(i, 2, new QTableWidgetItem(d.comments));V
	}
	foodSelectionChanged();
}

void MainWindow::updateFoodDetails(QDate date, int id)
{
	QString selected = false ? (QString::number(id)): "";
	bool all = false;
	DayFoodParameters dfp = _db.fetchParameterPage(date, selected);
	QTabWidget* foodTabs = findChild<QTabWidget*>("tabsFoodContent");
	for (int i = 0; i < foodTabs->count(); ++i)
	{
		QTableWidget* table = qobject_cast<QTableWidget*>(foodTabs->widget(i));
		int rows = 0;
		int id = table->objectName().right(1).toInt();
		for (int j = 0; j < dfp.count(); ++j)
		{
			const DayFoodParameter& d = dfp.at(j);
			if (d.idPage == id)
			{
				if (!d.isMain && !all)
					continue;
				++rows;
			}
		}
		table->setRowCount(rows);
		for (int j = 0, k = 0; j < dfp.count(); ++j)
		{
			if (dfp[j].idPage == id)
			{
				const DayFoodParameter& d = dfp.at(j);
				if (!d.isMain && !all)
					continue;
				QTableWidgetItem* pItem0 = new QTableWidgetItem(d.name);
				pItem0->setData(Qt::UserRole, d.id);
				table->setItem(k, 0, pItem0);
				QString s = QString::number(d.amount) + " из (" + QString::number(d.targetMin) + "/" + QString::number(d.targetMax) + ")";
				QTableWidgetItem* pItem1 = new QTableWidgetItem(s);
				pItem1->setData(Qt::UserRole+1, d.amount);
				pItem1->setData(Qt::UserRole+2, d.targetMin);
				pItem1->setData(Qt::UserRole+3, d.targetMax);
				table->setItem(k, 1, pItem1);
				++k;
			}
		}
	}
}

QDate MainWindow::getActualDate()
{
	QCalendarWidget* calendar = findChild<QCalendarWidget*>("diaryDate");
	return calendar->selectedDate();
}

void MainWindow::initTableWidgets()
{
	initTableWidgetColumns("tableExcercises", {"Наименование", "Количество всего", "Среднее"});
	initTableWidgetColumns("tableExerciseDetails", {"Количество", "Комментарий"});
	IdToString parameters = _db.fetchParameterPageList();
	QTabWidget* foodTabs = findChild<QTabWidget*>("tabsFoodContent");
	for (IdToString::const_iterator i = parameters.begin(); i != parameters.end(); ++i)
	{
		QString tableName = "tabsFoodContent_" + QString::number(i.key());
		QTableWidget* table = new QTableWidget (0, 2);
		table->setObjectName(tableName);
		table->horizontalHeader()->setSectionResizeMode(1, QHeaderView::Stretch);
		table->verticalHeader()->setVisible(false);
		table->verticalHeader()->setDefaultSectionSize(18);
		table->setItemDelegateForColumn(1, new ProgressLikePainter());
		foodTabs->addTab(table, i.value());
		initTableWidgetColumns(tableName, {"Наименование", "Количество"});
	}
	initTableWidgetColumns("tableFoodIncome", {"Наименование", "Количество"});
}

void MainWindow::initTableWidgetColumns(const QString& name, const QStringList& headerLabels)
{
	QTableWidget* table = findChild<QTableWidget*>(name);
	table ->setHorizontalHeaderLabels(headerLabels);
	for (int i = 0; i < table->horizontalHeader()->count(); ++i)
	{
		table->horizontalHeaderItem(i)->setTextAlignment(Qt::AlignLeft);
		table->setColumnWidth(i,
			_db.loadOptionFromDatabase("MainWindow_" + name + "_ColWidth_" + QString::number(i),
			QString::number(150)
		).toInt());
	}
	table->resize(
	   _db.loadOptionFromDatabase("MainWindow_ControlWidth_" + name, QString::number(150)).toInt(),
	   _db.loadOptionFromDatabase("MainWindow_ControlHeight_" + name, QString::number(150)).toInt());
}

void MainWindow::saveTableWidgetStates()
{
	_db.beginTransaction();
	saveTableWidgetColumns("tableExcercises");
	saveTableWidgetColumns("tableExerciseDetails");
	saveTableWidgetColumns("tableFoodIncome");
	QTabWidget* foodTabs = findChild<QTabWidget*>("tabsFoodContent");
	for (int i = 0; i < foodTabs->count(); ++i)
	{
		QTableWidget* table = qobject_cast<QTableWidget*>(foodTabs->widget(i));
		saveTableWidgetColumns(table->objectName());
	}
	_db.commitTransaction();
}

void MainWindow::saveTableWidgetColumns(const QString& name)
{
	QTableWidget* table = findChild<QTableWidget*>(name);
	for (int i = 0; i < table->horizontalHeader()->count(); ++i)
	{
		_db.saveOptionToDatabase("MainWindow_" + name + "_ColWidth_" + QString::number(i), QString::number(table->columnWidth(i)));
	}
	_db.saveOptionToDatabase("MainWindow_ControlWidth_" + name, QString::number(table->width()));
	_db.saveOptionToDatabase("MainWindow_ControlHeight_" + name, QString::number(table->height()));
}

void MainWindow::closeEvent(QCloseEvent* /* event */)
{
	saveTableWidgetStates();
}

void MainWindow::dateChanged(QDate date)
{
	qDebug() << "Date changed to " << date;
	updateExercises(date);
	updateFood(date);
}
