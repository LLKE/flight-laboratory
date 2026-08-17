cmake_minimum_required(VERSION 3.16)

project(FlightLaboratory VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS
    Quick
    QuickEffects
)

qt_standard_project_setup(REQUIRES 6.10)

if (EXISTS "${CMAKE_CURRENT_LIST_DIR}/importedcontent/CMakeLists.txt")
    add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/importedcontent)
endif()

qt_add_executable(appFlightLaboratory
    src/main.cpp
    src/basicdynamicssim.h
    src/basicdynamicssim.cpp
    src/pitchmodel.h
    src/pitchmodel.cpp
)

target_include_directories(appFlightLaboratory PRIVATE src)

qt_add_qml_module(appFlightLaboratory
    URI FlightLaboratory
    VERSION 1.0
    RESOURCE_PREFIX "/qt/qml"

    QML_FILES
        src/qml/Main.qml
        src/qml/ArtificialHorizion.qml
        src/qml/AttitudeGraph.qml
        src/qml/PIDLab.qml
)

set_target_properties(appFlightLaboratory PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appFlightLaboratory
    PRIVATE
        Qt6::Quick
        Qt6::QuickEffects
)

install(TARGETS appFlightLaboratory
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
