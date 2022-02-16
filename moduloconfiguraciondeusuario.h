#ifndef MODULOCONFIGURACIONDEUSUARIO_H
#define MODULOCONFIGURACIONDEUSUARIO_H

#include <QObject>

class ModuloconfiguracionDeUsuario : public QObject
{
    Q_OBJECT
public:
    explicit ModuloconfiguracionDeUsuario(QObject *parent = 0);
    
     Q_INVOKABLE qlonglong retornaTiempoMonitoreo();

     Q_INVOKABLE QString retornaWhereParaConsultaDeReclamosyEstados();


   Q_INVOKABLE static bool getReclamoVisible(){
        return m_reclamosVisibles;
    }

   Q_INVOKABLE static void setReclamoVisile(bool value){
        m_reclamosVisibles=value;
    }



    ///Seteo de visibilidad configuraciones
    Q_INVOKABLE static bool getConfiguracionVisible(){
         return m_configuracionVisibles;
     }
    Q_INVOKABLE static void setConfiguracionVisible(bool value){
         m_configuracionVisibles=value;
     }


    ///Seteo de visibilidad de ventana principal
    Q_INVOKABLE static bool getVentanaPrincipalVisible(){
         return m_ventanaPrincipalVisibles;
     }
    Q_INVOKABLE static void setVentanaPrincipalVisible(bool value){
         m_ventanaPrincipalVisibles=value;
     }


    ///Seteo de visibilidad de ventana mini display
    Q_INVOKABLE static bool getVentanaMiniDisplayVisible(){
         return m_ventanaMiniDisplayVisibles;
     }
    Q_INVOKABLE static void setVentanaMiniDisplayVisible(bool value){
         m_ventanaMiniDisplayVisibles=value;
     }




    ///Seteo de visibilidad de ventana alertas
    Q_INVOKABLE static bool getVentanaAlertasVisible(){
         return m_ventanaAlertasVisible;
     }
    Q_INVOKABLE static void setVentanaAlertasVisible(bool value){
         m_ventanaAlertasVisible=value;
     }




    ///Seteo tamanio pantalla ancho
    Q_INVOKABLE static int getTamanioPantallaWidth(){
         return m_tamanioPantallaWidth;
     }
    Q_INVOKABLE static void setTamanioPantallaWidth(int value){
         m_tamanioPantallaWidth=value;
     }
    ///Seteo tamanio pantalla alto
    Q_INVOKABLE static int getTamanioPantallaHeight(){
         return m_tamanioPantallaHeight;
     }
    Q_INVOKABLE static void setTamanioPantallaHeight(int value){
         m_tamanioPantallaHeight=value;
     }



signals:
    
public slots:

private:

    static bool m_reclamosVisibles;
    static bool m_configuracionVisibles;
    static bool m_ventanaAlertasVisible;
    static bool m_ventanaPrincipalVisibles;
    static bool m_ventanaMiniDisplayVisibles;

    static int m_tamanioPantallaWidth;
    static int m_tamanioPantallaHeight;

    
};

#endif // MODULOCONFIGURACIONDEUSUARIO_H
