#include "modulotecnicos.h"
#include <QtSql>
#include <QSqlQuery>
#include <Utilidades/database.h>
#include <QDebug>

ModuloTecnicos::ModuloTecnicos(QObject *parent)
    : QAbstractListModel(parent)
{
    QHash<int, QByteArray> roles;
    roles[codigoTecnicoRole] = "codigoTecnico";
    roles[nombreTecnicoRole] = "nombreTecnico";
    roles[codigoEstadoRole] = "codigoEstado";
    setRoleNames(roles);
}
Tecnicos::Tecnicos(const int &codigoTecnico, const QString &nombreTecnico,const int &codigoEstado)
    : m_codigoTecnico(codigoTecnico), m_nombreTecnico(nombreTecnico),m_codigoEstado(codigoEstado)
{
}

int Tecnicos::codigoTecnico() const
{
    return m_codigoTecnico;
}
QString Tecnicos::nombreTecnico() const
{
    return m_nombreTecnico;
}
int Tecnicos::codigoEstado() const
{
    return m_codigoEstado;
}

void ModuloTecnicos::agregarTecnico(const Tecnicos &tecnicos)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    m_Tecnicos << tecnicos;
    endInsertRows();
}

void ModuloTecnicos::limpiarListaTecnico(){
    m_Tecnicos.clear();
}

void ModuloTecnicos::buscarTecnicos(QString _consultaSql){

    if(!Database::cehqueStatusAccesoMysql())
        Database::connect("local").close();

    bool conexion=true;

    if(!Database::connect("local").isOpen()){
        if(!Database::connect("local").open()){
            qDebug() << "No conecto";
            conexion=false;
        }
    }
    if(conexion){

        QSqlQuery q = Database::consultaSql(_consultaSql,"local");
        QSqlRecord rec = q.record();

        ModuloTecnicos::reset();

        if(q.record().count()>0){
            while (q.next()){
                ModuloTecnicos::agregarTecnico(Tecnicos(
                                                        q.value(rec.indexOf("codigoTecnico")).toInt(),
                                                        q.value(rec.indexOf("nombreTecnico")).toString(),
                                                   q.value(rec.indexOf("codigoEstado")).toInt()
                                                        ));
            }
        }
    }
}

int ModuloTecnicos::rowCount(const QModelIndex & parent) const {
    return m_Tecnicos.count();
}

QVariant ModuloTecnicos::data(const QModelIndex & index, int role) const {

    if (index.row() < 0 || index.row() > m_Tecnicos.count()){
        return QVariant();
    }
    const Tecnicos &tecnicos = m_Tecnicos[index.row()];

    if (role == codigoTecnicoRole){
        return tecnicos.codigoTecnico();
    }
    else if (role == nombreTecnicoRole){
        return tecnicos.nombreTecnico();
    }
    else if (role == codigoEstadoRole){
        return tecnicos.codigoEstado();
    }
    return QVariant();
}
