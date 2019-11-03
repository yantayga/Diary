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
    void exerciseSelectionChanged();
    void foodSelectionChanged();
    void onAddExecise();
    void onAddFoodIntake();

private:
    Database _db;

    void updateExerciseDetails(QDate date, int id);
    void updateExercises(QDate date);
    void updateFood(QDate date);
    void updateFoodDetails(QDate date, int id);

    QDate getActualDate();

    void initTableWidgets();
    void initTableWidgetColumns(const QString& name, const QStringList& headerLabels);
    void saveTableWidgetStates();
    void saveTableWidgetColumns(const QString& name);
private:
    Ui::MainWindow *ui;

    // QWidget interface
protected:
    void closeEvent(QCloseEvent *event);
};
