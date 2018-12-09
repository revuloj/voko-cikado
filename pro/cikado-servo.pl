/* -*- Mode: Prolog -*- */
:- module(cikado,
	  [ server/1			% +Port
	  ]).
:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_server_files)).
:- use_module(library(http/http_files)).
:- use_module(library(http/http_parameters)). % reading post data
:- use_module(library(http/http_session)).
:- use_module(library(http/json)).
:- use_module(library(http/http_json)).
:- use_module(library(http/http_header)).
:- use_module(library(http/http_unix_daemon)).
%:- use_module(library(http/http_openid)).
:- use_module(library(http/http_path)).
:- use_module(library(http/html_write)).
:- use_module(library(http/http_open)).
:- use_module(library(settings)).
:- use_module(library(xpath)).

:- multifile http:location/3.
:- dynamic   http:location/3.

% TODO: is http/http_error autoloaded?
% see http://www.swi-prolog.org/pldoc/man?section=http-debug

:- use_module(library(debug)).

% difinu la aplikaĵon "redaktilo"
/***
:- use_module(redaktilo:library(pengines)).
:- use_module(redaktilo:redaktilo).
***/
%:- use_module(agordo).
%:- use_module(auth).
%:- use_module(xml_quote).
:- use_module(ekzfnt).

:- debug(http(request)).
:- debug(sercho(what)).
:- debug(sercho(stats)).
%:- debug(openid(_)).

:- initialization(init).
:- initialization(help,main).
%%%%%%%%%%%:- thread_initialization(thread_init).


% agordo de citaĵo-servo
http_cit_root('/cikado').
http_cit_host('cikado').
http_cit_port(8000).
http_cit_scheme(http).
http_session_timeout(3600).

init :-
    set_prolog_flag(encoding,utf8),
    %agordo:get_config([
	 http_cit_root(AppRoot),
%	 web_dir(WebDir),
%	 voko_dir(VokoDir),
	 http_cit_scheme(Scheme),
	 http_cit_host(Host),
	 http_cit_port(Port),
	 http_session_timeout(Timeout),
	%]),
    set_setting(http:prefix,AppRoot),
    set_setting(http:public_scheme,Scheme),
    set_setting(http:public_port,Port),
    set_setting(http:public_host,Host),
    http_set_session_options([
	cookie(redaktilo_seanco),
	timeout(Timeout),
	path(AppRoot)
	])
    .
    % la lokaj dosierujoj el kiuj servi dosierojn
%    assert(user:file_search_path(web,WebDir)),
%    assert(user:file_search_path(static,web(static)))
%    assert(user:file_search_path(voko,VokoDir)),

	  
%%http:location(cit,root(cit),[]).

% redirect from / to /citajhoj/, when behind a proxy, this is a task for the proxy
:- http_handler('/', http_redirect(moved,root(.)),[]).
%%:- http_handler(root(.), http_redirect(moved,root('cit/')),[]).
%:- http_handler(cit(.), reply_files, [prefix,authentication(openid)]).
%:- http_handler(static(.), reply_static_files, [prefix]).

%:- http_handler(red(revo_bibliogr), revo_bibliogr, []).
:- http_handler(root(cikado), citajho_sercho, []). %[authentication(ajaxid)]).



help :-
    format('~`=t~51|~n'), 
    format('|               Citaĵo-Serĉo.~t~50||~n'),
    format('~`=t~51|~n~n'),
    format('Programo por lanĉi la Citaĵoserĉservon. Vi povas aŭ~n'),
    format('tajpi interage ĉe la prolog-interpretilo: ~n~n'),
    format('   server(8000) ~n~n'),
    format('por lanĉi la servon ĉe retpordo 8000;~n'),
    format('aŭ lanĉi ĝin kiel fona servo,~n'),
    format('t.e. demono, per la predikato "daemon".~n'),
    format('Vidu la tiucelan skripton "run-search.sh".~n~n'),
    prolog.
	       
server(Port) :-
    http_server(http_dispatch, [port(Port)]).

daemon :-
    http_daemon.

/*******************************************/

%entry_no_cache(Request) :-
%  member(path(Path),Request),
%  sub_atom(Path,_,1,0,'/'),
%  writeln('Cache-Control: no-cache, no-store,  must-revalidate'),
%  writeln('Pragma: no-cache'),
%  writeln('Expires: 0'), !.

