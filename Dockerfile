FROM openjdk:jre-slim as builder
MAINTAINER <diestel@steloj.de>

# Tiu Javo-kesto servas nur por prepari ĉion, t.e. krei la HTML-paĝojn el la xml
# Ni poste forĵetos ĝin por krei Prolog-keston, kiu servas la paĝojn kune kune
# citaĵoserĉo.

RUN apt-get update && apt-get install -y --no-install-recommends \
    ant libsaxonhe-java \
    && rm -rf /var/lib/apt/lists/*

# libxalan2-java
# se uzi xalan anst. saxon necesas uzi fallback redirect anst. result-document,
# vd. http://www.java2s.com/Code/XML/XSLT-stylesheet/resultdocumentdemo.htm por kiel fari tion

#RUN useradd -ms /bin/bash -u 1001 revo
#USER revo:users

COPY  . /home/revo/verkoj
#COPY --chown=revo:users /xml /home/revo/verkoj/xml
#COPY --chown=revo:users /bld /home/revo/verkoj/bld
#COPY --chown=revo:users /xsl /home/revo/verkoj/xsl
#COPY --chown=revo:users /css /home/revo/verkoj/css
#COPY --chown=revo:users /build.xml /home/revo/verkoj/build.xml
ENV CLASSPATH=/usr/share/java/Saxon-HE.jar
RUN cd /home/revo/verkoj && ant klasikaj-verkoj

# Nun ni kreos la propran keston por servi la verkojn...

FROM swipl:stable

# FARENDA:
# servu kaj la verkojn kaj la citaĵoservon, tiel oni povas ankaŭ eliri el la
# serĉo en la tekstojn rekte....

RUN useradd -ms /bin/bash -u 1003 cikado
USER cikado:users

#RUN ls /home/ && mkdir /home/cikado/xml && mkdir /home/revo/txt
COPY ./xml /home/cikado/xml
COPY ./txt /home/cikado/txt
COPY ./pro /home/cikado/pro
COPY --from=builder /home/revo/verkoj/steloj.de /home/cikado/steloj.de

WORKDIR /home/cikado/pro

CMD ["swipl",\
    "-s","/home/cikado/pro/cikado-servo.pl",\
    "-g","cikado:daemon","-t","halt","--",\
    "--workers=10","--port=8082","--no-fork"]

#CMD ["swipl",\
#    "-s","/home/cikado/pro/cikado-servo.pl",\
#    "-g","cikado:server(8081)","-t","halt"]


# konstruo:
# docker build -t cikado .
#
# kuro
# docker run -p 8081:8081 cikado
# docker run -it cikado /bin/bash
#
# verkoj: http://localhost:8082/ -> /cikado/verkoj/ 
# serĉo: http://localhost:8082/cikado/cikado?sercho=homoj&kie=klasikaj
