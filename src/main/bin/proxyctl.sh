#!/bin/bash
ff=unix

pro_name=tlc-proxy
basedir=/opt/webapps/job/${pro_name}
log_path=/opt/logs/job/${pro_name}
log_name=proxy
pid=${log_path}/${pro_name}.pid
java_args="-Dlog_path=${log_path}/${log_name}"
jvm_args="-Xms500M -Xmx500M -Xmn300M -XX:PermSize=64M -XX:MaxPermSize=64M -XX:+UseFastAccessorMethods -XX:+CMSClassUnloadingEnabled -XX:+UseConcMarkSweepGC -XX:+UseCMSCompactAtFullCollection -XX:+CMSParallelRemarkEnabled -XX:MaxTenuringThreshold=20 -XX:CMSFullGCsBeforeCompaction=5 -XX:+UseCMSInitiatingOccupancyOnly -XX:CMSInitiatingOccupancyFraction=75 -XX:-PrintGC  -XX:-PrintGCTimeStamps -XX:+PrintGCDetails -XX:+PrintHeapAtGC -Xloggc:${log_path}/gc.log"

export JAVA_HOME=/usr/local/jdk1.7.0_79/
export PATH=$JAVA_HOME/bin:$PATH
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar

command=$1
if [ ${command}x != "start"x -a ${command}x != "stop"x ];
    then
        echo "usage: proxyctl [start|stop]"
elif [ ${command}x = "start"x ];
    then
        nohup java -jar ${basedir}/${pro_name}-1.0.0.jar ${java_args} ${jvm_args} --spring.profiles.active=prod >/dev/null 2>$1 &
        echo $!>${pid}
else [ ${command}x = "stop"x ]
        /bin/kill -9 `cat ${pid}`
        current_date=`date "+%Y-%m-%d %H:%M:%S"`
        echo "${current_date} shutdown tlc-proxy by shutdown.sh" >>${log_path}/${log_name}.log
fi