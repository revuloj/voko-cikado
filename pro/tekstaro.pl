user:file_search_path(tekstoj,'../txt').
user:file_search_path(esf,'../txt/tei_esf/tekstoj').
user:file_search_path(verkoj,'../txt/tei2').
user:file_search_path(cfg,'../cfg').

:- dynamic bib/4.

% referencoj de verko-identigiloj al la bibliografio de ReVo...
% Se la Verko-Id estas samlitera kiel la biblografia @mll, ne necesas
% aparta referenco tie ĉi, ekz-e: bib(prv,'PrV').
bib(bmt,'MT').
bib(bnt,'NT').
bib(d_l,'DL').
bib(e_e,'EE').
bib(mar,'Marta').
bib(d_l,'DL').
bib(f_e,'F').
bib(f_k,'FK').
bib(hml,'Hamlet').
bib(ifi,'Ifigenio').
bib(ika,'IK').
bib(ito,'InfanTorent2').
bib(kis,'Kiso').
bib(knd,'Kandid').
bib(lst,'Lasta').
bib(lbl,'BonaLingvo').
bib(msh,'MortulŜip').
bib(mtp,'Metrop').
bib(par,'Paroloj').
bib(p_i,'Iŝtar').
bib(pkp,'PatrojFiloj').
bib(rab,'Rabistoj').
bib(rvz,'Revizoro').
bib(spj,'SkandalJozef').
bib(sra,'SatirRak').

%bib(lr,'LR').
bib(vzm,'VivZam').


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% klasikaj tekstoj de Zamnenhof, Kabe, Ŝvarc kc - ĝis 1939
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

vrk(prv,proverbaro,1910,
    struct_teix(preface,chapter),
    verkoj('proverb.xml')).
vrk(bmt,biblio_malnova,1916,
    struct_biblio,
    tekstoj('biblio/malnova/*.utf')).
vrk(bnt,biblio_nova,1916,
    struct_biblio,
    tekstoj('biblio/nova/*.utf')).
vrk(fba,fabeloj,1926, %+/26/32/63
    struct_teix(foreword,story),
    verkoj('fabeloj?.xml')).
vrk(far,faraono,1926,
    struct_teix(chapter),
    verkoj('faraono?.xml')).
vrk(f_e,fundamento,1905,
    struct_fundamento,
    verkoj('fundamento.xml')).
vrk(grf,gfabeloj,1906,
    struct_teix(foreword,story),
    verkoj('gfabeloj.xml')).
vrk(knd,kandid,1929,
    struct_teix(chapter),
    verkoj('kandid.xml')).
vrk(lst,lasta,1910,
    struct_teix(story),
    verkoj('lasta.xml')).
vrk(ika,interompita,1928,
    struct_teix(chapter),
    verkoj('interrompita.xml')).
vrk(e_e,esenco,1907,
    struct_teix(chapter),
    verkoj('esenco.xml')).
vrk(hom,homaranismo,1906,
    struct_paroloj,
    verkoj('homaranismo.xml')).
vrk(fdo,opiofumejo,1908,
    struct_teix(novel),
    verkoj('fumejo.xml')).
vrk(par,paroloj,1904, %..-1913
    struct_paroloj,
    verkoj('paroloj.xml')).
vrk(poz,poemoj,1904,
    struct_teix(poem),
    verkoj('poemoj.xml')).
vrk(lsb,butiko,1931,
    struct_teix(foreword,poem),
    verkoj('butiko.xml')).
vrk(mar,marta,1910,
    struct_marta,
    verkoj('marta.xml')).
vrk(rvz,revizoro,1907,
    struct_teix(act),
    verkoj('revizoro.xml')).
vrk(rab,rabistoj,1908,
    struct_teix(act),
    verkoj('rabistoj.xml')).

vrk(bdv,batalo,1891,
    struct_gutenberg,
    tekstoj('gutenberg/Batalo_de_Vivo.html')).
vrk(chl,chu_li,1908,
    struct_tei(chapitro,postparolo),
    esf('chu-li.xml')).

