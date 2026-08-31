# Setup and Build Guide for VSCode

This guide explains how to configure, build, and run **FlightLaboratory** in VSCode.

The project uses:

* **C++17**
* **Qt 6.11**
* **Qt Quick / QML**
* **CMake**
* **Ninja**
* **GCC/G++**
* **VS Code**

The instructions below assume **Linux**.

---

## 1. Install the required software

Before opening the project, make sure the following are installed.

### VS Code

Install Visual Studio Code and the following extensions:

* **C/C++** (Microsoft)
* **CMake Tools** (Microsoft)

---

## 2. Install CMake, Ninja and GCC

On Ubuntu/Debian-based systems:

```bash
sudo apt update
sudo apt install cmake ninja-build gcc-11 g++-11
```

Check the installations:

```bash
cmake --version
ninja --version
gcc-11 --version
g++-11 --version
```

---

## 3. Install Qt

Install **Qt 6.11** with the Qt online installer.

The project expects a Qt installation containing at least:

* Qt Core
* Qt Gui
* Qt Quick
* Qt Quick Effects
* Qt QML

A typical Qt installation might be located at:

```text
/home/<username>/Qt/6.11.1/gcc_64
```

The exact path depends on where Qt was installed.

---

## 4. Clone the repository

Clone the project:

```bash
git clone <repository-url>
```

Then enter the project directory:

```bash
cd FlightLaboratory
```

The project contains the `CMakeLists.txt` file at its root:

```text
FlightLaboratory/
├── CMakeLists.txt
├── src/
│   ├── main.cpp
│   ├── ...
│   └── qml/
│       └── ...
└── ...
```

---

# 5. Open the project in VS Code

From the project directory:

```bash
code .
```

VS Code should detect the `CMakeLists.txt` automatically.

If prompted to select a CMake kit, select the GCC compiler used by the project, for example:

```text
GCC 11
```

You can also select it manually through:

**Command Palette (Ctrl + Shift + P) → CMake: Select a Kit**

---

# 6. Configure the Qt installation

CMake needs to know where Qt is installed.

The easiest way is to configure `CMAKE_PREFIX_PATH`.

Open VS Code's **CMake Tools configuration** and set:

```text
CMAKE_PREFIX_PATH=/home/<username>/Qt/6.11.1/gcc_64
```

This tells CMake where to search when the project contains:

```cmake
find_package(Qt6 REQUIRED COMPONENTS
    Quick
    QuickEffects
)
```

### Verify the path

The directory should contain something similar to:

```text
/home/<username>/Qt/6.11.1/gcc_64/
├── bin/
├── include/
├── lib/
└── ...
```

If `gcc_64` does not exist, check which Qt version and compiler configuration you installed.

---

# 7. Configure the project

In VS Code, open the Command Palette:

**Ctrl + Shift + P**

Select:

```text
CMake: Configure
```

CMake should find Qt and configure the project.

A successful configuration should end with something similar to:

```text
Configuring done
Generating done
```

The `build/` directory will be created automatically:

```text
FlightLaboratory/
├── CMakeLists.txt
├── src/
└── build/
```

You generally should **not modify anything inside `build/` manually**.

---

# 8. Build the project

After configuration, build the application using:

**Ctrl + Shift + P → CMake: Build**

Alternatively, use the build button provided by CMake Tools in the VS Code interface.

A successful build produces the application executable.

You can also build from a terminal:

```bash
cmake --build build
```

---

# 9. Run the application

After a successful build, use:

**Ctrl + Shift + P → CMake: Run Without Debugging**

Alternatively, press:

```text
Ctrl + F5
```

if the CMake Tools launch configuration is available.

---

# 10. Typical development workflow

Once the project has been configured successfully, the normal workflow is:

```text
Clone project
     ↓
Open in VS Code
     ↓
Configure CMake
     ↓
Build
     ↓
Run
```

After the initial configuration, you normally only need to **build and run** when modifying source code.

You need to configure CMake again when making changes such as:

* modifying `CMakeLists.txt`
* adding/removing source files
* changing Qt dependencies
* changing the compiler
* changing the build configuration

---

# 11. Clean configuration

If CMake gets into an inconsistent state, delete the generated build directory:

```bash
rm -rf build
```

Then configure the project again:

```text
Ctrl + Shift + P
→ CMake: Configure
```

This forces CMake to regenerate all build files and Qt-generated files.

This is particularly useful after significant changes to:

```cmake
qt_add_executable(...)
```

or:

```cmake
qt_add_qml_module(...)
```

---

# 12. Troubleshooting

## CMake cannot find Qt

If you see an error such as:

```text
Could not find a package configuration file provided by "Qt6"
```

check `CMAKE_PREFIX_PATH`.

It should point to the Qt compiler installation, for example:

```text
/home/<username>/Qt/6.11.1/gcc_64
```

**Do not point it to:**

```text
/home/<username>/Qt/6.11.1/
```

if the actual Qt installation is inside `gcc_64`.

---

## CMake finds Qt but cannot find a Qt component

For example:

```text
Could not find a package configuration file provided by
"Qt6QuickEffects"
```

Check that the required Qt component was installed.

The project's CMake file currently requires:

```cmake
find_package(Qt6 REQUIRED COMPONENTS
    Quick
    QuickEffects
)
```

---

## `RollSinPilot` or another QML C++ class cannot be found

C++ classes exposed to QML using:

```cpp
Q_OBJECT
QML_ELEMENT
```

must be included in the `SOURCES` section of the corresponding `qt_add_qml_module()`.

For example:

```cmake
qt_add_qml_module(appFlightLaboratory
    URI FlightLaboratory
    VERSION 1.0

    QML_FILES
        src/qml/Main.qml

    SOURCES
        src/virtual_pilot/virtual_pilot.h
        src/virtual_pilot/virtual_pilot.cpp
        src/virtual_pilot/roll_sin_pilot.h
        src/virtual_pilot/roll_sin_pilot.cpp
)
```

For this project, the include directories also contain:

```cmake
target_include_directories(appFlightLaboratory PRIVATE
    src
    src/virtual_pilot
)
```

The second directory is required because Qt's generated QML registration code may include headers by their filename rather than their path.

---

# 13. Building manually

Although VS Code is the recommended development environment, the project can also be configured and built from a terminal.

From the project root:

```bash
cmake -S . -B build \
    -G Ninja \
    -DCMAKE_BUILD_TYPE=Debug \
    -DCMAKE_PREFIX_PATH=/home/<username>/Qt/6.11.1/gcc_64
```

Then:

```bash
cmake --build build
```

The application can then be run from the generated build directory.

This is also useful for diagnosing whether a problem originates from the project/CMake configuration or from the VS Code environment.

---

# 14. Quick start

For someone who has just cloned the project, the essential steps are:

### Install

* Qt 6.11
* GCC/G++ 11
* CMake
* Ninja
* VS Code
* C/C++ extension
* CMake Tools extension

### Configure Qt

Set:

```text
CMAKE_PREFIX_PATH=/home/<username>/Qt/6.11.1/gcc_64
```

### Configure

**VS Code → Command Palette → CMake: Configure**

### Build

**VS Code → Command Palette → CMake: Build**

### Run

**VS Code → Command Palette → CMake: Run Without Debugging**

### If something goes wrong

Delete:

```bash
rm -rf build
```

and configure again.
