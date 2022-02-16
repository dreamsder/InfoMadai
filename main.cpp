#include <QtGui>
#include "window.h"
#include <QTextCodec>
#include <Utilidades/configuracionxml.h>
#include <QDebug>
#include <Utilidades/database.h>

int main(int argc, char *argv[])
{

    ////Codificacion del sistema para aceptar tildes y ñ
    QTextCodec *linuxCodec=QTextCodec::codecForName("UTF-8");
    QTextCodec::setCodecForTr(linuxCodec);
    QTextCodec::setCodecForCStrings(linuxCodec);
    QTextCodec::setCodecForLocale(linuxCodec);

    Q_INIT_RESOURCE(systray);

    QApplication app(argc, argv);

    if (!QSystemTrayIcon::isSystemTrayAvailable()) {
        QMessageBox::critical(0, QObject::tr("Systray"),
                              QObject::tr("No se puede detectar una bandeja de entrada disponible"));
        return 1;
    }
    QApplication::setQuitOnLastWindowClosed(false);

    if(ConfiguracionXml::leerConfiguracionXml()){
        qDebug()<< "configuracion leida ok";

        Database::crearBaseSqlLite();


    }else{
        qDebug()<< "falla leer conf";
    }

    Window window;



    return app.exec();
}
