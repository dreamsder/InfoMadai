#ifndef MODULOTECNICOS_H
#define MODULOTECNICOS_H

#include <QAbstractListModel>

class Tecnicos
{
public:
   Q_INVOKABLE Tecnicos(const int &codigoTecnico, const QString &nombreTecnico,const int &codigoEstado);

    int codigoTecnico() const;
    QString nombreTecnico() const;
    int codigoEstado() const;
private:
    int m_codigoTecnico;
    QString m_nombreTecnico;
    int m_codigoEstado;
};

class ModuloTecnicos : public QAbstractListModel
{
    Q_OBJECT
public:
    enum TecnicosRoles {
        codigoTecnicoRole = Qt::UserRole + 1,
        nombreTecnicoRole,
        codigoEstadoRole
    };

    ModuloTecnicos(QObject *parent = 0);

    Q_INVOKABLE void agregarTecnico(const Tecnicos &Tecnicos);
    Q_INVOKABLE void limpiarListaTecnico();
    Q_INVOKABLE int rowCount(const QModelIndex & parent = QModelIndex()) const;
    Q_INVOKABLE QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;
    Q_INVOKABLE void buscarTecnicos(QString);

private:
    QList<Tecnicos> m_Tecnicos;
};

#endif // MODULOTECNICOS_H