vrk(d_l,dualibro,1888,
    struct_gutenberg,
    tekstoj('gutenberg/Dua_Libro.html')).

vrk(dkm,don_kihhoto,1909,
    struct_tei(antauparolo,chapitro),
    esf('don-kihhoto-de-la-mancho-en-barcelono.xml')).

vrk(f_k,krestomatio,1904,
    struct_gutenberg,
    tekstoj('gutenberg/Krestomatio.html')).


% ne enestas <div>, sed nur body/p
%vrk(gli,gentoj_lingvo,1911,
%    struct_tei(parto),
%    esf('gentoj-kaj-lingvo-internacia.xml')).

vrk(gdn,georgo_dandin,1908,
    struct_tei(akto),
    esf('georgo-dandin.xml')).

%vrk(d_l,dualibro,
%    struct_tei,
%    esf('dua-libro.xml')).
%vrk(f_k,krestomatio,
%    struct_tei(parto),
%    esf('fundamenta-krestomatio.xml')).
vrk(hml,hamleto,1893,
    struct_gutenberg,
    tekstoj('gutenberg/Hamleto.html')).

vrk(hst,homoj_tero,1932,
    struct_tei(parto),
    esf('homoj-sur-la-tero.xml')).

vrk(ito,infanoj_torento,1934,
    struct_tei(parto),
    esf('infanoj-en-torento.xml')).

vrk(ikr,internacia_krestomatio,1907,
    struct_tei(parto),
    esf('internacia-krestomatio.xml')).

vrk(kpr,kastelo_prelongo,1907,
    struct_tei(antauparolo,chapitro),
    esf('kastelo-de-prelongo.xml')).
vrk(kzg,kion_zamenhof,1906,
    struct_tei(artikolo),
    esf('kion-zamenhof-ne-povis-diri-en-ghenevo.xml')).

vrk(ifi,ifigenio,1908,
    struct_gutenberg,
    tekstoj('gutenberg/Ifigenio.html')).
vrk(lrz,lingvaj_respondoj,1889, %..-1913
    struct_tei(chapitro),
    esf('lingvaj-respondoj.xml')).

vrk(vzm,vivozamenhof,1920,
    struct_gutenberg,
    tekstoj('gutenberg/Vivo_de_Zamenhof.html')).

vrk(kkl,kompatinda_klem,1931,
    struct_tei(chapitro),
    esf('kompatinda-klem.xml')).

vrk(vch,vivo_chukchoj,1933,
    struct_tei(chapitro),
    esf('el-vivo-de-chukchoj.xml')).

% div sen @type
%vrk(gmn,gimnazio,1909,
%    struct_tei(chapitro),
%    esf('la-gimnazio.xml')).

vrk(rba,rabeno,1909,
    struct_tei(chapitro),
    esf('la-rabeno-de-bahharahh.xml')).

vrk(lga,granda_aventuro,1931, %..1945,
    struct_tei(chapitro),
    esf('la-granda-aventuro.xml')).

vrk(mtp,metropoliteno,1933,
    struct_tei(chapitro),
    esf('metropoliteno.xml')).

vrk(lbe,letero_beaufront,1906,
    struct_tei(artikolo),
    esf('nefermita-letero-al-beaufront.xml')).

vrk(pkp,patroj_filoj,1909,
    struct_tei(chapitro),
    esf('patroj-kaj-filoj.xml')).

% div snd @type
%vrk(pgm,post_milito,1914,
%    struct_tei(chapitro),
%    esf('post-la-granda-milito.xml')).

vrk(p_i,pro_ishtar,1924,
    struct_tei(chapitro),
    esf('pro-ishtar.xml')).


% tro da neesperantaĵoj?:
%vrk(res,reformoj,1907,
%    struct_teix(artikolo),
%    verkoj('reformoj-esperanto.xml')).
vrk(ret,retoriko,1894,
    struct_tei(dedicho,rimarko,parto),
    esf('retoriko.xml')).

