/* -*- Mode: Prolog -*- */
:- module(tekstaro,[
	      verkaro/2,
	      read_all_vrk/0,
	      read_vrk/1,
	      save_vrk/1,
	      cit_to_ekzj/2
	  ]).
    
:- use_module(library(dcg/basics)).
:- use_module(library(sgml)).
:- use_module(library(xpath)).
%:- use_module(agordo).

:- dynamic txt/3, cit/3, aut/3, vrk/4, bib/2.

:- consult(tekstaro).

:- encoding(utf8).

:- debug(tekstaro(vrk)).
%:- debug(tekstaro(dos)).
%:- debug(tekstaro(chap)).
%%:- debug(tekstaro(txt)).

% vrk(mt,...)
% txt(mt:1,'Genezo','biblio/malnova/01biblio.gen.utf')
% cit(mt:1,3:14,'Kaj Dio la Eternulo diris al la..').
% aut(m2:1,'Funebro sen dio','Anna Loewenstein').

%:- initialization(agordo).
:- initialization(read_all_vrk).

teixdtd(verkoj('teixlite.dtd')).

%user:file_search_path(tekstoj,'/home/revo/citajhoj/tekstoj').
%user:file_search_path(verkoj,'/home/revo/verkoj/xml').

read_all_vrk :-
    retractall(cit(_,_,_)),
    retractall(txt(_,_,_)),
    retractall(aut(_,_,_)),
    \+ (
	vrk(Vrk,_,_,_),
	read_vrk(Vrk),
	fail
    ).

read_vrk(Vrk) :-
    (atom(Vrk) -> forget(Vrk); true),
    vrk(Vrk,Desc,Struct,PathSpec),
    % debug(tekstaro(vrk),'[~q] ~q',[Vrk,Desc]),
    expand_file_search_path(PathSpec,Pattern),
    %  atomic_list_concat([Rad,'/',Path,'/*.',Fin],'',Pattern),
    debug(tekstaro(vrk),'[~q] (~q) ~q',[Vrk,Desc,Pattern]),
    expand_file_name(Pattern,Files),
    read_vrk_files(Vrk,Struct,Files,1),
    !.

read_vrk_files(Vrk,Struct,[File|More],No) :-
    debug(tekstaro(dos),'[~q.~d] ~q',[Vrk,No,File]),
    % analizu la tekston
    Struct =.. [Pred|Dividoj],
    call(Pred,Vrk:No,_Titolo,File,Dividoj),
    % assert(txt(Vrk:No,Titolo,File)),
    % legu pliaj dosierojn de la verko
    No_1 is No+1,
    read_vrk_files(Vrk,Struct,More,No_1).
read_vrk_files(_,_,[],_).

forget(Vrk) :-
    retractall(tekstaro:cit(Vrk:_,_,_)),
    retractall(tekstaro:txt(Vrk:_,_,_)),
    retractall(tekstaro:aut(Vrk:_,_,_)).

save_vrk(Out,V) :-
  forall(
    cit(V:A,B,C),
    format(Out,'cit(~k:~k,~k,~k).~n',[V,A,B,C])
      ).

save_vrk(V) :-
    atom_concat(V,'.pl',File),
    setup_call_cleanup(
	    open(File,write,Out),
	    save_vrk(Out,V),
	    close(Out)
	).

% La Biblio
struct_biblio(Vrk:No,Titolo,File,_) :-
    read_file_to_codes(File,Codes,[encoding(utf8)]),
    phrase(biblio_teksto(Vrk:No,Titolo),Codes),
    assert(txt(Vrk:No,Titolo,File)).

% Teix-tekstoj, Dividoj donas la ĉapitrojn por referenci trovaĵojn
struct_teix(Vrk:No,Titolo,File,Dividoj) :-
    teix_teksto(Vrk:No,Titolo,File,Dividoj).

struct_teix_nevalida(Vrk:No,Titolo,File,Dividoj) :- !,
   teix1_teksto(Vrk:No,Titolo,File,Dividoj).


% La Fundamento de Eo - limigu al Antaŭparolo kaj Ekzercaro
struct_fundamento(Vrk:No,Titolo,File,_) :- !,
   fundamento_teksto(Vrk:No,Titolo,File).

% Marta
struct_marta(Vrk:No,Titolo,File,_) :- !,
   marta_teksto(Vrk:No,Titolo,File).

