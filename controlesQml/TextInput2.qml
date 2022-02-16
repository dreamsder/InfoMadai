/*********************************************************************
Khitomer - Sistema de facturación
Copyright (C) <2012-2013>  <Cristian Montano>

Este archivo es parte de Khitomer.

Khitomer es software libre: usted puede redistribuirlo y/o modificarlo
bajo los términos de la Licencia Pública General GNU publicada
por la Fundación para el Software Libre, ya sea la versión 3
de la Licencia, o (a su elección) cualquier versión posterior.

Este programa se distribuye con la esperanza de que sea útil, pero
SIN GARANTÍA ALGUNA; ni siquiera la garantía implícita
MERCANTIL o de APTITUD PARA UN PROPÓSITO DETERMINADO.
Consulte los detalles de la Licencia Pública General GNU para obtener
una información más detallada.

Debería haber recibido una copia de la Licencia Pública General GNU
junto a este programa.
En caso contrario, consulte <http://www.gnu.org/licenses/>.
*********************************************************************/

// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    id: rectangle1
    width: 500
    height: 35
    color: "#00000000"

    property alias textoTitulo: txtTitulo.text
    property alias textoInputBox: txtTextInput.text
    property alias echoMode: txtTextInput.echoMode
    property alias inputMask: txtTextInput.inputMask
    property double opacidadPorDefecto: 0.8
    property alias cursor_Visible: txtTextInput.cursorVisible


   property alias  validaFormato: txtTextInput.validator
    property bool enFocoSeleccionarTodo: false
    property alias textoDeFondo: txtTextoSombra.text

    property alias tituloImpricitWidth: txtTitulo.implicitWidth

    property int margenIzquierdo: 5

    property alias rectanguloTextoAlto: recTextInput.height
    property alias textoInputFontSize: txtTextInput.font.pointSize


    property alias enable: txtTextInput.enabled

    property alias colorDeTitulo: txtTitulo.color


    signal tabulacion
    signal enter
    signal clicEnBusqueda

    function tomarElFoco(){
        txtTextInput.focus=true
        if(enFocoSeleccionarTodo){
            txtTextInput.selectAll()
        }

    }

    function mensajeError(mensaje){

        txtInformacionErrorTimer.stop()
        txtInformacionError.text=mensaje
        txtInformacionError.visible=true
        txtInformacionErrorTimer.start()


    }



    Rectangle {
        id:recTextInput
        height: 19
        radius: 2
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

    Text {
        id: txtTitulo
        y: 2
        width: txtTitulo.implicitWidth
        height: 15
        color: "#dbd8d8"
        text: qsTr("Titulo:")
        verticalAlignment: Text.AlignBottom
        smooth: true
        font.bold: true
        anchors.bottom: recTextInput.top
        anchors.bottomMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: margenIzquierdo
        font.pixelSize: 12
        font.family: "Arial"
    }

}
