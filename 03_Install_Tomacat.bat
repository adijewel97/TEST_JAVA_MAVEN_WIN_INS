@echo off
set "LOG_FILE=D:\zSvrJavaMavenTomcat\install_tomcat7_log.txt"

REM Mulai mencatat log
echo [%DATE% %TIME%] Memulai proses instalasi... > "%LOG_FILE%"
echo. >> "%LOG_FILE%"

REM Lanjutkan mencatat log
set "INSTALL_DIR=D:\zSvrJavaMavenTomcat"

set "JDK_VERSION=17"
set "JDK_URL=https://download.oracle.com/java/17/latest/jdk-17_windows-x64_bin.zip"
set "JDK_DIR=%INSTALL_DIR%\jdk-%JDK_VERSION%"

set "TOMCAT_VERSION=7.0.109"
set "TOMCAT_URL=https://archive.apache.org/dist/tomcat/tomcat-7/v7.0.109/bin/apache-tomcat-%TOMCAT_VERSION%.zip"
set "TOMCAT_DIR=%INSTALL_DIR%\apache-tomcat-%TOMCAT_VERSION%"

set "NSSM_VERSION=2.24"
set "NSSM_URL=https://nssm.cc/release/nssm-%NSSM_VERSION%.zip"
set "NSSM_DIR=%INSTALL_DIR%\nssm-%NSSM_VERSION%"

REM Semua output akan dicatat ke file log
(
    REM Mengunduh JDK
    echo Mengunduh JDK...
    curl -L -o jdk-%JDK_VERSION%.zip %JDK_URL%

    REM Ekstrak file JDK ZIP ke direktori %INSTALL_DIR%
    echo [%DATE% %TIME%] Ekstrak file JDK ZIP ke direktori %INSTALL_DIR%...
    tar -xf jdk-%JDK_VERSION%.zip -C "%INSTALL_DIR%"

    REM Menghapus file ZIP JDK yang diunduh
    echo [%DATE% %TIME%] Menghapus file ZIP JDK yang diunduh...
    del jdk-%JDK_VERSION%.zip

    REM Mengunduh nssm
    echo Mengunduh nssm...
    curl -L -o nssm-%NSSM_VERSION%.zip %NSSM_URL%

    REM Ekstrak file nssm ZIP ke direktori %INSTALL_DIR%
    echo Ekstrak file nssm ZIP ke direktori %INSTALL_DIR%...
    tar -xf nssm-%NSSM_VERSION%.zip -C "%INSTALL_DIR%"

    REM Menghapus nssm file ZIP yang diunduh
    echo [%DATE% %TIME%] Menghapus nssm file ZIP yang diunduh...
    del nssm-%NSSM_VERSION%.zip

    REM Mengunduh Apache Tomcat versi %TOMCAT_VERSION%
    echo [%DATE% %TIME%] Mengunduh Apache Tomcat versi %TOMCAT_VERSION%...
    curl -L -o apache-tomcat-%TOMCAT_VERSION%.zip %TOMCAT_URL%

    REM Ekstrak file ZIP ke direktori %INSTALL_DIR%
    echo [%DATE% %TIME%] Ekstrak file ZIP ke direktori %INSTALL_DIR%...
    tar -xf apache-tomcat-%TOMCAT_VERSION%.zip -C "%INSTALL_DIR%"

    REM Menghapus file ZIP yang diunduh
    echo [%DATE% %TIME%] Menghapus file ZIP yang diunduh...
    del apache-tomcat-%TOMCAT_VERSION%.zip

    REM Menetapkan CATALINA_HOME dan PATH di tingkat sistem
    echo [%DATE% %TIME%] Menetapkan CATALINA_HOME dan PATH...
    setx JAVA_HOME "%JDK_DIR%" /M
    setx CATALINA_HOME "%TOMCAT_DIR%" /M
    setx NSSM_HOME "%NSSM_DIR%" /M
    setx PATH "%PATH%;%TOMCAT_DIR%\bin;%NSSM_DIR%\win64;%JDK_DIR%\bin" /M

    REM Mengatur CATALINA_HOME untuk sesi saat ini
    set CATALINA_HOME=%TOMCAT_DIR%

    REM Konfigurasi file tomcat-users.xml
    echo [%DATE% %TIME%] Konfigurasi file tomcat-users.xml...
    (
        echo ^<?xml version="1.0" encoding="UTF-8"?^>
        echo ^<tomcat-users^>
        echo ^  ^<role rolename="admin"/^>
        echo ^  ^<role rolename="manager-gui"/^>
        echo ^  ^<role rolename="manager-script"/^>
        echo ^  ^<role rolename="manager-jmx"/^>
        echo ^  ^<role rolename="manager-status"/^>
        echo ^  ^<user username="admin" password="admin" roles="admin,manager,manager-gui,manager-script,manager-jmx,manager-status"/^>
        echo ^</tomcat-users^>
    ) > "%TOMCAT_DIR%\conf\tomcat-users.xml"

    REM Pastikan Tomcat tidak berjalan dengan menghentikan proses java.exe
    echo [%DATE% %TIME%] Memastikan Tomcat berhenti sebelum melanjutkan...
    tasklist /FI "IMAGENAME eq java.exe" 2>NUL | find /I "java.exe" >NUL
    if "%ERRORLEVEL%"=="0" (
        echo [%DATE% %TIME%] Tomcat masih berjalan. Menghentikan proses secara paksa...
        taskkill /F /IM java.exe
        timeout /t 10
    ) else (
        echo [%DATE% %TIME%] Tomcat telah berhenti.
    )

    REM Memulai Tomcat
    echo [%DATE% %TIME%] Memulai Tomcat kembali...
    "%TOMCAT_DIR%\bin\catalina.bat" start
    timeout /t 5

    REM Menambahkan Tomcat sebagai service Windows dengan NSSM
    echo [%DATE% %TIME%] Menambahkan Tomcat sebagai service Windows dengan NSSM...
    "%NSSM_DIR%\win64\nssm.exe" install Tomcat7 "%TOMCAT_DIR%\bin\catalina.bat" run
    "%NSSM_DIR%\win64\nssm.exe" set Tomcat7 DisplayName "Apache Tomcat 7.0.109"
    "%NSSM_DIR%\win64\nssm.exe" set Tomcat7 Start SERVICE_AUTO_START
    "%NSSM_DIR%\win64\nssm.exe" set Tomcat7 AppStdout "%INSTALL_DIR%\tomcat_service_log.txt"
    "%NSSM_DIR%\win64\nssm.exe" set Tomcat7 AppStderr "%INSTALL_DIR%\tomcat_service_log.txt"

    REM Mengaktifkan Delayed Start
    reg add "HKLM\SYSTEM\CurrentControlSet\services\Tomcat7" /v DelayedAutostart /t REG_DWORD /d 0x1 /f

    REM Memulai layanan Tomcat
    echo [%DATE% %TIME%] Memulai service Tomcat...
    sc start Tomcat7

    echo [%DATE% %TIME%] Tomcat telah diinstal sebagai service Windows dengan startup otomatis dan Delayed Start.
) >> "%LOG_FILE%" 2>&1

echo [%DATE% %TIME%] Selesai! Semua proses telah dicatat di %LOG_FILE%
pause
