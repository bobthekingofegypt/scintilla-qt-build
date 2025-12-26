set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

find_package(QT NAMES Qt6 Qt5 COMPONENTS Core REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Gui Widgets REQUIRED)

if (Qt6_FOUND)
    find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core5Compat REQUIRED)
endif()

set(SCINTILLA_QT_EDIT_SOURCES
    qt/ScintillaEditBase/PlatQt.cpp
    qt/ScintillaEditBase/ScintillaQt.cpp
    qt/ScintillaEditBase/ScintillaEditBase.cpp
    qt/ScintillaEdit/ScintillaEdit.cpp
    qt/ScintillaEdit/ScintillaDocument.cpp
    src/AutoComplete.cxx
    src/CallTip.cxx
    src/CaseConvert.cxx
    src/CaseFolder.cxx
    src/CellBuffer.cxx
    src/ChangeHistory.cxx
    src/CharacterCategoryMap.cxx
    src/CharacterType.cxx
    src/CharClassify.cxx
    src/ContractionState.cxx
    src/DBCS.cxx
    src/Decoration.cxx
    src/Document.cxx
    src/EditModel.cxx
    src/Editor.cxx
    src/EditView.cxx
    src/Geometry.cxx
    src/Indicator.cxx
    src/KeyMap.cxx
    src/LineMarker.cxx
    src/MarginView.cxx
    src/PerLine.cxx
    src/PositionCache.cxx
    src/RESearch.cxx
    src/RunStyles.cxx
    src/ScintillaBase.cxx
    src/Selection.cxx
    src/Style.cxx
    src/UndoHistory.cxx
    src/UniConversion.cxx
    src/UniqueString.cxx
    src/ViewStyle.cxx
    src/XPM.cxx
)

add_library(scintilla-qt-edit STATIC)

if (MSVC)
    target_compile_options(scintilla-qt-edit PRIVATE /FIstring /FIvector)
endif()

target_sources(scintilla-qt-edit
    PRIVATE ${SCINTILLA_QT_EDIT_SOURCES}
    PUBLIC FILE_SET HEADERS
    BASE_DIRS ${PROJECT_SOURCE_DIR}/include
    FILES include/Scintilla.h
        include/ScintillaTypes.h
        include/ScintillaCall.h
        include/Sci_Position.h
        include/ILexer.h
        include/ILoader.h
        include/ScintillaMessages.h
        include/ScintillaStructures.h
        include/ScintillaWidget.h
)

target_sources(scintilla-qt-edit
    PRIVATE ${SCINTILLA_QT_EDIT_SOURCES}
    PUBLIC FILE_SET HEADERS
    BASE_DIRS ${PROJECT_SOURCE_DIR}/src
    FILES src/Debugging.h
        src/Platform.h
        src/Geometry.h
)

target_sources(scintilla-qt-edit
    PUBLIC FILE_SET HEADERS
    BASE_DIRS ${PROJECT_SOURCE_DIR}/qt/ScintillaEdit
    FILES qt/ScintillaEdit/ScintillaDocument.h
        qt/ScintillaEdit/ScintillaEdit.h
)

target_sources(scintilla-qt-edit
    PUBLIC FILE_SET HEADERS
    BASE_DIRS ${PROJECT_SOURCE_DIR}/qt/ScintillaEditBase
    FILES qt/ScintillaEditBase/ScintillaQt.h
        qt/ScintillaEditBase/PlatQt.h
        qt/ScintillaEditBase/ScintillaEditBase.h
)

# target_include_directories(scintilla-qt-edit PRIVATE include/ src/ qt/ qt/ScintillaEditBase)
target_compile_definitions(scintilla-qt-edit PRIVATE
    -DSCINTILLA_QT=1
    -DMAKING_LIBRARY=1
    -DSCI_LEXER=1
    -D_CRT_SECURE_NO_DEPRECATE=1
)
# target_include_directories(scintilla-qt-edit PUBLIC include/ src/ qt/ScintillaEdit qt/ScintillaEditBase )
target_include_directories(scintilla-qt-edit PUBLIC  
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>  
    $<INSTALL_INTERFACE:include/scintilla>  # <prefix>/include/mylib
)
target_include_directories(scintilla-qt-edit PUBLIC  
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/src>  
    $<INSTALL_INTERFACE:include/scintilla>  # <prefix>/include/mylib
)
target_include_directories(scintilla-qt-edit PUBLIC  
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/qt/ScintillaEdit>  
    $<INSTALL_INTERFACE:include/scintilla>  # <prefix>/include/mylib
)
target_include_directories(scintilla-qt-edit PUBLIC  
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/qt/ScintillaEditBase>  
    $<INSTALL_INTERFACE:include/scintilla>  # <prefix>/include/mylib
)

target_link_libraries(scintilla-qt-edit PRIVATE Qt::Widgets )
if (Qt6_FOUND)
    target_link_libraries(scintilla-qt-edit PRIVATE Qt6::Core5Compat)
endif()
set_property(TARGET scintilla-qt-edit PROPERTY VERSION "${CMAKE_PROJECT_VERSION}")
set_property(TARGET scintilla-qt-edit PROPERTY SOVERSION 5 )

include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

install(TARGETS scintilla-qt-edit
    EXPORT scintilla-qt-edit
    FILE_SET HEADERS 
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/scintilla
    INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/scintilla)

# A Package Config file that works from the installation directory
set(ConfigPackageLocation ${CMAKE_INSTALL_LIBDIR}/cmake/scintilla)
install(EXPORT scintilla-qt-edit
    FILE scintillaTargets.cmake
    NAMESPACE scintilla::
    DESTINATION ${ConfigPackageLocation}
    )
configure_package_config_file(
    scintillaConfig.cmake.in
    "${CMAKE_CURRENT_BINARY_DIR}/scintillaConfig.cmake"
    INSTALL_DESTINATION ${ConfigPackageLocation}
)
install(FILES
    "${CMAKE_CURRENT_BINARY_DIR}/scintillaConfig.cmake"
    # "${CMAKE_CURRENT_BINARY_DIR}/scintillaConfigVersion.cmake"
    DESTINATION ${ConfigPackageLocation}
    )
