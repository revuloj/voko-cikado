---
title: "Pakedo-Radio: mirakla komunikadorimedo"
author: Josef Wozniczka 
lang: eo
magazin: Scienca Revuo
year: 1996
volume: 168
keywords:
    - radio
source: https://scienca-revuo.info/article/42
license: CC BY-ND 4.0 (https://creativecommons.org/licenses/by-nd/4.0/)    
---

<!--  
prenita el:
STEB: [http://www.eventoj.hu](http://www.eventoj.hu/){.al}
Enretigo: *Mészáros* István\
-->

## Enkonduko

La deziro de homoj, komunikiĝi unu kun la alia, kondukis al disvolviĝo
de diversaj teknikaj metodoj kiuj permesus ne nur la senperan
interparoladon, sed ankaŭ la komunikadon distancan, unue nur skribitan
kaj en la nuna jarcento ankaŭ parolitan, danke al la inventoj de
telegrafo, telefono kaj radiotekniko. En la sekva artikolo estas
priskribita nova metodo de skriba komunikado pere de uzo de komputoro
kaj hejma radiostacio, tamen neprofesie, sed nur private kvazaŭ kiel
hobio.

## Pakedo-Radio (PR)

Pakedoradio (mallongigo: PR, angle: [packet radio]{.maldense}) konsistas el
komputoro (IBM kompatibla, tamen povas esti kun malgranda memorkapablo,
ekzemple PC 286, aŭ eĉ poŝa komputilo kiel ATARI-Portfolio kun memoro
128 kB aŭ eĉ malpli), radiostacio de t. n. CB-radio kun 40 kanaloj aŭ
nun 80 kanaloj (hejma stacio aŭ mana stacio --- angle: [handy
station]{.maldense} --- povas esti ankaŭ aŭtomobila radiostacio). Poste oni
bezonas t.n. *modemon* aŭ stacian nodan direktilon (angle: [terminal
node controller]{.maldense}, mallongigo: TNC), kiu transformas la ciferojn de
komputoro en aŭdeblajn signalojn por amplifikigi ilin kaj sendi ilin en
la eteron pere de supermallongaj ondoj fare de radiostacio.

Dum ricevado de informoj la modemo respektive TNC funkcias inverse: ĝi
transformadas la aŭdeblajn signalojn venantajn de la alia kunligita
PR-radiostacio en ciferajn signalojn, nome nuloj kaj unu-oj (0 kaj 1)
uzatajn en la cibernetiko. La vorto *pakedo* signifas ĉi tie, ke la
informoj tajpitaj en la komputoron, la radiostacio sendadas parte po unu
linio aŭ po unu frazo aŭ eĉ po parto de frazo: ĝuste kiel "pakedo da
informoj", do ne tuj la tutan skribitan tekston. Tiuj pakedoj estas
sendataj dum la paŭzo trans la eteraj ondoj, kiam en la elektita kanalo
de CB-radio regas momente "silento".

## Detala priskribo de PR

La pakedoj estas dissendataj kun ege granda rapideco de 1200 baŭdoj (1
baŭdo = 1 bito/sekundo). Inter la elsendoj la frekvenco estas libera pri
dispono de aliaj stacioj. Normale ĉiu tajpita linio (finita per puŝo de
butono [RETURN]{.maldense} --- returno) estas bindita je unu pakedo. Kontraŭe ĉe
normalaj radioskribo-tajpiloj (angle: [RTTY-radio teletype]{.maldense}) la
informoj estas transportitaj kurante kun relative malgranda rapideco
(ekz. 45 baŭdoj), kaj dum la tuta tempo la frekvenco estas okupita.

Pakedoradio obeas la X.25-normon, kiu estas aplikata por drata
telekomunikado, tamen modifita en certaj punktoj (ekz. adresa spaco kaj
UI-krado). Tiamaniere tiu ĉi normo fariĝas AX.25, normo kiun agnoskas
IARU (= Internacia Radio Organizaĵo).

## Klarigo de kelkaj bazaj terminoj

*Framo*
: (angle: [frame]{.maldense}) signifas kvadraĵon en kiu estas
ennestataj la trasendendaj efektivaj informoj ĉirkaŭitaj de stirinformoj
(adreso, sendinto, voknomo). Do ĉiu transdonata pakedo enhavas sendinton
kaj adresaton, kaj, se necese, perantan stacion, t.n. *nodon*, kio
ebligas ke la licenca oficejo kontrolu la enhavon de komunikado.

*Manpremo*
: Tiu ĉi termino devenas ankaŭ de la angla lingvo, nome
[handshake]{.maldense}, kaj signifas la procezon de kvitancado de ĉiu
ricevita framo. Danke al tio, en kazo de transporteraro aŭ perdo de
framo estas kaŭzigita konvena ripetiĝo. Oni povas sendi maksimume 7
pakedojn, poste devas necese veni la menciita *kvitanco*!

*Cifera ripetanto*
: (angle: "[digipeater]{.maldense}" = [digital
repeater]{.maldense}) estas speco de relajsa radio-stacio, sed alie ol ĉe
telefonado la ricevita *pakedo* estas enmagazenata, esplorata kaj tuj
poste sendata al la adresato. Ciferaj ripetantoj laboras normale en la
simpla modo (angle: [simplexmodus]{.maldense}), tio estas nur sur ununura
frekvenco (t.e. unu kanalo, en Germanujo nur kanaloj 24 aŭ 25). Oni
devas tajpi la nombron de la dezirata cifera ripetanto sur la klavaro de
komputoro.

*Modemo*
: Tiu vorto estas en la angla lingvo artefarita kunmetaĵo el
[modulator/demodulator]{.maldense}. Tio signifas, ke tiu ĉi elektronika
aparato transformadas ciferajn signalojn en aŭdeblajn tonojn en la
sendodirektadon kaj inverse en la direkton de sendinto. La jam menciita
TNC ankaŭ enhavas modemon.

*Konekti*
: "Konektu" ([connect]{.maldense}) estas ordono por esti
konektata kun alia PR-stacio. Oni devas ekzemple tajpi: "[connect
ESW028]{.maldense}" kaj poste premi la klavon [ENTER]{.maldense}. ESW028 estas en
tiu kazo ekzemplo de dezirata stacio. Se tiu ĉi stacio akceptas la
alvokon, ĝi sendas specialan *kvitancon* en la formo: "[connected to
ESW028]{.maldense}" (konektita al ESW028).  
La programon, kiu funkciigas la tutaĵon de PR, oni devas unue enkonduki
en la komputoron. Estas jam ellaboritaj diversaj programoj, preskaŭ ĉiuj
en la angla lingvo. Kiam la alkonektita adresato rifuzas la akcepton de
iu alvoko, tiam aperas ĉe la sendinto la informo "[busy]{.maldense}" (=
okupita). Kiam la alvokita PR-uzanto ne anoncas sin, tiam aperas sur la
ekrano la informo "[failure with ESW028]{.maldense}" kiu signifas
miskonekton kun ESW028.

