#! /bin/bash
INSTALL_DIR=/usr/hdp/current/zeppelin-server

# Import the helper method module.
wget -O /tmp/HDInsightUtilities-v01.sh -q https://hdiconfigactions.blob.core.windows.net/linuxconfigactionmodulev01/HDInsightUtilities-v01.sh && source /tmp/HDInsightUtilities-v01.sh && rm -f /tmp/HDInsightUtilities-v01.sh

fullHostName=$(hostname -f)
echo "fullHostName=$fullHostName"
if [[ $fullHostName != headnode0* && $fullHostName != hn0* ]]; then
    echo "$fullHostName is not headnode 0. This script has to be run on headnode 0."
    exit 0
fi

download_file https://staaadatahdinsight.blob.core.windows.net/zeppelin-conf/zeppelin-site.xml $INSTALL_DIR/conf/zeppelin-site.xml

$INSTALL_DIR/bin/zeppelin-daemon.sh stop
$INSTALL_DIR/bin/zeppelin-daemon.sh start
echo "Installation succeeded"