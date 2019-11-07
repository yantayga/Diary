#pragma once

#include "database.h"
#include "utilites.h"

#include <QDialog>
#include <QListWidget>
#include <QLineEdit>
#include <QStyledItemDelegate>

class EditValidatedDelegate : public QStyledItemDelegate
{
	Q_OBJECT

public:
	EditValidatedDelegate(QObject* parent = nullptr): QStyledItemDelegate(parent) {}

	QWidget *createEditor(QWidget* parent, const QStyleOptionViewItem&, const QModelIndex&) const override
	{
		QLineEdit *editor = new QLineEdit(parent);
		editor->setFrame(false);
		editor->setValidator(createUniversalDoubleValidator());
		return editor;
	}

	void setEditorData(QWidget* editor, const QModelIndex& index) const override
	{
		QString value = index.model()->data(index, Qt::EditRole).toString();
		static_cast<QLineEdit*>(editor)->setText(value);
	}

	void setModelData(QWidget* editor, QAbstractItemModel* model, const QModelIndex& index) const override
	{
		QString value = static_cast<QLineEdit*>(editor)->text();
		model->setData(index, value, Qt::EditRole);
	}

	void updateEditorGeometry(QWidget* editor, const QStyleOptionViewItem& option, const QModelIndex&) const override
	{
		editor->setGeometry(option.rect);
	}
};

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
	void chkShowAllStateChanged(int);

private:
	Ui::OneExecutionDialog *ui;
	Database& _db;

	void loadExercisesList();

	// QDialog interface
public slots:
	void accept();
};

