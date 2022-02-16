import QtQuick 1.1

Rectangle {
    id: rectangle2
    width: 400
    height: 300
    color: "#1c1c1c"
    radius: 7
    visible: true
    smooth: true


    signal guardarConfiguracion

    function cargarTiempoEspera(){
        for(var i=0; i<modeloEstadosDisponibles.count;i++){
            modeloEstadosDisponibles.setProperty(i,"minutoEsperaTipoReclamo",modeloCargaEstados.retornaTiempoMinimoEstadosSeteado(modeloEstadosDisponibles.get(i).codigoItem))
            modeloEstadosDisponibles.setProperty(i,"checkBoxActivo",modeloCargaEstados.retornaEstadoMonitoreoActivo(modeloEstadosDisponibles.get(i).codigoItem))
        }
    }


    Rectangle {
        id: rectangle1
        y: 217
        height: 5
        color: "#4b4b4b"
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        smooth: true
    }

    Rectangle {
        id: rectangle3
        x: 6
        color: "#1c1c1c"
        anchors.top: rectangle1.bottom
        anchors.topMargin: -2
        smooth: true
        anchors.bottom: parent.bottom
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.right: parent.right
        anchors.leftMargin: 0
        anchors.left: parent.left
    }

    ComboBoxEstados {
        id: cbxEstadosDisponibles
        height: 40
        z: 4
        anchors.right: parent.right
        anchors.rightMargin: 20
        textoComboBox: "clic para setear estados a monitorear"
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.top: parent.top
        anchors.topMargin: 50
        textoTitulo: "Estados disponibles:"
        modeloItems: modeloEstadosDisponibles



        ListModel{
            id:modeloEstadosDisponibles
            ListElement {
                codigoItem: "2"
                descripcionItem: "Asignado"
                checkBoxActivo:true
                minutoEsperaTipoReclamo:"3"
            }
            ListElement {
                codigoItem: "4"
                descripcionItem: "Nuevo"
                checkBoxActivo:true
                minutoEsperaTipoReclamo:"3"
            }

            ListElement {
                codigoItem: "6"
                descripcionItem: "Espera respuesta cliente"
                checkBoxActivo:true
                minutoEsperaTipoReclamo:"3"
            }
            ListElement {
                codigoItem: "9"
                descripcionItem: "En respuesta"
                checkBoxActivo:true
                minutoEsperaTipoReclamo:"3"
            }
            ListElement {
                codigoItem: "11"
                descripcionItem: "Envia consulta objetos"
                checkBoxActivo:true
                minutoEsperaTipoReclamo:"3"
            }
            ListElement {
                codigoItem: "14"
                descripcionItem: "Coordinado"
                checkBoxActivo:true
                minutoEsperaTipoReclamo:"3"
            }
            ListElement {
                codigoItem: "16"
                descripcionItem: "Reasignado"
                checkBoxActivo:true
                minutoEsperaTipoReclamo:"3"
            }
            ListElement {
                codigoItem: "99"
                descripcionItem: "Finalizado Guardia"
                checkBoxActivo:true
                minutoEsperaTipoReclamo:"3"
            }

        }
        onClicAbrirComboBox: {
            cargarTiempoEspera()
        }

        onGuardarDatosCombo: {
            for(var i=0; i<modeloEstadosDisponibles.count;i++){

                modeloCargaEstados.guardarTipoEstadosActivos(modeloEstadosDisponibles.get(i).codigoItem,modeloEstadosDisponibles.get(i).checkBoxActivo,modeloEstadosDisponibles.get(i).minutoEsperaTipoReclamo)

            }
        }
    }

    ComboBoxAreas {
        id: cbxAreasDisponibles
        height: 40
        z: 3
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.top: cbxEstadosDisponibles.bottom
        anchors.topMargin: 20
        textoTitulo: "Areas a monitorear:"
        modeloItems: modeloAreasDisponibles
        codigoValorSeleccion: modeloCargaEstados.retornaAreaAMonitorear()
        textoComboBox: {
            if(codigoValorSeleccion=="1"){
                "Hardware"
            }else if(codigoValorSeleccion=="2"){
                "Software"
            }else if(codigoValorSeleccion=="3"){
                "Hardware y Software"
            }
        }



        ListModel{
            id:modeloAreasDisponibles
            ListElement {
                codigoItem: "1"
                descripcionItem: "Hardware"                
            }
            ListElement {
                codigoItem: "2"
                descripcionItem: "Software"                
            }
            ListElement {
                codigoItem: "3"
                descripcionItem: "Hardware y Software"                
            }
        }
        onGuardarDatosCombo: {            
            modeloCargaEstados.guardarAreaAMonitorear(cbxAreasDisponibles.codigoValorSeleccion.trim())
        }
    }

    Text {
        id: text1
        color: "#ffffff"
        text: qsTr("Configuración de monitoreo")
        styleColor: "#a616a6"
        style: Text.Raised
        font.bold: true
        font.family: "Arial"
        anchors.top: parent.top
        anchors.topMargin: 10
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        smooth: true
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 20
        font.pixelSize: 20
    }

    TextInput2 {
        id: txtPeriodoMonitoreo
        textoTitulo: "Periodo monitoreo(min):"
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.top: cbxAreasDisponibles.bottom
        anchors.topMargin: 20
        inputMask: "0000;"
        z: 2
        textoInputBox: modeloCargaEstados.retornaTiempoPeriodoMonitoreo()

    }

    BotonPaletaSistema {
        id: botonpaletasistema1
        x: 315
        y: 250
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 20
        text: "Guardar cambios"
        onClicked: {
            if(txtPeriodoMonitoreo.textoInputBox.trim()==""){
                txtPeriodoMonitoreo.tomarElFoco()
            }else{
                modeloCargaEstados.guardarPeriodoMonitoreo(txtPeriodoMonitoreo.textoInputBox.trim())
                guardarConfiguracion()
                cbxAreasDisponibles.cerrarComboBox()
                cbxEstadosDisponibles.cerrarComboBox()
            }


        }
    }

    Text {
        id: lblVersion
        y: 4
        color: "#808080"
        text: "Ver.: "+_version.toString()
        anchors.left: parent.left
        anchors.leftMargin: 20
        smooth: true
        font.pixelSize: 10
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        font.family: "Verdana"
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
    }
}
