#include "moduloreclamos.h"
#include <QtSql>
#include <QSqlQuery>
#include <Utilidades/database.h>
#include <QDebug>
#include <QDesktopServices>
#include <modulocargadeestados.h>
#include <QDate>
#include <QDateTime>
#include <QTime>
#include <Utilidades/configuracionxml.h>

ModuloCargaDeEstados fechas;


ModuloReclamos::ModuloReclamos(QObject *parent)
    : QAbstractListModel(parent)
{
    QHash<int, QByteArray> roles;
    roles[codigoReclamoRole] = "codigoReclamo";
    roles[fechaCompletaReclamoRole] = "fechaCompletaReclamo";
    roles[nombreClienteRole] = "nombreCliente";
    roles[nombreSucursalRole] = "nombreSucursal";
    roles[codigoTecnicoRole] = "codigoTecnico";
    roles[nombreTecnicoRole] = "nombreTecnico";
    setRoleNames(roles);
}
Reclamos::Reclamos(const int &codigoReclamo, const QString &fechaCompletaReclamo, const QString &nombreCliente, const QString &nombreSucursal, const int &codigoTecnico, const QString &nombreTecnico)
    : m_codigoReclamo(codigoReclamo), m_fechaCompletaReclamo(fechaCompletaReclamo), m_nombreCliente(nombreCliente), m_nombreSucursal(nombreSucursal), m_codigoTecnico(codigoTecnico), m_nombreTecnico(nombreTecnico)
{
}

int Reclamos::codigoReclamo() const
{
    return m_codigoReclamo;
}
QString Reclamos::fechaCompletaReclamo() const
{
    return m_fechaCompletaReclamo;
}
QString Reclamos::nombreCliente() const
{
    return m_nombreCliente;
}
QString Reclamos::nombreSucursal() const
{
    return m_nombreSucursal;
}
int Reclamos::codigoTecnico() const
{
    return m_codigoTecnico;
}
QString Reclamos::nombreTecnico() const
{
    return m_nombreTecnico;
}


void ModuloReclamos::agregarReclamo(const Reclamos &reclamos)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    m_Reclamos << reclamos;
    endInsertRows();
}

void ModuloReclamos::limpiarListaReclamo(){
    m_Reclamos.clear();
}

void ModuloReclamos::buscarReclamos(QString _consultaSql){


    qDebug()<<_consultaSql;

    bool conexion=true;

    if(!Database::cehqueStatusAccesoMysql())
        Database::connect("local").close();

    if(!Database::connect("local").isOpen()){
        if(!Database::connect("local").open()){
            qDebug() << "No conecto";
            conexion=false;
        }
    }
    if(conexion){

        QSqlQuery q = Database::consultaSql(_consultaSql,"local");
        QSqlRecord rec = q.record();

        ModuloReclamos::reset();

        if(q.record().count()>0){
            while (q.next()){
                ModuloReclamos::agregarReclamo(Reclamos(
                                                   q.value(rec.indexOf("codigoReclamo")).toInt(),
                                                   q.value(rec.indexOf("fechaCompletaReclamo")).toString(),
                                                   q.value(rec.indexOf("nombreCliente")).toString(),
                                                   q.value(rec.indexOf("nombreSucursal")).toString(),
                                                   q.value(rec.indexOf("codigoTecnico")).toInt(),
                                                   q.value(rec.indexOf("nombreTecnico")).toString()
                                                   ));
            }
        }
    }
}

int ModuloReclamos::rowCount(const QModelIndex & parent) const {
    return m_Reclamos.count();
}

QVariant ModuloReclamos::data(const QModelIndex & index, int role) const {

    if (index.row() < 0 || index.row() > m_Reclamos.count()){
        return QVariant();
    }
    const Reclamos &reclamos = m_Reclamos[index.row()];

    if (role == codigoReclamoRole){
        return reclamos.codigoReclamo();
    }
    else if (role == fechaCompletaReclamoRole){
        return reclamos.fechaCompletaReclamo();
    }
    else if (role == nombreClienteRole){
        return reclamos.nombreCliente();
    }
    else if (role == nombreSucursalRole){
        return reclamos.nombreSucursal();
    }
    else if (role == codigoTecnicoRole){
        return reclamos.codigoTecnico();
    }
    else if (role == nombreTecnicoRole){
        return reclamos.nombreTecnico();
    }
    return QVariant();
}
int ModuloReclamos::retornaCodigoReclamo(int indice) const{
    return m_Reclamos[indice].codigoReclamo();
}
int ModuloReclamos::retornaCodigoTecnico(int indice) const{
    return m_Reclamos[indice].codigoTecnico();
}
QString ModuloReclamos::retornaNombreTecnico(int indice) const{
    return m_Reclamos[indice].nombreTecnico();
}
QString ModuloReclamos::retornaFechaCompletaReclamo(int indice) const{
    return m_Reclamos[indice].fechaCompletaReclamo();
}
QString ModuloReclamos::retornaNombreCliente(int indice) const{
    return m_Reclamos[indice].nombreCliente();
}
QString ModuloReclamos::retornaNombreSucursal(int indice) const{
    return m_Reclamos[indice].nombreSucursal();
}