vrk(rob,robinsono,1908,
    struct_tei(enkonduko,parto),
    esf('robinsono-kruso.xml')).

vrk(tor,al_torento,1930,
    struct_tei(chapitro),
    esf('al-torento.xml')).

vrk(taa,tri_angloj,1936,
    struct_tei(chapitro),
    esf('tri-angloj-alilande.xml')).

vrk(voj,vojaghimpresoj,1895, %(re 2003)
    struct_tei(enkonduko,chapitro),
    esf('vojaghimpresoj.xml')).

vrk(vak,vojagho_kazohinio,1938,
    struct_tei(chapitro),
    esf('vojagho-al-kazohinio.xml')).

% div sen @type
%vrk(vdl,vortoj_lanti,1920, %..1929
%    struct_teix(chapitro),
%    verkoj('vortoj-de-lanti.xml')).

vrk(zam,zamenhof,1929,
    struct_tei(chapitro),
    esf('zamenhof.xml')).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% postaj tekstoj (ekde 1940)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


vrk(chb,chu_bremsis,1978,
    struct_tei(chapitro),
    esf('chu-li-bremsis-sufiche.xml')).
vrk(chv,chu_trakosme,1980,
    struct_tei(chapitro),
    esf('chu-li-venis-trakosme.xml')).
vrk(ckv,chu_kunvenis,1982,
    struct_tei(chapitro),
    esf('chu-ni-kunvenis-vane.xml')).

vrk(chr,chu_rakonti,1986,
    struct_tei(novelo),
    esf('chu-rakonti-novele.xml')).

vrk(chm,chu_mortu,1982,
    struct_tei(chapitro),
    esf('chu-shi-mortu-trafike.xml')).
vrk(ckc,chu_chine,1976,
    struct_tei(chapitro),
    esf('chu-vi-kuiras-chine.xml')).

vrk(eep,perspektivo,1974,
    struct_tei(parto),
    esf('esperanto-en-perspektivo.xml')).

vrk(fsi,fajron_sentas,1990,
    struct_tei(antauparolo,chapitro),
    esf('fajron-sentas-mi-interne.xml')).

vrk(fsp,federala_sperto,1958,
    struct_tei(parto),
    esf('federala-sperto.xml')).

vrk(grd,gerda_malaperis,1983,
    struct_tei(chapitro),
    esf('gerda-malaperis.xml')).

% ne enestas <div>, sed nur body/p
%vrk(ghr,ghis_revido,1996,
%    struct_tei(parto),
%    esf('ghis-revido-krokodilido.xml')).

% ne enestas <div>, sed nur body/p
%vrk(hms,hitler_mau,1996,
%    struct_tei(chapitro),
%    esf('hitler-mau-strindberg-kaj-mi.xml')).


vrk(kfl,kien_fluas,1984, %..-87
    struct_tei(chapitro),
    esf('kien-fluas-roj-castalie.xml')).


vrk(kkr,koko_krias,1943, %..1954
    struct_tei(parto),
    esf('koko-krias-jam.xml')).

vrk(kon,kontakto,2011, %..-2019
    struct_tei(artikolo),
    esf('kontakto-2011-2019.xml')).

vrk(krm,kredu_min,1949,
    struct_tei(chapitro),
    esf('kredu-min-sinjorino.xml')).

vrk(krb,kruko_baniko,1970,
    struct_tei(ero),
    esf('kruko-kaj-baniko.xml')).

vrk(mkm,majstro_margarita,1991,
    struct_tei(chapitro),
    esf('la-majstro-kaj-margarita.xml')).
   
vrk(spj,skandalo_jozefo,1981,
    struct_tei(antauparolo,chapitro,klarigo,postparolo),
    esf('la-skandalo-pro-jozefo.xml')).
 
vrk(lbl,bona_lingvo,1989,
    struct_tei(chapitro),
    esf('la-bona-lingvo.xml')).
   