% Verkoj el Gutenberg-projekto
struct_gutenberg(Vrk:No,Titolo,File,_) :- 
    guten_teksto(Vrk:No,Titolo,File).


% Paroloj de Zamenhof, Homaranismo
struct_paroloj(Vrk:No,Titolo,File,_) :- !,
   paroloj_tekstoj(Vrk:No,Titolo,File).

% Monato 1
struct_monato_txt(Vrk:No,Titolo,File,_) :- !,
    read_file_to_codes(File,Codes,[]),
    phrase(monato_teksto(Vrk:No,Titolo),Codes),
    assert(txt(Vrk:No,Titolo,File)),
    debug(tekstaro(txt),'~q',[Titolo]).

% Monato 2, 3
struct_monato_html(Vrk:No,Titolo,File,_) :- !,
    monato2_html(Vrk:No,Titolo,File).

%verko_teksto(_,'','').



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% predikatoj por analizi TEIXLITE-tekstojn al txt- kaj cit-faktoj
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

teix_teksto(Vrk:No,Titolo,File,DivTypes) :-
    teixdtd(DTDPathSpec),
    expand_file_search_path(DTDPathSpec,DTDFile),
    new_dtd('TEI.2',DTD),
    load_dtd(DTD,DTDFile,[dialect(xml)]),
    load_xml(File,DOM,[dtd(DTD)]),
    teixlite_teksto(Vrk:No,DOM,DivTypes,Titolo),
    assert(txt(Vrk:No,Titolo,File)).

teix1_teksto(Vrk:No,Titolo,File,DivTypes) :-
%    teixdtd(DTDPathSpec),
%    expand_file_search_path(DTDPathSpec,DTDFile),
%    new_dtd('TEI.2',DTD),
%    load_dtd(DTD,DTDFile,[dialect(xml)]),
    load_xml(File,DOM,[]),
    tei1lite_teksto(Vrk:No,DOM,DivTypes,Titolo),
    assert(txt(Vrk:No,Titolo,File)).


/**
% ignoru pi(..)  en [pi(...),element(TEI.2..)]
fabelo_teksto(fb:No,[_,DOM],Titolo) :-
    teixlite_teksto(fb:No,[_,DOM],story,Titolo).

faraono_teksto(fr:No,[_,DOM],Titolo) :-
    teixlite_teksto(fr:No,[_,DOM],chapter,Titolo).
***/