void ModuloReclamos::abrirPaginaWeb(QString _paginaWeb)const{

    QDesktopServices::openUrl(QUrl(_paginaWeb));

}

bool ModuloReclamos::retornaReclamoActivoParaAviso(QString _codigoReclamo){

    bool conexion=true;

    if(!Database::connect("localSqlLite").isOpen()){
        if(!Database::connect("localSqlLite").open()){
            qDebug() << "No conecto";
            conexion=false;
        }
    }
    if(conexion){

        QSqlQuery query(Database::connect("localSqlLite"));

        if(query.exec("SELECT id FROM reclamos where id='"+_codigoReclamo+"';")) {
            if(query.first()){
                return true;
            }else{
                return false;
            }
        }else{
            return false;
        }
    }else{
        return false;
    }
}
QString ModuloReclamos::retornaFechaReclamoParaAviso(QString _codigoReclamo){

    bool conexion=true;

    if(!Database::connect("localSqlLite").isOpen()){
        if(!Database::connect("localSqlLite").open()){
            qDebug() << "No conecto";
            conexion=false;
        }
    }
    if(conexion){

        QSqlQuery query(Database::connect("localSqlLite"));

        if(query.exec("SELECT fechaParaAvisar FROM reclamos where id='"+_codigoReclamo+"';")) {
            if(query.first()){
                return query.value(0).toString();
            }else{
                return fechas.fechaDeHoy();
            }
        }else{
            return fechas.fechaDeHoy();
        }
    }else{
        return fechas.fechaDeHoy();
    }
}
QString ModuloReclamos::retornaHoraReclamoParaAviso(QString _codigoReclamo){

    bool conexion=true;

    if(!Database::connect("localSqlLite").isOpen()){
        if(!Database::connect("localSqlLite").open()){
            qDebug() << "No conecto";
            conexion=false;
        }
    }
    if(conexion){

        QSqlQuery query(Database::connect("localSqlLite"));

        if(query.exec("SELECT horaParaAvisar FROM reclamos where id='"+_codigoReclamo+"';")) {
            if(query.first()){
                return query.value(0).toString();
            }else{
                return "09:15";
            }
        }else{
            return "09:15";
        }
    }else{
        return "09:15";
    }
}

bool ModuloReclamos::eliminarAlerta(QString _codigoReclamo){

    bool conexion=true;

    if(!Database::connect("localSqlLite").isOpen()){
        if(!Database::connect("localSqlLite").open()){
            qDebug() << "No conecto";
            conexion=false;
        }
    }
    if(conexion){

        QSqlQuery query(Database::connect("localSqlLite"));

        if(query.exec("delete FROM reclamos where id='"+_codigoReclamo+"';")){
            return true;
        }else{
            return false;
        }
    }else{
        return false;
    }
}
void ModuloReclamos::marcarAlertaReportada(QString _codigoReclamo){

    bool conexion=true;

    if(!Database::connect("localSqlLite").isOpen()){
        if(!Database::connect("localSqlLite").open()){
            qDebug() << "No conecto";
            conexion=false;
        }
    }
    if(conexion){

        QSqlQuery query(Database::connect("localSqlLite"));

        query.exec("delete from reclamos where id='"+_codigoReclamo+"';");

    }
}
bool ModuloReclamos::guardarAlerta(QString _codigoReclamo,QString _tituloReclamo,QString _fechaGrabar,QString _horaGrabar){

    QString _fechaCorrecta="";
    QString _horaCorrecta="";

    if(_fechaGrabar.trimmed()=="--" || _horaGrabar.trimmed()==":" || _fechaGrabar.contains("--",Qt::CaseInsensitive)==true || _horaGrabar.length()!=5 || _fechaGrabar.length()!=10){
        return false;
    }

    _fechaCorrecta=_fechaGrabar.trimmed();
    _horaCorrecta=_horaGrabar.trimmed();

    bool conexion=true;
    if(!Database::connect("localSqlLite").isOpen()){
        if(!Database::connect("localSqlLite").open()){
            qDebug() << "No conecto";
            conexion=false;
        }
    }
    if(conexion){
        QSqlQuery query(Database::connect("localSqlLite"));

        if(query.exec("REPLACE INTO reclamos(id,titulo,fechaParaAvisar,horaParaAvisar,reportado) values('"+_codigoReclamo+"','"+_tituloReclamo+"','"+_fechaCorrecta+"','"+_horaCorrecta+"','0');")){
            return true;
        }else{
            return false;
        }
    }else{
        return false;
    }
}
QString ModuloReclamos::chequearAlertas(){

    bool conexion=true;

    if(!Database::connect("localSqlLite").isOpen()){
        if(!Database::connect("localSqlLite").open()){
            qDebug() << "No conecto";
            conexion=false;
        }
    }
    if(conexion){

        QString _reclamosAInformar="";

        QSqlQuery query(Database::connect("localSqlLite"));


        QString _fechaDeHoy=QDateTime::currentDateTime().date().toString("yyyy-MM-dd");
        QString _horaActual=QDateTime::currentDateTime().time().toString("HH:mm");


        if(query.exec("select id,horaParaAvisar from reclamos where fechaParaAvisar='"+_fechaDeHoy+"' and reportado='0'")){
            if(query.first()){
                query.previous();
                while (query.next()) {
                    if(query.value(1).toString().trimmed()==_horaActual.trimmed()){

                        _reclamosAInformar.append("[ "+query.value(0).toString()+" ]");
                        marcarAlertaReportada(query.value(0).toString());

                    }
                }
                return _reclamosAInformar;
            }else{
                return "";
            }
        }else{
            return "";
        }
    }else{
        return "";
    }
}

