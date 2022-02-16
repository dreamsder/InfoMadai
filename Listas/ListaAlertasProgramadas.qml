import QtQuick 1.1
import "../controlesQml"


Rectangle {
    id: rectListaTecnicoReclamos
    anchors.right:  parent.right
    anchors.rightMargin: 0
    anchors.left: parent.left
    anchors.leftMargin: 0
    height: 19
    color: "#00000000"

    BotonBarraDeHerramientas{
        id:eliminarFecha
        anchors.left: parent.left
        anchors.leftMargin: 10
        visible: true
        source: "qrc:/images/delete.png"       
        width: 19
        height: 19
        onClic: {

           modeloReclamos.eliminarAlerta(codigoReclamo)

           modeloReclamosAlertas.limpiarListaReclamo()
           modeloReclamosAlertas.buscarReclamosDeAlertas()
           retornaCantidadAlertas.text=modeloReclamosAlertas.retornaCantidadAlertas()

            modeloCargaEstados.limpiarListaEstados()
            modeloCargaEstados.buscarEstados("select case when (codigoEstado=3 and codigoTipoReclamo=2) then 99 else codigoEstado end'codigoEstado',case when (codigoEstado=3 and codigoTipoReclamo=2) then 'Finalizado Guardia' else nombreEstado end'nombreEstado',count(codigoReclamo)'cantidadReclamos',case when (codigoEstado=3 and codigoTipoReclamo=2) then 'D63A19' else colorEstado end'colorEstado' from Reclamos where "+modeloConfiguracionUsuarios.retornaWhereParaConsultaDeReclamosyEstados() +"  and codigoReclamo in "+modeloCargaEstados.retornarReclamosAMonitorearSegunTiempoEstablecido()+"  group by case when (codigoEstado=3 and codigoTipoReclamo=2) then 99 else codigoEstado end order by 2")
        }
    }


    Text {
        id: txtCodigoReclamo
        width: 30
        color: "#e68326"
        text: "#"+codigoReclamo
        font.underline: false
        smooth: true
        height: 19
        style: Text.Raised
        font.family: "Arial"
        font.bold: true
        font.pointSize: 9
        anchors.leftMargin: 10
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        anchors.left: eliminarFecha.right
        opacity: 0.8

        MouseArea {
            id: mouseAreaLinkReclamo
            hoverEnabled: true
            anchors.fill: parent
            onClicked: {

                modeloReclamos.abrirPaginaWeb("http://"+ modeloReclamos.retornaUrlMadai()  +"/madai/recXPerfilModificar.php?idReclamo="+codigoReclamo)

            }
            onEntered: {
                txtCodigoReclamo.opacity=1
                txtCodigoReclamo.font.underline=true

            }
            onExited: {
                txtCodigoReclamo.opacity=0.8
                txtCodigoReclamo.font.underline=false
            }
        }

    }

    Text {
        id: txtSucursalSeleccionada
        color: "#bebdbd"
        text: fechaCompletaReclamo
        smooth: true
        height: 19
        style: Text.Raised
        font.family: "Arial"
        font.bold: true
        font.pointSize: 9
        anchors.leftMargin: 10
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        anchors.left: txtCodigoReclamo.right
    }
}