%entry_no_cache(_).

/****
reply_files(Request) :-
    % evitu reveni al saluto-paĝo ĉiam denove
%%%   %%% entry_no_cache(Request),

%%    page_auth(Request),
    
    debug(redaktilo(request),'handler reply_files',[]),
    http_reply_from_files(web(.), [indexes(['redaktilo.html'])], Request).

reply_static_files(Request) :-
    % ne protektitaj publikaj dosieroj
    debug(redaktilo(request),'handler reply_static_files',[]),
    http_reply_from_files(static(.), [indexes(['notoj-pri-versio.html'])], Request).
***/

citajho_sercho(Request) :-
%%    ajax_auth(Request),
    debug(redaktilo(auth),'permesite',[]),
    http_parameters(Request,
	    [
	    sercho(Sercho, [length>1,length<500]),
	    kie(Kie, [oneof([vikipedio,anaso,klasikaj,postaj])]) 
	    ]),
    sercho(Kie,Sercho).


% API doc: https://en.wikipedia.org/w/api.php?action=help&modules=query%2Bsearch
% &gsrprop=snippet - ne funkcias aŭ sama kiel extract?
% PRIPENSU: ekskludu riskajn signojn el serĉo: &, ?, / (?)

sercho(vikipedio,Sercho) :-    
    debug(sercho(what),'>>> VIKIPEDIO: ~w',[Sercho]),
    uri_encoded(query_value,Sercho,SerchoEnc),
    UrlBase = 'https://eo.wikipedia.org/w/api.php?format=json&action=query&generator=search&gsrnamespace=0&gsrlimit=50&prop=extracts&exintro&explaintext&exsentences=1&exlimit=max',
    format(atom(Url),'~w&gsrsearch=~w',[UrlBase,SerchoEnc]),
    % Url= 'http://eo.wikipedia.org/w/api.php?action=query&list=search&format=json&indexpageids=true&prop=info&inprop=url&srsearch=homo&srnamespace=0&srprop=snippet&srlimit=16',
    time(http_open(Url,Stream,[])),
    format('Content-type: application/json~n~n'),
    copy_stream_data(Stream,current_output),
    close(Stream),
    debug(sercho(what),'<<< VIKIPEDIO: ~w',[Sercho]) .


sercho(klasikaj,Sercho) :-
    debug(sercho(what),'>>> KLASIKAJ: ~w',[Sercho]),
    (sub_atom(Sercho,_,1,_,' '), sub_atom(Sercho,3,1,_,_)
      ->
%	  show_stats,
	  time(findsmart(50,klasikaj,Sercho,Json))
%	  show_stats,
	  %%% findsmart(50,klasikaj,Sercho,Json)		      
      ;
      findfast(50,klasikaj,Sercho,Json)),
    reply_json(Json),
    debug(sercho(what),'<<< KLASIKAJ: ~w',[Sercho]) .

sercho(postaj,Sercho) :-
    debug(sercho(what),'>>> POSTAJ: ~w',[Sercho]),
    (sub_atom(Sercho,_,1,_,' '), sub_atom(Sercho,3,1,_,_)
      ->
%	  show_stats,
          time(findsmart(50,postaj,Sercho,Json))
%	  show_stats,
%%	  findsmart(50,postaj,Sercho,Json)
      ;
      findfast(50,postaj,Sercho,Json)),
    reply_json(Json),
    debug(sercho(what),'<<< POSTAJ: ~w',[Sercho]).

sercho(anaso,Sercho) :-
    debug(sercho(what),'>>> ANASO: ~w',[Sercho]),
    uri_encoded(query_value,Sercho,SerchoEnc),
    UrlBase = 'https://duckduckgo.com/lite?ia=web&dl=eo',
    format(atom(Url),'~w&q=~w+kaj+la',[UrlBase,SerchoEnc]),
    time(http_open(Url,Stream,[])),
    format('Content-type: text/html~n~n'),
    set_stream(Stream,encoding(utf8)),
    set_stream(current_output,encoding(utf8)),
    copy_stream_data(Stream,current_output),
    close(Stream),
    debug(sercho(what),'<<< ANASO: ~w',[Sercho]).



