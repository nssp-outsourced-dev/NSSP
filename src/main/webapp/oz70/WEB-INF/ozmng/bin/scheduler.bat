@echo off

set JAVA_HOME="C:\Program Files (x86)\Java\jre1.5.0_19"
set OZSCHEDULER_HOME=..\


if not "%OZSCHEDULER_HOME%" == "" goto start
echo Unable to determine the value of OZSCHEDULER_HOME.
goto eof


:start

set OZSchLib=%OZSCHEDULER_HOME%\lib\ozsfw70.jar
set OZSchLib=%OZSchLib%;%OZSCHEDULER_HOME%\conf

rem -----------------------------------
rem        Library for HTTPS/SSL
rem -----------------------------------
set OZSchLib=%OZSchLib%;%OZSCHEDULER_HOME%\lib\jcert.jar
set OZSchLib=%OZSchLib%;%OZSCHEDULER_HOME%\lib\jnet.jar
set OZSchLib=%OZSchLib%;%OZSCHEDULER_HOME%\lib\jsse.jar

rem -----------------------------------
rem        Library for Logging
rem -----------------------------------
set OZSchLib=%OZSchLib%;%OZSCHEDULER_HOME%\lib\log4j.jar

rem -----------------------------------
rem        Library for XML Parsing
rem -----------------------------------
set OZSchLib=%OZSchLib%;%OZSCHEDULER_HOME%\lib\crimson.jar
set OZSchLib=%OZSchLib%;%OZSCHEDULER_HOME%\lib\parser.jar
set OZSchLib=%OZSchLib%;%OZSCHEDULER_HOME%\lib\xerces.jar
set OZSchLib=%OZSchLib%;%OZSCHEDULER_HOME%\lib\dom4j-1.6.1.jar
set OZSchLib=%OZSchLib%;%OZSCHEDULER_HOME%\lib\jaxen-1.1.6.jar

rem -----------------------------------
rem        Library for Mailing
rem -----------------------------------
set OZSchLib=%OZSchLib%;%OZSCHEDULER_HOME%\lib\mail.jar
set OZSchLib=%OZSchLib%;%OZSCHEDULER_HOME%\lib\activation.jar

rem -----------------------------------
rem      USL Jar for USL
rem -----------------------------------
set OZSchLib=%OZSchLib%;%OZSCHEDULER_HOME%\lib\OZUSLClientSession.jar
set OZSchLib=%OZSchLib%;%OZSCHEDULER_HOME%\lib\OZUSLServerDES128.jar

rem -----------------------------------
rem        NT Service Class
rem -----------------------------------
set OZSchLib=%OZSchLib%;%OZSCHEDULER_HOME%\lib\OZServiceBootstrap.jar

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



echo Loading OZScheduler...

%JAVA_HOME%\bin\java -cp %OZSchLib% oz.scheduler.main.OZScheduler %1 %2

:eof
