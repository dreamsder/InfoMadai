#ifndef MODULORECLAMOS_H
#define MODULORECLAMOS_H

#include <QAbstractListModel>

class Reclamos
{
public:
    Q_INVOKABLE Reclamos(const int &codigoReclamo,const QString &fechaCompletaReclamo,const QString &nombreCliente,const QString &nombreSucursal

                         ,const int &codigoTecnico, const QString &nombreTecnico);

    int codigoReclamo() const;
    QString fechaCompletaReclamo() const;
    QString nombreCliente() const;
    QString nombreSucursal() const;    
    int codigoTecnico() const;
    QString nombreTecnico() const;

private:
    int m_codigoReclamo;
    QString m_fechaCompletaReclamo;
    QString m_nombreCliente;
    QString m_nombreSucursal;

    int m_codigoTecnico;
    QString m_nombreTecnico;
};

class ModuloReclamos : public QAbstractListModel
{
    Q_OBJECT
public:
    enum ReclamosRoles {
        codigoReclamoRole = Qt::UserRole + 1,
        fechaCompletaReclamoRole,
        nombreClienteRole,
        nombreSucursalRole,
        codigoTecnicoRole,
        nombreTecnicoRole
    };

    ModuloReclamos(QObject *parent = 0);

    Q_INVOKABLE void agregarReclamo(const Reclamos &Reclamos);
    Q_INVOKABLE void limpiarListaReclamo();
    Q_INVOKABLE int rowCount(const QModelIndex & parent = QModelIndex()) const;
    Q_INVOKABLE QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;
    Q_INVOKABLE void buscarReclamos(QString);
    Q_INVOKABLE void buscarReclamosDeAlertas();


    Q_INVOKABLE int retornaCodigoReclamo(int) const;
    Q_INVOKABLE int retornaCodigoTecnico(int) const;
    Q_INVOKABLE QString retornaNombreTecnico(int) const;    
    Q_INVOKABLE QString retornaFechaCompletaReclamo(int)const;
    Q_INVOKABLE QString retornaNombreCliente(int)const;
    Q_INVOKABLE QString retornaNombreSucursal(int)const;

    Q_INVOKABLE void abrirPaginaWeb(QString )const;

    Q_INVOKABLE bool retornaReclamoActivoParaAviso(QString);

    Q_INVOKABLE QString retornaFechaReclamoParaAviso(QString);
    Q_INVOKABLE QString retornaHoraReclamoParaAviso(QString);

    Q_INVOKABLE bool eliminarAlerta(QString);
    Q_INVOKABLE bool guardarAlerta(QString,QString,QString,QString);

    Q_INVOKABLE QString chequearAlertas();

    Q_INVOKABLE QString retornaCantidadAlertas();


    Q_INVOKABLE void marcarAlertaReportada(QString);

    void eliminarReclamoEnAlertaQueDejoDeEstarCoordinado();

    bool reclamoSigueCoordinado(QString );

    Q_INVOKABLE bool eliminoReclamoRemoto(QString );

    Q_INVOKABLE QString retornaUrlMadai();







private:
    QList<Reclamos> m_Reclamos;
};

#endif // MODULORECLAMOS_H
