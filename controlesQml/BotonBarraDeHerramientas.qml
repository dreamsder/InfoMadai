import QtQuick 1.1

Item {
    id: itemBotonBarraHerramientas
    width: 25
    height: 25
    smooth: true

    signal clic

    property double opacidad:0.7
    property alias rectanguloSecundarioVisible: rectColorSecundario.visible

    property alias source: imagenIcono.source
    property alias toolTip: toolTipText.text

    Image {
        id: imagenIcono
        opacity: opacidad
        smooth: true
        anchors.fill: parent
        asynchronous: true


        Rectangle{
            id:rectColorSecundario
            anchors.fill: parent
            opacity: 0.15
            color: "red"
            smooth: true
            anchors.rightMargin: 2
            anchors.leftMargin: 2
            anchors.bottomMargin: 2
            anchors.topMargin: 2
            visible: false
        }

        MouseArea {
            id: mouse_areaItemBarraHerramientas
            hoverEnabled: true
            anchors.fill: parent

            onClicked: clic()


            onEntered: {

                timer1.start()
                imagenIconoOpacidadOut.stop()
                imagenIconoOpacidadIn.start()
            }

            onExited: {

                timer1.stop()
                rectToolTipTextBarraHerramientas.visible=false
                imagenIconoOpacidadIn.stop()
                imagenIconoOpacidadOut.start()
            }


            onPressed: {
                timer1.stop()
                rectToolTipTextBarraHerramientas.visible=false
                imagenIconoScaleOut.stop()
                imagenIconoScaleIn.start()

            }
            onReleased: {
                  timer1.start()
                imagenIconoScaleIn.stop()
                imagenIconoScaleOut.start()

            }
        }
    }



    PropertyAnimation{
        id:imagenIconoOpacidadIn
        target: imagenIcono
        property: "opacity"
        from:opacidad
        to:1
        duration: 200
    }

    PropertyAnimation{
        id:imagenIconoOpacidadOut
        target: imagenIcono
        property: "opacity"
        to:opacidad
        from:1
        duration: 200
    }

    PropertyAnimation{
        id:imagenIconoScaleIn
        target: itemBotonBarraHerramientas
        property: "scale"
        from:1
        to:0.90
        duration: 50
    }
    PropertyAnimation{
        id:imagenIconoScaleOut
        target: itemBotonBarraHerramientas
        property: "scale"
        from:0.90
        to:1
        duration: 50
    }

    Rectangle{
        id:rectToolTipTextBarraHerramientas
        visible: false
        width: toolTipText.implicitWidth+20
        height: toolTipText.implicitHeight
        color: "#4d7dc0"
        radius: 6
        anchors.left: parent.left
        anchors.leftMargin: (toolTipText.implicitWidth+20)*-1
        opacity: 1
        z: 3
        smooth: true
        Text {
            id: toolTipText
            color: "#fdfbfb"
            horizontalAlignment: Text.AlignRight
            font.family: "Verdana"
            font.bold: false
            anchors.rightMargin: 10
            anchors.leftMargin: 10
            anchors.fill: parent
            smooth: true
            visible: true
        }

    }


    Timer {
        id:timer1
        interval: 1500;
        running: false;
        repeat: false;
        onTriggered: {
            if(toolTipText.text!=""){
                rectToolTipTextBarraHerramientas.x=itemBotonBarraHerramientas.width+10
                rectToolTipTextBarraHerramientas.y=itemBotonBarraHerramientas.height/4
                rectToolTipTextBarraHerramientas.visible=true
            }
        }


    }

}