fundamento_teksto(Dos,Titolo,File) :-
    teixdtd(DTDPathSpec),
    expand_file_search_path(DTDPathSpec,DTDFile),
    new_dtd('TEI.2',DTD),
    load_dtd(DTD,DTDFile,[dialect(xml)]),
    load_xml(File,[_,DOM],[dtd(DTD)]), % [_,DOM] ignoru pi(..)  en [pi(...),element(TEI.2..)]
    xpath(DOM,/'TEI.2',Root),
    xpath(Root,teiHeader/fileDesc/titleStmt/title(normalize_space),Titolo),!,
    assert(txt(Dos,Titolo,File)),
    \+ (
	xpath(Root,//(div(@type=Type,@id=_)),Div),
	memberchk(Type,[part,section]),
	once((
	    Type=section,
	    xpath(Div,/(div(@n=N)),_),
	    format(atom(SekcioTitolo),'&FE; ~w',[N])
	    ;
	    xpath(Div,/(div)/head(normalize_space),SekcioTitolo)
	)),
	debug(tekstaro(chap),'~q',[SekcioTitolo]),
%%	format('~n~q:~n',[SekcioTitolo]),
	teixlite_div(Dos,SekcioTitolo,Div),
	fail
    ).


paroloj_tekstoj(Dos,Titolo,File) :-
    teixdtd(DTDPathSpec),
    expand_file_search_path(DTDPathSpec,DTDFile),
    new_dtd('TEI.2',DTD),
    load_dtd(DTD,DTDFile,[dialect(xml)]),
    load_xml(File,[DOM],[dtd(DTD)]),
    xpath(DOM,/'TEI.2',Root),
    xpath(Root,teiHeader/fileDesc/titleStmt/title(normalize_space),Titolo),!,
    assert(txt(Dos,Titolo,File)),
    \+ (
	xpath(Root,//(text(@rend=doc)),Txt),
	xpath(Txt,/(text)/front/docTitle/titlePart(normalize_space),SekcioTitolo),
	debug(tekstaro(chap),'~q',[SekcioTitolo]),
%%	format('~n~q:~n',[SekcioTitolo]),
%%	teixlite_div(Dos,SekcioTitolo,Div),

	xpath(Txt,/text/body(text),Enhavo),
	atomic_list_concat(Frazoj,'.',Enhavo),
	forall(
		member(Fraz,Frazoj),
		once((
		    normalize_space(atom(Frazo),Fraz),
		    Frazo \= '',
		    debug(tekstaro(txt),'~q',[Frazo]),
		    assert(cit(Dos,SekcioTitolo,Frazo))
		; true
		))
	    ),
	fail
    ).

marta_teksto(Dos,Titolo,File) :-
    teixdtd(DTDPathSpec),
    expand_file_search_path(DTDPathSpec,DTDFile),
    new_dtd('TEI.2',DTD),
    load_dtd(DTD,DTDFile,[dialect(xml)]),
    % ignoru pi(..)  en [pi(...),element(TEI.2..)]
    load_xml(File,[_,DOM],[dtd(DTD)]),
    xpath(DOM,/'TEI.2',Root),
    xpath(Root,teiHeader/fileDesc/titleStmt/title(normalize_space),Titolo),!,
    assert(txt(Dos,Titolo,File)),
    \+ (
	xpath(Root,//(div(@type=Type)),Div),
	memberchk(Type,[foreword,main]),
	once((
	    Type=foreword,
	    SekcioTitolo='Antaŭparolo'
	    ;
	    SekcioTitolo=''
	)),
	debug(tekstaro(chap),'~q',[SekcioTitolo]),
%%	format('~n~q:~n',[SekcioTitolo]),
	teixlite_div(Dos,SekcioTitolo,Div),
	fail
    ).

guten_teksto(Dos,Titolo,File) :-
    load_html(File,[DOM],[encoding('utf-8')]),
    xpath(DOM,/html,Root),
    xpath(Root,head/title(normalize_space),Titolo),!,
    assert(txt(Dos,Titolo,File)),
 %   \+ (
%	xpath(Root,//h3,Sekcio),
%	debug(tekstaro(chap),'~q',[Sekcio]),

        \+ (
	    (
	     xpath(Root,body//p(text),Enhavo)
	     ;
	     xpath(Root,body//span(text),Enhavo)
	     ;
	     xpath(Root,body//div(@class=indented,text),Enhavo)
	    ),
	    atomic_list_concat(Frazoj,'.',Enhavo),
	    forall(
		member(Fraz,Frazoj),
		once((
		    normalize_space(atom(Frazo),Fraz),
		    Frazo \= '',
		    debug(tekstaro(txt),'~q',[Frazo]),
		    assert(cit(Dos,Titolo,Frazo))
		  ; true
		))
	    ),
	    fail
	).

	
%%	format('~n~q:~n',[SekcioTitolo]),
%	fail
%    ).


% ignoru pi(..)  en [pi(...),element(TEI.2..)]
teixlite_teksto(Dos,[_,DOM],SectionTypes,Titolo) :-
    xpath(DOM,/'TEI.2',Root),
    xpath(Root,teiHeader/fileDesc/titleStmt/title(normalize_space),Titolo),!,
    \+ (
	xpath(Root,//(div(@type=Type)),Div),
	memberchk(Type,SectionTypes),
    once((
        xpath(Div,/(div)/head(content),Cnt),
        text_content(Cnt,SekcioTitolo)
        ; SekcioTitolo=''
    )),
	debug(tekstaro(chap),'~q',[SekcioTitolo]),
%%	format('~n~q:~n',[SekcioTitolo]),
	teixlite_div(Dos,SekcioTitolo,Div),
	fail
    ).

tei1lite_teksto(Dos,[DOM],SectionTypes,Titolo) :-
    xpath(DOM,/'TEI',Root),
    xpath(Root,teiHeader/fileDesc/titleStmt/title(normalize_space),Titolo),!,
    \+ (
	xpath(Root,//(div(@type=Type)),Div),
	memberchk(Type,SectionTypes),
	xpath(Div,/(div)/head(normalize_space),SekcioTitolo),
	debug(tekstaro(chap),'~q',[SekcioTitolo]),
%%	format('~n~q:~n',[SekcioTitolo]),
	teixlite_div(Dos,SekcioTitolo,Div),
	fail
    ).

teixlite_div(Dos,SekcioTitolo,Div) :- 
    Div = element('div',_,Children),
    member(element(ChildName,Attrs,ChildContent),Children),
%%    write(ChildName), write(', '),

    xpath(element(ChildName,Attrs,ChildContent),/self(text),Enhavo),
    atomic_list_concat(Frazoj,'.',Enhavo),
    forall(
	    member(Fraz,Frazoj),
	    once((
		normalize_space(atom(Frazo),Fraz),
		Frazo \= '',
		debug(tekstaro(txt),'~q',[Frazo]),
		assert(cit(Dos,SekcioTitolo,Frazo))
	    ; true
	    ))
	).

% return atomic content only ignoring element content
text_content(Cnt,Atom) :-
    text_content_(Cnt,List),
    atomic_list_concat(List,A),
    normalize_space(atom(Atom),A).

text_content_([],[]).
text_content_([A|R1],[A|R2]) :-
    atomic(A), !,
    text_content_(R1,R2).
text_content_([_|R1],R2) :-
    text_content_(R1,R2).


monato2_html(Dos,Titolo,File) :-
    load_html(File,[DOM],[encoding('iso-8859-1')]),
    xpath(DOM,/html,Root),
    xpath(Root,head/title(normalize_space),T),!,
    lat3_utf8(T,Titolo),
    assert(txt(Dos,Titolo,File)),
    once((
	xpath(Root,head/meta(@name=author,@content),A), A\= ''
	;
	xpath(Root,head/meta(@name=editor,@content),A)
	;
	A=''
	)),
    lat3_utf8(A,Autoro),
    assert(aut(Dos,Titolo,Autoro)),
    \+ (
	xpath(Root,body//p(text),Enhavo),
	atomic_list_concat(Frazoj,'.',Enhavo),
	forall(
	    member(Fraz,Frazoj),
	    once((
		normalize_space(atom(Frazo),Fraz),
		Frazo \= '',
		lat3_utf8(Frazo,F),
		debug(tekstaro(txt),'~q',[F]),
		assert(cit(Dos,Titolo,F))
	      ; true
	    ))
	),
	fail
    ).

monato3_html(Dos,Titolo,File) :-
    load_html(File,[DOM],[encoding('utf-8')]),
    xpath(DOM,/html,Root),
    xpath(Root,head/title(normalize_space),Titolo),!,
    assert(txt(Dos,Titolo,File)),
    once((
	xpath(Root,head/meta(@name=author,@content),Autoro), Autoro \= ''
	;
	xpath(Root,body/div(span(@class=mm)),Div),
	xpath(Div,/div(normalize_space),Autoro)
	;
	Autoro=''
	)),
    assert(aut(Dos,Titolo,Autoro)),
    \+ (
	xpath(Root,body//p(text),Enhavo),
	atomic_list_concat(Frazoj,'.',Enhavo),
	forall(
	    member(Fraz,Frazoj),
	    once((
		normalize_space(atom(Frazo),Fraz),
		Frazo \= '',
		debug(tekstaro(txt),'~q',[Frazo]),
		assert(cit(Dos,Titolo,Frazo))
	      ; true
	    ))
	),
	fail
    ).

monato3_html(_,_,_) :- true. % ignoru nevalidajn dosierojn ,ekz. nevalidan HTML

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% predikatoj / DCG por analizi bibliotekstojn al txt- kaj cit-faktoj
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

biblio_teksto(VrkTxt,Titolo) -->
    biblio_titolo(1,Titolo1), "\n\n",
    { atom_codes(Titolo,Titolo1) },
    (biblio_titolo(2,_Titolo2), "\n\n"; []), % foje mankas subtitolo
    biblio_chapitroj(VrkTxt,1), !.

biblio_titolo(_Level,Titolo) -->
            \+ lookahead("Ĉapitro"),
            \+ lookahead("Psalmo"),
	    line_upper(Titolo).
     
   

biblio_chapitroj(VrkTxt,No) --> biblio_chapitro(VrkTxt,No),  !, { No_1 is No+1 }, biblio_chapitroj(VrkTxt,No_1).
biblio_chapitroj(VrkTxt,1) --> biblio_chapitro_teksto(VrkTxt,1). % ekz. Obadja (31) enhavas nur unu sennombran ĉaptiron
biblio_chapitroj(_,_) -->[].

biblio_chapitro(VrkTxt,No) --> biblio_chapitro_titolo(No,SubTitolo), "\n\n",
			       { SubTitolo = '' -> true
				 ; assert(cit(VrkTxt,No,SubTitolo))
			       },
			       biblio_chapitro_teksto(VrkTxt,No).

biblio_chapitro_titolo(No,'') --> blanks, "Ĉapitro", white, integer(No), !,
			       { debug(tekstaro(chap),'  ĉap ~q',[No]) }.
biblio_chapitro_titolo(No,SubTitolo) --> blanks, "Psalmo", white, integer(No), !,
				{ debug(tekstaro(chap),'  psa ~q',[No]) },
                                (
				    % post psalmo-titolo foje aperas subtitolo
				    "\n", biblio_subtitolo(SubTit),
				    { atom_codes(SubTitolo,SubTit) }
				 ;
				    [], { SubTitolo = '' }
				). 
			     
biblio_subtitolo(SubTitolo) --> "\n",
                             \+ lookahead("Ĉapitro"),
			     string_without("\n1",Text1),
			     biblio_subtitolo(Text2),
			     { append(Text1,[32|Text2],SubTitolo) }.
biblio_subtitolo([]) --> [].


% dbg: biblio_chapitro_titolo(_) --> [C,D,E], { atom_codes(A,[C,D,E]), throw(ne_trovis_chapitro_komencon(A)) }.
    
biblio_chapitro_teksto(VrkTxt,Chap) --> biblio_alineoj(VrkTxt,Chap,1).

biblio_alineoj(VrkTxt,Chap,No) --> biblio_alineo(VrkTxt,Chap,No), { No_1 is No+1 }, biblio_alineoj(VrkTxt,Chap,No_1).

biblio_alineoj(_,_,_) --> biblio_piednoto.

biblio_alineoj(_,_,_) --> [].

% piednoto, ignoru 
biblio_piednoto() --> "\n* ", string_without("\n",_).

biblio_alineo(VrkTxt,ChapNo,AlnNo) -->
    integer(AlnNo), blank, string_without("\n1234567890",Text1),
    biblio_alineo_tail(Text2),
    {
	append(Text1,[32|Text2],Text),
	atom_codes(T,Text),
	assert(cit(VrkTxt,ChapNo:AlnNo,T)),
	debug(tekstaro(txt),'    ~d:~d ~q',[ChapNo,AlnNo,T])
    }.
biblio_alineo_tail([]) --> biblio_piednoto. 
biblio_alineo_tail(Text) --> "\n",
                             \+ lookahead("Ĉapitro"),
                             \+ lookahead("Psalmo"),
			     string_without("\n1234567890",Text1),
			     biblio_alineo_tail(Text2),
			     { append(Text1,[32|Text2],Text) }.
biblio_alineo_tail([]) --> [].


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% predikatoj / DCG por analizi monatotekstojn el s.c.e. al txt- kaj cit-faktoj
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

monato_teksto(Dos,Titolo) -->
    monato_header,
    "\n",
    monato_komento,
    "\n",
    monato_titolo(Titolo),!,
    "\n",
    monato_teksto(Teksto),
    {
	monato_teksto_frazoj(Dos,Titolo,Teksto)
    }.

monato_teksto(Dos,Titolo) -->
    monato_komento,
    "\n",
    monato_titolo(Titolo),!,
    "\n",
    monato_teksto(Teksto),
    {
	monato_teksto_frazoj(Dos,Titolo,Teksto)
    }.

monato_teksto(Dos,Titolo) -->
    monato_titolo(Titolo),!,
    "\n",
    monato_teksto(Teksto),
    {
	monato_teksto_frazoj(Dos,Titolo,Teksto)
    }.


monato_teksto_frazoj(Dos,Titolo,Teksto) :-
    atom_codes(T,Teksto),
    atomic_list_concat(Frazoj,'.',T),
    forall(
	    member(Fraz,Frazoj),
	    once((
		normalize_space(atom(Frazo),Fraz),
		Frazo \= '',
		%Fraz=F,
		cx_utf8(Fraz,F),
		debug(tekstaro(txt),'~q',[F]),
		assert(cit(Dos,Titolo,F))
	    ; true))
	).	


monato_header -->
    "From soc.", string_without("\n",_), "\n",
    "From: ", string_without("\n",_), "\n",
    "Date: ", string_without("\n",_), "\n",
    "Newsgroups: ", string_without("\n",_), "\n",
    "Subject: ", string_without("\n",_), "\n".

monato_header -->
    "Date: ", string_without("\n",_), "\n",
    "From: ", string_without("\n",_), "\n",
    "Subject: ", string_without("\n",_), "\n",
    "To: ", string_without("\n",_), "\n".

monato_komento -->
    "Pro peto ", string_without("=",_),
    monato_komento_linio,
    blanks,
    monato_komento_linio,!,
    ("\n";[]).

monato_komento -->
    "Pro peto ", string_without("=",_),
    monato_komento_linio,
    ("\n";[]).

monato_komento -->
    monato_komento_linio,
    monato_komento.

monato_komento --> [].

monato_komento_linio --> "=", string_without("\n",_), "\n".

monato_titolo(Titolo) -->
    string_without("\n",Tit), "\n",
    { cx_utf8_a(Tit,Titolo) }.

monato_teksto(Teksto) -->
    monato_teksto_linio(Linio),!,
    monato_teksto(Pli),
    { append(Linio,[32|Pli],Teksto) }.
monato_teksto([]) --> [].

monato_teksto_linio(Linio) -->
    string_without("\n",Linio), "\n".


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% predikatoj por redoni ekzemploj kun fontindiko kiel Json
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


cit_to_ekzj(Citoj,Texts) :-
    findall(
	    json([sim=Simil,cit=CitJson]),
	    (
		member(Simil-Cit,Citoj),
		cit_to_json(Cit,CitJson)
	    ),
	    Texts).

cit_to_json(cit(Vrk,Lok,Text),json([ekz=Text,fnt=FntJson])) :-
	fnt_json(Vrk,Lok,FntJson).


fnt_json(Vrk:_,_,json([bib=Bib])) :- bib(Vrk,Bib).

fnt_json(bu:_,Lok,json([vrk='La Stranga Butiko',aut='Raymond Schwartz',lok=Lok,url='http://steloj.de/esperanto/butiko'])).

fnt_json(Vrk:No,Lok,json([bib=Bib,lok=FntLok])) :-
	     (Vrk = mt ; Vrk = nt),
	     % TODO: aldonu titolon de la teksto
	     tekstaro:txt(Vrk:No,Titolo,_),
	     format(atom(FntLok),'~w ~w',[Titolo,Lok]),
	     upcase_atom(Vrk,Bib).	     

fnt_json(fb:No,Lok,json([bib=Bib,lok=Lok])) :-
      format(atom(Bib),'Fab~d',[No]).

fnt_json(fe:_,Lok,json([bib='F',lok=Lok])).

fnt_json(gf:_,Lok,json([bib='ElektFab',lok=Lok])).

fnt_json(fr:No,Lok,json([bib=Bib,lok=FntLok])) :-
    format(atom(Bib),'Far~d',[No]),
    atomic_list_concat([Vorto|Vortoj],' ',Lok),
    sub_atom(Vorto,0,1,_,L1),
    sub_atom(Vorto,1,_,0,Literoj),
    downcase_atom(Literoj,Literoj_),
    atom_concat(L1,Literoj_,Vorto1),
    atomic_list_concat([Vorto1|Vortoj],' ',FntLok).

fnt_json(pa:_,Tit,json([bib='Paroloj',vrk=Tit])).
fnt_json(hm:_,Tit,json([bib='Homaranismo',vrk=Tit])).
fnt_json(lr:_,Lok,json([bib='LR',lok=Lok])).

fnt_json(po:_,Tit,json([aut='L. L. Zamenhof',vrk=Tit])).

fnt_json(ra:_,Lok,json([bib='Rabistoj',lok=Lok])).
fnt_json(rv:_,Lok,json([bib='Revizoro',lok=Lok])).

fnt_json(sr:_,Lok,json([aut='Michael Ende, trad. Wolfram Diestel',vrk='La Senĉesa Rakonto',lok=Lok])).

fnt_json(m1:No,Tit,json([bib='Monato',vrk=Tit,lok=Nro,url=Url])) :-
    tekstaro:txt(m1:No,_,File),
    atomic_list_concat([_,N|_],'-',File),
    atom_codes(N,[J1,J2,N1,N2]),
    atom_codes(Nro,[J1,J2,0'/,N1,N2]),
    atomic_list_concat(Parts,'/',File),
    reverse(Parts,[Dos|_]),
    format(atom(Url),'http://steloj.de/esperanto/monato1/~w',[Dos]).

fnt_json(m2:No,Tit,json([bib='Monato',aut=Aut,vrk=Tit,url=Url])) :-
    tekstaro:aut(m2:No,_,Aut),
    tekstaro:txt(m2:No,_,File),
    %sub_atom(File,_,6,5,Nro),
    atomic_list_concat(Parts,'/',File),
    reverse(Parts,[Dos|_]),
    format(atom(Url),'http://steloj.de/esperanto/monato2/~w',[Dos]).

fnt_json(m3:No,Tit,json([bib='Monato',aut=Aut,vrk=Tit,url=Url,lok=Jaro])) :-
    tekstaro:aut(m3:No,_,Aut),
    tekstaro:txt(m3:No,_,File),
    atomic_list_concat(Parts,'/',File),
    reverse(Parts,[Dos,Jaro|_]),
    %once((
	%memberchk(Jaro,['2003','2004']),
	%format(atom(Url),'http://www.esperanto.be/fel/~w/~w',[Jaro,Dos])
	%;
	format(atom(Url),'https://www.monato.be/~w/~w',[Jaro,Dos])
	%))
    .

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% helpo-predikatoj / DCG por analizado
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

lookahead(T), T --> T.

line_upper([C|Tail]) --> [C],
	{ code_type(C,upper) },
	line_upper_tail(Tail).			

line_upper_tail([L|Tail]) --> [C],
	{ code_type(C,upper(L)) },
	line_upper_tail(Tail).
line_upper_tail([0' |Tail]) --> white,
	line_upper_tail(Tail).
line_upper_tail([0'.|Tail]) --> ".",
	line_upper_tail(Tail).
line_upper_tail([]) --> [].


lat3_utf8([C|More],[C|More1]) :-
    code_type(C,ascii),!,
    lat3_utf8(More,More1).

% 'æ-ĉ,ý-ŭ,ø-ĝ,¼-ĵ,Æ-Ĉ,þ-ŝ'
% [230-265,253-365,248-285,188-309,198-264,254-349]
% 'ð-ĥ,Ø-Ĝ,Ð-Ĥ'
% [240,45,293,44,216,45,284,44,208,45,292]

lat3_utf8(Alat3,Autf8) :-
    atom_codes(Alat3,Codes),
    lat3_utf8_(Codes,Utf),
    atom_codes(Autf8,Utf).

lat3_utf8_([C|More],[C1|More1]) :-
    memberchk(C-C1,[230-265,253-365,248-285,188-309,221-364,
		    198-264,254-349,240-293,216-284,208-292]),!,
    lat3_utf8_(More,More1).

lat3_utf8_([C|More],[C|More1]) :-
    lat3_utf8_(More,More1).

lat3_utf8_([],[]).


utf8_cx(Chapel,Cx) :-
    atom_codes(Chapel,ChCodes),
    translcodes(TC),
    utf8_cx(ChCodes,CxCodes,TC),
    atom_codes(Cx,CxCodes).

cx_utf8(Cx,Utf) :-
    atom_codes(Cx,XCodes),
    translcodes(TC),
    utf8_cx(UCodes,XCodes,TC),
    atom_codes(Utf,UCodes).

cx_utf8_a(XCodes,UtfAtom) :-
    translcodes(TC),
    utf8_cx(UCodes,XCodes,TC),
    atom_codes(UtfAtom,UCodes).

utf8_cx([],[],_).
utf8_cx([Ch|ChRest],[C,X|CxRest],Transl) :-
    member(Ch-[C,X],Transl),
    !,
    utf8_cx(ChRest,CxRest,Transl).

utf8_cx([L|ChRest],[L|CxRest],Transl) :-
    utf8_cx(ChRest,CxRest,Transl).

translcodes([
	   264-[67,120],
	   284-[71,120],
	   292-[72,120],
	   308-[74,120],
	   348-[83,120],
	   364-[85,120],
	   265-[99,120],
	   285-[103,120],
	   293-[104,120],
	   309-[106,120],
	   349-[115,120],
	   365-[117,120]]).

	