vrk(mma,majstro_martinelli,1993,
    struct_tei(chapitro,notico,epilogo),
    esf('la-majstro-kaj-martinelli.xml')).
   
vrk(rsp,respubliko,1993,
    struct_tei(antauparolo,enkonduko,parto),
    esf('la-respubliko.xml')).
   
vrk(sol,soleno,2003,
    struct_tei(rakonto),
    esf('la-soleno.xml')).
 
vrk(kis,kiso,1995,
    struct_tei(antauparolo,novelo,notoj),
    esf('la-kiso.xml')).

% div sen @type
%vrk(mpe,mia_penso,1957,
%    struct_tei(chapitro),
%    esf('mia-penso.xml')).

vrk(msh,mortula_shipo,1995,
    struct_tei(chapitro),
    esf('mortula-shipo.xml')).

vrk(lpl,letero_pluamikoj,1984,
    struct_tei(enkonduko,chapitro),
    esf('ne-nur-leteroj-de-plumamikoj.xml')).

% div snd @type
%vrk(efi,efika_informado,1974,
%    struct_tei(chapitro),
%    esf('por-pli-efika-informado.xml')).


vrk(sra,satiraj_rakontoj,1950, %..1969
    struct_tei(rakonto),
    esf('satiraj-rakontoj.xml')).

vrk(scr,senchesa,1997,
    struct_teix(chapter),
    verkoj('senchesa*.xml')). % per la * ignoriĝas, se mankas!

vrk(tki,tokio_invitas,1963,
    struct_tei(artikolo),
    esf('tokio-invitas-vin.xml')).

vrk(vra,vespera_rugho,1950,
    struct_tei(novelo),
    esf('vespera-rugho-anoncas-ventegon.xml')).

vrk(viv,vivo_vokas,1946,
    struct_tei(chapitro),
    esf('vivo-vokas.xml')).

vrk(md1,mondediplo1,2002,
    struct_tei(artikolo),
    esf('mondediplo-2002.xml')).

vrk(md2,mondediplo2,2005,
    struct_tei(artikolo),
    esf('mondediplo-2005.xml')).
  
vrk(md3,mondediplo3,2008,
    struct_tei(artikolo),
    esf('mondediplo-2008.xml')).

vrk(md4,mondediplo4,2011,
    struct_tei(artikolo),
    esf('mondediplo-2011.xml')).
  
vrk(md5,mondediplo5,2014,
    struct_tei(artikolo),
    esf('mondediplo-2014.xml')).
     
vrk(md6,mondediplo6,2017,
    struct_tei(artikolo),
    esf('mondediplo-2017.xml')).

vrk(mo1,monato_1,1993, %..-1995
    struct_monato_txt,
    tekstoj('monato/*.txt')).
vrk(mo2,monato_2,1999, %..-2001
    struct_monato2_html,
    tekstoj('monato2/html/*.html')).
vrk(mo3,monato_3,2003, %..-2015
    struct_monato3_html,
    tekstoj('monato3/*/0*.*')).

vrk(ode,ondo_esperanto,2001, %..2004
    struct_tei(gazeto),
    esf('ondo-de-esperanto.xml')).



%verkaro(klasikaj,[pv,mt,nt,fb,gf,fr,fe,ee,ik,hm,pa,po,bu,ma,ha,ba,op,rv,ra,vz,if,lr,fk,dl]).
verkaro(klasikaj,Verkoj) :- findall(V,(vrk(V,_,Jaro,_,_),Jaro<1940),Verkoj).
verkaro(postaj,Verkoj) :- findall(V,(vrk(V,_,Jaro,_,_),Jaro>=1940),Verkoj).
verkaro(chiuj,Verkoj) :- findall(V,vrk(V,_,_,_,_),Verkoj).

verko_listo:- 
    bagof(V-J-T,X^Y^vrk(V,T,J,X,Y),Vj),
    sort(Vj,SVj),
    forall(
        member(Vrk-Jar-Tit,SVj),
        format('[~w-~d] ~w~n',[Vrk,Jar,Tit])
    ).
