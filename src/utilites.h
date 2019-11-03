#pragma once

#include <QWidget>
#include <QItemSelectionModel>

template<class W>
void selectItemById(W* widget, int id)
{
	for (int i = 0; i < widget->count(); ++i)
	{
		int inId = widget->item(i)->data(Qt::UserRole).toInt();
		if (inId == id)
		{
			widget->setCurrentItem(widget->item(i), QItemSelectionModel::SelectCurrent);
			return;
		}
	}
}
