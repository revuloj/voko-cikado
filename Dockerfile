FROM debian:stable-slim as builder
LABEL MAINTAINER=<diestel@steloj.de>

ARG BIBLIOGR=https://raw.githubusercontent.com/revuloj/revo-fonto/master/cfg/bibliogr.xml
ARG GRUNDO=https://github.com/revuloj/voko-grundo/archive/master.zip

# Tiu ĉi Javo-procezujo servas nur por prepari ĉion, t.e. krei la HTML-paĝojn el la xml
# Ni poste forĵetos ĝin por krei Prolog-procezujon, kiu servas la paĝojn kune kune
# citaĵoserĉo.


RUN apt-get update && apt-get install -y --no-install-recommends \
    openjdk-17-jre ant libsaxonb-java unzip curl \
    && rm -rf /var/lib/apt/lists/* \
    && cd /tmp && echo "<- ${BIBLIOGR}" && curl -LO ${BIBLIOGR} \
    && echo "<- ${GRUNDO}" && curl -LO ${GRUNDO} && unzip -q master.zip voko-grundo-master/dtd/* \
    && ls /tmp/*

# libxalan2-java
# se uzi xalan anst. saxon necesas uzi fallback redirect anst. result-document,
# vd. http://www.java2s.com/Code/XML/XSLT-stylesheet/resultdocumentdemo.htm por kiel fari tion

# libsaxonhe-java: havas problemon transformante multajn artikolojn: normalizationData.xml not found...


#RUN useradd -ms /bin/bash -u 1001 revo
#USER revo:users

COPY  . /home/revo/verkoj

# JAXP limo:
# JAXP00010001: The parser has encountered more than "64000" entity expansions in this document
# vd. https://stackoverflow.com/questions/26809558/jdk-limit-on-entity-expansions
# sen limo: jdk.xml.entityExpansionLimit=0
ENV CLASSPATH=/usr/share/java/saxonb.jar \
    SAXONJAR=/usr/share/java/saxonb.jar \
    ANT_OPTS="-Xmx1000m -Djdk.xml.entityExpansionLimit=256000"
  # vd. supre: /usr/share/java/Saxon-HE.jar
RUN cd /home/revo/verkoj && ant klasikaj-verkoj

# Nun ni kreos la propran keston por servi la verkojn...

FROM swipl:stable

# FARENDA:
# servu kaj la verkojn kaj la citaĵoservon, tiel oni povas ankaŭ eliri el la
# serĉo en la tekstojn rekte....

RUN useradd -ms /bin/bash -u 1003 cikado 
USER cikado:users

#RUN ls /home/ && mkdir /home/cikado/xml && mkdir /home/revo/txt
#COPY ./xml /home/cikado/xml (nun en /txt/tei2)
COPY ./txt /home/cikado/txt
COPY ./pro /home/cikado/pro
COPY --from=builder /home/revo/verkoj/steloj.de /home/cikado/steloj.de
COPY --from=builder /tmp/voko-grundo-master/dtd /home/cikado/dtd/
COPY --from=builder /tmp/bibliogr.xml /home/cikado/cfg/

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
