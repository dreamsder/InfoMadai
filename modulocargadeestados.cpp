#include "modulocargadeestados.h"
#include <QtSql>
#include <QSqlQuery>
#include <Utilidades/database.h>
#include <QDebug>
#include <QDateTime>


ModuloCargaDeEstados::ModuloCargaDeEstados(QObject *parent)
    : QAbstractListModel(parent)
{
    QHash<int, QByteArray> roles;
    roles[codigoEstadoRole] = "codigoEstado";
    roles[nombreEstadoRole] = "nombreEstado";
    roles[cantidadReclamosRole] = "cantidadReclamos";
    roles[colorEstadoRole] = "colorEstado";
    setRoleNames(roles);
}
Estados::Estados(const int &codigoEstado, const QString &nombreEstado,const int &cantidadReclamos,const QString &colorEstado)
    : m_codigoEstado(codigoEstado), m_nombreEstado(nombreEstado), m_cantidadReclamos(cantidadReclamos), m_colorEstado(colorEstado)
{
}

int Estados::codigoEstado() const
{
    return m_codigoEstado;
}
QString Estados::nombreEstado() const
{
    return m_nombreEstado;
}
int Estados::cantidadReclamos() const
{
    return m_cantidadReclamos;
}
QString Estados::colorEstado() const
{
    return m_colorEstado;
}


void ModuloCargaDeEstados::agregarEstado(const Estados &estados)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    m_Estados << estados;
    endInsertRows();
}

void ModuloCargaDeEstados::limpiarListaEstados(){
    m_Estados.clear();
}

void ModuloCargaDeEstados::buscarEstados(QString _consultaSql){

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

        ModuloCargaDeEstados::reset();

        if(q.record().count()>0){
            while (q.next()){
                ModuloCargaDeEstados::agregarEstado(Estados(
                                                        q.value(rec.indexOf("codigoEstado")).toInt(),
                                                        q.value(rec.indexOf("nombreEstado")).toString(),
                                                        q.value(rec.indexOf("cantidadReclamos")).toInt(),
                                                        q.value(rec.indexOf("colorEstado")).toString()
                                                        ));
            }
        }
    }

}

int ModuloCargaDeEstados::rowCount(const QModelIndex & parent) const {
    return m_Estados.count();
}

QVariant ModuloCargaDeEstados::data(const QModelIndex & index, int role) const {

    if (index.row() < 0 || index.row() > m_Estados.count()){
        return QVariant();
    }
    const Estados &estados = m_Estados[index.row()];

    if (role == codigoEstadoRole){
        return estados.codigoEstado();
    }
    else if (role == nombreEstadoRole){
        return estados.nombreEstado();
    }
    else if (role == cantidadReclamosRole){
        return estados.cantidadReclamos();
    }
    else if (role == colorEstadoRole){
        return estados.colorEstado();
    }
    return QVariant();
}


QString ModuloCargaDeEstados::retornarReclamosAMonitorearSegunTiempoEstablecido(){

    QString _where=" 1=1 ";
    QString _reclamos=" (1";
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

        QSqlQuery query = Database::consultaSql("SELECT codigoReclamo, nombreTipoReclamo,case when (codigoEstado=3 and codigoTipoReclamo=2) then 99 else codigoEstado end'codigoEstado',fechaHoraGuardado,tiempoReclamo FROM Reclamos ;","local");

        if(query.first()){
            query.previous();
            while (query.next()){

                if(chequeaTiempoActualDelreclamo(query.value(2).toString(),query.value(1).toString(),query.value(3).toString(),query.value(4).toLongLong())){
                    if(chequeoReclamoNoEsteEnAlerta(query.value(0).toString())){

                        _reclamos.append(","+query.value(0).toString());
                    }
                }
            }
            _reclamos.append(") ");
            return _reclamos;
        }else{
            _reclamos.append(") ");
            return _where;
        }
    }

    _reclamos.append(") ");
    return _where;
}

