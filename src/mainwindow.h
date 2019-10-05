#pragma once

#include <QMainWindow>

#include "database.h"

QT_BEGIN_NAMESPACE
namespace Ui { class MainWindow; }
QT_END_NAMESPACE

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

public slots:
    void dateChanged(QDate date);

private:
    Database _db;

private:
    Ui::MainWindow *ui;
};
