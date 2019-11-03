/********************************************************************************
** Form generated from reading UI file 'onefoodintakedialog.ui'
**
** Created by: Qt User Interface Compiler version 5.13.1
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_ONEFOODINTAKEDIALOG_H
#define UI_ONEFOODINTAKEDIALOG_H

#include <QtCore/QVariant>
#include <QtWidgets/QApplication>
#include <QtWidgets/QDateEdit>
#include <QtWidgets/QDialog>
#include <QtWidgets/QDialogButtonBox>
#include <QtWidgets/QLabel>
#include <QtWidgets/QLineEdit>
#include <QtWidgets/QListWidget>
#include <QtWidgets/QPlainTextEdit>

QT_BEGIN_NAMESPACE

class Ui_OneFoodIntakeDialog
{
public:
    QDialogButtonBox *buttonBox;
    QDateEdit *dateExecution;
    QListWidget *listFoods;
    QPlainTextEdit *textComment;
    QLabel *label;
    QLineEdit *textAmount;

    void setupUi(QDialog *OneFoodIntakeDialog)
    {
        if (OneFoodIntakeDialog->objectName().isEmpty())
            OneFoodIntakeDialog->setObjectName(QString::fromUtf8("OneFoodIntakeDialog"));
        OneFoodIntakeDialog->resize(499, 696);
        buttonBox = new QDialogButtonBox(OneFoodIntakeDialog);
        buttonBox->setObjectName(QString::fromUtf8("buttonBox"));
        buttonBox->setGeometry(QRect(150, 660, 341, 32));
        buttonBox->setOrientation(Qt::Horizontal);
        buttonBox->setStandardButtons(QDialogButtonBox::Cancel|QDialogButtonBox::Ok);
        dateExecution = new QDateEdit(OneFoodIntakeDialog);
        dateExecution->setObjectName(QString::fromUtf8("dateExecution"));
        dateExecution->setGeometry(QRect(10, 10, 481, 22));
        listFoods = new QListWidget(OneFoodIntakeDialog);
        listFoods->setObjectName(QString::fromUtf8("listFoods"));
        listFoods->setGeometry(QRect(10, 40, 481, 531));
        textComment = new QPlainTextEdit(OneFoodIntakeDialog);
        textComment->setObjectName(QString::fromUtf8("textComment"));
        textComment->setGeometry(QRect(9, 620, 480, 31));
        label = new QLabel(OneFoodIntakeDialog);
        label->setObjectName(QString::fromUtf8("label"));
        label->setGeometry(QRect(10, 580, 121, 16));
        label->setTextFormat(Qt::PlainText);
        textAmount = new QLineEdit(OneFoodIntakeDialog);
        textAmount->setObjectName(QString::fromUtf8("textAmount"));
        textAmount->setGeometry(QRect(100, 580, 113, 20));

        retranslateUi(OneFoodIntakeDialog);
        QObject::connect(buttonBox, SIGNAL(accepted()), OneFoodIntakeDialog, SLOT(accept()));
        QObject::connect(buttonBox, SIGNAL(rejected()), OneFoodIntakeDialog, SLOT(reject()));
        QObject::connect(listFoods, SIGNAL(currentItemChanged(QListWidgetItem*,QListWidgetItem*)), OneFoodIntakeDialog, SLOT(selectFood(QListWidgetItem*)));

        QMetaObject::connectSlotsByName(OneFoodIntakeDialog);
    } // setupUi

    void retranslateUi(QDialog *OneFoodIntakeDialog)
    {
        OneFoodIntakeDialog->setWindowTitle(QCoreApplication::translate("OneFoodIntakeDialog", "Dialog", nullptr));
        textComment->setPlaceholderText(QCoreApplication::translate("OneFoodIntakeDialog", "\320\272\320\276\320\274\320\274\320\265\320\275\321\202\320\260\321\200\320\270\320\271", nullptr));
        label->setText(QCoreApplication::translate("OneFoodIntakeDialog", "\320\232\320\276\320\273\320\270\321\207\320\265\321\201\321\202\320\262\320\276:", nullptr));
        textAmount->setPlaceholderText(QCoreApplication::translate("OneFoodIntakeDialog", "\320\272\320\276\320\273\320\270\321\207\320\265\321\201\321\202\320\262\320\276", nullptr));
    } // retranslateUi

};

namespace Ui {
    class OneFoodIntakeDialog: public Ui_OneFoodIntakeDialog {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_ONEFOODINTAKEDIALOG_H
