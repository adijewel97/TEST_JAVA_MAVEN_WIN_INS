@echo off
set "JDK_VERSION=17"
set "JDK_URL=https://download.oracle.com/java/%JDK_VERSION%/archive/jdk-%JDK_VERSION%_windows-x64_bin.zip"
set "INSTALL_DIR=D:\zSvrJavaMavenTomcat"
set "JDK_DIR=%INSTALL_DIR%\jdk-%JDK_VERSION%"

REM Memastikan direktori INSTALL_DIR sudah ada atau membuatnya jika belum
if not exist "%INSTALL_DIR%" (
    echo Membuat direktori %INSTALL_DIR%...
    mkdir "%INSTALL_DIR%"
)

echo Mengunduh OpenJDK versi %JDK_VERSION%...
curl -L -o openjdk-%JDK_VERSION%-windows-x64_bin.zip %JDK_URL%

echo Ekstrak file ZIP ke direktori %INSTALL_DIR%...
tar -xf openjdk-%JDK_VERSION%-windows-x64_bin.zip -C "%INSTALL_DIR%"

echo Menghapus file ZIP yang diunduh...
del openjdk-%JDK_VERSION%-windows-x64_bin.zip

echo Menetapkan JAVA_HOME dan PATH...
REM Set JAVA_HOME di tingkat sistem
setx JAVA_HOME "%JDK_DIR%" /M

REM Tambahkan JDK\bin langsung ke PATH
setx PATH "%PATH%;%INSTALL_DIR%\jdk-%JDK_VERSION%\bin" /M

echo Instalasi OpenJDK selesai.

REM Verifikasi instalasi dengan menjalankan "java -version"
echo Memverifikasi instalasi Java...
java -version

pause
