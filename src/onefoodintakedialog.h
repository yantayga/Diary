#pragma once

#include "database.h"

#include <QDialog>
#include <QListWidget>

namespace Ui {
class OneFoodIntakeDialog;
}

class OneFoodIntakeDialog : public QDialog
{
    Q_OBJECT

public:
    explicit OneFoodIntakeDialog(QWidget *parent, Database& db, QDate date);
    ~OneFoodIntakeDialog();

public slots:
    void selectFood(QListWidgetItem* item);

private:
    Ui::OneFoodIntakeDialog *ui;
    Database& _db;

    void loadFoodList();

    // QDialog interface
public slots:
    void accept();
};

