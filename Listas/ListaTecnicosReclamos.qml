import QtQuick 1.1
import "../controlesQml"


Rectangle {
    id: rectListaTecnicoReclamos
    anchors.right:  parent.right
    anchors.rightMargin: 0
    anchors.left: parent.left
    anchors.leftMargin: 0
    height: txtTecnicoReclamoSeleccionado.height+txtCodigoReclamo.implicitHeight+5
    color: "#00000000"

    TextInputSimple{
        id:txtFechaGrabar
        width: 90
        anchors.left: parent.left
        anchors.leftMargin: 32
        anchors.top: txtCodigoReclamo.bottom
        anchors.topMargin: 5
        enFocoSeleccionarTodo: true
        inputMask: "nnnn-nn-nn; "
        validaFormato: validacionFecha
        textoInputBox: fechaAviso
        visible: false
        onTabulacion: txtHoraGrabar.tomarElFoco()

        onEnter: txtHoraGrabar.tomarElFoco()
    }


    RegExpValidator{
        id:validacionFecha
        ///Fecha AAAA/MM/DD
        regExp: new RegExp("(20|  |2 | 2)(0[0-9, ]| [0-9, ]|1[0123456789 ]|2[0123456789 ]|3[0123456789 ]|4[0123456789 ])\-(0[1-9, ]| [1-9, ]|1[012 ]| [012 ])\-(0[1-9, ]| [1-9, ]|[12 ][0-9, ]|3[01 ]| [01 ])")
    }


    TextInputSimple{
        id:txtHoraGrabar
        width: 60
        anchors.left: txtFechaGrabar.right
        anchors.leftMargin: 10
        anchors.top: txtCodigoReclamo.bottom
        anchors.topMargin: 5
        enFocoSeleccionarTodo: true
        inputMask: "NN:NN; "
        validaFormato: validacionHora
        textoInputBox: horaAviso
        visible: false
        onTabulacion: {
            txtFechaGrabar.tomarElFoco()
        }
        onEnter: txtFechaGrabar.tomarElFoco()
    }
    RegExpValidator{
        id:validacionHora
        regExp: new RegExp( "([0-1, ][0-9, ]|2[0-3, ])\:[0-5, ][0-9, ]" )
    }

    BotonBarraDeHerramientas{
        id:guardarFecha
        anchors.top: txtCodigoReclamo.bottom
        anchors.topMargin: 5
        anchors.left: txtHoraGrabar.right
        anchors.leftMargin: 10
        visible: false
        source: "qrc:/images/VistoOk.png"
        width: 19
        height: 19
        onClic: {

            if(modeloReclamos.guardarAlerta(codigoReclamo," - "+fechaCompletaReclamo+" - "+nombreCliente+" "+nombreSucursal,txtFechaGrabar.textoInputBox.trim(),txtHoraGrabar.textoInputBox.trim())){
                imgAvisoReclamoFechaSeteado.visible=true
                imgAvisoReclamoFechaSeteado.width=12

                txtFechaGrabar.visible=false
                txtHoraGrabar.visible=false
                guardarFecha.visible=false
                eliminarFecha.visible=false
                rectListaTecnicoReclamos.height= txtTecnicoReclamoSeleccionado.height+txtCodigoReclamo.implicitHeight+5

                modeloCargaEstados.limpiarListaEstados()
                modeloCargaEstados.buscarEstados("select case when (codigoEstado=3 and codigoTipoReclamo=2) then 99 else codigoEstado end'codigoEstado',case when (codigoEstado=3 and codigoTipoReclamo=2) then 'Finalizado Guardia' else nombreEstado end'nombreEstado',count(codigoReclamo)'cantidadReclamos',case when (codigoEstado=3 and codigoTipoReclamo=2) then 'D63A19' else colorEstado end'colorEstado' from Reclamos where "+modeloConfiguracionUsuarios.retornaWhereParaConsultaDeReclamosyEstados() +"  and codigoReclamo in "+modeloCargaEstados.retornarReclamosAMonitorearSegunTiempoEstablecido()+"  group by case when (codigoEstado=3 and codigoTipoReclamo=2) then 99 else codigoEstado end order by 2")

                mpReclamos.cargarReclamos(tipoReclamo)

            }else{
                txtFechaGrabar.tomarElFoco()
            }
        }
    }
    BotonBarraDeHerramientas{
        id:eliminarFecha
        anchors.top: txtCodigoReclamo.bottom
        anchors.topMargin: 5
        anchors.left: guardarFecha.right
        anchors.leftMargin: 10
        visible: false
        source: "qrc:/images/delete.png"
        width: 19
        height: 19
        onClic: {
            if(modeloReclamos.eliminarAlerta(codigoReclamo)){
                imgAvisoReclamoFechaSeteado.visible=false
                imgAvisoReclamoFechaSeteado.width=0
                txtFechaGrabar.textoInputBox=modeloCargaEstados.fechaDeHoy()
                txtHoraGrabar.textoInputBox="09:15"

                txtFechaGrabar.visible=false
                txtHoraGrabar.visible=false
                guardarFecha.visible=false
                eliminarFecha.visible=false
                rectListaTecnicoReclamos.height= txtTecnicoReclamoSeleccionado.height+txtCodigoReclamo.implicitHeight+5

                modeloCargaEstados.limpiarListaEstados()
                modeloCargaEstados.buscarEstados("select case when (codigoEstado=3 and codigoTipoReclamo=2) then 99 else codigoEstado end'codigoEstado',case when (codigoEstado=3 and codigoTipoReclamo=2) then 'Finalizado Guardia' else nombreEstado end'nombreEstado',count(codigoReclamo)'cantidadReclamos',case when (codigoEstado=3 and codigoTipoReclamo=2) then 'D63A19' else colorEstado end'colorEstado' from Reclamos where "+modeloConfiguracionUsuarios.retornaWhereParaConsultaDeReclamosyEstados() +"  and codigoReclamo in "+modeloCargaEstados.retornarReclamosAMonitorearSegunTiempoEstablecido()+"  group by case when (codigoEstado=3 and codigoTipoReclamo=2) then 99 else codigoEstado end order by 2")
            }
        }
    }

    Text {
        id: txtTecnicoReclamoSeleccionado
        color: "#e0e0e0"
        text: nombreTecnico
        anchors.right: parent.right
        anchors.rightMargin: 5
        smooth: true
        anchors.top: parent.top
        anchors.topMargin: 0
        style: Text.Raised
        font.family: "Microsoft Sans Serif"
        font.bold: true
        font.pointSize: 10
        anchors.leftMargin: 12
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        anchors.left: parent.left
        height: {
            if(nombreTecnico==""){
                0
            }else{
                16
            }
        }

    }


    BotonBarraDeHerramientas{
        id:btnSeteoFechaCoordinados
        width: {
            if(tipoReclamo=="14"){
                12
            }else{
                0
            }
        }
        z: 1
        height: 12
        anchors.left: parent.left
        anchors.leftMargin: 15
        anchors.top: txtTecnicoReclamoSeleccionado.bottom
        anchors.topMargin: 3
        source: "qrc:/images/Configuracion.png"
        visible: {
            if(tipoReclamo=="14"){
                true
            }else{
                false
            }
        }
        onClic: {
            if(txtFechaGrabar.visible){
                txtFechaGrabar.visible=false
                txtHoraGrabar.visible=false
                guardarFecha.visible=false
                eliminarFecha.visible=false
                rectListaTecnicoReclamos.height= txtTecnicoReclamoSeleccionado.height+txtCodigoReclamo.implicitHeight+5
            }else{
                txtFechaGrabar.visible=true
                txtHoraGrabar.visible=true
                guardarFecha.visible=true
                eliminarFecha.visible=true
                rectListaTecnicoReclamos.height= txtTecnicoReclamoSeleccionado.height+txtCodigoReclamo.implicitHeight+10+txtFechaGrabar.height
                txtFechaGrabar.tomarElFoco()
            }


        }
    }

    Text {
        id: txtCodigoReclamo
        width: 30
        color: "#e68326"
        text: "#"+codigoReclamo
        font.underline: false
        smooth: true
        anchors.top: txtTecnicoReclamoSeleccionado.bottom
        anchors.topMargin: 3
        style: Text.Raised
        font.family: "Arial"
        font.bold: true
        font.pointSize: 9
        anchors.leftMargin: 5
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        anchors.left: imgAvisoReclamoFechaSeteado.right
        opacity: 0.8

        MouseArea {
            id: mouseAreaLinkReclamo
            hoverEnabled: true
            anchors.fill: parent
            onClicked: {

                if(tipoReclamo=="3" || tipoReclamo=="99"){
                    modeloReclamos.eliminoReclamoRemoto(codigoReclamo)
                    modeloReclamosSeleccionado.remove(index)
                }


                modeloReclamos.abrirPaginaWeb("http://"+modeloReclamos.retornaUrlMadai()+"/madai/recXPerfilModificar.php?idReclamo="+codigoReclamo)




            }
            onEntered: {
                txtCodigoReclamo.opacity=1
                txtCodigoReclamo.font.underline=true

            }
            onExited: {
                txtCodigoReclamo.opacity=0.8
                txtCodigoReclamo.font.underline=false
            }
        }

    }

    Text {
        id: txtFechaReclamoSeleccionado
        color: "#bebdbd"
        text: "- "+fechaCompletaReclamo
        anchors.top: txtTecnicoReclamoSeleccionado.bottom
        font.pointSize: 9
        verticalAlignment: Text.AlignVCenter
        font.family: "Arial"
        font.bold: true
        anchors.leftMargin: 10
        horizontalAlignment: Text.AlignLeft
        anchors.left: txtCodigoReclamo.right
        style: Text.Raised
        smooth: true
        anchors.topMargin: 3
    }

    Text {
        id: txtClienteSeleccionado
        color: "#bebdbd"
        text: "- "+nombreCliente
        smooth: true
        anchors.top: txtTecnicoReclamoSeleccionado.bottom
        anchors.topMargin: 3
        style: Text.Raised
        font.bold: true
        font.family: "Arial"
        font.pointSize: 9
        horizontalAlignment: Text.AlignLeft
        anchors.leftMargin: 5
        verticalAlignment: Text.AlignVCenter
        anchors.left: txtFechaReclamoSeleccionado.right
    }

    Text {
        id: txtSucursalSeleccionada
        color: "#bebdbd"
        text: nombreSucursal
        smooth: true
        anchors.top: txtTecnicoReclamoSeleccionado.bottom
        anchors.topMargin: 3
        style: Text.Raised
        font.family: "Arial"
        font.bold: true
        font.pointSize: 9
        anchors.leftMargin: 5
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        anchors.left: txtClienteSeleccionado.right
    }

    Image {
        id: imgAvisoReclamoFechaSeteado
        height: 12
        smooth: true
        asynchronous: true
        anchors.left: btnSeteoFechaCoordinados.right
        anchors.leftMargin: 5
        anchors.top: txtCodigoReclamo.bottom
        anchors.topMargin: -15
        source: "qrc:/images/campana.png"
        visible: {
            if(tipoReclamo=="14" && alertaActiva){
                true
            }else{
                false
            }
        }
        width: {
            if(tipoReclamo=="14" && alertaActiva){
                12
            }else{
                0
            }
        }
    }
}
