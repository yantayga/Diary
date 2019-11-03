#pragma once

#include <QStyledItemDelegate>

class ProgressLikePainter : public QStyledItemDelegate
{
	Q_OBJECT

public:
	using QStyledItemDelegate::QStyledItemDelegate;

	void paint(QPainter *painter, const QStyleOptionViewItem &option,
			   const QModelIndex &index) const override;
};

