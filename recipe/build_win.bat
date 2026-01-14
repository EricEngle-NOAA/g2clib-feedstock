@echo on
setlocal EnableDelayedExpansion

REM Host prefix (dependencies) is PREFIX/LIBRARY_PREFIX.
REM Build prefix (tools like pkg-config) is BUILD_PREFIX.

REM Where pkg-config should look for .pc files (from HOST env)
set "PKG_CONFIG_PATH=%LIBRARY_PREFIX%\lib\pkgconfig;%LIBRARY_PREFIX%\share\pkgconfig"

REM pkg-config executable comes from BUILD env (pkgconf is a build dependency)
set "PKG_CONFIG_EXECUTABLE=%BUILD_PREFIX%\Library\bin\pkg-config.exe"

REM Diagnostics
echo PKG_CONFIG_PATH=%PKG_CONFIG_PATH%
echo PKG_CONFIG_EXECUTABLE=%PKG_CONFIG_EXECUTABLE%
if not exist "%PKG_CONFIG_EXECUTABLE%" (
  echo ERROR: pkg-config.exe not found at "%PKG_CONFIG_EXECUTABLE%"
  dir "%BUILD_PREFIX%\Library\bin"
  exit 1
)
"%PKG_CONFIG_EXECUTABLE%" --version
if errorlevel 1 exit 1

REM Configure
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

REM Build
cmake --build build --config Release --parallel
if errorlevel 1 exit 1

REM Install
cmake --install build --config Release
if errorlevel 1 exit 1
