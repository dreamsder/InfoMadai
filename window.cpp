#include <QtGui>
#include "window.h"
#include <QDebug>
#include <QSysInfo>
#include <QDesktopWidget>
#include <QDeclarativeContext>
#include <QDeclarativeEngine>
#include <QPalette>
#include <QTextCodec>
#include <modulocargadeestados.h>
#include <moduloconfiguraciondeusuario.h>
#include <modulotecnicos.h>
#include <moduloreclamos.h>


ModuloCargaDeEstados moduloCargaEstados;
ModuloconfiguracionDeUsuario moduloConfiguracionUsuarios;
ModuloTecnicos moduloTecnicos;
ModuloReclamos moduloReclamos;
ModuloReclamos moduloReclamosAlertas;

bool ModuloconfiguracionDeUsuario::m_reclamosVisibles;
bool ModuloconfiguracionDeUsuario::m_configuracionVisibles;
bool ModuloconfiguracionDeUsuario::m_ventanaPrincipalVisibles;
bool ModuloconfiguracionDeUsuario::m_ventanaMiniDisplayVisibles;
bool ModuloconfiguracionDeUsuario::m_ventanaAlertasVisible;
int ModuloconfiguracionDeUsuario::m_tamanioPantallaHeight;
int ModuloconfiguracionDeUsuario::m_tamanioPantallaWidth;

//! [0]
Window::Window()
{    


    ////Codificacion del sistema para aceptar tildes y ñ
    QTextCodec *linuxCodec=QTextCodec::codecForName("UTF-8");
    QTextCodec::setCodecForTr(linuxCodec);
    QTextCodec::setCodecForCStrings(linuxCodec);
    QTextCodec::setCodecForLocale(linuxCodec);


    this->setWindowIcon(QIcon(":/images/cero.png"));

    createActions();
    createTrayIcon();

    QDesktopWidget tamanioPantalla;
    moduloConfiguracionUsuarios.setTamanioPantallaHeight(tamanioPantalla.height());
    moduloConfiguracionUsuarios.setTamanioPantallaWidth(tamanioPantalla.width());



    this->setWindowFlags(Qt::CustomizeWindowHint | Qt::WindowStaysOnTopHint | Qt::MSWindowsFixedSizeDialogHint | Qt::FramelessWindowHint);
    this->setWindowOpacity(1);
    this->setFixedHeight(tamanioPantalla.height());
    this->setFixedWidth(tamanioPantalla.width());
    this->setMinimumSize(tamanioPantalla.width(),tamanioPantalla.height());
    this->setMaximumSize(tamanioPantalla.width(),tamanioPantalla.height());
    this->setWindowTitle("Centro de configuraciones");
    this->setStyleSheet("background:rgba(0,0,0,0);"
                        "color:'white';"
                        "font: 13px;"
                        "selection-color: orange;"
                        "selection-background-color: black;"
                        );
    this->setAttribute(Qt::WA_TranslucentBackground,true);

    this->setGeometry(0,0,tamanioPantalla.width(),tamanioPantalla.height());

    connect(trayIcon, SIGNAL(activated(QSystemTrayIcon::ActivationReason)),
            this, SLOT(iconActivated(QSystemTrayIcon::ActivationReason)));

    declarativeViewform = new QDeclarativeView;
    declarativeViewform->setContentsMargins(0,0,0,0);
    declarativeViewform->setGeometry(0,0,tamanioPantalla.width(),tamanioPantalla.height());


    declarativeViewform->rootContext()->setContextProperty("AplicacionPrincipal",this);

    declarativeViewform->rootContext()->setContextProperty("modeloCargaEstados", &moduloCargaEstados );

    declarativeViewform->rootContext()->setContextProperty("modeloConfiguracionUsuarios", &moduloConfiguracionUsuarios );

    declarativeViewform->rootContext()->setContextProperty("modeloTecnicos", &moduloTecnicos );

    declarativeViewform->rootContext()->setContextProperty("modeloReclamos", &moduloReclamos );

    declarativeViewform->rootContext()->setContextProperty("modeloReclamosAlertas", &moduloReclamosAlertas );

    moduloConfiguracionUsuarios.setReclamoVisile(false);
    moduloConfiguracionUsuarios.setVentanaMiniDisplayVisible(true);
    moduloConfiguracionUsuarios.setVentanaAlertasVisible(false);

    declarativeViewform->setInteractive(true);


    declarativeViewform->setSource(QUrl("qrc:/main.qml"));

    this->setContentsMargins(0,0,0,0);

    QVBoxLayout *mainLayout = new QVBoxLayout;
    mainLayout->setMargin(0);
    mainLayout->addWidget(declarativeViewform);
    setLayout(mainLayout);

    this->setIcon(0);
    trayIcon->show();

    this->setVisible(true);



}

