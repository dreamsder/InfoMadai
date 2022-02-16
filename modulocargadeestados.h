#ifndef MODULOCARGADEESTADOS_H
#define MODULOCARGADEESTADOS_H

#include <QAbstractListModel>

class Estados
{
public:
   Q_INVOKABLE Estados(const int &codigoEstado, const QString &nombreEstado,const int &cantidadReclamos,const QString &colorEstado);

    int codigoEstado() const;
    QString nombreEstado() const;
    int cantidadReclamos() const;
    QString colorEstado() const;

private:
    int m_codigoEstado;
    QString m_nombreEstado;
    int m_cantidadReclamos;
    QString m_colorEstado;
};

class ModuloCargaDeEstados : public QAbstractListModel
{
    Q_OBJECT
public:
    enum EstadosRoles {
        codigoEstadoRole = Qt::UserRole + 1,
        nombreEstadoRole,
        cantidadReclamosRole,
        colorEstadoRole
    };

    ModuloCargaDeEstados(QObject *parent = 0);

    Q_INVOKABLE void agregarEstado(const Estados &Estados);
    Q_INVOKABLE void limpiarListaEstados();
    Q_INVOKABLE int rowCount(const QModelIndex & parent = QModelIndex()) const;
    Q_INVOKABLE QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;
    Q_INVOKABLE void buscarEstados(QString);

    Q_INVOKABLE QString retornarReclamosAMonitorearSegunTiempoEstablecido();

    Q_INVOKABLE QString retornarReclamosAMonitorearSegunTiempoEstablecidoPorEstado(QString codigoEstado);



    Q_INVOKABLE bool chequeaTiempoActualDelreclamo(QString , QString, QString, qlonglong);

    Q_INVOKABLE bool esUnDiaFeriadoFijo(QString);

    Q_INVOKABLE bool retornaTiempoMinimoEstados(qlonglong, QString);
    Q_INVOKABLE QString retornaTiempoMinimoEstadosSeteado(QString);

    Q_INVOKABLE bool retornaEstadoMonitoreoActivo(QString);

    Q_INVOKABLE void guardarTipoEstadosActivos(QString ,bool , QString );

    Q_INVOKABLE void guardarAreaAMonitorear(QString);

    Q_INVOKABLE QString retornaAreaAMonitorear();

    Q_INVOKABLE QString retornaTiempoPeriodoMonitoreo();

    Q_INVOKABLE void guardarPeriodoMonitoreo(QString);
    Q_INVOKABLE QString fechaDeHoy();

    Q_INVOKABLE bool chequeoReclamoNoEsteEnAlerta(QString);













private:
    QList<Estados> m_Estados;
};


#endif // MODULOCARGADEESTADOS_H
