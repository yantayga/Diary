#pragma once

#include "database.h"

#include <QDialog>
#include <QListWidget>

namespace Ui {
class OneExecutionDialog;
}

class OneExecutionDialog : public QDialog
{
    Q_OBJECT

public:
    explicit OneExecutionDialog(QWidget *parent, Database& db, QDate date);
    ~OneExecutionDialog();

public slots:
    void selectExercise(QListWidgetItem* item);

private:
    Ui::OneExecutionDialog *ui;
    Database& _db;

    void loadExercisesList();

    // QDialog interface
public slots:
    void accept();
};