void ModuloReclamos::buscarReclamosDeAlertas(){
    bool conexion=true;


    if(!Database::connect("localSqlLite").isOpen()){
        if(!Database::connect("localSqlLite").open()){
            qDebug() << "No conecto";
            conexion=false;
        }
    }
    if(conexion){

        QSqlQuery q = Database::consultaSql("select * from reclamos;","localSqlLite");
        QSqlRecord rec = q.record();

        ModuloReclamos::reset();

        if(q.record().count()>0){
            while (q.next()){
                ModuloReclamos::agregarReclamo(Reclamos(
                                                   q.value(rec.indexOf("id")).toInt(),
                                                   q.value(rec.indexOf("titulo")).toString(),
                                                   q.value(rec.indexOf("fechaParaAvisar")).toString(),
                                                   q.value(rec.indexOf("horaParaAvisar")).toString(),
                                                   q.value(rec.indexOf("id")).toInt(),
                                                   q.value(rec.indexOf("reportado")).toString()
                                                   ));
            }
        }
    }
}


QString ModuloReclamos::retornaUrlMadai(){
        return ConfiguracionXml::getHostRemoto();
}

QString ModuloReclamos::retornaCantidadAlertas(){

    bool conexion=true;

    if(!Database::connect("localSqlLite").isOpen()){
        if(!Database::connect("localSqlLite").open()){
            qDebug() << "No conecto";
            conexion=false;
        }
    }
    if(conexion){

        eliminarReclamoEnAlertaQueDejoDeEstarCoordinado();

        QSqlQuery query(Database::connect("localSqlLite"));
        if(query.exec("select count(*) from reclamos ")){
            if(query.first()){
                return query.value(0).toString();
            }else{
                return "0";
            }
        }else{
            return "0";
        }
    }else{
        return "0";
    }
}
void ModuloReclamos::eliminarReclamoEnAlertaQueDejoDeEstarCoordinado(){

    bool conexion=true;

    if(!Database::connect("localSqlLite").isOpen()){
        if(!Database::connect("localSqlLite").open()){
            qDebug() << "No conecto";
            conexion=false;
        }
    }
    if(conexion){

        QSqlQuery query(Database::connect("localSqlLite"));
        if(query.exec("select id from reclamos ")){
            if(query.first()){
                query.previous();
                while (query.next()){

                    if(!reclamoSigueCoordinado(query.value(0).toString()))
                        eliminarAlerta(query.value(0).toString());

                }
            }
        }
    }
}
bool ModuloReclamos::reclamoSigueCoordinado(QString _codigoReclamo){
    bool conexion=true;

    if(!Database::connect("remota").isOpen()){
        if(!Database::connect("remota").open()){
            qDebug() << "No conecto";
            conexion=false;
        }
    }
    if(conexion){
        QSqlQuery query(Database::connect("remota"));
        if(query.exec("select idReclamo from reclamos where idReclamo='"+_codigoReclamo+"' and idEstado=14;")){
            if(query.first()){
                return true;
            }else{
                return false;
            }
        }else{
            return true;
        }
    }else{
        return true;
    }
}

bool ModuloReclamos::eliminoReclamoRemoto(QString _codigoReclamo){
    bool conexion=true;

    if(!Database::connect("local").isOpen()){
        if(!Database::connect("local").open()){
            qDebug() << "No conecto";
            conexion=false;
        }
    }
    if(conexion){

        QSqlQuery query(Database::connect("local"));

        if(query.exec("delete FROM Reclamos where codigoReclamo='"+_codigoReclamo+"';")){
            return true;
        }else{
            return false;
        }
    }else{
        return false;
    }
}



