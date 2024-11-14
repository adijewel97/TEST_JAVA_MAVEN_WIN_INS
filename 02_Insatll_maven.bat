@echo off
set "MAVEN_VERSION=3.9.8"
set "MAVEN_URL=https://dlcdn.apache.org/maven/maven-3/%MAVEN_VERSION%/binaries/apache-maven-%MAVEN_VERSION%-bin.zip"
set "INSTALL_DIR=D:\zSvrJavaMavenTomcat"
set "MAVEN_DIR=%INSTALL_DIR%\apache-maven-%MAVEN_VERSION%"

REM Memastikan direktori INSTALL_DIR ada atau membuatnya jika belum
if not exist "%INSTALL_DIR%" (
    echo Membuat direktori %INSTALL_DIR%...
    mkdir "%INSTALL_DIR%"
)

echo Mengunduh Apache Maven versi %MAVEN_VERSION%...
curl -L -o apache-maven-%MAVEN_VERSION%-bin.zip %MAVEN_URL%

echo Ekstrak file ZIP ke direktori %INSTALL_DIR%...
tar -xf apache-maven-%MAVEN_VERSION%-bin.zip -C "%INSTALL_DIR%"

echo Menghapus file ZIP yang diunduh...
del apache-maven-%MAVEN_VERSION%-bin.zip

echo Menetapkan MAVEN_HOME secara global...
setx MAVEN_HOME "%MAVEN_DIR%" /M

echo Menambahkan Maven ke PATH...
setx PATH "%PATH%;%MAVEN_DIR%\bin" /M

echo Instalasi Apache Maven selesai.

REM Verifikasi instalasi dengan menjalankan "mvn -version"
echo Memverifikasi instalasi Maven...
mvn -version
pause
