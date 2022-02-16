#include "database.h"
#include "QSqlQuery"
#include "QSqlRecord"
#include <Utilidades/configuracionxml.h>
#include <QSqlError>
#include <QDebug>
#include <QDir>
#include <QSqlResult>

static QSqlDatabase dbconLocal= QSqlDatabase::addDatabase("QMYSQL","Local");
static QSqlDatabase dbcon= QSqlDatabase::addDatabase("QMYSQL","Remota");

/// Conexión para guardar la configuración del usuario
static QSqlDatabase dbconSqlLite= QSqlDatabase::addDatabase("QSQLITE","sqlLiteLocal");

static QSqlQuery resultadoConsulta;
static QSqlRecord rec;

Database::Database()
{}

bool Database::cehqueStatusAccesoMysql() {
    if(!Database::connect("local").isOpen()){
        if(!Database::connect("local").open()){
            return false;
        }else{
            QSqlQuery query = Database::consultaSql("select 1","local");
            if(query.first()) {
                return true;
            }else{
                return false;
            }
        }
    }else{
        QSqlQuery query = Database::consultaSql("select 1;","local");
        if(query.first()) {
            return true;
        }else{
            return false;
        }
    }

}

QSqlDatabase Database::connect(QString _instancia) {

    if(_instancia=="local"){
        dbconLocal.setPort(ConfiguracionXml::getPuertoLocal());
        dbconLocal.setHostName(ConfiguracionXml::getHostLocal());
        dbconLocal.setDatabaseName(ConfiguracionXml::getBaseLocal());
        dbconLocal.setUserName(ConfiguracionXml::getUsuarioLocal());
        dbconLocal.setPassword(ConfiguracionXml::getClaveLocal());
        return dbconLocal;
    }else if(_instancia=="localSqlLite"){

        if(QDir::rootPath()=="/"){
            dbconSqlLite.setDatabaseName("/opt/InfoMadai/infoMadai.db.sqlite");
        }else{
            dbconSqlLite.setDatabaseName(QDir::rootPath()+"/InfoMadai/infoMadai.db.sqlite");
        }


        return dbconSqlLite;
    }else{
        dbcon.setPort(ConfiguracionXml::getPuertoRemoto());
        dbcon.setHostName(ConfiguracionXml::getHostRemoto());
        dbcon.setDatabaseName(ConfiguracionXml::getBaseRemoto());
        dbcon.setUserName(ConfiguracionXml::getUsuarioRemoto());
        dbcon.setPassword(ConfiguracionXml::getClaveRemoto());
        return dbcon;
    }
}
void Database::closeDb() {
    QSqlDatabase::removeDatabase("QMYSQL");
    QSqlDatabase::removeDatabase("QSQLITE");
}

QSqlQuery Database::consultaSql(QString _consulta,QString _instancia){

    if(_instancia=="local"){
        resultadoConsulta = dbconLocal.exec(_consulta);
    }else if(_instancia=="localSqlLite"){
        resultadoConsulta = dbconSqlLite.exec(_consulta);
    }else{
        resultadoConsulta = dbcon.exec(_consulta);
    }
    rec = resultadoConsulta.record();
    return resultadoConsulta;
}


