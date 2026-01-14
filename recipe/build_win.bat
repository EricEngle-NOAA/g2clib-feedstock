@echo on
setlocal EnableDelayedExpansion

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
