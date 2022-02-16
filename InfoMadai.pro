HEADERS       = window.h \
    Utilidades/database.h \
    Utilidades/configuracionxml.h \
    modulocargadeestados.h \
    moduloconfiguraciondeusuario.h \
    modulotecnicos.h \
    moduloreclamos.h
SOURCES       = main.cpp \
                window.cpp \
    Utilidades/database.cpp \
    Utilidades/configuracionxml.cpp \
    modulocargadeestados.cpp \
    moduloconfiguraciondeusuario.cpp \
    modulotecnicos.cpp \
    moduloreclamos.cpp
RESOURCES     = systray.qrc
QT           += xml svg declarative sql network

sources.files = $$SOURCES $$HEADERS $$RESOURCES $$FORMS InfoMadai.pro resources images
INSTALLS += target sources

FORMS +=

OTHER_FILES += \
    main.qml \
    controlesQml/BotonBarraDeHerramientas.qml \
    Listas/ListaTipoReclamos.qml \
    controlesQml/MapaDeReclamos.qml \
    Listas/ListaTecnicosReclamos.qml \
    controlesQml/PantallaConfiguracion.qml \
    controlesQml/CheckBox.qml \
    controlesQml/TextInputSimple.qml \
    controlesQml/ComboBoxEstados.qml \
    controlesQml/ComboBoxAreas.qml \
    controlesQml/TextInput2.qml \
    controlesQml/BotonPaletaSistema.qml \
    Listas/ListaTipoReclamosMiniDisplay.qml \
    controlesQml/AlertasProgramadas.qml \
    Listas/ListaAlertasProgramadas.qml
