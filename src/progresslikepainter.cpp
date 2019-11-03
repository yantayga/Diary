#include "progresslikepainter.h"

#include <QPainter>

void ProgressLikePainter::paint(QPainter *painter, const QStyleOptionViewItem &option,
		   const QModelIndex &index) const
{
	double amount = index.data(Qt::UserRole+1).toDouble();
	double targetMin = index.data(Qt::UserRole+2).toDouble();
	double targetMax = index.data(Qt::UserRole+3).toDouble();
	if (amount < targetMin)
	{
		double d = amount / targetMin;
		const QBrush bg1(QColor(0xaa,0xaa,0xaa)); // gray
		painter->fillRect(option.rect, bg1);
		QRect r = option.rect;
		r.setRight(r.left() + (r.width() * d));
		const QBrush bg2(QColor(0,0xff,0)); // green
		painter->fillRect(r, bg2);
	}
	else if (amount < targetMax || targetMax == 0)
	{
		const QBrush bg(QColor(0,0xff,0)); // green
		painter->fillRect(option.rect, bg);
	}
	else
	{
		const QBrush bg(QColor(0xff,0,0)); // red
		painter->fillRect(option.rect, bg);
	}

	QString s = index.data(Qt::DisplayRole).toString();
	painter->setPen((option.state & QStyle::State_Selected)?QColor(0xff,0xff,0xff):QColor(0,0,0));
	painter->drawText(option.rect, Qt::AlignHCenter | Qt::AlignVCenter, s);
}
