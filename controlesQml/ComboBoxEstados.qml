import QtQuick 1.1

Rectangle {
    id: rectangle2
    width: 500
    height: 35
    color: "#00000000"


    property alias textoTitulo: txtTitulo.text
    property alias textoComboBox: txtTextoSeleccionado.text
    property string codigoValorSeleccion
    property double opacidadPorDefecto: 0.8
    property alias colorTitulo: txtTitulo.color

    property alias modeloItems: listview1.model

    property alias colorRectangulo: rectPrincipalComboBox.color

    signal clicEnBusqueda
    signal tabulacion
    signal enter
    signal senialAlAceptarOClick
    signal guardarDatosCombo
    signal clicAbrirComboBox

    function tomarElFoco(){
        if(listview1.count>=10){
            listview1.highlightRangeMode=ListView.StrictlyEnforceRange           
            listview1.interactive=true
        }else{
            listview1.highlightRangeMode=ListView.NoHighlightRange
            listview1.interactive=false
        }
        if(txtTextoSeleccionado.enabled)
        txtTextoSeleccionado.focus=true

    }
    function activo(valor){
        guardarDatosCombo()
        cerrarComboBox()

        mouse_area1.enabled=valor
        mouse_area2.enabled=valor
        mouse_area3.enabled=valor
        rectangle2.enabled=valor
        txtTextoSeleccionado.enabled=valor

    }

    function cerrarComboBox(){
        rectPrincipalComboBoxAparecerYIn.stop()
        mouse_area1.enabled=true
        rectPrincipalComboBox.visible=false
        txtTextoSeleccionado.enabled=true
    }

    Keys.onEscapePressed: {
        guardarDatosCombo()
        cerrarComboBox()
    }

    Rectangle {
        id: rectPrincipalComboBox
        x: 0
        y: 39
        radius: 3
        border.width: 1
        border.color: "#a8a0a0"
        color:"#6f6f6f"
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: -20
        smooth: true
        height: listview1.contentHeight+45

        visible: false
        z:2000

        MouseArea {
            id: mouse_area4
            anchors.bottomMargin: 0
            clip: true
            anchors.topMargin: 30
            anchors.fill: parent

            ListView {
                id:listview1
                x: 0
                y: 30
                interactive: false
                z: 1
                spacing: 10
                anchors.bottomMargin: 10
                anchors.rightMargin: 20
                anchors.leftMargin: 0
                anchors.topMargin: 5
                anchors.fill: parent
                focus: true                                
                delegate:                                    
                    FocusScope {
                    width: childrenRect.width; height: childrenRect.height
                    x:childrenRect.x; y: childrenRect.y
                    Rectangle{
                        id:rect1
                        height: texto1.implicitHeight
                        width: rectPrincipalComboBox.width
                        color: "transparent"

                        CheckBox{
                            id:checkbox1
                            chekActivo: checkBoxActivo
                            anchors.left: parent.left
                            anchors.leftMargin: 10
                            anchors.verticalCenter:  parent.verticalCenter
                        }

                        TextInputSimple{
                            id:txtTiempoEsperaInformarReclamo
                            anchors.right: parent.right
                            anchors.rightMargin: 5
                            anchors.verticalCenter:  parent.verticalCenter
                            width: 70
                            height: 19
                            enFocoSeleccionarTodo: true
                            textoInputBox: minutoEsperaTipoReclamo
                            largoMaximo: 4
                            inputMask: "0000;"
                            z:150
                            onTextoInputBoxChanged: {
                                modeloEstadosDisponibles.setProperty(index,"minutoEsperaTipoReclamo",txtTiempoEsperaInformarReclamo.textoInputBox.trim())
                            }

                        }


                        Text {
                            id: texto1
                            focus: true
                            text: descripcionItem
                            font.family: "Verdana"
                            smooth: true
                            font.pointSize: 10
                            color:"black"
                           // styleColor: "white"
                           // style: Text.Raised
                            z: 100
                            anchors.left: checkbox1.right
                            anchors.leftMargin: 13

                            onActiveFocusChanged: {

                                if(activeFocus){
                                    opacityOff.stop()
                                    opacityIn.start()
                                    texto1.color="white"
                                //    texto1.style= Text.Normal
                                 //   texto1.font.bold= true

                                }else{
                                    opacityIn.stop()
                                    opacityOff.start()
                                   texto1.color="black"
                                //    texto1.style= Text.Raised
                                 //   texto1.font.bold= false
                                }



                            }

                            Rectangle {
                                id: rectTextComboBox
                                y: 12
                                height: 19
                                color: "#5358be"
                                width: listview1.width-5
                                radius: 1
                                smooth: true
                                opacity: 0
                                border.width: 0
                                border.color: "#000000"
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: -3
                                anchors.left: parent.left
                                anchors.leftMargin: -10
                                anchors.top: parent.top
                                anchors.topMargin: -3
                                z:-50


                            }

                            PropertyAnimation{
                                id: opacityIn
                                target: rectTextComboBox
                                property: "opacity"
                                from:0
                                to: 0.60
                                duration: 200
                            }
                            PropertyAnimation{
                                id: opacityOff
                                target: rectTextComboBox
                                property: "opacity"
                                from: 0.60
                                to:0
                                duration: 50
                            }

                            Keys.onReturnPressed: {

                                modeloEstadosDisponibles.setProperty(index,"checkBoxActivo",!checkbox1.chekActivo)
                                senialAlAceptarOClick()
                                enter()

                            }


                        }

                        MouseArea{
                            id:mouseArea
                           // height: texto1.height
                           // width: listview1.width
                            anchors.left: rect1.left
                            anchors.leftMargin: 0
                            anchors.right: rect1.right
                            anchors.rightMargin: 0
                            anchors.top: rect1.top
                            anchors.topMargin: 0
                            anchors.bottom: rect1.bottom
                            anchors.bottomMargin: 0
                            hoverEnabled: true
                            onClicked: {
                                listview1.forceActiveFocus()
                                modeloEstadosDisponibles.setProperty(index,"checkBoxActivo",!checkbox1.chekActivo)
                                senialAlAceptarOClick()
                            }
                            onEntered: {
                                listview1.forceActiveFocus()
                                opacityOff.stop()
                                opacityIn.start()
                               texto1.color="white"
                            }
                            onExited:{
                                opacityIn.stop()
                                opacityOff.start()
                                texto1.color="black"
                            }
                        }
                    }
            }
            }
        }

        Rectangle {
            id: rectangle3
            y: 24
            width: 25
            height: 25
            color: rectPrincipalComboBox.color
            anchors.left: parent.left
            anchors.leftMargin: 50
            anchors.top: parent.top
            anchors.topMargin: -6
            rotation: 45
            z: 1
        }

        BotonBarraDeHerramientas {
            id: btnCerrarCombobox
            anchors.top: parent.top
            anchors.topMargin: 5
            anchors.right: parent.right
            anchors.rightMargin: 10
            source: "qrc:/images/Wall_A_3002_1_2.png"
            onClic: {

                guardarDatosCombo()
                cerrarComboBox()
            }
        }
    }

    Rectangle {
        id: rectTextComboBox2
        x: 0
        y: -19
        height: 19
        color: "#ffffff"
        radius: 2
        border.color: "#686b71"
        TextInput {
            id: txtTextoSeleccionado
            color: "#000000"
            text: qsTr("")
            font.family: "Verdana"
            smooth: true
            anchors.topMargin: 1
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.rightMargin: 0
            font.bold: false
            font.pointSize: 9
            z: 1
            anchors.right: parent.right
            horizontalAlignment: TextInput.AlignHCenter
            anchors.left: parent.left

            onActiveFocusChanged: {                
                if(txtTextoSeleccionado.activeFocus==true){
                    colorIn2.start()
                    opacityIn2.start()


                    if(rectPrincipalComboBox.visible==false){                        
                        clicAbrirComboBox()
                        tomarElFoco()
                        listview1.forceActiveFocus()
                        rectPrincipalComboBox.visible=true
                        rectPrincipalComboBoxAparecerYIn.start();
                        txtTextoSeleccionado.enabled=false
                    }


                }
                if(txtTextoSeleccionado.activeFocus==false){
                    colorOff2.start()
                    opacityOff2.start()

                }
            }

        }
        MouseArea {
            id: mouse_area1
            visible: false
            anchors.fill: parent
            onClicked: {

                mouse_area1.enabled=false
            }
        }
        anchors.bottom: parent.bottom
        anchors.rightMargin: 0
        border.width: 1
        anchors.bottomMargin: 0
        anchors.right: parent.right
        anchors.leftMargin: 0
        opacity: opacidadPorDefecto
        anchors.left: parent.left
    }

    Text {
        id: txtTitulo
        x: 0
        y: -34
        height: 15
        width: txtTitulo.implicitWidth
        color: "#dbd8d8"
        text: qsTr("Titulo:")
        font.family: "Arial"
        smooth: true
        verticalAlignment: Text.AlignBottom
        font.pixelSize: 12
        anchors.top: parent.top
        anchors.topMargin: 0
        font.bold: true
        anchors.leftMargin: 5
        anchors.left: parent.left
    }

    PropertyAnimation{
        id:rectPrincipalComboBoxAparecerYIn
        target: rectPrincipalComboBox
        property: "y"
        from:39
        to: 48
        duration: 200
    }

    PropertyAnimation{
        id: colorIn2
        target: rectTextComboBox2
        property: "border.color"
        from:"#686b71"
        to: "#0470fd"
        duration: 500
    }
    PropertyAnimation{
        id: colorOff2
        target: rectTextComboBox2
        property: "border.color"
        from: "#0470fd"
        to:"#686b71"
        duration: 500
    }

    PropertyAnimation{
        id: opacityIn2
        target: rectTextComboBox2
        property: "opacity"
        from:opacidadPorDefecto
        to: 1
        duration: 200
    }
    PropertyAnimation{
        id: opacityOff2
        target: rectTextComboBox2
        property: "opacity"
        from: 1
        to:opacidadPorDefecto
        duration: 200
    }



}