*Poŝtkesto*
: ([mailbox]{.maldense} aŭ BBS = [Bulletin-board-system]{.maldense}
= pertabula informadsistemo) estas stacio de PR-radio en kiu neniu homo
tajpas sur la klavaron sed la komputoro laboras plene aŭtomatike. En la
poŝtkeston oni povas enskribi personajn informojn destinitajn por iu
alia uzanto, kies voknomon la sendinto unue entajpas en sian komputoron
por ke la kesto sciu, kien ĝi devas sendi la ricevitan informon. La
transsendado okazas kutime dumnokte, kiam ne regas vigla "trafiko" sur
la radioondoj.  
La poŝtkesta sistemo ebligas la forsendadon de informoj al aliaj, eĉ tre
foraj, PR-uzantoj kiuj estas registritaj en la "[mailbox]{.maldense}" de
ilia hejmloko en Germanujo aŭ eĉ en tuta Eŭropo. Por tre foraj stacioj en
Eŭropo oni uzas la telefonan reton pere de speciala modemo. Tio tamen
estas pagenda, kontraŭe al la senpaga PR surbende de kanaloj 24 kaj 25
en Germanujo.

*Monitoro*
: (el la angla: gardisto, inspektoro). Tiu ĉi modo servas por
observi la aktivecon de ĉiuj stacioj laborantaj sur la elektita
frekvenco. Oni povas kunlegi tion, kion skribas aliaj uzantoj aŭ kion
oni sendadas laŭ la jam menciita poŝtkesta sistemo, tiamaniere
eksciiĝante novaĵojn.

*Listo de aŭditaj stacioj*
: (angla mallongigo: MH - [my hearing]{.maldense}
= mia aŭdado). Kiam stacio estas konektita kun nodo (cifera ripetanto)
oni povas tajpi la ordonon [MH]{.maldense} kaj tuj aperas listo de stacioj kun
kiuj la nodo havis kontakton: la nodo kvazaŭ "aŭdis" ilin. Similan
eblecon havas kelkaj programoj uzataj de privataj stacioj ne funkciantaj
kiel nodoj.

## Kiel fariĝi uzanto de PR?

Se oni posedas jam komputoron oni bezonas nur aĉeti radiostacion kaj
konvenan modemon aŭ TNC kun programo sur diskedo. Eblas aĉeti
radiostacion kaj modemon kun diskeda programo jam por entute 170
Germanaj Markoj. Sed oni devas starigi ankaŭ konvenan antenon, kies
alteco dependas de la loĝloko kaj distanco de la plej proksima nodo.

## Resumo

La supre priskribita invento de *pakedoradio* povas servi kiel tre
efektiva rimedo por disvastigi Esperanton. La PR-stacio de la aŭtoro ĵus
nomiĝas "Esperanto". Sed preskaŭ ĉiu radio-interparolanto estas
konfesinta, ke li tute ne sciis kion tiu vorto signifas. Ili nun aŭdis
almenaŭ iom pri la Internacia Lingvo. Kiel licencigita radioamatoro
eblas fari PR tutmonde sur la bendoj 70 cm kaj 2 m. Jam estas 50
Esperantoparolantoj en Eŭropo, kiuj komunikadas inter si internacilingve
pere de pakedoradio sur la menciitaj ondolongoj. Pliajn detalojn de tiu
nova tutmonda rimedo de interkomunikiĝo la aŭtoro priskribos en aparta
artikolo.

## Fonto de la supraj informoj:

1.   BTX-gazeto de ESONOD kaj propraj spertoj
2.   Manlibro de TNC2C
3.   Manlibro de Radiostacio CV 2000
4.   Diskedo kun programoj de PR por la modemoj