void Database::crearBaseSqlLite(){

    if(!Database::connect("localSqlLite").isOpen()){
        if(!Database::connect("localSqlLite").open()){
            qDebug() << "No conecto";
        }else{

            Database::consultaSql("CREATE TABLE IF NOT EXISTS configuracion (id integer(10) primary key , descripcion varchar(500),valorParametro varchar(50),activo varchar(1));" ,"localSqlLite");
            Database::consultaSql("CREATE TABLE IF NOT EXISTS reclamos (id integer(10) primary key , titulo varchar(500),fechaParaAvisar varchar(50),horaParaAvisar varchar(50),reportado varchar(1));" ,"localSqlLite");

            /// Comienzo a crear los valores en las tablas, si ya no estan creados
            QSqlQuery query(Database::connect("localSqlLite"));

            /// Parametro para el tiempo que demora el monitoreo en chequear los nuevos reclamos
            if(query.exec("SELECT id FROM configuracion where id=1;")) {
                if(!query.first()){
                    Database::consultaSql("INSERT INTO configuracion(id,descripcion,valorParametro,activo)values(1,'Tiempo en minutos que define cada cuanto tiempo cehqueo por nuevos reclamos.','5','0');" ,"localSqlLite");
                }else{
                    qDebug()<< "No es necesario crear el parametro 1";
                }
            }else{
                qDebug()<< query.lastError();
            }


            /// Parametro que indica el area que hay que monitorear
            /// 1 es hardware
            /// 2 es software
            /// 3 es ambas(soft y hard)
            if(query.exec("SELECT id FROM configuracion where id=2;")) {
                if(!query.first()){
                    Database::consultaSql("INSERT INTO configuracion(id,descripcion,valorParametro,activo)values(2,'Parametro que define el area que hay que monitorear, 1 es hardware, 2 es software, 3 es ambas.','3','0');" ,"localSqlLite");
                }else{
                    qDebug()<< "No es necesario crear el parametro 2";
                }
            }else{
                qDebug()<< query.lastError();
            }





            /// Parametro que indica el tiempo de tolerancia minimo para informar un reclamo en estado asignado(2)
            /// 2,4,6,9,11,14
            if(query.exec("SELECT id FROM configuracion where id=4;")) {
                if(!query.first()){
                    Database::consultaSql("INSERT INTO configuracion(id,descripcion,valorParametro,activo)values(4,'Tiempo minimo del reclamo asignado para mostrar en monitoreo en minutos: ','60','1');" ,"localSqlLite");
                }else{
                    qDebug()<< "No es necesario crear el parametro 4";
                }
            }else{
                qDebug()<< query.lastError();
            }



            /// Parametro que indica el tiempo de tolerancia minimo para informar un reclamo en estado nuevo(4)
            /// 2,4,6,9,11,14
            if(query.exec("SELECT id FROM configuracion where id=5;")) {
                if(!query.first()){
                    Database::consultaSql("INSERT INTO configuracion(id,descripcion,valorParametro,activo)values(5,'Tiempo minimo del reclamo nuevo para mostrar en monitoreo en minutos: ','60','1');" ,"localSqlLite");
                }else{
                    qDebug()<< "No es necesario crear el parametro 5";
                }
            }else{
                qDebug()<< query.lastError();
            }



            /// Parametro que indica el tiempo de tolerancia minimo para informar un reclamo en estado espera respuesta cliente(6)
            /// 2,4,6,9,11,14
            if(query.exec("SELECT id FROM configuracion where id=6;")) {
                if(!query.first()){
                    Database::consultaSql("INSERT INTO configuracion(id,descripcion,valorParametro,activo)values(6,'Tiempo minimo del reclamo respuesta cliente para mostrar en monitoreo en minutos: ','60','1');" ,"localSqlLite");
                }else{
                    qDebug()<< "No es necesario crear el parametro 6";
                }
            }else{
                qDebug()<< query.lastError();
            }


            /// Parametro que indica el tiempo de tolerancia minimo para informar un reclamo en estado respuesta(9)
            /// 2,4,6,9,11,14
            if(query.exec("SELECT id FROM configuracion where id=7;")) {
                if(!query.first()){
                    Database::consultaSql("INSERT INTO configuracion(id,descripcion,valorParametro,activo)values(7,'Tiempo minimo del reclamo respuesta para mostrar en monitoreo en minutos: ','60','1');" ,"localSqlLite");
                }else{
                    qDebug()<< "No es necesario crear el parametro 7";
                }
            }else{
                qDebug()<< query.lastError();
            }

            /// Parametro que indica el tiempo de tolerancia minimo para informar un reclamo en estado envio a objetos(11)
            /// 2,4,6,9,11,14
            if(query.exec("SELECT id FROM configuracion where id=8;")) {
                if(!query.first()){
                    Database::consultaSql("INSERT INTO configuracion(id,descripcion,valorParametro,activo)values(8,'Tiempo minimo del reclamo espera objetos para mostrar en monitoreo en minutos: ','60','1');" ,"localSqlLite");
                }else{
                    qDebug()<< "No es necesario crear el parametro 8";
                }
            }else{
                qDebug()<< query.lastError();
            }

            /// Parametro que indica el tiempo de tolerancia minimo para informar un reclamo en estado Coordinado(14)
            /// 2,4,6,9,11,14
            if(query.exec("SELECT id FROM configuracion where id=9;")) {
                if(!query.first()){
                    Database::consultaSql("INSERT INTO configuracion(id,descripcion,valorParametro,activo)values(9,'Tiempo minimo del reclamo Coordinado para mostrar en monitoreo en minutos: ','60','1');" ,"localSqlLite");
                }else{
                    qDebug()<< "No es necesario crear el parametro 9";
                }
            }else{
                qDebug()<< query.lastError();
            }


            /// Parametro que indica el tiempo de tolerancia minimo para informar un reclamo en estado Reasignado(16)
            /// 2,4,6,9,11,14,16
            if(query.exec("SELECT id FROM configuracion where id=10;")) {
                if(!query.first()){
                    Database::consultaSql("INSERT INTO configuracion(id,descripcion,valorParametro,activo)values(10,'Tiempo minimo del reclamo Reasignado para mostrar en monitoreo en minutos: ','60','1');" ,"localSqlLite");
                }else{
                    qDebug()<< "No es necesario crear el parametro 10";
                }
            }else{
                qDebug()<< query.lastError();
            }

            /// Parametro que indica el tiempo de tolerancia minimo para informar un reclamo en estado Finalizado(3)
            /// 2,4,6,9,11,14,16
            if(query.exec("SELECT id FROM configuracion where id=11;")) {
                if(!query.first()){
                    Database::consultaSql("INSERT INTO configuracion(id,descripcion,valorParametro,activo)values(11,'Tiempo minimo del reclamo Finalizado para mostrar en monitoreo en minutos: ','60','1');" ,"localSqlLite");
                }else{
                    qDebug()<< "No es necesario crear el parametro 11";
                }
            }else{
                qDebug()<< query.lastError();
            }


            /// Parametro que indica el tiempo de tolerancia minimo para informar un reclamo en estado Finalizado(3) y de guardia
            /// 2,4,6,9,11,14,16
            if(query.exec("SELECT id FROM configuracion where id=12;")) {
                if(!query.first()){
                    Database::consultaSql("INSERT INTO configuracion(id,descripcion,valorParametro,activo)values(12,'Tiempo minimo del reclamo Finalizado de guardia para mostrar en monitoreo en minutos: ','60','1');" ,"localSqlLite");
                }else{
                    qDebug()<< "No es necesario crear el parametro 12";
                }
            }else{
                qDebug()<< query.lastError();
            }

        }
    }
}


