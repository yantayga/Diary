#include "mainwindow.h"
#include "oneexecutiondialog.h"
#include "ui_mainwindow.h"

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

void MainWindow::exerciseSelectionChanged()
{
    qDebug() << "Exercise selected";
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
    QDate date = pItem->data(Qt::UserRole + 1).toDate();
    updateExerciseDetails(date, id);
}

void MainWindow::onAddExecise()
{
    OneExecutionDialog dlg(nullptr, _db, getActualDate());
    if (dlg.exec() == QDialog::Accepted)
    {
        updateExercises(getActualDate());
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
        pItem->setData(Qt::UserRole + 1, date);
        table->setItem(i, 0, pItem);
        table->setItem(i, 1, new QTableWidgetItem(d.params));
        table->setItem(i, 2, new QTableWidgetItem(d.total));
    }
    exerciseSelectionChanged();
}

void MainWindow::updateFood(QDate date)
{
    date = date.addDays(1);
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
}

void MainWindow::saveTableWidgetStates()
{
    saveTableWidgetColumns("tableExcercises");
    saveTableWidgetColumns("tableExerciseDetails");
}

void MainWindow::saveTableWidgetColumns(const QString& name)
{
    QTableWidget* table = findChild<QTableWidget*>(name);
    for (int i = 0; i < table->horizontalHeader()->count(); ++i)
    {
        _db.saveOptionToDatabase("MainWindow_" + name + "_ColWidth_" + QString::number(i), QString::number(table->columnWidth(i)));
    }
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
