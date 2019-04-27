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
:- debug(cikado(_)).
%:- debug(cikado(stats)).

:- initialization(init).
:- initialization(help,main).
%%%%%%%%%%%:- thread_initialization(thread_init).


% agordo de citaĵo-servo
http_cit_root('/cikado').
http_cit_host('cikado').
http_cit_port(8082).
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
    
    % ,debug(http(request))
    % ,debug(cikado(_))
    %assert(user:file_search_path('verkoj','../steloj.de'))
    . 
    % la lokaj dosierujoj el kiuj servi dosierojn
%    assert(user:file_search_path(web,WebDir)),
%    assert(user:file_search_path(static,web(static)))
%    assert(user:file_search_path(voko,VokoDir)),

%%% http://<host:port>/cikado/verkoj -> ../steloj.de

user:file_search_path('steloj','../steloj.de'). % uzata en reply_static_files
http:location(verkoj,root(verkoj),[]).
:- http_handler(verkoj(.), reply_static_files, [prefix]).
% redirect from / to /cikado/verkoj/, when behind a proxy, this is a task for the proxy
:- http_handler('/', http_redirect(moved,root(verkoj)),[]).


%%% http://<host:port>/cikado/cikado -> serĉo

%%:- http_handler(root(.), http_redirect(moved,root('cit/')),[]).
%:- http_handler(cit(.), reply_files, [prefix,authentication(openid)]).
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
**/

reply_static_files(Request) :-
    % ne protektitaj publikaj dosieroj
    debug(cikado(request),'handler reply_static_files',[]),
    http_reply_from_files(steloj(.), [indexes(['index.html'])], Request).

citajho_sercho(Request) :-
%%    ajax_auth(Request),
    %debug(cikado(auth),'permesite',[]),
    http_parameters(Request,
	    [
	    sercho(Sercho, [length>1,length<500]),
	    kie(Kie, [oneof([klasikaj,postaj])]) 
	    ]),
    sercho(Kie,Sercho).


sercho(klasikaj,Sercho) :-
    debug(cikado(what),'>>> KLASIKAJ: ~w',[Sercho]),
    (sub_atom(Sercho,_,1,_,' '), sub_atom(Sercho,3,1,_,_)
      ->
%	  show_stats,
	  time(findsmart(50,klasikaj,Sercho,Json))
%	  show_stats,
	  %%% findsmart(50,klasikaj,Sercho,Json)		      
      ;
      findfast(50,klasikaj,Sercho,Json)),
    reply_json(Json),
    debug(cikado(what),'<<< KLASIKAJ: ~w',[Sercho]) .


sercho(postaj,Sercho) :-
    debug(cikado(what),'>>> POSTAJ: ~w',[Sercho]),
    (sub_atom(Sercho,_,1,_,' '), sub_atom(Sercho,3,1,_,_)
      ->
%	  show_stats,
          time(findsmart(50,postaj,Sercho,Json))
%	  show_stats,
%%	  findsmart(50,postaj,Sercho,Json)
      ;
      findfast(50,postaj,Sercho,Json)),
    reply_json(Json),
    debug(cikado(what),'<<< POSTAJ: ~w',[Sercho]).
