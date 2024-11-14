A) install JAVA 
	1. jalanka file bat :
	   01_Insatll_jdk17
        2. test cdm :
	   java -version

B) install maven 
	1. jalankan file bat berikut untuk nsatal maveb dan buat enverment i windows 11
	   nama file : 01_Insatll_maven
	   @echo off
		set "MAVEN_VERSION=3.9.8"
		set "MAVEN_URL=https://dlcdn.apache.org/maven/maven-3/%MAVEN_VERSION%/binaries/apache-maven-%MAVEN_VERSION%-bin.zip"
		set "INSTALL_DIR=D:\00_database_docker\APP_MAVEN\TEST_JAVA_MAVEN_WIN"
		set "MAVEN_DIR=%INSTALL_DIR%\apache-maven-%MAVEN_VERSION%"

		echo Mengunduh Apache Maven versi %MAVEN_VERSION%...
		curl -L -o apache-maven-%MAVEN_VERSION%-bin.zip %MAVEN_URL%

		echo Ekstrak file ZIP ke direktori %INSTALL_DIR%...
		tar -xf apache-maven-%MAVEN_VERSION%-bin.zip -C "%INSTALL_DIR%"

		echo Menghapus file ZIP yang diunduh...
		del apache-maven-%MAVEN_VERSION%-bin.zip

		echo Menetapkan MAVEN_HOME dan PATH...
		REM Set MAVEN_HOME di tingkat sistem
		setx MAVEN_HOME "%MAVEN_DIR%" /M

		REM Tambahkan INSTALL_DIR\bin langsung ke PATH
		setx PATH "%PATH%;%INSTALL_DIR%\apache-maven-%MAVEN_VERSION%\bin" /M

		echo Instalasi Maven selesai. Verifikasi instalasi dengan membuka Command Prompt baru dan menjalankan "mvn -version".
		pause

	2. jalan perintah test run maven :
	   mvn - version
   C) Install tomcat 7.0.109
      	1. jalankan file bat :
	   03_Install_Tomacat
	2. masuk command dos masuk folder tomcat jalankan perintah 
           - cd D:\zSvrJavaMavenTomcat\apache-tomcat-7.0.109\bin
           - D:\zSvrJavaMavenTomcat\apache-tomcat-7.0.109\bin>catalina start
	   - D:\zSvrJavaMavenTomcat\apache-tomcat-7.0.109\bin>catalina Stop
         3. sudah bisa start langusng saat file bat dijalankan

	 4. sipan di git biar nagak hilang:
		echo "# TEST_JAVA_MAVEN_WIN_INS" >> README.md
		git init
		git add README.md
		git commit -m "first commit"
		git branch -M main
		git remote add origin https://github.com/adijewel97/TEST_JAVA_MAVEN_WIN_INS.git
		git push -u origin main
			  
			  
sc create Tomcat7 binPath= "\"%SystemRoot%\System32\cmd.exe\" /c \"%CATALINA_HOME%\bin\catalina.bat\" run" start= auto DisplayName= "Apache Tomcat 7.0.109"