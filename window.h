#ifndef WINDOW_H
#define WINDOW_H

#include <QSystemTrayIcon>
#include <QDialog>
#include <QDeclarativeView>

QT_BEGIN_NAMESPACE
class QAction;
class QDeclarativeView;

QT_END_NAMESPACE

//! [0]
class Window : public QDialog
{
    Q_OBJECT

public:
    Window();

    void mostrarIcono();

    Q_INVOKABLE void showMessage(QString);
    Q_INVOKABLE void actualizarTipoReclamos();
    Q_INVOKABLE void mostrarVentanaMain();
    Q_INVOKABLE void mostrarMiniVentana();
    Q_INVOKABLE void mostrarVentanaConfiguracion();
    Q_INVOKABLE void mostrarAlertaVentana();
    Q_INVOKABLE void setIcon(int index);

protected:
    void closeEvent(QCloseEvent *event);

private slots:

    void iconActivated(QSystemTrayIcon::ActivationReason reason);
    void messageClicked();

private:

    void createActions();
    void createTrayIcon();

    QAction *mostrarMiniDisplay;
    QAction *mostrarVentanaPrincipal;
    QAction *mostrarVentanaAlertas;
    QAction *actualizarTipoDeReclamos;
    QAction *mostrarConfiguracion;
    QAction *quitAction;

    QSystemTrayIcon *trayIcon;
    QMenu *trayIconMenu;
    QDeclarativeView *declarativeViewform;
};
//! [0]

#endif
