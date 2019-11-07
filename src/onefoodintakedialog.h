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
	explicit OneFoodIntakeDialog(QWidget *parent, Database& db, QDate date, int id);
	~OneFoodIntakeDialog();

public slots:
	void selectFood(QListWidgetItem* item);
	void chkShowAllStateChanged(int);

private:
	Ui::OneFoodIntakeDialog *ui;
	Database& _db;
	int _id;

	void loadFoodList();
	void loadFoodIntake();

	// QDialog interface
public slots:
	void accept();
};

