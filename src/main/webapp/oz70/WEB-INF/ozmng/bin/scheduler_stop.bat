@echo off

set JAVA_HOME="C:\Program Files (x86)\Java\jre1.5.0_19"
set OZSCHEDULER_HOME=..\


if not "%OZSCHEDULER_HOME%" == "" goto start
echo Unable to determine the value of OZSCHEDULER_HOME.
goto eof


:start

set OZSchLib=%OZSCHEDULER_HOME%\conf
set OZSchLib=%OZSchLib%;%OZSCHEDULER_HOME%\lib\ozsfw70.jar
set OZSchLib=%OZSchLib%;%OZSCHEDULER_HOME%\lib\j2ee.jar

rem -----------------------------------
rem        Library for Logging
rem -----------------------------------
set OZSchLib=%OZSchLib%;%OZSCHEDULER_HOME%\lib\log4j.jar

echo Terminate OZScheduler...

%JAVA_HOME%\bin\java -cp %OZSchLib% oz.scheduler.main.OZScheduler -k %1

:eof
