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
    id: rectContenedorPrincipal

    SystemPalette { id: activePalette }

    property string text: "Boton"

    signal clicked

    function mensajeError(mensaje){

        txtMensajeInformacionTimer.stop()
        txtMensajeInformacion.text=mensaje
        txtMensajeInformacion.visible=true
        txtMensajeInformacionTimer.start()
    }


    width: txtTituloBoton.width + 20; height: 30;    border { width: 1; color: Qt.darker(activePalette.button) }
    smooth: true
    radius: 3

    // color the button with a gradient
    gradient: Gradient {
        GradientStop {
            position: 0.0
            color: {
                if (mouseArea.pressed)
                    return activePalette.window
                else
                    return activePalette.light
            }
        }
        GradientStop { position: 1.0; color: activePalette.button }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: rectContenedorPrincipal.clicked();

        onPressed: {
            containerScaleOut.stop()
            containerScaleIn.start()
        }
        onReleased: {
            containerScaleIn.stop()
            containerScaleOut.start()
        }
    }

    Text {
        id: txtTituloBoton
        anchors.centerIn: rectContenedorPrincipal
        color: activePalette.buttonText
        text: rectContenedorPrincipal.text
        font.pointSize: 11
        font.family: "Verdana"
        smooth: true
        width: txtTituloBoton.implicitWidth
        height: 20
    }


    PropertyAnimation{
        id: containerScaleIn
        target: rectContenedorPrincipal
        property: "scale"
        from:1
        to:0.96
        duration: 200
    }
    PropertyAnimation{
        id: containerScaleOut
        target: rectContenedorPrincipal
        property: "scale"
        to:1
        from:0.96
        duration: 50
    }

    Text {
        id: txtMensajeInformacion
        color: "#d93e3e"
        text: ""
        font.family: "Verdana"
        anchors.right: parent.right
        anchors.rightMargin: 2
        horizontalAlignment: Text.AlignLeft
        font.bold: true
        font.pointSize: 10
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 24
        smooth: true
        visible: false
        height: 15
        width: txtMensajeInformacion.implicitWidth
    }

    Timer{
        id:txtMensajeInformacionTimer
        repeat: false
        interval: 5000
        onTriggered: {

            txtMensajeInformacion.visible=false
            txtMensajeInformacion.color="#d93e3e"

        }
    }
}