void Window::closeEvent(QCloseEvent *event)
{
    /* if (trayIcon->isVisible()) {
        QMessageBox::information(this, tr("Systray"),
                                 tr("The program will keep running in the "
                                    "system tray. To terminate the program, "
                                    "choose <b>Quit</b> in the context menu "
                                    "of the system tray entry."));
        hide();
        event->ignore();
    }*/
}
//! [2]

//! [3]
void Window::setIcon(int index)
{

    /// Si el valor de index es 1, cargo icono de advertencia de nuevos reclamos
    /// Si el valor de index es 0, cargo el icono de bandeja de reclamos vacia
    if(index==1){
        trayIcon->setIcon(QIcon(":/images/reclamos.png"));
    }else{
        trayIcon->setIcon(QIcon(":/images/cero.png"));
    }

}
//! [3]

//! [4]
void Window::iconActivated(QSystemTrayIcon::ActivationReason reason)
{
    switch (reason) {
    case QSystemTrayIcon::Trigger:

      //  showMessage();
        break;
    case QSystemTrayIcon::DoubleClick:

        mostrarVentanaMain();

        break;
    case QSystemTrayIcon::MiddleClick:

        break;
    default:
        ;
    }
}
//! [4]

//! [5]
void Window::showMessage(QString _mensajes)
{
    QSystemTrayIcon::MessageIcon icon = QSystemTrayIcon::MessageIcon(0);
    trayIcon->showMessage("Atento", _mensajes, icon,0);
}
//! [5]

//! [6]
void Window::messageClicked()
{
   /* QMessageBox::information(0, tr("Systray"),
                             tr("Sorry, I already gave what help I could.\n"
                                "Maybe you should try asking a human?"));*/
}

void Window::createActions()
{
 //   minimizeAction = new QAction(tr("Mi&nimize"), this);
 //   connect(minimizeAction, SIGNAL(triggered()), this, SLOT(hide()));

 //   maximizeAction = new QAction(tr("Ma&ximize"), this);
 //   connect(maximizeAction, SIGNAL(triggered()), this, SLOT(showMaximized()));

    actualizarTipoDeReclamos= new QAction(tr("Actualizar estados de reclamos"), this);
    connect(actualizarTipoDeReclamos, SIGNAL(triggered()), this , SLOT(actualizarTipoReclamos()));


    mostrarConfiguracion= new QAction(tr("Configuración"), this);
    connect(mostrarConfiguracion, SIGNAL(triggered()), this , SLOT(mostrarVentanaConfiguracion()));


    mostrarVentanaPrincipal = new QAction(tr("Ventana principal"), this);
    connect(mostrarVentanaPrincipal, SIGNAL(triggered()), this , SLOT(mostrarVentanaMain()));

    mostrarMiniDisplay = new QAction(tr("Mini display"), this);
    connect(mostrarMiniDisplay, SIGNAL(triggered()), this , SLOT(mostrarMiniVentana()));

    mostrarVentanaAlertas = new QAction(tr("Listado de alertas"), this);
    connect(mostrarVentanaAlertas, SIGNAL(triggered()), this , SLOT(mostrarAlertaVentana()));


    quitAction = new QAction(tr("Cerrar bandeja de entrada"), this);
    connect(quitAction, SIGNAL(triggered()), qApp, SLOT(quit()));
}

