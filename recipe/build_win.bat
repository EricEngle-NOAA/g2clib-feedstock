@echo on
setlocal EnableDelayedExpansion

REM Ensure pkg-config (pkgconf) can find conda .pc files
set "PKG_CONFIG_PATH=%LIBRARY_PREFIX%\lib\pkgconfig;%LIBRARY_PREFIX%\share\pkgconfig"

REM Force CMake's FindPkgConfig to use the conda-provided pkg-config
set "PKG_CONFIG_EXECUTABLE=%LIBRARY_BIN%\pkg-config.exe"

REM Helpful diagnostics in CI logs
where pkg-config
pkg-config --version

mkdir build
if errorlevel 1 exit 1

cmake -S "%SRC_DIR%" -B build -G "Ninja" ^
      %CMAKE_ARGS% ^
      -DCMAKE_BUILD_TYPE=Release ^
      -DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX%" ^
      -DCMAKE_LIBRARY_PATH="%LIBRARY_LIB%" ^
      -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
      -DCMAKE_INSTALL_BINDIR=bin ^
      -DCMAKE_INSTALL_LIBDIR=lib ^
      -DCMAKE_INSTALL_INCLUDEDIR=include ^
      -DCMAKE_FIND_FRAMEWORK=NEVER ^
      -DCMAKE_FIND_APPBUNDLE=NEVER ^
      -DPKG_CONFIG_EXECUTABLE="%PKG_CONFIG_EXECUTABLE%" ^
      -DUSE_Jasper=ON ^
      -DUSE_OpenJPEG=OFF ^
      -DUSE_PNG=ON ^
      -DUSE_AEC=ON ^
      -DBUILD_STATIC_LIBS=OFF ^
      -DCMAKE_WINDOWS_EXPORT_ALL_SYMBOLS=ON
if errorlevel 1 exit 1

REM Build step
cmake --build build --config Release --parallel
if errorlevel 1 exit 1

REM Install step
cmake --install build --config Release
if errorlevel 1 exit 1
