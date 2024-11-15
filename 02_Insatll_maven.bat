@echo off
set "MAVEN_VERSION=3.9.8"
set "MAVEN_URL=https://dlcdn.apache.org/maven/maven-3/%MAVEN_VERSION%/binaries/apache-maven-%MAVEN_VERSION%-bin.zip"
set "INSTALL_DIR=D:\zSvrJavaMavenTomcat"
set "MAVEN_DIR=%INSTALL_DIR%\apache-maven-%MAVEN_VERSION%"
set "LOG_FILE=%INSTALL_DIR%\install_maven_log.txt"

REM Membuat atau membersihkan file log
echo [%DATE% %TIME%] Memulai instalasi Apache Maven versi %MAVEN_VERSION% >> "%LOG_FILE%"
echo [%DATE% %TIME%] Log file: %LOG_FILE% >> "%LOG_FILE%"
echo ============================= >> "%LOG_FILE%"

REM Memastikan direktori INSTALL_DIR ada atau membuatnya jika belum
if not exist "%INSTALL_DIR%" (
    echo [%DATE% %TIME%] Membuat direktori %INSTALL_DIR%... >> "%LOG_FILE%"
    mkdir "%INSTALL_DIR%"
)

echo[%DATE% %TIME%] Mengunduh Apache Maven versi %MAVEN_VERSION%... >> "%LOG_FILE%"
curl -L -o apache-maven-%MAVEN_VERSION%-bin.zip %MAVEN_URL% >> "%LOG_FILE%" 2>&1

echo [%DATE% %TIME%] Ekstrak file ZIP ke direktori %INSTALL_DIR%... >> "%LOG_FILE%"
tar -xf apache-maven-%MAVEN_VERSION%-bin.zip -C "%INSTALL_DIR%" >> "%LOG_FILE%" 2>&1

echo [%DATE% %TIME%] Menghapus file ZIP yang diunduh... >> "%LOG_FILE%"
del apache-maven-%MAVEN_VERSION%-bin.zip >> "%LOG_FILE%" 2>&1

echo [%DATE% %TIME%] Menetapkan MAVEN_HOME secara global... >> "%LOG_FILE%"
setx MAVEN_HOME "%MAVEN_DIR%" /M >> "%LOG_FILE%" 2>&1

REM Memeriksa apakah MAVEN_DIR\bin sudah ada dalam PATH
echo [%DATE% %TIME%] Memeriksa apakah %MAVEN_DIR%\bin sudah ada di PATH... >> "%LOG_FILE%"
set "CURRENT_PATH="
for /f "delims=" %%i in ('echo %PATH%') do set "CURRENT_PATH=%%i"

echo %CURRENT_PATH% | findstr /i "%MAVEN_DIR%\bin" >nul
if errorlevel 1 (
    echo [%DATE% %TIME%] Menambahkan %MAVEN_DIR%\bin ke PATH... >> "%LOG_FILE%"
    setx PATH "%PATH%;%MAVEN_DIR%\bin" /M >> "%LOG_FILE%" 2>&1
) else (
    echo [%DATE% %TIME%] %MAVEN_DIR%\bin sudah ada di PATH, tidak perlu ditambahkan lagi. >> "%LOG_FILE%"
)

echo [%DATE% %TIME%] Instalasi Apache Maven selesai. >> "%LOG_FILE%"

REM Verifikasi instalasi dengan menjalankan "mvn -version"
echo [%DATE% %TIME%] Memverifikasi instalasi Maven... >> "%LOG_FILE%"
mvn -version >> "%LOG_FILE%" 2>&1

echo [%DATE% %TIME%] Instalasi selesai. >> "%LOG_FILE%"

pause
