#ifndef DATABASE_H
#define DATABASE_H

#include <QSqlDatabase>

#include <QSqlDatabase>
#include "QSqlQuery"

class Database : public QSqlDatabase
{
public:

    static QSqlDatabase connect(QString) ;
    static void closeDb();
    static QSqlQuery consultaSql(QString,QString);

    static void crearBaseSqlLite();

    static bool cehqueStatusAccesoMysql();



private:
    Database();

};

#endif // DATABASE_H
