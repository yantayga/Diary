#include "utilites.h"

#include <QRegExpValidator>

QValidator* createUniversalDoubleValidator()
{
	return new QRegExpValidator(QRegExp("\\d+([,.]\\d+)?"));
}
