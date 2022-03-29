import QtQuick 1.1
import "controlesQml"
import "Listas"


Rectangle {
    id: rectRoot
    width: modeloConfiguracionUsuarios.getTamanioPantallaWidth()
    height: modeloConfiguracionUsuarios.getTamanioPantallaHeight()
    x:0
    y:0
    color: "#00000000"
    smooth: true
    visible: true

    property string _version: "2.3.2"

    //cambios:
    //2.2.0: Se agregan los reclamos con estado finalizado.
    //2.2.1: Se maximiza el tiempo de recarga de cantidad de alertas.
    //     : Se modifican los timeout para que esperen mas tiempo, y no sobrecargar el sistema.
    //2.2.2: Se mejora la velocidad de carga de reclamos.
    //2.2.3: Se actualiza para obtener la web desde la configuracion
    //2.3.0: Se deriva el calculo de tiempo a la aplicación que levanta los reclamos
    //2.3.1: Se agrega soporte para reclamos Finalizados Guardia.
    //2.3.2: Se agrega la posibilidad de eliminar de la lista reclamos Finalizados Guardia(codigoEstado 99).

    Rectangle {
        id: rectangle1
        width: 250
        height: 400
        color: "#1c1c1c"
        radius: 5
        x: modeloConfiguracionUsuarios.getTamanioPantallaWidth()-rectangle1.width-3
        y: modeloConfiguracionUsuarios.getTamanioPantallaHeight()-rectangle1.height-50
        z: 3
        clip: false
        visible: modeloConfiguracionUsuarios.getVentanaPrincipalVisible()
        smooth: true

        Rectangle {
            id: rectangle2
            x: 5
            y: 45
            color: "#0affffff"
            radius: 5
            z: 4
            clip: true
            anchors.top: botonCerrarVentana.bottom
            anchors.topMargin: 10
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 5
            anchors.right: parent.right
            anchors.rightMargin: 5
            anchors.left: parent.left
            anchors.leftMargin: 5
            border.width: 2
            border.color: "#a2a2a2"
            smooth: true

            Rectangle {
                id: rectangle3
                color: "#00000000"
                radius: 5
                anchors.rightMargin: 0
                anchors.bottomMargin: 0
                anchors.leftMargin: 1
                anchors.topMargin: 1
                anchors.fill: parent
                smooth: true
                border.color: "#000000"
                border.width: 2

                ListView {
                    id: listaTipoEstadoReclamos
                    z: 2
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    spacing: 5
                    interactive: false
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.top: parent.top
                    anchors.rightMargin: 5
                    anchors.bottomMargin: 5
                    anchors.topMargin: 5
                    delegate: ListaTipoReclamos{}
                    model: modeloCargaEstados
                    clip: true


                }

                Image {
                    id: image1
                    x: -1
                    y: -1
                    asynchronous: true
                    opacity: 0.8
                    anchors.bottomMargin: 0
                    visible: true
                    anchors.leftMargin: 0
                    anchors.topMargin: 0
                    smooth: true
                    fillMode: Image.Tile
                    anchors.fill: parent
                    source: "qrc:/images/fondoRec.png"
                }
            }
        }

        BotonBarraDeHerramientas {
            id:botonCerrarVentana
            x: 215
            y: 10
            width: 25
            height: 25
            z: 5
            toolTip: "Cerrar"
            opacidad: 0.3
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.right: parent.right
            anchors.rightMargin: 10
            source: "qrc:/images/Wall_A_3002_1_2.png"
            onClic: {
                modeloConfiguracionUsuarios.setReclamoVisile(false)
                modeloConfiguracionUsuarios.setVentanaPrincipalVisible(false)
                modeloConfiguracionUsuarios.setConfiguracionVisible(false)
            }
        }

        BotonBarraDeHerramientas {
            id: botonConfiguracion
            x: 10
            y: 10
            width: 25
            height: 25
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.top: parent.top
            anchors.topMargin: 10
            source: "qrc:/images/Configuracion.png"
            opacidad: 0.7
            z: 6
            onClic: {
                if(modeloConfiguracionUsuarios.getConfiguracionVisible()){
                    modeloConfiguracionUsuarios.setConfiguracionVisible(false)
                }else{
                    modeloConfiguracionUsuarios.setConfiguracionVisible(true)
                }
            }
        }

        BotonBarraDeHerramientas {
            id: botonActualizarManualmente
            x: 112
            y: 10
            width: 25
            height: 25
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 10
            source: "qrc:/images/actualizar.png"
            opacidad: 0.4
            smooth: true
            z: 7
            onClic: {
                actualizarReclamos()
                modeloConfiguracionUsuarios.setReclamoVisile(false)

            }
        }

        Rectangle {
            id: rectangle4
            x: 173
            y: 378
            width: 40
            height: 40
            color: rectangle1.color
            anchors.horizontalCenterOffset: -50
            anchors.horizontalCenter: parent.horizontalCenter
            smooth: true
            anchors.top: parent.top
            anchors.topMargin: 378
            rotation: -45
            z: -1
            transformOrigin: Item.Center
        }
    }
    Timer{
        id: timerActualizarReclamos
        interval: modeloConfiguracionUsuarios.retornaTiempoMonitoreo()   /// 3600000 Esto es 1 hora. Los milisegundos se calculan:  (minuto * 60) * 1000
        repeat: true
        running: false
        onTriggered: {            
            actualizarReclamos()
        }
    }
    MapaDeReclamos {
        id: mpReclamos
        width: 430        
        visible: modeloConfiguracionUsuarios.getReclamoVisible()
        z: 2
        anchors.right: rectangle1.left
        anchors.rightMargin: 20
        anchors.bottom: rectangle1.top
        anchors.bottomMargin: (rectangle1.height*-1)+10
        anchors.top: rectangle1.bottom
        anchors.topMargin: (rectangle1.height*-1)+40
    }


    AlertasProgramadas {
        id: apAlertasProgramadas
        width: 430
        visible: modeloConfiguracionUsuarios.getVentanaAlertasVisible()
        z: 3
        anchors.right: rectangle1.left
        anchors.rightMargin: 480
        anchors.bottom: rectangle1.top
        anchors.bottomMargin: (rectangle1.height*-1)+10
        anchors.top: rectangle1.bottom
        anchors.topMargin: (rectangle1.height*-1)+40
    }

    function mostrarReclamos(){
        if(mpReclamos.visible==false){
            modeloConfiguracionUsuarios.setReclamoVisile(true)           
        }
    }



    /// Carga la lista de estados
    function actualizarReclamos(){

        modeloCargaEstados.limpiarListaEstados()
        modeloCargaEstados.buscarEstados("select case when (codigoEstado=3 and codigoTipoReclamo=2) then 99 else codigoEstado end'codigoEstado',case when (codigoEstado=3 and codigoTipoReclamo=2) then 'Finalizado Guardia' else nombreEstado end'nombreEstado',count(codigoReclamo)'cantidadReclamos',case when (codigoEstado=3 and codigoTipoReclamo=2) then 'D63A19' else colorEstado end'colorEstado' from Reclamos where "+modeloConfiguracionUsuarios.retornaWhereParaConsultaDeReclamosyEstados() +"  and codigoReclamo in "+modeloCargaEstados.retornarReclamosAMonitorearSegunTiempoEstablecido()+"  group by case when (codigoEstado=3 and codigoTipoReclamo=2) then 99 else codigoEstado end order by 2")

        if(modeloCargaEstados.rowCount()!=0){
            AplicacionPrincipal.setIcon(1)
        }else{
            AplicacionPrincipal.setIcon(0)
        }
    }
    Timer{
        interval: 100
        repeat: true
        running: true
        onTriggered: {
            mpReclamos.visible=modeloConfiguracionUsuarios.getReclamoVisible()
        }
    }
    Timer{
        interval: 100
        repeat: true
        running: true
        onTriggered: {
            pantallaConfiguracion.visible=modeloConfiguracionUsuarios.getConfiguracionVisible()
        }
    }
    Timer{
        interval: 100
        repeat: true
        running: true
        onTriggered: {
            rectangle1.visible=modeloConfiguracionUsuarios.getVentanaPrincipalVisible()
        }
    }
    Timer{
        interval: 100
        repeat: true
        running: true
        onTriggered: {
            rectMiniDisplay.visible=modeloConfiguracionUsuarios.getVentanaMiniDisplayVisible()
        }
    }
    Timer{
        interval: 120000
        repeat: true
        running: true
        onTriggered: {
            retornaCantidadAlertas.text=modeloReclamosAlertas.retornaCantidadAlertas()
        }
    }



    Timer{
        interval: 100
        repeat: true
        running: true
        onTriggered: {
            apAlertasProgramadas.visible=modeloConfiguracionUsuarios.getVentanaAlertasVisible()
        }
    }
    Timer{
        interval: 120000
        repeat: true
        running: true
        onTriggered: {

            /// Timer para chequear si hay algun reclamos que informar
            var _reclamosAInformar=modeloReclamos.chequearAlertas()
            if(_reclamosAInformar!=""){

                mostrarMensajeInformativo("Reclamos en fecha: "+_reclamosAInformar)
                //AplicacionPrincipal.showMessage("Reclamos en fecha: "+_reclamosAInformar)

            }
        }
    }


    PantallaConfiguracion {
        id: pantallaConfiguracion
        x: 244
        y: 107
        width: 323
        height: 260
        anchors.bottom: rectangle1.top
        anchors.bottomMargin: -15
        anchors.right: rectangle1.left
        anchors.rightMargin: -15
        visible: modeloConfiguracionUsuarios.getConfiguracionVisible()
        z: 4
        onGuardarConfiguracion: {

            modeloConfiguracionUsuarios.setConfiguracionVisible(false)
        }
    }




    Rectangle {
        id: rectMiniDisplay
        x: rectRoot.width-50-(lblClicActualizar.implicitWidth+100)
        y: rectRoot.height-50-rectMiniDisplay.height
        width: {
            if(listaTipoEstadoReclamosMiniDisplay.count==0){
                lblClicActualizar.visible=true
                imgCampana.visible=false
                lblClicActualizar.implicitWidth+16
            }else{
                lblClicActualizar.visible=false
                imgCampana.visible=true
                listaTipoEstadoReclamosMiniDisplay.contentWidth+4+32
            }
        }
        height: 34

        color: mousearea1.pressed ? "#a0000000" : "#1c1c1c"
        radius: 5
        clip: false
        smooth: true
        visible: modeloConfiguracionUsuarios.getVentanaMiniDisplayVisible()


        Rectangle {
            id: rectangle5
            color: "#00000000"
            radius: 5
            opacity: mousearea1.pressed ? "0.1" : "1"
            anchors.bottomMargin: 2
            anchors.topMargin: 2
            anchors.fill: parent
            smooth: true
            border.color: "#000000"
            ListView {
                id: listaTipoEstadoReclamosMiniDisplay
                anchors.right: imgCampana.left
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.rightMargin: 2
                anchors.leftMargin: 2
                //width: 300
                orientation: ListView.Horizontal
                flickableDirection: Flickable.HorizontalFlick
                clip: true
                spacing: 2
                interactive: false
                delegate: ListaTipoReclamosMiniDisplay{
                }
                model: modeloCargaEstados
                z: 2
            }

            Text {
                id: lblClicActualizar
                color: "#ffffff"
                text: qsTr("clic para actualizar")
                z: 3
                smooth: true
                visible: true
                opacity: 0.5
                font.pointSize: 10
                font.family: "Arial"
                font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter

                MouseArea {
                    id: mousearea2
                    hoverEnabled: true
                    anchors.bottomMargin: -5
                    anchors.topMargin: -5
                    anchors.fill: parent
                    onEntered: {
                        lblClicActualizarOpacidadOff.stop()
                        lblClicActualizarOpacidadOn.start()
                    }
                    onExited: {
                        lblClicActualizarOpacidadOn.stop()
                        lblClicActualizarOpacidadOff.start()
                    }
                    onClicked: actualizarReclamos()


                }
                PropertyAnimation{
                    id:lblClicActualizarOpacidadOn
                    target: lblClicActualizar
                    property: "opacity"
                    from:0.5
                    to:1
                    duration: 200
                }

                PropertyAnimation{
                    id:lblClicActualizarOpacidadOff
                    target: lblClicActualizar
                    property: "opacity"
                    from:1
                    to:0.5
                    duration: 100
                }
            }

            Image {
                id: imgCampana
                x: 100
                y: 0
                width: 30
                asynchronous: true
                smooth: true
                visible: true
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 2
                source: "qrc:/images/campana32x32.png"

                MouseArea {
                    id: mouseAreaCampana
                    z: 1
                    anchors.fill: parent
                    onClicked: {
                        modeloConfiguracionUsuarios.setVentanaAlertasVisible(true)
                        modeloReclamosAlertas.limpiarListaReclamo()
                        modeloReclamosAlertas.buscarReclamosDeAlertas()
                    }
                }

                Text {
                    id: retornaCantidadAlertas
                    color: "#ffffff"
                    text: modeloReclamosAlertas.retornaCantidadAlertas()
                    anchors.bottomMargin: 0
                    anchors.rightMargin: 4
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignBottom
                    visible: true
                    smooth: true
                    anchors.fill: parent
                    style: Text.Raised
                    font.pointSize: 11
                    font.family: "Microsoft Sans Serif"
                    font.bold: true
                }
            }
            border.width: 0
        }

        Rectangle {
            id: rectangle6
            width: 40
            height: 37
            //color: "#321c1c1c"
            color: mousearea1.pressed ? "#00000000" : "#321c1c1c"
            radius: 12
            anchors.horizontalCenter: parent.horizontalCenter
            clip: true
            z: -1
            anchors.bottom: rectMiniDisplay.top
            anchors.bottomMargin: -10
            smooth: true

            MouseArea {
                id: mousearea1
                anchors.bottomMargin: 10
                hoverEnabled: true
                z: 3
                anchors.fill: parent
                drag.target: rectMiniDisplay
                drag.axis: Drag.XandYAxis
                onEntered: {
                    imgIconoMoverMiniDisplayOpacidadOff.stop()
                    imgIconoMoverMiniDisplayOpacidadOn.start()
                }
                onExited: {
                    imgIconoMoverMiniDisplayOpacidadOn.stop()
                    imgIconoMoverMiniDisplayOpacidadOff.start()
                }

            }


            PropertyAnimation{
                id:imgIconoMoverMiniDisplayOpacidadOn
                target: imgIconoMoverMiniDisplay
                property: "opacity"
                from:0.3
                to:1
                duration: 200
            }

            PropertyAnimation{
                id:imgIconoMoverMiniDisplayOpacidadOff
                target: imgIconoMoverMiniDisplay
                property: "opacity"
                from:1
                to:0.3
                duration: 100
            }

            Image {
                id: imgIconoMoverMiniDisplay
                opacity: 0.3
                anchors.bottomMargin: 10
                asynchronous: true
                smooth: true
                anchors.rightMargin: 7
                anchors.leftMargin: 7
                anchors.topMargin: 1
                anchors.fill: parent
                source: "qrc:/images/iconoMover.png"
            }
        }
        z: 5
    }

    /// Esto son los segundos que espera el mensaje de informaciòn para desaparecer
    Timer{
        id:tiempoMensajeInformativo
        interval: 30000
        repeat: false
        running: false
        onTriggered: {
            rectAvisoInformacion.visible=false
            tiempoMensajeInformativo.stop()
        }
    }

    function mostrarMensajeInformativo(mensaje){
        txtMensajeInformativo.text=mensaje
        rectAvisoInformacion.x=modeloConfiguracionUsuarios.getTamanioPantallaWidth()-rectAvisoInformacion.width-50
        rectAvisoInformacion.y=modeloConfiguracionUsuarios.getTamanioPantallaHeight()-rectAvisoInformacion.height-40
        rectAvisoInformacion.visible=true
       // tiempoMensajeInformativo.start()

    }

    Rectangle {
        id: rectAvisoInformacion
        width: txtMensajeInformativo.implicitWidth+40
        height: 50
        color: "#ffffe1"
        radius: 9
        border.color: "#000000"
        smooth: true
        z: 7
        visible: false
        x: modeloConfiguracionUsuarios.getTamanioPantallaWidth()-rectAvisoInformacion.width-50
        y: modeloConfiguracionUsuarios.getTamanioPantallaHeight()-rectAvisoInformacion.height-40

        Text {
            id: txtMensajeInformativo
            text: qsTr("Aviso generico")
            anchors.top: text2.bottom
            anchors.topMargin: 9
            anchors.left: parent.left
            anchors.leftMargin: 10
            font.pointSize: 8
            font.family: "Arial"
            font.pixelSize: 12
        }

        Text {
            id: text2
            text: qsTr("Aviso:")
            font.pointSize: 10
            font.family: "Arial"
            font.bold: true
            smooth: true
            anchors.left: parent.left
            anchors.leftMargin: 5
            anchors.top: parent.top
            anchors.topMargin: 5
            font.pixelSize: 12
        }

        BotonBarraDeHerramientas {
            id: botonCerrarVentana1
            y: 10
            width: 15
            height: 15
            anchors.top: parent.top
            anchors.topMargin: 5
            source: "qrc:/images/Wall_A_3002.png"
            anchors.rightMargin: 5
            toolTip: ""
            opacidad: 0.3
            z: 5
            anchors.right: parent.right
            onClic: {
                rectAvisoInformacion.visible=false
                tiempoMensajeInformativo.stop()

            }
        }
    }


}
