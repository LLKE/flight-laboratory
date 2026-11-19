cmake_minimum_required(VERSION 3.16)

project(FlightLaboratory VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS
    Quick
    QuickEffects
    Widgets
)

qt_standard_project_setup(REQUIRES 6.10)

if (EXISTS "${CMAKE_CURRENT_LIST_DIR}/importedcontent/CMakeLists.txt")
    add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/importedcontent)
endif()

qt_add_executable(appFlightLaboratory
    src/main.cpp
)

target_include_directories(appFlightLaboratory PRIVATE
    src
    src/adapters
    src/flight_lab_engine/
    src/virtual_pilot
    src/control/
    src/control/controllers/
    src/control/loops/
    src/models/
)

set_source_files_properties(src/qml/Styling/Styling.qml PROPERTIES
    QT_QML_SINGLETON_TYPE TRUE
)

qt_add_qml_module(appFlightLaboratory
    URI FlightLaboratory
    VERSION 1.0

    QML_FILES
        src/qml/Main.qml
        src/qml/ArtificialHorizion.qml
        src/qml/AttitudeGraph.qml
        src/qml/PIDLab/PIDLab.qml
        src/qml/PIDLab/PIDTuningGuide.qml
        src/qml/PIDLab/PIDControlLoopDisplay.qml
        src/qml/PIDLab/PIDSignalArrow.qml
        src/qml/BasicComponents/LabelledSlider.qml
        src/qml/BasicComponents/TelemetryDisplay.qml
        src/qml/BasicComponents/TitledFrame.qml
        src/qml/Styling/Styling.qml

    SOURCES
        src/adapters/flight_lab_adapter.h
        src/adapters/flight_lab_adapter.cpp
        src/adapters/pid_lab_adapter.h
        src/adapters/pid_lab_adapter.cpp

        src/virtual_pilot/virtual_pilot.h
        src/virtual_pilot/virtual_pilot.cpp
        src/virtual_pilot/roll_sin_pilot.h
        src/virtual_pilot/roll_sin_pilot.cpp
        src/virtual_pilot/pitch_step_pilot.h
        src/virtual_pilot/pitch_step_pilot.cpp
        src/virtual_pilot/pitch_step_scenario.h
        src/virtual_pilot/pitch_step_scenario.cpp

        src/control/loops/pid_control_loop.h
        src/control/loops/pid_control_loop.cpp
        src/control/loops/control_loop.h
        src/control/controllers/pid.cpp
        src/control/controllers/pid.h

        src/flight_lab_engine/flight_lab_engine.h
        src/flight_lab_engine/pid_lab_engine.h
        src/flight_lab_engine/pid_lab_engine.cpp
        src/flight_lab_engine/response_metrics.h
        src/flight_lab_engine/response_metrics.cpp
        src/flight_lab_engine/scenario.h
        src/flight_lab_engine/scenario_factory.h
        src/flight_lab_engine/scenario_factory.cpp

        src/models/pitch_model.h
        src/models/pitch_model.cpp
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
        Qt6::Widgets
)

install(TARGETS appFlightLaboratory
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

set_target_properties(appFlightLaboratory PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)
