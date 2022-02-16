import QtQuick 1.1
Rectangle{
    id:rectPrincipal
    width: image1.width
    height: 20
    color: "#00000000"


    property bool chekActivo: false

    property double opacidadPorDefecto: 0.8


    function setActivo(atributo){
        chekActivo=atributo
        image1.visible=chekActivo
    }

Rectangle {
    id: rectangle1

    color: "#00000000"
    anchors.topMargin: 0
    anchors.fill: parent
    smooth: true



    Rectangle {
        id: rectangle2
        width: 18
        height: 19
        color: "#ffffff"
        smooth: true
        radius: 2
        border.color: "#686b71"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        border.width: 1
        opacity: {

            if(chekActivo){
                1
            }else{
                opacidadPorDefecto
            }
        }

        Image {
            id: image1
            visible: chekActivo
            smooth: true
            asynchronous: true
            anchors.rightMargin: -6
            anchors.leftMargin: 2
            anchors.bottomMargin: 2
            anchors.topMargin: -4
            anchors.fill: parent
            source: "qrc:/images/VistoOk.png"
        }
    }

    MouseArea {
        id: mouse_area1
        anchors.fill: parent

        onClicked: {

            if(chekActivo){
                setActivo(false)
                opacityIn.stop()
                opacityOff.start()
            }else{
                setActivo(true)
                opacityOff.stop()
                opacityIn.start()
            }

        }


    }

    PropertyAnimation{
        id: opacityIn
        target: rectangle2
        property: "opacity"
        from:opacidadPorDefecto
        to: 1
        duration: 200
    }
    PropertyAnimation{
        id: opacityOff
        target: rectangle2
        property: "opacity"
        from: 1
        to:opacidadPorDefecto
        duration: 200
    }




}
}
