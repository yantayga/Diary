/********************************************************************************
** Form generated from reading UI file 'mainwindow.ui'
**
** Created by: Qt User Interface Compiler version 5.13.1
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_MAINWINDOW_H
#define UI_MAINWINDOW_H

#include <QtCore/QVariant>
#include <QtWidgets/QAction>
#include <QtWidgets/QApplication>
#include <QtWidgets/QCalendarWidget>
#include <QtWidgets/QFrame>
#include <QtWidgets/QHBoxLayout>
#include <QtWidgets/QHeaderView>
#include <QtWidgets/QLabel>
#include <QtWidgets/QMainWindow>
#include <QtWidgets/QMenu>
#include <QtWidgets/QMenuBar>
#include <QtWidgets/QSplitter>
#include <QtWidgets/QStatusBar>
#include <QtWidgets/QTabWidget>
#include <QtWidgets/QTableWidget>
#include <QtWidgets/QWidget>

QT_BEGIN_NAMESPACE

class Ui_MainWindow
{
public:
    QAction *actionAddExercise;
    QAction *actionAddFoodIntake;
    QWidget *centralwidget;
    QHBoxLayout *horizontalLayout;
    QFrame *frameLeft;
    QCalendarWidget *diaryDate;
    QTabWidget *tabsRegistered;
    QSplitter *tabExercises;
    QTableWidget *tableExcercises;
    QLabel *totalExercises;
    QTableWidget *tableExerciseDetails;
    QSplitter *tabFood;
    QTableWidget *tableFoodIncome;
    QTabWidget *tabsFoodContent;
    QWidget *tabTracking;
    QTableWidget *tableTracking;
    QWidget *tabNotes;
    QMenuBar *menubar;
    QMenu *menuFile;
    QMenu *menu;
    QStatusBar *statusbar;

    void setupUi(QMainWindow *MainWindow)
    {
        if (MainWindow->objectName().isEmpty())
            MainWindow->setObjectName(QString::fromUtf8("MainWindow"));
        MainWindow->resize(1049, 600);
        MainWindow->setAnimated(false);
        actionAddExercise = new QAction(MainWindow);
        actionAddExercise->setObjectName(QString::fromUtf8("actionAddExercise"));
        actionAddExercise->setShortcutContext(Qt::ApplicationShortcut);
        actionAddFoodIntake = new QAction(MainWindow);
        actionAddFoodIntake->setObjectName(QString::fromUtf8("actionAddFoodIntake"));
        actionAddFoodIntake->setShortcutContext(Qt::ApplicationShortcut);
        centralwidget = new QWidget(MainWindow);
        centralwidget->setObjectName(QString::fromUtf8("centralwidget"));
        horizontalLayout = new QHBoxLayout(centralwidget);
        horizontalLayout->setSpacing(0);
        horizontalLayout->setObjectName(QString::fromUtf8("horizontalLayout"));
        horizontalLayout->setContentsMargins(0, 0, 0, 0);
        frameLeft = new QFrame(centralwidget);
        frameLeft->setObjectName(QString::fromUtf8("frameLeft"));
        frameLeft->setMinimumSize(QSize(248, 169));
        frameLeft->setMaximumSize(QSize(248, 16777215));
        frameLeft->setFrameShape(QFrame::Panel);
        diaryDate = new QCalendarWidget(frameLeft);
        diaryDate->setObjectName(QString::fromUtf8("diaryDate"));
        diaryDate->setGeometry(QRect(0, 0, 248, 169));

        horizontalLayout->addWidget(frameLeft);

        tabsRegistered = new QTabWidget(centralwidget);
        tabsRegistered->setObjectName(QString::fromUtf8("tabsRegistered"));
        tabExercises = new QSplitter();
        tabExercises->setObjectName(QString::fromUtf8("tabExercises"));
        QSizePolicy sizePolicy(QSizePolicy::Expanding, QSizePolicy::Expanding);
        sizePolicy.setHorizontalStretch(0);
        sizePolicy.setVerticalStretch(0);
        sizePolicy.setHeightForWidth(tabExercises->sizePolicy().hasHeightForWidth());
        tabExercises->setSizePolicy(sizePolicy);
        tabExercises->setOrientation(Qt::Vertical);
        tabExercises->setOpaqueResize(true);
        tabExercises->setChildrenCollapsible(false);
        tableExcercises = new QTableWidget(tabExercises);
        if (tableExcercises->columnCount() < 3)
            tableExcercises->setColumnCount(3);
        tableExcercises->setObjectName(QString::fromUtf8("tableExcercises"));
        QSizePolicy sizePolicy1(QSizePolicy::Preferred, QSizePolicy::Preferred);
        sizePolicy1.setHorizontalStretch(0);
        sizePolicy1.setVerticalStretch(0);
        sizePolicy1.setHeightForWidth(tableExcercises->sizePolicy().hasHeightForWidth());
        tableExcercises->setSizePolicy(sizePolicy1);
        tableExcercises->setEditTriggers(QAbstractItemView::NoEditTriggers);
        tableExcercises->setAlternatingRowColors(true);
        tableExcercises->setSelectionMode(QAbstractItemView::SingleSelection);
        tableExcercises->setSelectionBehavior(QAbstractItemView::SelectRows);
        tableExcercises->setShowGrid(true);
        tableExcercises->setColumnCount(3);
        tabExercises->addWidget(tableExcercises);
        tableExcercises->horizontalHeader()->setDefaultSectionSize(150);
        tableExcercises->horizontalHeader()->setHighlightSections(false);
        tableExcercises->verticalHeader()->setVisible(false);
        tableExcercises->verticalHeader()->setDefaultSectionSize(21);
        tableExcercises->verticalHeader()->setHighlightSections(false);
        totalExercises = new QLabel(tabExercises);
        totalExercises->setObjectName(QString::fromUtf8("totalExercises"));
        totalExercises->setMinimumSize(QSize(0, 18));
        totalExercises->setMaximumSize(QSize(16777215, 18));
        totalExercises->setTextInteractionFlags(Qt::LinksAccessibleByMouse|Qt::TextSelectableByMouse);
        tabExercises->addWidget(totalExercises);
        tableExerciseDetails = new QTableWidget(tabExercises);
        if (tableExerciseDetails->columnCount() < 2)
            tableExerciseDetails->setColumnCount(2);
        tableExerciseDetails->setObjectName(QString::fromUtf8("tableExerciseDetails"));
        sizePolicy1.setHeightForWidth(tableExerciseDetails->sizePolicy().hasHeightForWidth());
        tableExerciseDetails->setSizePolicy(sizePolicy1);
        tableExerciseDetails->setEditTriggers(QAbstractItemView::NoEditTriggers);
        tableExerciseDetails->setAlternatingRowColors(true);
        tableExerciseDetails->setSelectionMode(QAbstractItemView::SingleSelection);
        tableExerciseDetails->setSelectionBehavior(QAbstractItemView::SelectRows);
        tableExerciseDetails->setColumnCount(2);
        tabExercises->addWidget(tableExerciseDetails);
        tableExerciseDetails->horizontalHeader()->setDefaultSectionSize(150);
        tableExerciseDetails->verticalHeader()->setVisible(false);
        tableExerciseDetails->verticalHeader()->setDefaultSectionSize(21);
        tableExerciseDetails->verticalHeader()->setHighlightSections(false);
        tabsRegistered->addTab(tabExercises, QString());
        tabFood = new QSplitter();
        tabFood->setObjectName(QString::fromUtf8("tabFood"));
        sizePolicy.setHeightForWidth(tabFood->sizePolicy().hasHeightForWidth());
        tabFood->setSizePolicy(sizePolicy);
        tabFood->setOrientation(Qt::Vertical);
        tabFood->setChildrenCollapsible(false);
        tableFoodIncome = new QTableWidget(tabFood);
        if (tableFoodIncome->columnCount() < 2)
            tableFoodIncome->setColumnCount(2);
        tableFoodIncome->setObjectName(QString::fromUtf8("tableFoodIncome"));
        tableFoodIncome->setMinimumSize(QSize(150, 0));
        tableFoodIncome->setEditTriggers(QAbstractItemView::NoEditTriggers);
        tableFoodIncome->setAlternatingRowColors(true);
        tableFoodIncome->setSelectionMode(QAbstractItemView::SingleSelection);
        tableFoodIncome->setSelectionBehavior(QAbstractItemView::SelectRows);
        tableFoodIncome->setShowGrid(true);
        tableFoodIncome->setColumnCount(2);
        tabFood->addWidget(tableFoodIncome);
        tableFoodIncome->horizontalHeader()->setDefaultSectionSize(150);
        tableFoodIncome->horizontalHeader()->setHighlightSections(false);
        tableFoodIncome->verticalHeader()->setVisible(false);
        tableFoodIncome->verticalHeader()->setDefaultSectionSize(21);
        tableFoodIncome->verticalHeader()->setHighlightSections(false);
        tabsFoodContent = new QTabWidget(tabFood);
        tabsFoodContent->setObjectName(QString::fromUtf8("tabsFoodContent"));
        tabsFoodContent->setMinimumSize(QSize(0, 150));
        tabFood->addWidget(tabsFoodContent);
        tabsRegistered->addTab(tabFood, QString());
        tabTracking = new QWidget();
        tabTracking->setObjectName(QString::fromUtf8("tabTracking"));
        tableTracking = new QTableWidget(tabTracking);
        if (tableTracking->columnCount() < 3)
            tableTracking->setColumnCount(3);
        tableTracking->setObjectName(QString::fromUtf8("tableTracking"));
        tableTracking->setGeometry(QRect(50, 120, 797, 289));
        QSizePolicy sizePolicy2(QSizePolicy::Maximum, QSizePolicy::Maximum);
        sizePolicy2.setHorizontalStretch(0);
        sizePolicy2.setVerticalStretch(0);
        sizePolicy2.setHeightForWidth(tableTracking->sizePolicy().hasHeightForWidth());
        tableTracking->setSizePolicy(sizePolicy2);
        tableTracking->setEditTriggers(QAbstractItemView::NoEditTriggers);
        tableTracking->setAlternatingRowColors(true);
        tableTracking->setSelectionMode(QAbstractItemView::SingleSelection);
        tableTracking->setSelectionBehavior(QAbstractItemView::SelectRows);
        tableTracking->setShowGrid(true);
        tableTracking->setColumnCount(3);
        tableTracking->horizontalHeader()->setDefaultSectionSize(150);
        tableTracking->horizontalHeader()->setHighlightSections(false);
        tableTracking->verticalHeader()->setVisible(false);
        tableTracking->verticalHeader()->setDefaultSectionSize(21);
        tableTracking->verticalHeader()->setHighlightSections(false);
        tabsRegistered->addTab(tabTracking, QString());
        tabNotes = new QWidget();
        tabNotes->setObjectName(QString::fromUtf8("tabNotes"));
        tabsRegistered->addTab(tabNotes, QString());

        horizontalLayout->addWidget(tabsRegistered);

        MainWindow->setCentralWidget(centralwidget);
        menubar = new QMenuBar(MainWindow);
        menubar->setObjectName(QString::fromUtf8("menubar"));
        menubar->setGeometry(QRect(0, 0, 1049, 18));
        menuFile = new QMenu(menubar);
        menuFile->setObjectName(QString::fromUtf8("menuFile"));
        menu = new QMenu(menubar);
        menu->setObjectName(QString::fromUtf8("menu"));
        MainWindow->setMenuBar(menubar);
        statusbar = new QStatusBar(MainWindow);
        statusbar->setObjectName(QString::fromUtf8("statusbar"));
        MainWindow->setStatusBar(statusbar);

        menubar->addAction(menuFile->menuAction());
        menubar->addAction(menu->menuAction());
        menuFile->addAction(actionAddExercise);
        menu->addAction(actionAddFoodIntake);

        retranslateUi(MainWindow);
        QObject::connect(diaryDate, SIGNAL(clicked(QDate)), MainWindow, SLOT(dateChanged(QDate)));
        QObject::connect(tableExcercises, SIGNAL(itemSelectionChanged()), MainWindow, SLOT(exerciseSelectionChanged()));
        QObject::connect(actionAddExercise, SIGNAL(triggered()), MainWindow, SLOT(onAddExecise()));
        QObject::connect(tableFoodIncome, SIGNAL(itemSelectionChanged()), MainWindow, SLOT(foodSelectionChanged()));
        QObject::connect(actionAddFoodIntake, SIGNAL(triggered()), MainWindow, SLOT(onAddFoodIntake()));
        QObject::connect(tableFoodIncome, SIGNAL(cellDoubleClicked(int,int)), MainWindow, SLOT(onEditFoodIntake(int,int)));

        tabsRegistered->setCurrentIndex(1);
        tabsFoodContent->setCurrentIndex(-1);


        QMetaObject::connectSlotsByName(MainWindow);
    } // setupUi

    void retranslateUi(QMainWindow *MainWindow)
    {
        MainWindow->setWindowTitle(QCoreApplication::translate("MainWindow", "\320\224\320\275\320\265\320\262\320\275\320\270\320\272", nullptr));
        actionAddExercise->setText(QCoreApplication::translate("MainWindow", "\320\224\320\276\320\261\320\260\320\262\320\270\321\202\321\214 \321\203\320\277\321\200\320\260\320\266\320\275\320\265\320\275\320\270\320\265", nullptr));
#if QT_CONFIG(shortcut)
        actionAddExercise->setShortcut(QCoreApplication::translate("MainWindow", "Ctrl+E", nullptr));
#endif // QT_CONFIG(shortcut)
        actionAddFoodIntake->setText(QCoreApplication::translate("MainWindow", "\320\224\320\276\320\261\320\260\320\262\320\270\321\202\321\214 \320\277\321\200\320\270\320\265\320\274 \320\277\320\270\321\211\320\270", nullptr));
#if QT_CONFIG(shortcut)
        actionAddFoodIntake->setShortcut(QCoreApplication::translate("MainWindow", "Ctrl+F", nullptr));
#endif // QT_CONFIG(shortcut)
        totalExercises->setText(QCoreApplication::translate("MainWindow", "TextLabel", nullptr));
        tabsRegistered->setTabText(tabsRegistered->indexOf(tabExercises), QCoreApplication::translate("MainWindow", "\320\243\320\277\321\200\320\260\320\266\320\275\320\265\320\275\320\270\321\217", nullptr));
        tabsRegistered->setTabText(tabsRegistered->indexOf(tabFood), QCoreApplication::translate("MainWindow", "\320\225\320\264\320\260", nullptr));
        tabsRegistered->setTabText(tabsRegistered->indexOf(tabTracking), QCoreApplication::translate("MainWindow", "\320\237\320\260\321\200\320\260\320\274\320\265\321\202\321\200\321\213", nullptr));
        tabsRegistered->setTabText(tabsRegistered->indexOf(tabNotes), QCoreApplication::translate("MainWindow", "Page", nullptr));
        menuFile->setTitle(QCoreApplication::translate("MainWindow", "\320\243\320\277\321\200\320\260\320\266\320\275\320\265\320\275\320\270\321\217", nullptr));
        menu->setTitle(QCoreApplication::translate("MainWindow", "\320\225\320\264\320\260", nullptr));
    } // retranslateUi

};

namespace Ui {
    class MainWindow: public Ui_MainWindow {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_MAINWINDOW_H
