@echo off

set JAVA_HOME="C:\Program Files (x86)\Java\jre1.5.0_19"
set MAX_MEMORY=256M
set MIN_MEMORY=128M
set JAVA_OPTION=-Xms%MIN_MEMORY% -Xmx%MAX_MEMORY%


set OZSERVER_HOME=..
set USER_CLASSPATH=%OZSERVER_HOME%\uds\
set OZLIBALL=%OZSERVER_HOME%\lib
set OZLIB=%OZLIBALL%\ozsfw70.jar;%OZSERVER_HOME%\conf\


set JAVA_OPTION=



%JAVA_HOME%\bin\java %JAVA_OPTION% -cp %OZLIB% oz.framework.db.Auth %1 %2 %3 %4
