/* -*- Mode: Prolog -*- */

:- module(ekzfnt,[
	      printbest/4,
	      findbest/5,
	      findfast/3,
	      findfast/4,
	      findsmart/3,
	      findsmart/4,
          findregex/3,
          findregex/4,
	      show_stats/0
]).

:- use_module(library(dcg/basics)).
%:- use_module(library(readutil)).
:- use_module(library(isub)).
:- use_module(library(pcre)).

:- use_module(tekstanalizo).

:- debug(ekzfnt(_)).
:- debug(sercho(what)).
:- debug(sercho(stats)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% predikatoj por serĉi en la faktoj pri la fontoj
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%! printbest(+Metodo,+Max,+Serĉo,+Verko) is det
%
% Serĉas per =findbest= en la verko =Verko= kaj tuj elskribas la plej bonajn trovojn.
% =Methodo= estas la serĉmetodo kaj povas esti unu el =ngram=, =isub=, =contains=
% aŭ =regex=. =Max= donas la nombron de maksimume redonotaj trovoj, =Sercho= donas
% la serĉesprimon, kio povas esti unu aŭ pluraj vortoj aŭ regulesprimo kun la metodo =regex=.
% 
printbest(Method,Max,Sercho,Vrk) :-
    findbest(Method,Max,Sercho,Vrk,Trovoj),
    forall(
	    member(Simil-Cit,Trovoj),
	    (
		format('(~w) ~q~n',[Simil,Cit]),

		(debugging(ekzfnt(_))
		 ->
		     once((
			Method=ngram,
			Cit = cit(_,_,Text,_),	 
			debug_ngrams(Sercho,Text,4)
			;
			true
		     ))
		 ;
		 true
		)
	    )).

%! findfast(+Max,+Serĉo,-Trovoj) is det
%
% Serĉas unuavice per la metodo =contains= ekzaktajn lokojn kaj
% duavice poer la metodo =isub= neekzaktajn lokojn, kie aperas
% la vorto au la frazeto donita en =Sercho=. Traserĉataj estas ĉiuj verkoj.
% La rezulto redoniĝas en =Trovoj=.
findfast(Max,Sercho,Trovoj) :- findfast(Max,chiuj,Sercho,Trovoj).

%! findfast(+Max,+Verkaro,+Serĉo,-Trovoj) is det
%
% Serĉas unuavice per la metodo =contains= ekzaktajn lokojn kaj
% duavice poer la metodo =isub= neekzaktajn lokojn, kie aperas
% la vorto au la frazeto donita en =Sercho=. Traserĉataj estas la verkoj
% el la verkolisto =Verkaro=. La rezulto redoniĝas en =Trovoj=.
findfast(Max,Verkaro,Sercho,Trovoj) :-
    once((
        atom(Verkaro),
        verkaro(Verkaro,Verkoj)
        ;
        is_list(Verkaro),
        Verkaro = Verkoj
    )),

    concurrent_maplist(findbest(contains,Max,Sercho),Verkoj,Tr),
    append(Tr,Tr1),
    length(Tr1,L), Mx2 is Max-L,
    (Mx2 > 0
     ->
	 pairs_values(Tr1,Ekskludoj),
	 once((findbest_excl(isub,Mx2,Sercho,Verkoj,Ekskludoj,Tr2);Tr2=[])),
	 append(Tr1,Tr2,Trovj)
     ; Trovj=Tr1),
    cit_to_ekzj(Trovj,Trovoj).

%! findsmart(+Max,+Serĉo,-Trovoj) is det
%
% Serĉas per la metodo =ngram= neekzaktajn lokojn, kie aperas
% la vorto au la frazeto donita en =Sercho=. Traserĉataj estas ĉiuj verkoj.
% La rezulto redoniĝas en =Trovoj=.
findsmart(Max,Sercho,Trovoj) :- findsmart(Max,chiuj,Sercho,Trovoj).

%! findsmart(+Max,+Verkaro,+Serĉo,-Trovoj) is det
%
% Serĉas per la metodo =ngram= neekzaktajn lokojn, kie aperas
% la vorto au la frazeto donita en =Sercho=. Traserĉataj estas la verkoj
% el la verkolisto =Verkaro=. La rezulto redoniĝas en =Trovoj=.
findsmart(Max,Verkaro,Sercho,Trovoj) :-
  atom_length(Sercho,L), L>3,

  once((
    atom(Verkaro),
    verkaro(Verkaro,Verkoj)
    ;
    is_list(Verkaro),
    Verkaro = Verkoj
  )),

  concurrent_maplist(findbest(ngram,Max,Sercho),Verkoj,T), 

  % faru unu liston el pluraj (pro paralela serĉo)
  append(T,Trv), !,

  length(Trv,Len), debug(ekzfnt(findsmart),'findsmart len Trv ~w',[Len]),

 ( Trv = []
    -> Trovoj = []
  ;			   
      group_by(1,Simil-T1,
%  bagof(Simil-T1,
	   limit(Max,
		 order_by([desc(Simil)],member(Simil-T1,Trv))),
	   Trovj),
			   
    cit_to_ekzj(Trovj,Trovoj)).


%! findregex(+Max,+Serĉo,-Trovoj) is det
%
% Serĉas per la metodo =regex= lokojn kiuj konformas al la regulesprimo
% donita en =Sercho=. Traserĉataj estas ĉiuj verkoj.
% La rezulto redoniĝas en =Trovoj=.
findregex(Max,Sercho,Trovoj) :- findregex(Max,chiuj,Sercho,Trovoj).

%! findregex(+Max,+Verkaro,+Serĉo,-Trovoj) is det
%
% Serĉas per la metodo =regex= lokojn kiuj konformas al la regulesprimo
% donita en =Sercho=. Traserĉataj estas la verkoj el la verkolisto =Verkaro=.
% La rezulto redoniĝas en =Trovoj=.
findregex(Max,Verkaro,Sercho,Trovoj) :-
    % vd. http://www.pcre.org/current/doc/html/pcre2syntax.html#SEC10
    %atom_concat('(*UCP)',Sercho,Pattern),
    %re_compile(Pattern,Regex,[]),
    atom_length(Sercho,L), L>2,
    re_compile(Sercho,Regex,[caseless(true),ucp(true)]),

    once((
        atom(Verkaro),
        verkaro(Verkaro,Verkoj)
        ;
        is_list(Verkaro),
        Verkaro = Verkoj
    )),
    
    concurrent_maplist(findbest(regex,Max,Regex),Verkoj,T), 
  
    % faru unu liston el pluraj (pro paralela serĉo)
    append(T,Trv), !, re_flush,  
    length(Trv,Len), debug(ekzfnt(findregex),'findregex len Trv ~w',[Len]),
  
   ( Trv = []
      -> Trovoj = []
    ;			   
        group_by(1,Simil-T1,
  %  bagof(Simil-T1,
         limit(Max,
           order_by([desc(Simil)],member(Simil-T1,Trv))),
         Trovj),
                 
      cit_to_ekzj(Trovj,Trovoj)).

%! findbest(+Metodo,+Max,+Serĉo,+Vrk,-Trovoj) is det
%
% Serĉas per la metodo =Metodo= lokojn kiuj laŭeble bone 
% konformas al la serĉesprimo donita en =Sercho=. 
% La metodoj =contains= kaj =regex= serĉas ekzakte, la metodoj
% =isub= kaj =ngram= neekzakte. =Max= donas la maksimumon de redonotaj trovoj.
% =Vrk= povas esti unopa verko aŭ listo de verkoj, ekze =|[prv,m_t]|=. 
% La rezulto redoniĝas en =Trovoj=.
findbest(Method,Max,Sercxo,Vrk,Trovoj) :-
    group_by(_, Simil-cit(Vrk:Dos,Lok,Txt,Fn),
	     limit(Max,
		   order_by([desc(Simil)],
			    (
				%member(Vrk,Verkoj),
				find(Method,Sercxo,cit(Vrk:Dos,Lok,Txt,Fn),Simil)
			    ))),
	     Trovoj), !.


findbest(Method,Max,Sercxo,Verkoj,Trovoj) :-
    is_list(Verkoj),
    group_by(_, Simil-cit(Vrk:Dos,Lok,Txt,Fn),
	     limit(Max,
		   order_by([desc(Simil)],
			    (
				member(Vrk,Verkoj),
				find(Method,Sercxo,cit(Vrk:Dos,Lok,Txt,Fn),Simil)
			    ))),
	     Trovoj), !.

% empty list when nothing found
findbest(_,_,_,_,[]).

%! findbest(+Metodo,+Max,+Serĉo,+Vrk,+Ekskludoj,-Trovoj) is det
%
% Same kiel findebest/5, sed la aldona parametro =Ekskludoj= donas liston
% de trovlokoj, kiuj estas ignorataj. Utila se oni volas serci per pluraj metodoj
% unu post la alia kaj eviti, ke retrovitaj lokoj limigu la nombron de rezultoj.
findbest_excl(Method,Max,Sercxo,Vrk,Ekskludoj,Trovoj) :-
    \+ is_list(Vrk),
    %normalize(Sercho,Sercxo),
    group_by(_, Simil-cit(Vrk:Dos,Lok,Txt,Fn),
	     limit(Max,
		   order_by([desc(Simil)],
			    (
				find(Method,Sercxo,cit(Vrk:Dos,Lok,Txt,Fn),Simil),
                                \+ memberchk(cit(Vrk:Dos,Lok,Txt,Fn),Ekskludoj)
			    ))),
	     Trovoj), !.

findbest_excl(Method,Max,Sercxo,Verkoj,Ekskludoj,Trovoj) :-
    is_list(Verkoj),
    %normalize(Sercho,Sercxo),
    group_by(_, Simil-cit(Vrk:Dos,Lok,Txt,Fn),
	     limit(Max,
		   order_by([desc(Simil)],
			    (
				member(Vrk,Verkoj),
				find(Method,Sercxo,cit(Vrk:Dos,Lok,Txt,Fn),Simil),
                                \+ memberchk(cit(Vrk:Dos,Lok,Txt,Fn),Ekskludoj)
			    ))),
	     Trovoj), !.

% empty list when nothing found
findbest_exl(_,_,_,_,_,[]).

append_excl(Trovoj1,Trovoj2,Trovoj) :-
    pairs_values(Trovoj1,Excl),
    exclude(excl_chk(Excl),Trovoj2,Resto2),
    append(Trovoj1,Resto2,Trovoj).
excl_chk(Excl,_-Cit) :- memberchk(Cit,Excl).

%! find(+Metodo,+Serĉo,?Trovo,-Simileco) is nondet
%
% Serĉas per la metodo =Metodo= kaj la esprimo =Sercho=.
% Unuopa trovo estas en la formo =|cit(Vrk:Dos,Lok,Txt)|=,
% ĉe kio =Vrk= jam povas esti antaŭplenigita por limigi la
% serĉon al tiu verko. =Simileco= donas valoron inter 0 kaj 1
% por mezuro, kiom bone la trovo konformas al la serĉesprimo.
% Ĉe ekzaktaj serĉmetodoj =contains= kaj =regex= gi estas ciam 1.0
find(ngram,Sercxo,cit(Vrk:Dos,Lok,Txt,Fn),Simil) :-
    atom_length(Sercxo,L), L>3,
    ngrams(Sercxo,4,NGrams),
    tekstaro:cit(Vrk:Dos,Lok,Txt,Fn),
    ngram_find(NGrams,Txt,Simil),
    Simil > 0.3. %0.3 .

find(isub,Sercxo,cit(Vrk:Dos,Lok,Txt,Fn),Simil) :-
    downcase_atom(Sercxo,S),
    tekstaro:cit(Vrk:Dos,Lok,Txt,Fn),
    downcase_atom(Txt,T),
    isub(S,T,Simil,[zero_to_one(true)]),
    Simil > 0.5 .

find(contains,Sercxo,cit(Vrk:Dos,Lok,Txt,Fn),1.0) :-
    downcase_atom(Sercxo,S),
    tekstaro:cit(Vrk:Dos,Lok,Txt,Fn),
    text_contained(S,Txt).

find(regex,Sercxo,cit(Vrk:Dos,Lok,Txt,Fn),1.0) :-
    tekstaro:cit(Vrk:Dos,Lok,Txt,Fn),
    re_match(Sercxo,Txt).    

%! ngram_find(+NGrams,+Teksto:atom,-Simileco) is nondet
%
% Komparas la liston de n-gramoj =NGrams= kun la
% atomo =Teksto= (t.e. frazo el traserĉenda fontoteksto) 
% kaj redonas mezuron de konformeco kiel =Simileco=.
% Se ciuj n-gramoj troviĝas tio estas 1.0, se nur la duono
% troviĝis tio estas 0.5 kaj se neniu troviĝis 0.0
ngram_find(NGrams,Atom,Percentage) :-
    proper_length(NGrams,Len), Len>0,
    ngram_count(NGrams,Atom,0,Count),
    Percentage is Count / Len.   % >= 0.7


%! text_contained(+Serĉo,+Teksto) is det
%
% Rezultiĝas kiel =true= se la minuskligita 
% teksto =Serĉo= troviĝas ekzakte ie ie en =Teksto=.
% aliokaze rezultiĝas =false=.
text_contained(Sercxo,Teksto) :-
  atom_length(Sercxo,L1), L1>0,
  atom_length(Teksto,L2), L2>0,
 % downcase_atom(Sercxo,A1),
  downcase_atom(Teksto,A2),
  sub_atom(A2,_,_,_,Sercxo).  

%! text_match(+Atom1,+Atom2,-Procentoj) is det
%
% Redonas kiel =Procentoj= 1.0, se =|Atom1 = Atom2|=,
% aliokaze redoniĝas la rezulto de ngram_match kun n=4.
text_match(Atom1,Atom2,Percentage) :-
  Atom1 = Atom2, Percentage = 1.0.
  
text_match(Atom1,Atom2,Percentage) :-
  ngram_match(Atom1,Atom2,4,Percentage).


%! ngram_match(+Atom1,+Atom2,+N,-Procentoj) is det
%
% Redonas procentan valoron (inter 0 kaj 1), kiom
% bone =Atom1= kaj =Atom2= similas. Ambaŭ atomoj estas
% dishakitaj en n-gramoj kun la longo =N=. Poste la simileco
% estas kalkulita kiel propocio de komunaj n-gramoj kaj
% la minimuma longeco de la atomoj.
ngram_match(Atom1,Atom2,N,Percentage) :-
    %downcase_atom(Atom1,A1),
    %downcase_atom(Atom2,A2),
    ngrams(Atom1,N,NGrams1),
    ngrams(Atom2,N,NGrams2),
    ord_intersection(NGrams1,NGrams2,CommonNGrams),
    proper_length(NGrams1,L1),
    proper_length(NGrams2,L2),
    proper_length(CommonNGrams,Lc),
    % FIXME: chu la formulo taugas, ghi estas spontane skribita
    Percentage is Lc / min(L1,L2).   % >= 0.7
    %Percentage is (Lc+Lc) / (L1+L2). % >=0.66

%! ngram_count(+NGramoj,+Atom,+Valoro0,-Nombro) is det
%
% Redonas kiel =Nombro= la nombron de ngramoj el
% =NGrams= trovitaj en Atom. =Valoro0= estas la
% baza nombro por kalkulado, komence nulo.
ngram_count([],_,C,C).
ngram_count([NGram|More],Atom,C,Count) :-
    once((
	sub_atom(Atom,_,_,_,NGram),
	C1 is C+1
	;
	C1=C
    )),
    ngram_count(More,Atom,C1,Count).
  
%! ngrams(+Atom,+Len,-NGramoj) is det
%
% Dishakas =Atom= en n-gramojn kun la longo =N=.
ngrams(Atom,Len,NGrams) :- 
  setof(NGram,A^B^sub_atom(Atom,B,Len,A,NGram),NGrams).
    
debug_ngrams(Atom1,Atom2,N) :-
    normalize(Atom1,A1),
    downcase_atom(Atom2,A2),
    ngrams(A1,N,NGrams1),
    ngrams(A2,N,NGrams2),
    ord_intersection(NGrams1,NGrams2,CommonNGrams),
    debug(ekzfnt(ngram),'~q',[CommonNGrams]).

normalize(Sercho,Sercxo) :-
    downcase_atom(Sercho,Sercxo).

	  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% testoj
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

test_findsmart(Times) :-
    Times >0,
    show_stats,
    (0 is Times mod 2 -> Set = klasikaj ; Set = postaj),
    Sercho = 'kepleraj leĝoj',
    debug(sercho(what),'~w: ~w',[Set,Sercho]),
    time(findsmart(20,Set,Sercho,_T)),
    T1 is Times-1,
    test_findsmart(T1).

test_findsmart(0) :- show_stats.

show_stats :-
    \+ show_mem_stats,
    statistics(atoms,Atoms),
%     statistics(heapused,Heap),
    statistics(agc,AGC),
    statistics(agc_time,AGCTime),
    statistics(agc_gained,AGCGained),
    format(atom(Stats),'atoms: ~d agc: ~d time: ~1fs gained: ~d~n',[Atoms,AGC,AGCTime,AGCGained]),
    debug(sercho(stats),'~w',[Stats]).
  
		   
show_mem_stats :-
    current_prolog_flag(pid, PID),
    format(atom(StatFile),'/proc/~d/status',PID),
    open(StatFile,read,In,[]),
    repeat,
    read_line_to_codes(In,L),
    (
     L \= end_of_file
     ->	(atom_codes(Line,L),
	atomic_list_concat([Key,Value],':',Line),
	(memberchk(Key,['VmPeak','VmSize','VmHWM','VmRSS'])
	 -> (
		 normalize_space(atom(Val),Value),
		 debug(sercho(stats),'~w: ~w',[Key,Val])
		 %format('~w: ~w   ',[Key,Val])
	     )
	 ; true))
     ; close(In), !),
    fail.


	