bool ModuloCargaDeEstados::chequeoReclamoNoEsteEnAlerta(QString _codigoReclamo){

    bool conexion=true;
    if(!Database::connect("localSqlLite").isOpen()){
        if(!Database::connect("localSqlLite").open()){
            qDebug() << "No conecto";
            conexion=false;
        }
    }
    if(conexion){
        QSqlQuery query(Database::connect("localSqlLite"));

        if(query.exec("select id,fechaParaAvisar from reclamos where id='"+_codigoReclamo+"';")){
            if(query.first()){
                if(query.value(1).toDate().toString("yyyy-MM-dd")>QDateTime::currentDateTime().date().toString("yyyy-MM-dd")){
                    return false;
                }else{
                    return true;
                }
            }else{
                return true;
            }
        }else{
            return true;
        }
    }else{
        return true;
    }
}

bool ModuloCargaDeEstados::chequeaTiempoActualDelreclamo(QString _codigoEstado,QString _tipoReclamo,QString _fechaHoraGuardado,qlonglong minutosDelReclamo){


   /*

    qlonglong minutosDelReclamo=0;
    QDateTime _tiempoGuardado;

    if(_tipoReclamo=="Comun"){


        // Si el tiempo a comparar es del mismo día, agrego los minutos
        if(_tiempoGuardado.fromString(_fechaHoraGuardado,"yyyy-MM-dd HH:mm").date().toString("yyyy-MM-dd")== QDateTime::currentDateTime().toString("yyyy-MM-dd")){

            if(QDateTime::currentDateTime().toString("HH").toInt()<18){
                minutosDelReclamo+=_tiempoGuardado.fromString(_fechaHoraGuardado,"yyyy-MM-dd HH:mm").time().secsTo(QDateTime::currentDateTime().time())/60;
            }else{
                minutosDelReclamo+=_tiempoGuardado.fromString(_fechaHoraGuardado,"yyyy-MM-dd HH:mm").time().secsTo(QDateTime(QDateTime::currentDateTime().date(),QTime(18,0,0,0)).time())/60;
            }

        }else{
            int i=1;

            if(_tiempoGuardado.fromString(_fechaHoraGuardado,"yyyy-MM-dd HH:mm").time()<QTime(18,0,0,0)){
                minutosDelReclamo+=_tiempoGuardado.fromString(_fechaHoraGuardado,"yyyy-MM-dd HH:mm").time().secsTo(QTime(18,0,0,0))/60;
            }


            while(i!=9999){





                if(_tiempoGuardado.fromString(_fechaHoraGuardado,"yyyy-MM-dd HH:mm").date().addDays(i).toString("yyyy-MM-dd")== QDateTime::currentDateTime().toString("yyyy-MM-dd")){

                    if(QDateTime::currentDateTime().toString("HH").toInt()<18){

                        minutosDelReclamo+=QDateTime(_tiempoGuardado.fromString(_fechaHoraGuardado,"yyyy-MM-dd HH:mm").date(),QTime(9,0,0,0)).addDays(i).time().secsTo(QDateTime::currentDateTime().time())/60;
                    }else{

                        minutosDelReclamo+=QDateTime(_tiempoGuardado.fromString(_fechaHoraGuardado,"yyyy-MM-dd HH:mm").date(),QTime(9,0,0,0)).addDays(i).time().secsTo(QDateTime(QDateTime::currentDateTime().date(),QTime(18,0,0,0)).time())/60;
                    }
                    i=9999;

                }else{
                    if(_tiempoGuardado.fromString(_fechaHoraGuardado,"yyyy-MM-dd HH:mm").date().addDays(i).dayOfWeek()==6 || _tiempoGuardado.fromString(_fechaHoraGuardado,"yyyy-MM-dd HH:mm").date().addDays(i).dayOfWeek()==7){
                        i++;
                    }else{

                        if(esUnDiaFeriadoFijo(_tiempoGuardado.fromString(_fechaHoraGuardado,"yyyy-MM-dd HH:mm").date().addDays(i).toString("yyyy-MM-dd"))){
                            i++;
                        }else{
                            minutosDelReclamo+=QDateTime(_tiempoGuardado.fromString(_fechaHoraGuardado,"yyyy-MM-dd HH:mm").date(),QTime(9,0,0,0)).addDays(i).time().secsTo(QDateTime(QDateTime::currentDateTime().date(),QTime(18,0,0,0)).time())/60;

                            i++;
                        }
                    }
                }
            }
        }
    }else if(_tipoReclamo=="Guardia" ){
        minutosDelReclamo+=_tiempoGuardado.fromString(_fechaHoraGuardado,"yyyy-MM-dd HH:mm").secsTo(QDateTime::currentDateTime())/60;
    }

*/
    if(minutosDelReclamo==0){
        return false;
    }else{
        return retornaTiempoMinimoEstados(minutosDelReclamo,_codigoEstado);
    }
}


