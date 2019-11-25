#include "oneexecutiondialog.h"
#include "ui_oneexecutiondialog.h"

#include <QLabel>
#include <QDateEdit>
#include <QCheckBox>
#include <QPlainTextEdit>
#include <QMessageBox>

OneExecutionDialog::OneExecutionDialog(QWidget *parent, Database& db, QDate date):
	QDialog(parent),
	ui(new Ui::OneExecutionDialog),
	_db(db)
{
	ui->setupUi(this);

	loadExercisesList();

	QDateEdit* dateEdit = findChild<QDateEdit*>("dateExecution");
	dateEdit->setDate(date);

	QTableWidget* params = findChild<QTableWidget*>("tableParams");
	params->setItemDelegateForColumn(1, new EditValidatedDelegate(params));

	QLineEdit* numOfCopies = findChild<QLineEdit*>("NumOfCopies");
	numOfCopies->setValidator(new QIntValidator(1, 100));
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

	QPlainTextEdit* thisComment = findChild<QPlainTextEdit*>("textComment");
	thisComment->setPlainText(lastComment);
}

void OneExecutionDialog::chkShowAllStateChanged(int)
{
	loadExercisesList();
}

void OneExecutionDialog::loadExercisesList()
{
	QListWidget *lst = findChild<QListWidget*>("listExercises");
	lst->clear();

	QCheckBox* showAll = findChild<QCheckBox*>("chkShowAll");
	IdToString exs = _db.fetchExList(showAll->isChecked());
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
		QMessageBox::warning(this,"Недопустимый параметр", "Не выбрано упражнение");
		return;
	}
	int id = lst->selectedItems()[0]->data(Qt::UserRole).toInt();

	double p1 = 0, p2 = 0, p3 = 0;
	QTableWidget* params = findChild<QTableWidget*>("tableParams");
	if (params->rowCount() > 0)
	{
		QString s = params->item(0, 1)->text().replace(',','.');
		p1 = s.toDouble();
		if (p1 < 0.0000001)
		{
			QMessageBox::warning(this,"Недопустимый параметр", "Не заполнено количество");
			return;
		}
	}
	if (params->rowCount() > 1)
	{
		QString s = params->item(1, 1)->text().replace(',','.');
		p2 = s.toDouble();
	}
	if (params->rowCount() > 2)
	{
		QString s = params->item(2, 1)->text().replace(',','.');
		p3 = s.toDouble();
	}

	QPlainTextEdit* thisComment = findChild<QPlainTextEdit*>("textComment");

	QLineEdit* numOfCopies = findChild<QLineEdit*>("NumOfCopies");
	size_t n = numOfCopies->text().toUInt();

	_db.beginTransaction();

	for (size_t i = 0; i < n; ++i)
	{
		_db.addExecution(dateEdit->date(), id, p1, p2, p3, thisComment->toPlainText());
	}

	_db.commitTransaction();
	QDialog::accept();
}
