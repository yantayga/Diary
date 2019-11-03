/********************************************************************************
** Form generated from reading UI file 'oneexecutiondialog.ui'
**
** Created by: Qt User Interface Compiler version 5.13.1
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_ONEEXECUTIONDIALOG_H
#define UI_ONEEXECUTIONDIALOG_H

#include <QtCore/QVariant>
#include <QtWidgets/QApplication>
#include <QtWidgets/QDateEdit>
#include <QtWidgets/QDialog>
#include <QtWidgets/QDialogButtonBox>
#include <QtWidgets/QHeaderView>
#include <QtWidgets/QLabel>
#include <QtWidgets/QListWidget>
#include <QtWidgets/QPlainTextEdit>
#include <QtWidgets/QTableWidget>

QT_BEGIN_NAMESPACE

class Ui_OneExecutionDialog
{
public:
    QDialogButtonBox *buttonBox;
    QListWidget *listExercises;
    QTableWidget *tableParams;
    QLabel *labelComments;
    QDateEdit *dateExecution;
    QPlainTextEdit *textComment;

    void setupUi(QDialog *OneExecutionDialog)
    {
        if (OneExecutionDialog->objectName().isEmpty())
            OneExecutionDialog->setObjectName(QString::fromUtf8("OneExecutionDialog"));
        OneExecutionDialog->resize(500, 506);
        OneExecutionDialog->setModal(true);
        buttonBox = new QDialogButtonBox(OneExecutionDialog);
        buttonBox->setObjectName(QString::fromUtf8("buttonBox"));
        buttonBox->setGeometry(QRect(150, 470, 341, 32));
        buttonBox->setOrientation(Qt::Horizontal);
        buttonBox->setStandardButtons(QDialogButtonBox::Cancel|QDialogButtonBox::Ok);
        listExercises = new QListWidget(OneExecutionDialog);
        listExercises->setObjectName(QString::fromUtf8("listExercises"));
        listExercises->setGeometry(QRect(10, 40, 481, 261));
        tableParams = new QTableWidget(OneExecutionDialog);
        if (tableParams->columnCount() < 3)
            tableParams->setColumnCount(3);
        tableParams->setObjectName(QString::fromUtf8("tableParams"));
        tableParams->setGeometry(QRect(10, 310, 311, 111));
        tableParams->setColumnCount(3);
        tableParams->horizontalHeader()->setHighlightSections(false);
        tableParams->horizontalHeader()->setStretchLastSection(true);
        tableParams->verticalHeader()->setVisible(false);
        tableParams->verticalHeader()->setDefaultSectionSize(21);
        tableParams->verticalHeader()->setHighlightSections(false);
        labelComments = new QLabel(OneExecutionDialog);
        labelComments->setObjectName(QString::fromUtf8("labelComments"));
        labelComments->setGeometry(QRect(330, 310, 161, 111));
        labelComments->setFrameShape(QFrame::StyledPanel);
        labelComments->setFrameShadow(QFrame::Sunken);
        labelComments->setAlignment(Qt::AlignLeading|Qt::AlignLeft|Qt::AlignTop);
        labelComments->setWordWrap(true);
        dateExecution = new QDateEdit(OneExecutionDialog);
        dateExecution->setObjectName(QString::fromUtf8("dateExecution"));
        dateExecution->setGeometry(QRect(10, 10, 481, 22));
        textComment = new QPlainTextEdit(OneExecutionDialog);
        textComment->setObjectName(QString::fromUtf8("textComment"));
        textComment->setGeometry(QRect(10, 430, 481, 31));

        retranslateUi(OneExecutionDialog);
        QObject::connect(buttonBox, SIGNAL(accepted()), OneExecutionDialog, SLOT(accept()));
        QObject::connect(buttonBox, SIGNAL(rejected()), OneExecutionDialog, SLOT(reject()));
        QObject::connect(listExercises, SIGNAL(currentItemChanged(QListWidgetItem*,QListWidgetItem*)), OneExecutionDialog, SLOT(selectExercise(QListWidgetItem*)));

        QMetaObject::connectSlotsByName(OneExecutionDialog);
    } // setupUi

    void retranslateUi(QDialog *OneExecutionDialog)
    {
        OneExecutionDialog->setWindowTitle(QCoreApplication::translate("OneExecutionDialog", "Dialog", nullptr));
        labelComments->setText(QString());
        textComment->setPlaceholderText(QCoreApplication::translate("OneExecutionDialog", "\320\272\320\276\320\274\320\274\320\265\320\275\321\202\320\260\321\200\320\270\320\271", nullptr));
    } // retranslateUi

};

namespace Ui {
    class OneExecutionDialog: public Ui_OneExecutionDialog {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_ONEEXECUTIONDIALOG_H
