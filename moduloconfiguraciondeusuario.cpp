#include "moduloconfiguraciondeusuario.h"
#include <Utilidades/database.h>
#include <QDebug>

ModuloconfiguracionDeUsuario::ModuloconfiguracionDeUsuario(QObject *parent) :
    QObject(parent)
{

}
qlonglong ModuloconfiguracionDeUsuario::retornaTiempoMonitoreo(){

    bool conexion=true;

    if(!Database::connect("localSqlLite").isOpen()){
        if(!Database::connect("localSqlLite").open()){
            qDebug() << "No conecto";
            conexion=false;
        }
    }
    if(conexion){


        QSqlQuery query(Database::connect("localSqlLite"));

        if(query.exec("SELECT valorParametro FROM configuracion where id=1;")) {
            if(query.first()){
                return ((query.value(0).toLongLong())*60)*1000;
            }else{
                return ((10)*60)*1000;
            }
        }else{
            return ((10)*60)*1000;
        }
    }
    return ((10)*60)*1000;
}

QString ModuloconfiguracionDeUsuario::retornaWhereParaConsultaDeReclamosyEstados(){
    bool conexion=true;

    QString _where= " 1=1 " ;

    if(!Database::connect("localSqlLite").isOpen()){
        if(!Database::connect("localSqlLite").open()){
            qDebug() << "No conecto";
            conexion=false;
        }
    }
    if(conexion){
        QSqlQuery query(Database::connect("localSqlLite"));

        if(query.exec("SELECT valorParametro FROM configuracion where id=2;")) {
            if(query.first()){
                if(query.value(0).toString().trimmed()==""){
                    _where.append(" and codigoArea in (1,2) ");
                }else if(query.value(0).toString().trimmed()=="1"){
                    _where.append(" and codigoArea in (1)   ");
                }else if(query.value(0).toString().trimmed()=="2"){
                    _where.append(" and codigoArea in (2)   ");
                }else if(query.value(0).toString().trimmed()=="3"){
                    _where.append(" and codigoArea in (1,2)   ");
                }
            }else{
                _where.append(" and codigoArea in (1,2)   ");
            }
        }else{
            _where.append(" and codigoArea in (1,2)   ");
        }

        query.clear();
        if(query.exec("SELECT id,activo FROM configuracion where id in (4,5,6,7,8,9,10,11,12);")) {
            if(query.first()){
                query.previous();
                _where.append(" and ( codigoEstado in (-1");
                bool muestroLosDeGuardiaFinalizados=false;
                while(query.next()){

                    if(query.value(1).toString()=="1"){

                        if(query.value(0).toString()=="4"){
                            _where.append(",2");
                        }else if(query.value(0).toString()=="5"){
                            _where.append(",4");
                        }else if(query.value(0).toString()=="6"){
                            _where.append(",6");
                        }else if(query.value(0).toString()=="7"){
                            _where.append(",9");
                        }else if(query.value(0).toString()=="8"){
                            _where.append(",11");
                        }else if(query.value(0).toString()=="9"){
                            _where.append(",14");
                        }else if(query.value(0).toString()=="10"){
                            _where.append(",16");
                        }else if(query.value(0).toString()=="11"){
                            _where.append(",3");
                        }else if(query.value(0).toString()=="12"){
                            //_where.append(",99");
                            muestroLosDeGuardiaFinalizados=true;
                        }
                    }
                }
                if(muestroLosDeGuardiaFinalizados){
                    _where.append(") or  (codigoEstado=3 and codigoTipoReclamo=2)) ");
                }else{
                    _where.append(") ) ");
                }

            }else{
                _where.append(" and codigoEstado in (2,3,4,6,9,11,14,16,99) ");
            }
        }else {
            _where.append(" and codigoEstado in (2,3,4,6,9,11,14,16,99) ");
        }
    }

   // qDebug()<< _where;
    return _where;
}