bool ModuloCargaDeEstados::retornaTiempoMinimoEstados(qlonglong _tiempoDeReclamos,QString _codigoEstado){




    int _idConfiguracion=0;

    if(_codigoEstado=="2")//Asignado
        _idConfiguracion=4;


    if(_codigoEstado=="4")//Nuevo
        _idConfiguracion=5;

    if(_codigoEstado=="6")//Respuesta de cliente
        _idConfiguracion=6;

    if(_codigoEstado=="9")//Respuesta
        _idConfiguracion=7;

    if(_codigoEstado=="11")//Respuesta de objetos
        _idConfiguracion=8;

    if(_codigoEstado=="14")//Coordinado
        _idConfiguracion=9;

    if(_codigoEstado=="16")//Reasignado
        _idConfiguracion=10;

    if(_codigoEstado=="3")//Finalizado
        _idConfiguracion=11;


    if(_codigoEstado=="99")//Finalizado guardia
        _idConfiguracion=12;

    bool conexion=true;
    if(!Database::connect("localSqlLite").isOpen()){
        if(!Database::connect("localSqlLite").open()){
            qDebug() << "No conecto";
            conexion=false;
        }
    }
    if(conexion){

        QSqlQuery query(Database::connect("localSqlLite"));
        if(query.exec("SELECT valorParametro FROM configuracion where id='"+QString::number(_idConfiguracion)+"'")) {
            if(query.first()){

                if(_tiempoDeReclamos>query.value(0).toLongLong()){

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
    }else {
        return false;
    }
}

QString ModuloCargaDeEstados::retornaTiempoMinimoEstadosSeteado(QString _codigoEstado){


    int _idConfiguracion=0;

    if(_codigoEstado=="2")//Asignado
        _idConfiguracion=4;

    if(_codigoEstado=="4")//Nuevo
        _idConfiguracion=5;

    if(_codigoEstado=="6")//Respuesta de cliente
        _idConfiguracion=6;

    if(_codigoEstado=="9")//Respuesta
        _idConfiguracion=7;

    if(_codigoEstado=="11")//Respuesta de objetos
        _idConfiguracion=8;

    if(_codigoEstado=="14")//Coordinado
        _idConfiguracion=9;

    if(_codigoEstado=="16")//Reasignado
        _idConfiguracion=10;

    if(_codigoEstado=="3")//Finalizado
        _idConfiguracion=11;

    if(_codigoEstado=="99")//Finalizado Guardia
        _idConfiguracion=12;

    bool conexion=true;
    if(!Database::connect("localSqlLite").isOpen()){
        if(!Database::connect("localSqlLite").open()){
            qDebug() << "No conecto";
            conexion=false;
        }
    }
    if(conexion){

        QSqlQuery query(Database::connect("localSqlLite"));
        if(query.exec("SELECT valorParametro FROM configuracion where id='"+QString::number(_idConfiguracion)+"'")) {
            if(query.first()){
                return query.value(0).toString();
            }else{
                return "0";
            }
        }else{
            return "0";
        }
    }else {
        return "0";
    }
}


bool ModuloCargaDeEstados::retornaEstadoMonitoreoActivo(QString _codigoEstado){


    int _idConfiguracion=0;

    if(_codigoEstado=="2")//Asignado
        _idConfiguracion=4;

    if(_codigoEstado=="4")//Nuevo
        _idConfiguracion=5;

    if(_codigoEstado=="6")//Respuesta de cliente
        _idConfiguracion=6;

    if(_codigoEstado=="9")//Respuesta
        _idConfiguracion=7;

    if(_codigoEstado=="11")//Respuesta de objetos
        _idConfiguracion=8;

    if(_codigoEstado=="14")//Coordinado
        _idConfiguracion=9;

    if(_codigoEstado=="16")//Reasignado
        _idConfiguracion=10;

    if(_codigoEstado=="3")//Finalizado
        _idConfiguracion=11;

    if(_codigoEstado=="99")//Finalizado guardia
        _idConfiguracion=12;

    bool conexion=true;
    if(!Database::connect("localSqlLite").isOpen()){
        if(!Database::connect("localSqlLite").open()){
            qDebug() << "No conecto";
            conexion=false;
        }
    }
    if(conexion){

        QSqlQuery query(Database::connect("localSqlLite"));
        if(query.exec("SELECT activo FROM configuracion where id='"+QString::number(_idConfiguracion)+"'")) {
            if(query.first()){
                if(query.value(0).toString()=="1"){
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
    }else {
        return false;
    }
}


void ModuloCargaDeEstados::guardarTipoEstadosActivos(QString _codigoEstado,bool _activo, QString _minutos){


    int _idConfiguracion=0;

    if(_codigoEstado=="2")//Asignado
        _idConfiguracion=4;

    if(_codigoEstado=="4")//Nuevo
        _idConfiguracion=5;

    if(_codigoEstado=="6")//Respuesta de cliente
        _idConfiguracion=6;

    if(_codigoEstado=="9")//Respuesta
        _idConfiguracion=7;

    if(_codigoEstado=="11")//Respuesta de objetos
        _idConfiguracion=8;

    if(_codigoEstado=="14")//Coordinado
        _idConfiguracion=9;

    if(_codigoEstado=="16")//Reasignado
        _idConfiguracion=10;

    if(_codigoEstado=="3")//Finalizado
        _idConfiguracion=11;

    if(_codigoEstado=="99")//Finalizado guardia
        _idConfiguracion=12;

    QString checkActivo="0";
    if(_activo)
        checkActivo="1";




    bool conexion=true;
    if(!Database::connect("localSqlLite").isOpen()){
        if(!Database::connect("localSqlLite").open()){
            qDebug() << "No conecto";
            conexion=false;
        }
    }
    if(conexion){
        QSqlQuery query(Database::connect("localSqlLite"));

        if(query.exec("update configuracion set valorParametro='"+_minutos+"',activo='"+checkActivo+"' where id='"+QString::number(_idConfiguracion)+"'")){
        }else{
            qDebug()<< query.lastError();
        }



    }
}


void ModuloCargaDeEstados::guardarAreaAMonitorear(QString _valorAreasMonitoreo){

    bool conexion=true;
    if(!Database::connect("localSqlLite").isOpen()){
        if(!Database::connect("localSqlLite").open()){
            qDebug() << "No conecto";
            conexion=false;
        }
    }
    if(conexion){
        QSqlQuery query(Database::connect("localSqlLite"));

        if(query.exec("update configuracion set valorParametro='"+_valorAreasMonitoreo+"'  where id=2")){
        }else{
            qDebug()<< query.lastError();
        }
    }
}

QString ModuloCargaDeEstados::retornaAreaAMonitorear(){

    bool conexion=true;
    if(!Database::connect("localSqlLite").isOpen()){
        if(!Database::connect("localSqlLite").open()){
            qDebug() << "No conecto";
            conexion=false;
        }
    }
    if(conexion){
        QSqlQuery query(Database::connect("localSqlLite"));

        if(query.exec("select valorParametro from configuracion where id=2")){
            if(query.first()){
                return query.value(0).toString();
            }else{
                qDebug()<< query.lastError();
                return "3";
            }
        }else{
            qDebug()<< query.lastError();
            return "3";
        }
    }else{
        return "3";
    }
}
QString ModuloCargaDeEstados::retornaTiempoPeriodoMonitoreo(){

    bool conexion=true;
    if(!Database::connect("localSqlLite").isOpen()){
        if(!Database::connect("localSqlLite").open()){
            qDebug() << "No conecto";
            conexion=false;
        }
    }
    if(conexion){
        QSqlQuery query(Database::connect("localSqlLite"));

        if(query.exec("select valorParametro from configuracion where id=1")){
            if(query.first()){
                return query.value(0).toString();
            }else{
                qDebug()<< query.lastError();
                return "3";
            }
        }else{
            qDebug()<< query.lastError();
            return "3";
        }
    }else{
        return "3";
    }
}


void ModuloCargaDeEstados::guardarPeriodoMonitoreo(QString _valorPeriodoMonitoreo){

    bool conexion=true;
    if(!Database::connect("localSqlLite").isOpen()){
        if(!Database::connect("localSqlLite").open()){
            qDebug() << "No conecto";
            conexion=false;
        }
    }
    if(conexion){
        QSqlQuery query(Database::connect("localSqlLite"));

        if(query.exec("update configuracion set valorParametro='"+_valorPeriodoMonitoreo+"'  where id=1")){
        }else{
            qDebug()<< query.lastError();
        }
    }
}



bool ModuloCargaDeEstados::esUnDiaFeriadoFijo(QString _fechaAcomparar){
    bool conexion=true;

    if(!Database::cehqueStatusAccesoMysql())
        Database::connect("local").close();

    if(!Database::connect("local").isOpen()){
        if(!Database::connect("local").open()){

            //  Logs::loguear("No hay conexion a la base de datos almacen");
            conexion=false;
        }
    }
    if(conexion){
        QSqlQuery query(Database::connect("local"));

        if(query.exec("SELECT * FROM Feriados where codigoMes=0 and codigoAnio=0 and fechaFeriado='"+QDate::fromString(_fechaAcomparar,"yyyy-MM-dd").toString("dd-MM")+"'")){

            if(query.first()){
                if(query.value(0).toString()!=""){
                    return true;
                }else{
                    return false;
                }
            }else{
                return false;
            }
        }else{
            return false;}
    }else{
        return false;}
}

QString ModuloCargaDeEstados::fechaDeHoy(){
    QDateTime dat;
    return dat.currentDateTime().toString("yyyy/MM/dd");
}



QString ModuloCargaDeEstados::retornarReclamosAMonitorearSegunTiempoEstablecidoPorEstado(QString codigoEstado){

    QString _where=" 1=1 ";
    QString _reclamos=" (1";
    bool conexion=true;

    QString consultaSql="";

    if(codigoEstado=="99"){
        consultaSql="SELECT codigoReclamo, nombreTipoReclamo,'99' as 'codigoEstado',fechaHoraGuardado,tiempoReclamo FROM Reclamos where codigoEstado=3 and codigoTipoReclamo=2;";
    }else{
        consultaSql="SELECT codigoReclamo, nombreTipoReclamo,codigoEstado,fechaHoraGuardado,tiempoReclamo FROM Reclamos where codigoEstado='"+codigoEstado+"';";
    }



    if(!Database::cehqueStatusAccesoMysql())
        Database::connect("local").close();

    if(!Database::connect("local").isOpen()){
        if(!Database::connect("local").open()){
            qDebug() << "No conecto";
            conexion=false;
        }
    }
    if(conexion){

        QSqlQuery query = Database::consultaSql(consultaSql,"local");

        if(query.first()){
            query.previous();
            while (query.next()){


                if(chequeaTiempoActualDelreclamo(query.value(2).toString(),query.value(1).toString(),query.value(3).toString(),query.value(4).toLongLong())){

                    if(chequeoReclamoNoEsteEnAlerta(query.value(0).toString())){
                        _reclamos.append(","+query.value(0).toString());
                    }
                }
            }

            _reclamos.append(") ");
            return _reclamos;
        }else{

            _reclamos.append(") ");
            return _where;
        }
    }

    _reclamos.append(") ");
    return _where;
}
