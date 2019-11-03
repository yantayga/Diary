#include "onefoodintakedialog.h"
#include "ui_onefoodintakedialog.h"

#include <QLabel>
#include <QDateEdit>
#include <QLineEdit>
#include <QTextEdit>

OneFoodIntakeDialog::OneFoodIntakeDialog(QWidget *parent, Database& db, QDate date) :
    QDialog(parent),
    ui(new Ui::OneFoodIntakeDialog),
    _db(db)
{
    ui->setupUi(this);

    loadFoodList();

    QDateEdit* dateEdit = findChild<QDateEdit*>("dateExecution");
    dateEdit->setDate(date);

    QLineEdit* thisAmount = findChild<QLineEdit*>("textAmount");
    thisAmount->setValidator(new QDoubleValidator);
}

OneFoodIntakeDialog::~OneFoodIntakeDialog()
{
    delete ui;
}

void OneFoodIntakeDialog::selectFood(QListWidgetItem *item)
{

}

void OneFoodIntakeDialog::loadFoodList()
{
    IdToString exs = _db.fetchFoodList(true);
    QListWidget *lst = findChild<QListWidget*>("listFoods");
    for (IdToString::const_iterator i = exs.begin(); i != exs.end(); ++i)
    {
        QListWidgetItem* pItem = new QListWidgetItem(i.value());
        pItem->setData(Qt::UserRole, i.key());
        lst->addItem(pItem);
    }
    lst->sortItems();
}

void OneFoodIntakeDialog::accept()
{
    QDateEdit* dateEdit = findChild<QDateEdit*>("dateExecution");

    QListWidget *lst = findChild<QListWidget*>("listFoods");
    if (lst->selectedItems().size() == 0)
    {
        return;
    }
    int id = lst->selectedItems()[0]->data(Qt::UserRole).toInt();

    QLineEdit* thisAmount = findChild<QLineEdit*>("textAmount");

    double amount = thisAmount->text().toDouble();
    if (amount < 0.0000001)
    {
        return;
    }

    QTextEdit* thisComment = findChild<QTextEdit*>("textComment");

    _db.addFoodIntake(dateEdit->date(), id, amount, thisComment->toPlainText());
    QDialog::accept();
}