/*void Window::mostrarVentanaReclamos(){

    if(moduloConfiguracionUsuarios.getReclamoVisible()){
      //  moduloConfiguracionUsuarios.setReclamoVisile(false);
     //   this->hide();

    }else{

    //    this->show();
    }
}*/

void Window::mostrarVentanaMain(){

    if(moduloConfiguracionUsuarios.getVentanaPrincipalVisible()){                
        moduloConfiguracionUsuarios.setVentanaPrincipalVisible(false);
        moduloConfiguracionUsuarios.setReclamoVisile(false);        
    }else{        
        moduloConfiguracionUsuarios.setVentanaPrincipalVisible(true);                
    }
}

void Window::mostrarMiniVentana(){

    if(moduloConfiguracionUsuarios.getVentanaMiniDisplayVisible()){
        moduloConfiguracionUsuarios.setVentanaMiniDisplayVisible(false);
    }else{
        moduloConfiguracionUsuarios.setVentanaMiniDisplayVisible(true);
    }
}

void Window::mostrarAlertaVentana(){

    if(moduloConfiguracionUsuarios.getVentanaAlertasVisible()){
        moduloConfiguracionUsuarios.setVentanaAlertasVisible(false);
    }else{
        moduloReclamosAlertas.limpiarListaReclamo();
        moduloReclamosAlertas.buscarReclamosDeAlertas();
        moduloConfiguracionUsuarios.setVentanaAlertasVisible(true);
    }
}

void Window::actualizarTipoReclamos(){

    moduloCargaEstados.limpiarListaEstados();
    moduloCargaEstados.buscarEstados("select case when (codigoEstado=3 and codigoTipoReclamo=2) then 99 else codigoEstado end'codigoEstado',case when (codigoEstado=3 and codigoTipoReclamo=2) then 'Finalizado Guardia' else nombreEstado end'nombreEstado',count(codigoReclamo)'cantidadReclamos',case when (codigoEstado=3 and codigoTipoReclamo=2) then 'D63A19' else colorEstado end'colorEstado' from Reclamos where "+moduloConfiguracionUsuarios.retornaWhereParaConsultaDeReclamosyEstados() +"  and codigoReclamo in "+moduloCargaEstados.retornarReclamosAMonitorearSegunTiempoEstablecido()+"  group by case when (codigoEstado=3 and codigoTipoReclamo=2) then 99 else codigoEstado end order by 2");

    moduloReclamosAlertas.limpiarListaReclamo();
    moduloReclamosAlertas.buscarReclamosDeAlertas();
    if(moduloCargaEstados.rowCount()!=0){
        this->setIcon(1);
    }else{
        this->setIcon(0);
    }

}

void Window::mostrarVentanaConfiguracion(){

    if(moduloConfiguracionUsuarios.getConfiguracionVisible()){
        moduloConfiguracionUsuarios.setConfiguracionVisible(false);
    }else{
        moduloConfiguracionUsuarios.setConfiguracionVisible(true);
    }
}

void Window::createTrayIcon()
{

    trayIconMenu = new QMenu(this);
    //  trayIconMenu->addAction(minimizeAction);
    //  trayIconMenu->addAction(maximizeAction);
    trayIconMenu->addAction(mostrarVentanaAlertas);
    trayIconMenu->addAction(mostrarConfiguracion);
    trayIconMenu->addAction(mostrarVentanaPrincipal);
    trayIconMenu->addAction(mostrarMiniDisplay);
    trayIconMenu->addAction(actualizarTipoDeReclamos);
    trayIconMenu->addSeparator();
    trayIconMenu->addAction(quitAction);

    trayIcon = new QSystemTrayIcon(this);
    trayIcon->setContextMenu(trayIconMenu);
}

