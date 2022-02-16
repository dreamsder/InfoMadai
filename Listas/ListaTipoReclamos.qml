import QtQuick 1.1

Rectangle{
    id: rectListaItem
    width: parent.width
    height: 20
    color: "#00000000"
    radius: 1
    smooth: true

    property string codigoDeTipoReclamo: codigoEstado

    MouseArea{
        id: mousearea1
        anchors.rightMargin: 0
        z: 1
        anchors.fill: parent
        hoverEnabled: true        
        onClicked: {
            mostrarReclamos()
            mpReclamos.textoTipoReclamoSeleccinado=nombreEstado
            mpReclamos.colorRectanguloTipoReclamo="#"+colorEstado

            //Cargo los tecnicos y reclamos

            mpReclamos.cargarReclamos(codigoEstado)


            //modeloTecnicos.buscarTecnicos ("select  codigoTecnicoResponsable'codigoTecnico', nombreTecnicoResponsable'nombreTecnico',codigoEstado'codigoEstado' from Reclamos where "+modeloConfiguracionUsuarios.retornaWhereParaConsultaDeReclamosyEstados() +"  and codigoReclamo in "+modeloCargaEstados.retornarReclamosAMonitorearSegunTiempoEstablecido()+" and codigoEstado='"+codigoEstado+"' group by codigoTecnicoResponsable order by 2")




        }
    }

    PropertyAnimation{
        id:rectListaItemColorSeleccionado
        target: rectListaItem
        property: "color"
        from: "#e9e8e9"
        to:"#9294C6"
        duration: 100

    }
    PropertyAnimation{
        id:rectListaItemColorDeseleccionado
        target: rectListaItem
        property: "color"
        to: "#e9e8e9"
        from:"#9294C6"
        duration: 50

    }

    Rectangle {
        id: rectangle1
        color: "#"+colorEstado
        radius: 2
        clip: true
        smooth: true
        anchors.left: txtCantidadReclamosPorEstado.right
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: parent.top
        anchors.leftMargin: 10

        Text {
            id:txtTipoEstadoReclamo
            text: nombreEstado
            styleColor: {
                if(nombreEstado=="Respuesta" || nombreEstado=="Asignado"){
                    "#ffffff"
                }else{
                    "#000000"
                }
            }

            clip: true
            style: Text.Raised
            horizontalAlignment: Text.AlignLeft
            font.family: "Microsoft Sans Serif"
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            smooth: true
            font.pointSize: 10
            font.bold: true
            verticalAlignment: Text.AlignVCenter
            anchors.left: parent.left
            anchors.leftMargin: 5
            anchors.right: parent.right
            anchors.rightMargin: 5
            anchors.top: parent.top
            anchors.topMargin: 0
            color: {

                if(nombreEstado=="Respuesta" || nombreEstado=="Asignado"){
                    "#000000"
                }else{
                    "#ffffff"
                }

}
        }
    }

    Text {
        id: txtCantidadReclamosPorEstado
        width: 30
        color: "#ffffff"
        text: cantidadReclamos
        style: Text.Raised
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        font.pointSize: 11
        verticalAlignment: Text.AlignVCenter
        font.family: "Microsoft Sans Serif"
        font.bold: true
        horizontalAlignment: Text.AlignRight
        smooth: true
    }
}
