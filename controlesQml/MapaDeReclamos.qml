import QtQuick 1.1
import "../Listas"


Rectangle {
    id: rectPrincipalMp
    width: 300
    height: 300
    color: "#1c1c1c"
    radius: 5
    visible: true
    smooth: true
    clip: false


    property alias  textoTipoReclamoSeleccinado: txtTipoEstadoReclamoSeleccionado.text
    property alias colorRectanguloTipoReclamo: rectTipoReclamoSeleccionado.color


    function cargarReclamos(codigoEstado){

        var codigoEstadoParaguardia="3"

        if(codigoEstado!="99"){
            codigoEstadoParaguardia=codigoEstado;
        }


        modeloReclamos.limpiarListaReclamo()
        modeloReclamos.buscarReclamos("select codigoReclamo,fechaCompletaReclamo, nombreCliente,nombreSucursal,codigoTecnicoResponsable'codigoTecnico',nombreTecnicoResponsable'nombreTecnico' from Reclamos where  "+modeloConfiguracionUsuarios.retornaWhereParaConsultaDeReclamosyEstados() +"  and   codigoReclamo in "+modeloCargaEstados.retornarReclamosAMonitorearSegunTiempoEstablecidoPorEstado(codigoEstado)+" and codigoEstado='"+codigoEstadoParaguardia+"'  group by codigoReclamo order by 6,1")
        modeloReclamosSeleccionado.clear()

        var _codigoTecnico="-1"

        for(var i=0; i<modeloReclamos.rowCount();i++){


            if(_codigoTecnico!=modeloReclamos.retornaCodigoTecnico(i)){
                modeloReclamosSeleccionado.append({
                                                      codigoReclamo:modeloReclamos.retornaCodigoReclamo(i),
                                                      codigoTecnico:modeloReclamos.retornaCodigoTecnico(i),
                                                      nombreTecnico:modeloReclamos.retornaNombreTecnico(i),
                                                      fechaCompletaReclamo:modeloReclamos.retornaFechaCompletaReclamo(i),
                                                      nombreCliente:modeloReclamos.retornaNombreCliente(i),
                                                      nombreSucursal:modeloReclamos.retornaNombreSucursal(i),
                                                      tipoReclamo:codigoEstado,
                                                      alertaActiva:modeloReclamos.retornaReclamoActivoParaAviso(modeloReclamos.retornaCodigoReclamo(i)),
                                                      fechaAviso:modeloReclamos.retornaFechaReclamoParaAviso(modeloReclamos.retornaCodigoReclamo(i)),
                                                      horaAviso:modeloReclamos.retornaHoraReclamoParaAviso(modeloReclamos.retornaCodigoReclamo(i))
                                                  })
                _codigoTecnico=modeloReclamos.retornaCodigoTecnico(i)
            }else{
                modeloReclamosSeleccionado.append({
                                                      codigoReclamo:modeloReclamos.retornaCodigoReclamo(i),
                                                      codigoTecnico:modeloReclamos.retornaCodigoTecnico(i),
                                                      nombreTecnico:"",
                                                      fechaCompletaReclamo:modeloReclamos.retornaFechaCompletaReclamo(i),
                                                      nombreCliente:modeloReclamos.retornaNombreCliente(i),
                                                      nombreSucursal:modeloReclamos.retornaNombreSucursal(i),
                                                      tipoReclamo:codigoEstado,
                                                      alertaActiva:modeloReclamos.retornaReclamoActivoParaAviso(modeloReclamos.retornaCodigoReclamo(i)),
                                                      fechaAviso:modeloReclamos.retornaFechaReclamoParaAviso(modeloReclamos.retornaCodigoReclamo(i)),
                                                      horaAviso:modeloReclamos.retornaHoraReclamoParaAviso(modeloReclamos.retornaCodigoReclamo(i))
                                                  })
            }
        }
    }
    ListView {
        id: listaReclamos
        clip: true
        spacing: 10
        interactive: {
            if(listaReclamos.count>4){
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
        delegate: ListaTecnicosReclamos {
        }
        model: modeloReclamosSeleccionado
        z: 4
        anchors.right: parent.right
        anchors.leftMargin: 5
        anchors.left: parent.left
    }

    ListModel{
        id:modeloReclamosSeleccionado
    }


    Image {
        id: image1
        x: -1
        y: -1
        z: 3
        anchors.rightMargin: 1
        smooth: true
        anchors.fill: parent
        asynchronous: true
        anchors.topMargin: 1
        source: "qrc:/images/fondoRec.png"
        visible: true
        anchors.bottomMargin: 1
        fillMode: Image.Tile
        anchors.leftMargin: 1
        opacity: 0.8
    }

    Rectangle {
        id: rectangle1
        width: 40
        height: 40
        color: rectPrincipalMp.color
        anchors.top: parent.top
        anchors.topMargin: 60
        transformOrigin: Item.Center
        anchors.left: image1.right
        anchors.leftMargin: -23
        rotation: -45
        smooth: true
        z: 1

    }


    PropertyAnimation{
        id:opacidadRectangle1On
        target: rectangle1
        property: "opacity"
        from:0.5
        to:1
        duration: 200
    }
    PropertyAnimation{
        id:opacidadRectangle1Off
        target: rectangle1
        property: "opacity"
        from:1
        to:0.5
        duration: 50
    }

    Rectangle {
        id: rectTipoReclamoSeleccionado
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
            id: txtTipoEstadoReclamoSeleccionado
            color: {

                if(text=="Respuesta" || text=="Asignado"){
                    "#000000"
                }else{
                    "#ffffff"
                }

            }
            text: textoTipoReclamoSeleccinado
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.right: botonCerrarVentana.left
            anchors.rightMargin: 10
            anchors.top: parent.top
            styleColor: {
                if(text=="Respuesta" || text=="Asignado"){
                    "#ffffff"
                }else{
                    "#000000"
                }
            }
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
                modeloConfiguracionUsuarios.setReclamoVisile(false)
            }
        }
        anchors.bottom: listaReclamos.top
    }

    Rectangle {
        id: rectScrollbar
        y: 4
        width: 5
        color: "#00ffffff"
        radius: 6
        anchors.right: listaReclamos.left
        anchors.rightMargin: -8
        smooth: true
        clip: true
        anchors.top: parent.top
        anchors.topMargin: 50
        Rectangle {
            id: scrollbarTareas
            x: 2
            y: listaReclamos.visibleArea.yPosition * listaReclamos.height+3
            width: 5
            height: {
                if(listaReclamos.count>10){
                    listaReclamos.visibleArea.heightRatio * listaReclamos.height-30
                }else{
                    listaReclamos.visibleArea.heightRatio * listaReclamos.height-3
                }

            }
            color: rectTipoReclamoSeleccionado.color
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
            if(listaReclamos.count>4){
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
