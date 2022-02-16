import QtQuick 1.1

Rectangle{
    id: rectListaItem
    height: 30
    color: "#"+colorEstado
    radius: 5
    clip: true
    smooth: true

    property string codigoDeTipoReclamo: codigoEstado
    width: 30

    MouseArea{
        id: mousearea1
        smooth: false
        anchors.rightMargin: 0
        z: 7
        anchors.fill: parent
        hoverEnabled: true        
        onClicked: {
            mostrarReclamos()
            mpReclamos.textoTipoReclamoSeleccinado=nombreEstado
            mpReclamos.colorRectanguloTipoReclamo="#"+colorEstado

            //Cargo los tecnicos y reclamos

            mpReclamos.cargarReclamos(codigoEstado)
        }
    }


    Text {
        id: txtCantidadReclamosPorEstado
        color: "#ffffff"
        text: cantidadReclamos
        z: 6
        anchors.rightMargin: 5
        anchors.fill: parent
        style: Text.Raised
        font.pointSize: 11
        verticalAlignment: Text.AlignBottom
        font.family: "Microsoft Sans Serif"
        font.bold: true
        horizontalAlignment: Text.AlignRight
        smooth: true
    }

    Rectangle {
        id: rectangle1
        x: 8
        y: 15
        width: 40
        height: 40
        color: rectListaItem.color
        opacity: 1
        z: 5
        rotation: -45
        anchors.top: parent.top
        anchors.topMargin: 18
        anchors.left: parent.left
        anchors.leftMargin: 13
        smooth: true
    }
}
