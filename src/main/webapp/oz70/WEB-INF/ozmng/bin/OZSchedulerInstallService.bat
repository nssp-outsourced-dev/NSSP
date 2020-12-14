@echo off

set JRE_PATH=C:\Program Files\Java\jdk1.8.0_121\jre\bin\server\jvm.dll
set OZSCHEDULER_HOME=D:\webapps\oz70\WEB-INF\ozmng
set OZSCHEDULER_HOME_BIN=D:\webapps\oz70\WEB-INF\ozmng\bin


set MAX_MEMORY=256
set MIN_MEMORY=128

rem JAVA option delemter is ;
set JAVA_OPTION=


if not "%OZSCHEDULER_HOME%" == "" goto start
echo Unable to determine the value of OZSCHEDULER_HOME.
goto eof

if not "%OZSCHEDULER_HOME_BIN%" == "" goto start
echo Unable to determine the absolute path value of OZSCHEDULER_HOME_BIN.
goto eof

if not "%JRE_PATH%" == "" goto start
echo Unable to determine the absolute path value of JRE_PATH
goto eof


:start

set OZSchLib=%OZSCHEDULER_HOME%\lib\ozsfw70.jar
set OZSchLib=%OZSchLib%;%OZSCHEDULER_HOME%\conf

rem --------------------------------------------------
rem        OZ Service BootStrap
rem --------------------------------------------------
set OZSchLib=%OZSchLib%;%OZSCHEDULER_HOME%\lib\OZServiceBootstrap.jar

rem --------------------------------------------------
rem        Library for HTTPS/SSL
rem --------------------------------------------------
set OZSchLib=%OZSchLib%;%OZSCHEDULER_HOME%\lib\jnet.jar
set OZSchLib=%OZSchLib%;%OZSCHEDULER_HOME%\lib\jsse.jar

rem --------------------------------------------------
rem        Library for Logging
rem --------------------------------------------------
set OZSchLib=%OZSchLib%;%OZSCHEDULER_HOME%\lib\log4j.jar

rem --------------------------------------------------
rem        Library for XML Parsing
rem --------------------------------------------------
set OZSchLib=%OZSchLib%;%OZSCHEDULER_HOME%\lib\crimson.jar
set OZSchLib=%OZSchLib%;%OZSCHEDULER_HOME%\lib\parser.jar
set OZSchLib=%OZSchLib%;%OZSCHEDULER_HOME%\lib\xerces.jar
set OZSchLib=%OZSchLib%;%OZSCHEDULER_HOME%\lib\dom4j-1.6.1.jar
set OZSchLib=%OZSchLib%;%OZSCHEDULER_HOME%\lib\jaxen-1.1.6.jar

rem --------------------------------------------------
rem        Library for Mailing
rem --------------------------------------------------
set OZSchLib=%OZSchLib%;%OZSCHEDULER_HOME%\lib\mail.jar
set OZSchLib=%OZSchLib%;%OZSCHEDULER_HOME%\lib\activation.jar

rem --------------------------------------------------
rem      USL Jar for USL
rem --------------------------------------------------
set OZSchLib=%OZSchLib%;%OZSCHEDULER_HOME%\lib\OZUSLClientSession.jar
set OZSchLib=%OZSchLib%;%OZSCHEDULER_HOME%\lib\OZUSLServerDES128.jar

rem -----------------------------------
rem        Library for Holiday Check
rem -----------------------------------

set OZSchLib=%OZSchLib%;%OZSCHEDULER_HOME%\lib\icu4j_2_8.jar

rem -----------------------------------
rem        Library for Applet Export
rem -----------------------------------

set OZSchLib=%OZSchLib%;%OZSCHEDULER_HOME%\lib\ozviewer_lib.jar
set OZSchLib=%OZSchLib%;%OZSCHEDULER_HOME%\lib\ozrresource.jar
set OZSchLib=%OZSchLib%;%OZSCHEDULER_HOME%\lib\poi-scratchpad-3.0.2.jar
set OZSchLib=%OZSchLib%;%OZSCHEDULER_HOME%\lib\uk.co.mmscomputing.imageio.tiff.jar
set OZSchLib=%OZSchLib%;%OZSCHEDULER_HOME%\lib\json-simple-1.1.1.jar


OZServiceSC.exe //IS//OZScheduler --DisplayName="OZScheduler" --Description="OZScheduler" --StartPath="%OZSCHEDULER_HOME_BIN%" --StopPath="%OZSCHEDULER_HOME_BIN%" --Classpath="%OZSchLib%" --Jvm="%JRE_PATH%" --JvmOptions="-Xmixed;%JAVA_OPTION%" --JvmMs="%MIN_MEMORY%" --JvmMx="%MAX_MEMORY%" --StartMode=jvm --StopMode=jvm  --StartClass=oz.server.OZServiceBootstrap --StartParams=OZSchedulerStart --StopClass=oz.server.OZServiceBootstrap --StopParams=OZSchedulerStop --LogPath="%OZSCHEDULER_HOME_BIN%" --LogLevel=DEBUG

:eof
