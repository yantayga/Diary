#include "mainwindow.h"
#include "ui_mainwindow.h"

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    _db.createTables();
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::dateChanged(QDate date)
{
    qDebug() << "Date changed to " << date;
}
