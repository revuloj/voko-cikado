user:file_search_path(tekstoj,'../txt').
user:file_search_path(esf,'../txt/tei_esf/tekstoj').
user:file_search_path(verkoj,'../txt/tei2').
user:file_search_path(ekstraj,'../ekstraj').
user:file_search_path(cfg,'../cfg').

:- dynamic bib/4.

%! bib(?Id,?Bib) is nondet
%
% Asocio inter la verk-indiko kaj la bibliografia indiko (@mll).
% vd [bibliografio.xml](https://github.com/revuloj/revo-fonto/blob/master/cfg/bibliogr.xml).
% Tio funkcias aŭtomate se ambaŭ minuskligite egalas.
% Aliokaze la rilaton ni registras per aparta fakto.

bib(m_t,'MT').
bib(n_t,'NT').
bib(d_l,'DL').
bib(e_e,'EE').
bib(hom,'Homaranismo').
bib(mrt,'Marta').
bib(d_l,'DL').
bib(f_e,'F').
bib(f_k,'FK').
bib(fb1,'Fab1').
bib(fb2,'Fab2').
bib(fb3,'Fab3').
bib(fb4,'Fab4').
bib(fbg,'ElektFab').
bib(fr1,'Far1').
bib(fr2,'Far2').
bib(fr3,'Far3').
bib(grd,'Gerda').
bib(hml,'Hamlet').
bib(ifi,'Ifigenio').
bib(ika,'IK').
bib(ito,'InfanTorent2').
bib(kis,'Kiso').
bib(kon,'Kon11').
bib(knd,'Kandid').
bib(lst,'Lasta').
bib(lbl,'BonaLingvo').
bib(lpl,'Plumamikoj').
bib(lrz,'LR').
bib(msh,'MortulŜip').
bib(mtp,'Metrop').
bib(par,'Paroloj').
bib(ode,'LOdE').
bib(p_i,'Iŝtar').
bib(pkp,'PatrojFiloj').
bib(rab,'Rabistoj').
bib(rvz,'Revizoro').
bib(spj,'SkandalJozef').
bib(sra,'SatirRak').
bib(vch,'Ĉukĉoj').
bib(voj,'VojaĝImp').
bib(vzm,'VivZam').


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% klasikaj tekstoj de Zamnenhof, Kabe, Ŝvarc kc - ĝis 1939
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%! vrk(?Id,?Nomo,?Jaro,-Strukturo,-Dosierskemo) is nondet
%
% Tiu predikato priskribas registritan verkon kun sia mallongigo, nomo,
% aperjaro, strukturo kaj dosierskemo.
% La mallongigo Id kaj la nomo devas esti unikaj.
% La strukturo indikas kiel la programo devas legi kaj disanalizi
% la fontotekston, ekz-e struct_teix(foreword,story) indikas,
% ke la fonto estas XML-teksto laŭ dokumenttipo TEI-Lite kaj
% la sekcioj estas rekoneblaj per =|@type=forword|= kaj =|@stype=story|=.
% Fine la dosierskemo indikas la dosierujon kaj la skemon por trovi la
% la fontodosierojn en la disko, ekz-e verkoj('fabeloj?.xml') trovas
% la dosierojn =|fabeloj1.xml|=, =|fabeloj2.xml|= ktp. en la dosierujo, kiun ni
% registris sub la nomo verkoj.
vrk(prv,proverbaro,1910,
    struct_teix(preface,chapter),
    verkoj('proverb.xml')).
vrk(m_t,biblio_malnova,1916,
    struct_biblio,
    tekstoj('biblio/malnova/*.utf')).
vrk(n_t,biblio_nova,1916,
    struct_biblio,
    tekstoj('biblio/nova/*.utf')).
vrk(fb1,fabeloj1,1926, 
    struct_teix(foreword,story),
    verkoj('fabeloj1.xml')).
vrk(fb2,fabeloj2,1926, 
    struct_teix(foreword,story),
    verkoj('fabeloj2.xml')).
vrk(fb3,fabeloj3,1932, 
    struct_teix(foreword,story),
    verkoj('fabeloj3.xml')).
vrk(fb4,fabeloj4,1963, 
    struct_teix(foreword,story),
    verkoj('fabeloj4.xml')).
vrk(fr1,faraono1,1927,
    struct_teix(chapter),
    verkoj('faraono1.xml')).
vrk(fr2,faraono2,1926,
    struct_teix(chapter),
    verkoj('faraono2.xml')).
vrk(fr3,faraono3,1926,
    struct_teix(chapter),
    verkoj('faraono3.xml')).
vrk(pgm,post_milito,1922,
    struct_tei(chapter),
    esf('post-la-granda-milito.xml')).
vrk(f_e,fundamento,1905,
    struct_fundamento,
    verkoj('fundamento.xml')).
vrk(fbg,gfabeloj,1906,
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
vrk(poe,poemoj,1904,
    struct_teix(poem),
    verkoj('poemoj.xml')).
vrk(lsb,butiko,1931,
    struct_teix(foreword,poem),
    verkoj('butiko.xml')).
vrk(mrt,marta,1910,
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

vrk(ido,idoj_orfeo,1923,
    struct_tei(antauparolo,parto),
    esf('idoj-de-orfeo.xml')).

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

vrk(mra,mirinda_amo,1913,
    struct_tei(chapitro),
    esf('mirinda-amo.xml')).

vrk(kkl,kompatinda_klem,1931,
    struct_tei(chapitro),
    esf('kompatinda-klem.xml')).


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

vrk(quv,quo_vadis,1933,
    struct_tei(chapitro),
    esf('quo-vadis.xml')).

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

vrk(srt,sro_tadeo,1918,    
    struct_tei(antauparolo,chapitro),
    esf('sinjoro-tadeo.xml')).

vrk(tor,al_torento,1930,
    struct_tei(chapitro),
    esf('al-torento.xml')).

vrk(taa,tri_angloj,1936,
    struct_tei(chapitro),
    esf('tri-angloj-alilande.xml')).

vrk(vch,vivo_chukchoj,1933,
    struct_tei(chapitro),
    esf('el-vivo-de-chukchoj.xml')).

vrk(vzm,vivozamenhof,1920,
    struct_gutenberg,
    tekstoj('gutenberg/Vivo_de_Zamenhof.html')).    

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
vrk(chc,chu_chine,1976,
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
    ekstraj('senchesa*.xml')). % per la * ignoriĝas, se mankas!

vrk(tki,tokio_invitas,1963,
    struct_tei(artikolo),
    esf('tokio-invitas-vin.xml')).

vrk(vra,vespera_rugho,1950,
    struct_tei(novelo),
    esf('vespera-rugho-anoncas-ventegon.xml')).

vrk(viv,vivo_vokas,1946,
    struct_tei(chapitro),
    esf('vivo-vokas.xml')).

vrk(lae,lingvistikaj_aspektoj,1978,    
    struct_tei(antauparolo,chapitro),
    esf('lingvistikaj-aspektoj.xml')).

vrk(oip,ombro_interna,1984,    
    struct_tei(antauparolo,precipa,postparolo),
    esf('ombro-sur-interna-pejzagho.xml')).

vrk(stu,shtona_urbo,1999,    
    struct_tei(antauparolo,parto),
    esf('la-shtona-urbo.xml')).

vrk(mja,memorajhoj_agripina,2021,    
    struct_tei(parto),
    esf('la-memorajhoj-de-julia-agripina.xml')).
    

/* kvalito nur subaveraĝa...:
vrk(md02,mondediplo1,2002,
    struct_tei(artikolo),
    esf('mondediplo-2002.xml')).

vrk(md05,mondediplo2,2005,
    struct_tei(artikolo),
    esf('mondediplo-2005.xml')).
  
vrk(md08,mondediplo3,2008,
    struct_tei(artikolo),
    esf('mondediplo-2008.xml')).

vrk(md11,mondediplo4,2011,
    struct_tei(artikolo),
    esf('mondediplo-2011.xml')).
  
vrk(md14,mondediplo5,2014,
    struct_tei(artikolo),
    esf('mondediplo-2014.xml')).
     
vrk(md17,mondediplo6,2017,
    struct_tei(artikolo),
    esf('mondediplo-2017.xml')).
*/

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



%! verkaro(?Verkaro,-Listo) is nondet
%
% Tiu predikato redonas iun el pluraj antaŭdifinitaj verkolistojj, kiujn oni povas traserĉi samtempe.
% Momente estas difinitaj =klasikaj= por verkoj aperintaj ĝis la 2a mondmilito,
% =postaj= por tiuj, aperintaj post la 2a mondmilito kaj =chiuj=.

%verkaro(klasikaj,[pv,mt,nt,fb,gf,fr,fe,ee,ik,hm,pa,po,bu,ma,ha,ba,op,rv,ra,vz,if,lr,fk,dl]).
verkaro(klasikaj,Verkoj) :- findall(V,(vrk(V,_,Jaro,_,_),Jaro<1940),Verkoj).
verkaro(postaj,Verkoj) :- findall(V,(vrk(V,_,Jaro,_,_),Jaro>=1940),Verkoj).
verkaro(chiuj,Verkoj) :- findall(V,vrk(V,_,_,_,_),Verkoj).
verkaro(De-Ghis,Verkoj) :- findall(V,(vrk(V,_,Jaro,_,_),Jaro>=De,Jaro=<Ghis),Verkoj).

verko_listo:- 
    bagof(V-J-T,X^Y^vrk(V,T,J,X,Y),Vj),
    sort(Vj,SVj),
    forall(
        member(Vrk-Jar-Tit,SVj),
        format('[~w-~d] ~w~n',[Vrk,Jar,Tit])
    ).
