user:file_search_path(tekstoj,'../txt').
user:file_search_path(esf,'../txt/tei_esf/tekstoj').
user:file_search_path(verkoj,'../txt/tei2').

bib(pv,'PrV').
bib(ee,'EE').
bib(ma,'Marta').
bib(ba,'BdV').
bib(dl,'DL').
bib(fk,'FK').
bib(op,'FdO').
bib(ha,'Hamlet').
bib(if,'Ifigenio').
bib(ik,'IK').
%bib(lr,'LR').
bib(vz,'VivZam').
   
% klasikaj tekstoj de Zamnenhof, Kabe, Ŝvarc
vrk(pv,proverbaro,
    struct_teix(preface,chapter),
    verkoj('proverb.xml')).
vrk(mt,biblio_malnova,
    struct_biblio,
    tekstoj('biblio/malnova/*.utf')).
vrk(nt,biblio_nova,
    struct_biblio,
    tekstoj('biblio/nova/*.utf')).
vrk(fb,fabeloj,
    struct_teix(foreword,story),
    verkoj('fabeloj?.xml')).
vrk(fr,faraono,
    struct_teix(chapter),
    verkoj('faraono?.xml')).
vrk(fe,fundamento,
    struct_fundamento,
    verkoj('fundamento.xml')).
vrk(gf,gfabeloj,
    struct_teix(foreword,story),
    verkoj('gfabeloj.xml')).
vrk(ik,interompita,
    struct_teix(chapter),
    verkoj('interrompita.xml')).
vrk(ee,esenco,
    struct_teix(chapter),
    verkoj('esenco.xml')).
vrk(hm,homaranismo,
    struct_paroloj,
    verkoj('homaranismo.xml')).
vrk(op,opiofumejo,
    struct_teix(novel),
    verkoj('fumejo.xml')).
vrk(pa,paroloj,
    struct_paroloj,
    verkoj('paroloj.xml')).
vrk(po,poemoj,
    struct_teix(poem),
    verkoj('poemoj.xml')).
vrk(bu,butiko,
    struct_teix(foreword,poem),
    verkoj('butiko.xml')).
vrk(ma,marta,
    struct_marta,
    verkoj('marta.xml')).
vrk(rv,revizoro,
    struct_teix(act),
    verkoj('revizoro.xml')).
vrk(ra,rabistoj,
    struct_teix(act),
    verkoj('rabistoj.xml')).

vrk(ba,batalo,
    struct_gutenberg,
    tekstoj('gutenberg/Batalo_de_Vivo.html')).
vrk(dl,dualibro,
    struct_gutenberg,
    tekstoj('gutenberg/Dua_Libro.html')).
vrk(fk,krestomatio,
    struct_gutenberg,
    tekstoj('gutenberg/Krestomatio.html')).
%vrk(dl,dualibro,
%    struct_tei,
%    esf('dua-libro.xml')).
%vrk(fk,krestomatio,
%    struct_tei(parto),
%    esf('fundamenta-krestomatio.xml')).
vrk(ha,hamleto,
    struct_gutenberg,
    tekstoj('gutenberg/Hamleto.html')).
vrk(if,ifigenio,
    struct_gutenberg,
    tekstoj('gutenberg/Ifigenio.html')).
vrk(lr,lingvaj_respondoj,
    struct_tei(parto),
    esf('lingvaj-respondoj.xml')).
vrk(vz,vivozamenhof,
    struct_gutenberg,
    tekstoj('gutenberg/Vivo_de_Zamenhof.html')).
vrk(vc,vivo_chukchoj,
    struct_tei(chapitro),
    esf('el-vivo-de-chukchoj.xml')).

% postaj tekstoj
vrk(to,al_torento,
    struct_tei(chapitro),
    esf('al-torento.xml')).

vrk(cb,chu_bremsis,
    struct_tei(chapitro),
    esf('chu-li-bremsis-sufiche.xml')).
vrk(cv,chu_venis,
    struct_tei(chapitro),
    esf('chu-li-venis-trakosme.xml')).
vrk(cl,chu_li,
    struct_tei(chapitro),
    esf('chu-li.xml')).
vrk(ck,chu_kunvenis,
    struct_tei(chapitro),
    esf('chu-ni-kunvenis-vane.xml')).

vrk(cr,chu_rakonto,
    struct_tei(novelo),
    esf('chu-rakonti-novele.xml')).

vrk(cm,chu_kmortu,
    struct_tei(chapitro),
    esf('chu-shi-mortu-trafike.xml')).
vrk(cc,chu_chine,
    struct_tei(chapitro),
    esf('chu-vi-kuiras-chine.xml')).

vrk(ep,perspektivo,
    struct_tei(parto),
    esf('esperanto-en-perspektivo.xml')).

vrk(fi,fajron_sentas,
    struct_tei(chapitro),
    esf('fajron-sentas-mi-interne.xml')).

vrk(fs,federala_sperto,
    struct_tei(parto),
    esf('federala-sperto.xml')).


vrk(m1,monato_1,
    struct_monato_txt,
    tekstoj('monato/*.txt')).
vrk(m2,monato_2,
    struct_monato2_html,
    tekstoj('monato2/html/*.html')).
vrk(m3,monato_3,
    struct_monato3_html,
    tekstoj('monato3/*/0*.*')).

vrk(sr,senchesa,
    struct_teix(chapter),
    verkoj('senchesa*.xml')). % per la * ignoriĝas, se mankas!

verkaro(klasikaj,[pv,mt,nt,fb,gf,fr,fe,ee,ik,hm,pa,po,bu,ma,ha,ba,op,rv,ra,vz,if,lr,fk,dl]).
verkaro(postaj,[m1,m2,m3,sr]).
verkaro(chiuj,Verkoj) :- findall(V,vrk(V,_,_,_),Verkoj).
