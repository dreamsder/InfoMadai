import QtQuick 1.1
import "../Listas"


Rectangle {
    id: rectPrincipalAlertasProgramadas
    width: 300
    height: 300
    color: "#1c1c1c"
    radius: 5
    visible: true
    smooth: true
    clip: false

    ListView {
        id: listaAlertasProgramadas
        clip: true
        spacing: 10
        interactive: {
            if(listaAlertasProgramadas.count>4){
                true
            }else{
                false
            }
        }
        anchors.top: parent.top
        anchors.topMargin: 45
        anchors.bottom: parent.bottom
        anchors.rightMargin: 5
        anchors.bottomMargin: 5
        delegate: ListaAlertasProgramadas {
        }
        model: modeloReclamosAlertas
        z: 4
        anchors.right: parent.right
        anchors.leftMargin: 5
        anchors.left: parent.left
    }    


    Image {
        id: image1
        x: -1
        y: -1
        z: 3
        asynchronous: true
        anchors.rightMargin: 1
        smooth: true
        anchors.fill: parent
        anchors.topMargin: 1
        source: "qrc:/images/fondoRec.png"
        visible: true
        anchors.bottomMargin: 1
        fillMode: Image.Tile
        anchors.leftMargin: 1
        opacity: 0.8
    }

    Rectangle {
        id: rectTituloAlertasProgramadas
        color: "#12b79c"
        radius: 2
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.topMargin: 5
        anchors.bottomMargin: 5
        z: 5
        clip: true
        smooth: true
        anchors.top: parent.top
        Text {
            id: lblTituloAlertasProgramadas
            color: "#ffffff"
            text: "Alertas programadas"
            anchors.left: imgCampanaAlertasProgramadas.right
            anchors.leftMargin: 10
            anchors.right: botonCerrarVentana.left
            anchors.rightMargin: 10
            anchors.top: parent.top            
            font.pointSize: 11
            anchors.bottomMargin: 0
            verticalAlignment: Text.AlignVCenter
            anchors.bottom: parent.bottom
            font.family: "Microsoft Sans Serif"
            clip: true
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            style: Text.Raised
            smooth: true
            anchors.topMargin: 0
        }

        BotonBarraDeHerramientas {
            id: botonCerrarVentana
            x: 260
            y: 5
            width: 25
            height: 25
            anchors.right: parent.right
            anchors.rightMargin: 5
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/images/Wall_A_3002_1_2.png"
            toolTip: "Cerrar"
            opacidad: 0.8
            z: 8
            onClic: {
                modeloConfiguracionUsuarios.setVentanaAlertasVisible(false)
            }
        }

        Image {
            id: imgCampanaAlertasProgramadas
            width: 30
            smooth: true
            asynchronous: true
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 3
            anchors.top: parent.top
            anchors.topMargin: 2
            anchors.left: parent.left
            anchors.leftMargin: 10
            source: "qrc:/images/campana32x32.png"
        }
        anchors.bottom: listaAlertasProgramadas.top
    }

    Rectangle {
        id: rectScrollbar
        y: 4
        width: 5
        color: "#00ffffff"
        radius: 6
        anchors.right: listaAlertasProgramadas.left
        anchors.rightMargin: -8
        smooth: true
        clip: true
        anchors.top: parent.top
        anchors.topMargin: 50
        Rectangle {
            id: scrollbarTareas
            x: 2
            y: listaAlertasProgramadas.visibleArea.yPosition * listaAlertasProgramadas.height+3
            width: 5
            height: {
                if(listaAlertasProgramadas.count>10){
                    listaAlertasProgramadas.visibleArea.heightRatio * listaAlertasProgramadas.height-30
                }else{
                    listaAlertasProgramadas.visibleArea.heightRatio * listaAlertasProgramadas.height-3
                }

            }
            color: rectTituloAlertasProgramadas.color
            radius: 3
            smooth: true
            visible: true
            anchors.rightMargin: 0
            z: 3
            anchors.right: parent.right
            opacity: 0.5
        }
        anchors.bottom: parent.bottom
        visible: {
            if(listaAlertasProgramadas.count>4){
                true
            }else{
                false
            }
        }
        anchors.bottomMargin: 5
        z: 7
        opacity: 1
    }
}
