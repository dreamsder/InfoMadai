import QtQuick 1.1

Rectangle {
    id: rectangle1
    width: 500
    height: 19
    color: "#00000000"

    property alias textoInputBox: txtTextInput.text
    property alias echoMode: txtTextInput.echoMode
    property alias inputMask: txtTextInput.inputMask
    property double opacidadPorDefecto: 0.8
    property alias cursor_Visible: txtTextInput.cursorVisible
    property alias largoMaximo: txtTextInput.maximumLength
    property alias  validaFormato: txtTextInput.validator
    property bool enFocoSeleccionarTodo: false
    property alias textoDeFondo: txtTextoSombra.text

    property int margenIzquierdo: 5

    property alias rectanguloTextoAlto: recTextInput.height
    property alias textoInputFontSize: txtTextInput.font.pointSize


    property alias enable: txtTextInput.enabled



    signal tabulacion
    signal enter
    signal clicEnBusqueda

    function tomarElFoco(){
        txtTextInput.focus=true
        if(enFocoSeleccionarTodo){
            txtTextInput.selectAll()
        }

    }

    Rectangle {
        id:recTextInput
        radius: 2
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        smooth: true
        border.width: 1
        border.color: "#686b71"




        opacity: opacidadPorDefecto

        PropertyAnimation{
            id: colorIn
            target: recTextInput
            property: "border.color"
            from:"#686b71"
            to: "#0470fd"
            duration: 500
        }
        PropertyAnimation{
            id: colorOff
            target: recTextInput
            property: "border.color"
            from: "#0470fd"
            to:"#686b71"
            duration: 500
        }

        PropertyAnimation{
            id: opacityIn
            target: recTextInput
            property: "opacity"
            from:opacidadPorDefecto
            to: 1
            duration: 200
        }
        PropertyAnimation{
            id: opacityOff
            target: recTextInput
            property: "opacity"
            from: 1
            to:opacidadPorDefecto
            duration: 200
        }

        TextInput {
            id: txtTextInput
            height: parent.height
            color: "#000000"
            text: qsTr("")
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.left: parent.left
            font.family: "Verdana"
            smooth: true
            horizontalAlignment: TextInput.AlignHCenter            
            inputMask: ""
            echoMode: TextInput.Normal
            z: 2
            font.pointSize: 9
            font.bold: false
            maximumLength: 45
            selectByMouse: true
            selectionColor: "gray"
                onActiveFocusChanged: {

                    if(txtTextInput.activeFocus==true){
                        colorIn.start()
                        opacityIn.start()
                        txtTextoSombra.visible=false



                    }
                    if(txtTextInput.activeFocus==false){
                        colorOff.start()
                        opacityOff.start()
                        if(txtTextInput.text.trim()==""){
                            txtTextoSombra.visible=true
                        }

                    }
                }

                onTextChanged: veirficoTextoEntxtTextInput.start()



            Keys.onTabPressed: tabulacion()

            Keys.onEnterPressed: enter()

            Keys.onReturnPressed: enter()




            Text {
                id: txtTextoSombra
                color:"#8b8888"
                font.family: "Verdana"
                font.italic: true
                anchors.fill: parent
                font.pointSize: txtTextInput.font.pointSize
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            Timer{
                id:veirficoTextoEntxtTextInput
                interval: 2000
                running: true
                onTriggered: {

                    if(txtTextInput.text.trim()=="" && txtTextInput.activeFocus==false){
                        txtTextoSombra.visible=true
                    }else if(txtTextInput.text.trim()!=""){
                        txtTextoSombra.visible=false
                    }

                }
            }
        }




    }
}
