#!/bin/bash
# -----------------------------------------------------
#
#            OZ Sscheduler Start-up File
#
# This batch file written and tested under Windows 2000
# check your path indicate <JAVA_HOME>/bin
#
# -----------------------------------------------------


# -----------------------------------
#        OZ Scheduler Home
# -----------------------------------
OZSCHEDULER_HOME=../

# -----------------------------------
#        JDK Path
# -----------------------------------
JAVA_HOME=../../jre15



if [ "$OZSCHEDULER_HOME" != "" ]; then

OZSchLib=$OZSCHEDULER_HOME/conf
OZSchLib=$OZSchLib:$OZSCHEDULER_HOME/lib/ozsfw70.jar

# -----------------------------------
#        Library for HTTPS/SSL
# -----------------------------------
OZSchLib=$OZSchLib:$OZSCHEDULER_HOME/lib/jcert.jar
OZSchLib=$OZSchLib:$OZSCHEDULER_HOME/lib/jnet.jar
OZSchLib=$OZSchLib:$OZSCHEDULER_HOME/lib/jsse.jar

# -----------------------------------
#        Library for Logging
# -----------------------------------

OZSchLib=$OZSchLib:$OZSCHEDULER_HOME/lib/log4j.jar

# -----------------------------------
#        Library for XML Parsing
# -----------------------------------
OZSchLib=$OZSchLib:$OZSCHEDULER_HOME/lib/crimson.jar
OZSchLib=$OZSchLib:$OZSCHEDULER_HOME/lib/parser.jar
OZSchLib=$OZSchLib:$OZSCHEDULER_HOME/lib/xerces.jar
OZSchLib=$OZSchLib:$OZSCHEDULER_HOME/lib/dom4j-1.6.1.jar
OZSchLib=$OZSchLib:$OZSCHEDULER_HOME/lib/jaxen-1.1.6.jar

# -----------------------------------
#        Library for Mailing
# -----------------------------------

OZSchLib=$OZSchLib:$OZSCHEDULER_HOME/lib/mail.jar
OZSchLib=$OZSchLib:$OZSCHEDULER_HOME/lib/activation.jar

# -----------------------------------
#      USL Jar for USL
# -----------------------------------
OZSchLib=$OZSchLib:$OZSCHEDULER_HOME/lib/OZUSLClientSession.jar
OZSchLib=$OZSchLib:$OZSCHEDULER_HOME/lib/OZUSLServerDES128.jar

# -----------------------------------
#        Library for Holiday Check
# -----------------------------------

OZSchLib=$OZSchLib:$OZSCHEDULER_HOME/lib/icu4j_2_8.jar


# -----------------------------------
#        Library for Applet Export
# -----------------------------------

OZSchLib=$OZSchLib:$OZSCHEDULER_HOME/lib/ozviewer_lib.jar
OZSchLib=$OZSchLib:$OZSCHEDULER_HOME/lib/ozrresource.jar
OZSchLib=$OZSchLib:$OZSCHEDULER_HOME/lib/poi-scratchpad-3.0.2.jar
OZSchLib=$OZSchLib:$OZSCHEDULER_HOME/lib/uk.co.mmscomputing.imageio.tiff.jar
OZSchLib=$OZSchLib:$OZSCHEDULER_HOME/lib/json-simple-1.1.1.jar


echo Loading OZScheduler...

$JAVA_HOME/bin/java -cp $OZSchLib oz.scheduler.main.OZScheduler $1 $2

else
echo Unable to determine the value of OZSCHEDULER_HOME.
fi
