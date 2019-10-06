#include "oneexecutiondialog.h"
#include "ui_oneexecutiondialog.h"

#include <QLabel>
#include <QDateEdit>
#include <QTextEdit>

OneExecutionDialog::OneExecutionDialog(QWidget *parent, Database& db, QDate date):
    QDialog(parent),
    ui(new Ui::OneExecutionDialog),
    _db(db)
{
    ui->setupUi(this);

    loadExercisesList();

    QDateEdit* dateEdit = findChild<QDateEdit*>("dateExecution");
    dateEdit->setDate(date);
}

OneExecutionDialog::~OneExecutionDialog()
{
    delete ui;
}

void OneExecutionDialog::selectExercise(QListWidgetItem* item)
{
    int id = item->data(Qt::UserRole).toInt();
    QStringList paramNames, paramUnits;
    QString comment, lastComment;
    _db.fetchExInfo(id, paramNames, paramUnits, comment, lastComment);

    QTableWidget* params = findChild<QTableWidget*>("tableParams");
    params->setRowCount(paramNames.count());
    for (int i = 0; i < paramNames.count(); ++i)
    {
        params->setItem(i, 0, new QTableWidgetItem(paramNames[i]));
        params->item(i, 0)->setFlags(Qt::NoItemFlags);
        params->setItem(i, 1, new QTableWidgetItem("0"));
        params->item(i, 1)->setFlags(Qt::ItemIsEnabled | Qt::ItemIsEditable | Qt::ItemIsSelectable);
        params->setItem(i, 2, new QTableWidgetItem(paramUnits[i]));
        params->item(i, 2)->setFlags(Qt::NoItemFlags);
    }

    QLabel* excomments = findChild<QLabel*>("labelComments");
    excomments->setText(comment);

    QTextEdit* thisComment = findChild<QTextEdit*>("textComment");
    thisComment->setText(lastComment);
}

void OneExecutionDialog::loadExercisesList()
{
    IdToString exs = _db.fetchExList(true);
    QListWidget *lst = findChild<QListWidget*>("listExercises");
    for (IdToString::const_iterator i = exs.begin(); i != exs.end(); ++i)
    {
        QListWidgetItem* pItem = new QListWidgetItem(i.value());
        pItem->setData(Qt::UserRole, i.key());
        lst->addItem(pItem);
    }
    lst->sortItems();
}

void OneExecutionDialog::accept()
{
    QDateEdit* dateEdit = findChild<QDateEdit*>("dateExecution");

    QListWidget *lst = findChild<QListWidget*>("listExercises");
    if (lst->selectedItems().size() == 0)
    {
        reject();
    }
    int id = lst->selectedItems()[0]->data(Qt::UserRole).toInt();

    double p1 = 0, p2 = 0, p3 = 0;
    QTableWidget* params = findChild<QTableWidget*>("tableParams");
    if (params->rowCount() > 0)
    {
        p1 = params->item(0, 1)->text().toDouble();
    }
    if (params->rowCount() > 1)
    {
        p2 = params->item(1, 1)->text().toDouble();
    }
    if (params->rowCount() > 2)
    {
        p3 = params->item(2, 1)->text().toDouble();
    }

    int retId = 0;

    QTextEdit* thisComment = findChild<QTextEdit*>("textComment");

    _db.addExecution(dateEdit->date(), id, p1, p2, p3, thisComment->toPlainText(), retId);
    QDialog::accept();
}
