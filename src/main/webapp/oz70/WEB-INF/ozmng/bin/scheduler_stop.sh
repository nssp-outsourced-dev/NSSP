#!/bin/bash
# -----------------------------------------------------
#
#            OZ Sscheduler Stop File                  
# 
# This batch file written and tested under Windows 2000
# check your path indicate <JAVA_HOME>/bin
# 
# -----------------------------------------------------


OZSCHEDULER_HOME=../
JAVA_HOME=../../JRE15

if [ "$OZSCHEDULER_HOME" != "" ]; then 
 OZSchLib=$OZSCHEDULER_HOME/conf
 OZSchLib=$OZSchLib:$OZSCHEDULER_HOME/lib/ozsfw70.jar
 OZSchLib=$OZSchLib:$OZSCHEDULER_HOME/lib/j2ee.jar
 
# -----------------------------------
#        Library for Logging
# -----------------------------------
OZSchLib=$OZSchLib:$OZSCHEDULER_HOME/lib/log4j.jar

echo Terminate OZScheduler...

$JAVA_HOME/bin/java -cp $OZSchLib oz.scheduler.main.OZScheduler -k $1

else 
echo Unable to determine the value of OZSCHEDULER_HOME.
fi
