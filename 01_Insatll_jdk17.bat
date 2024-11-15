@echo off
set "JDK_VERSION=17"
set "JDK_URL=https://download.oracle.com/java/%JDK_VERSION%/archive/jdk-%JDK_VERSION%_windows-x64_bin.zip"
set "INSTALL_DIR=D:\zSvrJavaMavenTomcat"
set "JDK_DIR=%INSTALL_DIR%\jdk-%JDK_VERSION%"
set "LOG_FILE=%INSTALL_DIR%\install_java_log.txt"

REM Membuat atau membersihkan file log
echo [%DATE% %TIME%] Memulai instalasi OpenJDK versi %JDK_VERSION% >> "%LOG_FILE%"
echo Log file: %LOG_FILE% >> "%LOG_FILE%"
echo ============================= >> "%LOG_FILE%"

REM Memastikan direktori INSTALL_DIR sudah ada atau membuatnya jika belum
if not exist "%INSTALL_DIR%" (
    echo [%DATE% %TIME%] Membuat direktori %INSTALL_DIR%... >> "%LOG_FILE%"
    mkdir "%INSTALL_DIR%"
)

echo [%DATE% %TIME%] Mengunduh OpenJDK versi %JDK_VERSION%... >> "%LOG_FILE%"
curl -L -o openjdk-%JDK_VERSION%-windows-x64_bin.zip %JDK_URL% >> "%LOG_FILE%" 2>&1

echo [%DATE% %TIME%] Ekstrak file ZIP ke direktori %INSTALL_DIR%... >> "%LOG_FILE%"
tar -xf openjdk-%JDK_VERSION%-windows-x64_bin.zip -C "%INSTALL_DIR%" >> "%LOG_FILE%" 2>&1

echo [%DATE% %TIME%] Menghapus file ZIP yang diunduh... >> "%LOG_FILE%"
del openjdk-%JDK_VERSION%-windows-x64_bin.zip >> "%LOG_FILE%" 2>&1

echo [%DATE% %TIME%] Menetapkan JAVA_HOME dan PATH... >> "%LOG_FILE%"

REM Set JAVA_HOME di tingkat sistem
setx JAVA_HOME "%JDK_DIR%" /M >> "%LOG_FILE%" 2>&1

REM Memeriksa apakah JDK\bin sudah ada dalam PATH
echo [%DATE% %TIME%] Memeriksa apakah %JDK_DIR%\bin sudah ada di PATH... >> "%LOG_FILE%"
set "CURRENT_PATH="
for /f "delims=" %%i in ('echo %PATH%') do set "CURRENT_PATH=%%i"

echo %CURRENT_PATH% | findstr /i "%JDK_DIR%\bin" >nul
if errorlevel 1 (
    echo [%DATE% %TIME%] Menambahkan %JDK_DIR%\bin ke PATH... >> "%LOG_FILE%"
    setx PATH "%PATH%;%JDK_DIR%\bin" /M >> "%LOG_FILE%" 2>&1
) else (
    echo [%DATE% %TIME%] %JDK_DIR%\bin sudah ada di PATH, tidak perlu ditambahkan lagi. >> "%LOG_FILE%"
)

echo [%DATE% %TIME%] Instalasi OpenJDK selesai. >> "%LOG_FILE%"

REM Verifikasi instalasi dengan menjalankan "java -version"
echo [%DATE% %TIME%] Memverifikasi instalasi Java... >> "%LOG_FILE%"
java -version >> "%LOG_FILE%" 2>&1

echo [%DATE% %TIME%] Instalasi selesai. >> "%LOG_FILE%"

pause
