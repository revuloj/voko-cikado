#CLASSPATH=/usr/lib/xml/xp.jar:/usr/lib/xml/xt.jar:/usr/lib/xml/sax.jar

XTPATH=/home/revo/bezonoj/xt-20020426a-src
CLASSPATH=$XTPATH/xt.jar:$XTPATH/lib/xp.jar:$XTPATH/lib/xml-apis.jar
export CLASSPATH

#JAVA_HOME=/opt/JavaEE5/java
JAVA_OPTS=-Xmx275M
/usr/bin/java ${JAVA_OPTS} com.jclark.xsl.sax.Driver $1 $2

