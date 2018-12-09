/* -*- Mode: Prolog -*- */
:- module(redaktilo_auth,
	  [
%	      page_auth/2,
%	      ajax_auth/2
	      request_ajax_id/2,
	      ajax_id_time_valid/1,
	      new_ajax_id/2
	  ]).

:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_parameters)). % reading post data
:- use_module(library(http/http_session)).
:- use_module(library(http/http_header)).
:- use_module(library(http/http_openid)).
:- use_module(library(http/http_host)).
:- use_module(library(http/html_write)).
:- use_module(library(settings)).
:- use_module(library(google_client)).

:- multifile
        google_client:login_existing_user/1,
        google_client:create_user/1.

:- multifile http:location/3, user:body//2.
:- dynamic   http:location/3.

:- use_module(library(debug)).

:- use_module(agordo).
:- use_module(sqlrevo).
:- use_module(param_checks).

% iel aŭtomata utf8 ne funkcias kiam redaktilo-test lanĉiĝas kiel systemd servo (per sistemestro "root")
:- encoding(utf8).

http:location(reg,root(reg),[]).

%:- http_handler(root(redaktilo_saluto), redaktilo_saluto, []).

% openid-paĝoj
:- http_handler(openid(login), revo_login, []).
:- http_handler(openid(oauth2_login), oauth2_login, []).

:- http_handler(openid(verify), openid_verf,
	 [priority(10)]).
%%%
:- http_handler(openid(authenticate), openid_auth, []).

% registro-paĝoj
:- http_handler(reg(revo_registro), revo_registro, []).
:- http_handler(reg(revo_registro1), revo_registro1, []).

user:body(saluto, Body) -->  html(body([onload='checkCookieConsent()'],Body)).


/************* OpenId salutoj ********************/

openid_auth(Request) :-
  entry_no_cache(Request),
  http_openid:openid_authenticate(Request).

openid_verf(Request) :-
    http_openid:openid_verify([ax([email(_,[])])],Request).

http:location(openid, root(openid), []).

:- multifile
	http_openid:openid_hook/1.

http_openid:openid_hook(trusted(_OpenID, Server)) :-
    uri_components(Server,uri_components(Scheme, Authority, _Path, _Search, _Fragment)),
    memberchk(Scheme,[http,https]),
    memberchk(Authority,
	      [ %% 'localhost:8000',
	       'open.login.yahooapis.com'
	      ]),
    debug(openid(test), 'Trusting server ~q', [Server]).

%%'https://open.login.yahooapis.com/openid/op/1.1/auth'
%%'http://kardo:8000/openid/server'

revo_login(Request) :-
%    setting(http:prefix,Root),
%    atom_concat(Root,'/',ReturnTo),
    %atomic_list_concat(['https://revaj.steloj.de',Root,'/'],'',ReturnTo),

    return_to_url(Request,ReturnTo),
    
    reply_html_page(saluto,
		    [ title('Saluto al Redaktilo'),
		      link([rel="stylesheet",type="text/css",href="../css/openid.css"],[]),
		      link([rel="stylesheet",type="text/css",href="../static/static-pages.css"],[]),
		      script([src="../static/kuketoj.js"],[]),
		      script([src="https://code.jquery.com/jquery-3.2.1.js"],[])
		    ],
		    [\redaktilo_saluto([return_to(ReturnTo)])]).

oauth2_login(Request) :-
    oauth_authenticate(Request, 'google.com', [client_data(Request)]).

    
revo_registro(_Request) :-
	once((
		http_session_data(openid(OpenId)),
		atom(OpenId)
		;    
		http_session_data(oauth2id(OpenId)),
		debug(redaktilo(auth),'OAuth2 id: ~q',[OpenId]),
		string(OpenId)
	)),
	reply_html_page([ title('OpenID registro')
		    ],
		    [ \register_email_form(OpenId,[]) ]).


revo_registro1(Request) :-
    http_parameters(Request,
		    [
			retposhto(Retadreso,[length>0,length<100])
		    ]),
	once((
		check_email(Retadreso,RetadresoChecked),
		http_session_data(openid(OpenId)),
		editor_update_openid(RetadresoChecked,OpenId),
		http_session_assert(retadreso(RetadresoChecked)),
		setting(http:prefix,Root),
		http_redirect(moved_temporary,Root,Request)
		;
		check_email(Retadreso,RetadresoChecked),
		http_session_data(oauth2id(SubId)),
		editor_update_subid(RetadresoChecked,SubId),
		http_session_assert(retadreso(RetadresoChecked)),
		setting(http:prefix,Root),
		http_redirect(moved_temporary,Root,Request)
        ;
        % FARENDA: ĉu funkcis jam se la redaktanto havas plurajn retadresojn...?
        % Se la retadreso ne funkcias, avertu la uzanton...
		format('Content-type: text/html; charset=UTF-8~n'),
		format('Status: ~d~n~n',[302]),
		set_stream(current_output,encoding(utf8)),
		write("<html><body><h1>Retadreso ne valida!</h1>"),
		write("<p>Via retadreso ne estas valida aŭ ne jam registrita. Bv. turniĝi al la administrantoj de Reta Vortaro."),
		write("</body></html>")
    )).	    
%   http_status_reply(forbidden('/'),current_output,

register_email_form(OpenId,Options) -->
    {
	http_link_to_id(revo_registro1, [], Registro), % /redaktilo/reg/revo_registro1
	option(action(Action), Options, Registro)
    },
    html(div([ class('openid-login')
		 ],
		 [ %\openid_title,
		   form([ name(register),
			  id(register),
			  action(Action),
			  method('GET')
			],
			[
			    h1(['OpenID - registro de retpoŝtadreso']),
			    div(
			      [style='background-color: #f5f3e5; padding: 2em'],
			      [
			       p(['Vi sukcese salutis per OpenID.']),
			       p(['Necesas ligi vian OpenId kun la retpoŝtadreso ',
				  'uzata de vi kiel redaktanto. ',
				  'Bonvolu doni retpoŝtadreson per kiu vi ',
				  'registriĝis ĉe Reta Vortaro.'
				 ]),
			       p([
					span('Via OpenID:'), br(''),
	     				input([ class('openid-input'),
						name(openid_url),
						id(openid_url),
						value(OpenId),
						readonly(readonly),
						size(50)
					      ])
				    ]),
			       p([
					span('Via repoŝtadreso por redaktado:'), br(''),
					input([ class('openid-input'),
						name(retposhto),
						id(retposhto),
						size(50),
						placeholder('Via retpoŝtadreso')
					      ])
				    ]),
			       input([ type(submit),
				       value('Registru!')
				     ])
				   ])%,
%			  \buttons(Options),
%			  \stay_logged_on(Options)
			])
		 ])).


redaktilo_saluto(Options) -->
    {
	option(return_to(ReturnTo), Options, '/redaktilo/')
    },
    html(div([class="openid-login"],
	     [div([class="openid-title",style="background-image: linear-gradient(90deg, white, transparent);padding: 1em"],
	          [a([href="http://openid.net/"],
	             [img([src="../icons/openid-logo-square.png",alt="OpenID"],[])]),
		   span('Saluto per OpenID')]),

	      p(['Per ensalutado al Redaktilo tra via Yahoo- aŭ Google-konto vi konsentas uzi viajn personajn informojn kiel priskribita detale en la ',
		 a([href="../static/datumprotekto.html"],['Datumprotekta Deklaro']),'.']),

	      form([name="oauth2",id="oauth2",action="oauth2_login",method="GET"],
		   div([style="background-image: linear-gradient(90deg,#f5f3e5,transparent); padding: 2em; margin-bottom: 1em"],
		       [p(['Se vi havas konton ĉe Guglo:']),
		        input([type="image",id=google_login,src="../static/btn_google_signin_light_normal_web.png",disabled=disabled,
			       alt="Saluto per Google",title="Salutu per Google-konto",value="Google",style="margin-left:1em"])])),
	      
	      form([name="login",id="login",action="verify",method="GET"],
		   [input([type="hidden",id="return_to",name="openid.return_to",value=ReturnTo],[]),
		    input([type="hidden",name="openid_url",id="openid_url",value="https://me.yahoo.com"],[]),
		    div([style="background-image: linear-gradient(90deg,#f5f3e5,transparent); padding: 2em"],
			[p(['Se vi havas konton ĉe Yahoo:']),
			 input([type="image",id=yahoo_login,src="../static/btn_yahoo_signin.png",onclick="javascript:{$('form#login').submit();}",disabled=disabled,
				alt="Saluto per Yahoo",title="Salutu per Yahoo-konto",style="margin-left:1em"],[])
			])]),
	      
	      div([p(['Mi rekomendas informiĝi per ',a([href="../static/notoj-pri-versio.html"],['"Notoj kaj konsiloj"']),
		     ' pri uzado de la redaktilo kaj konataj eraroj.']),
		   p(['Aktuale estas jenaj antaŭkondiĉoj por povi saluti al la redaktilo:',
		      ul([li('Vi devas esti registrita redaktanto ĉe Reta Vortaro.'),
			  li('Vi havas konton ĉe Google aŭ Yahoo, permesanta saluti.'),
			  li(['Salutante per Yahoo: via havas OpenId (vd. ',
			     a([href="https://me.yahoo.com"],['https://me.yahoo.com']),
			     ', vi povas registri ĝin dum unua saluto).'])
			 ]),
		      'Identigiloj de aliaj OpenId-provizantoj ankoraŭ ne estas subtenataj. ',
		      'Sed vi povas peti ĉe la administranto de Reta Vortaro por la sekva versio se vi bezonas.'])
		  ]),
	      div([class='kuketoaverto',id='kuketoaverto'],
		  [p(['Ni uzas kuketojn (retumilajn memoretojn). Uzante nian servon vi konsentas al konservado de informoj en kuketoj ',
		      'kaj uzo de via retadreso kaj nomo por identigi vin kaj marki viajn redaktojn. ',
		      'Eksciu pli pri la uzado de personaj datumoj en la ',
		      a([href='../static/datumprotekto.html'],['datumprotekta deklaro']),'.',br(''),br(''),
                      button([name='konfirmo',onClick='setCookieConsent()'],['Mi konfirmas'])
			 ]),
		   p([img([src='../static/kaefer2.png'])])
		  ])])
	 ).


% a) kontrolu, ĉu la uzanto jam salutis tra Google (OAuth2)
% b) se ne, voku openid_saluto, tio kontrolas, ĉu salutis per Yahoo (OpenId), se ne iras a saluto-paĝo
% c) se salutis per OpenId kontrolu ĉu la retadreso jam estas kaj se ne provu akiri ĝin de Yahoo aŭ per registropaĝo

page_auth(Request,RedID) :-
   %%% http_open_session(_Id, []),

    once((
		oauth2_id(RedID)
		;
		openid_saluto(Request,RedID)
    )).

% se jam sukcese salutis per OAuth2 -> bone
% se ne kontroliĝos ĉu sukcese salutis per OpenId (vd. page_auth, dua opcio)
% se tute ne jam salutis openid_user transiros al saluto-pago, kaj tie oni povas saluti
% kaj per Yahoo (OpenId) kaj per Google (OAuth2)

oauth2_id(RedID) :-
    % salutinta per OpenId Connect (OAuth2)
    http_session_data(oauth2id(_UserOAuthId)),
    % kaj retpoŝtadreso jam eltrovita
    http_session_data(retadreso(_)),
    http_session_data(red_id(RedID)).

google_client:login_existing_user(Claim) :-
    SubId = Claim.sub,
    http_session_assert(oauth2id(SubId)),
		  
    % trovu uzanton per subid aŭ email,
    % se ambau ne funkcias necesas registri lin/ŝin (per create_user)		  
    once((
	% trovu tiun ĉi uzanton inter la redaktantoj per UserOpenId
	editor_by_subid(SubId,row(RedID,_,Retadreso))
	%http_session_assert(retadreso(Retadreso))
	;
	% se ne trovita, ĉu ni ricevis konatan retadreson per Claim?
	Claim.email_verified = 'true',
        editor_by_email(Claim.email,row(RedID,_,_,Retadreso)) % preferata retadreso povas devii de Claim.email
        % , fail % por testi registradon...
	%http_session_assert(retadreso(Retadreso))
    )),
    
    %http_session_assert(oauth2id(Claim.sub)),
    http_session_assert(retadreso(Retadreso)),
    http_session_assert(red_id(RedID)),
    http_redirect(moved_temporary, '../red/', Claim.client_data).


% se ankoraŭ ne trovita demandu la retadreson per retpaĝo

google_client:create_user(Profile) :-
    http_redirect(moved_temporary, '../reg/revo_registro', Profile.client_data).

openid_saluto(Request,RedID) :-
    % debug(redaktilo(auth),'~q',[Request]),
    openid_user(Request, UserOpenId, []),
    % debug(redaktilo(auth),'openid: ~q',[UserOpenId]),
	once((
		% retpoŝtadreso jam eltrovita
		http_session_data(retadreso(_)),
			http_session_data(red_id(RedID))
		;
		% trovu tiun ĉi uzanton inter la redaktantoj per UserOpenId
		editor_by_openid(UserOpenId,row(RedID,_,Retadreso)),
		http_session_assert(retadreso(Retadreso))
		;							
		% se ne trovita, ĉu ni ricevis konatan retadreson per ax-atributo?
		http_session_data(ax(Values)),
		memberchk(email(Email),Values),
		editor_by_email(Email,row(RedID,_,_,Retadreso)), % preferata retadreso povas devii de Email
		http_session_assert(retadreso(Retadreso)),
		http_session_assert(red_id(RedID))
		;
		% se ankoraŭ ne trovita demandu la retadreson per retpaĝo
		%	throw(http_redirect(moved_temporary, 'revo_registro.html', Request))
		http_redirect(moved_temporary, '../reg/revo_registro', Request)
    )).
    
ajax_auth(Request,RedID) :-
    once((
	ajax_user(Request,RedID,ClientIP),
	debug(redaktilo(ajaxid),'AjaxAuth: ~q ~q',[RedID,ClientIP])
	;
	% kreu AjaxID el session+request
	new_ajax_id_cookie(Request,RedID,Cookie),
	debug(redaktilo(ajaxid),'AjaxID: ~q',[Cookie]),
	format('Set-Cookie: ~w\r\n',[Cookie])
	      %user_auth(Request)
	; % Ajax-hash ne (plu) valida, necesas resaluto
%	memberchk(path(Path), Request),
%	throw(http_reply(forbidden(Path))) %,'Tro longa tempo pasis post saluto, necesas resaluti nun.')))
	format('Status: ~d~n~n',[401]),
	throw(http_reply(html([': Tro longa tempo pasis post saluto, necesas resaluti nun.\n'])))
    )). 

% identigo per kuketo AjaxID, kiu konsistas el redaktanto ID kaj kuketo-kreo-tempo signitaj per HMAC
% en la kalkulado de HMAC eniras ankaŭ la klienta IP, tiel ke ĝi ne validas por alia kliento se li
% ŝtelis ĝin

ajax_user(Request,RedID,ClientIP) :-
    %debug(redaktilo(ajaxid),'AjaxRequest ~q',[Request]),
    member(peer(ip(A,B,C,D)),Request),
    %debug(redaktilo(ajaxid),'AjaxID_a ~q',[Cookies]),
    atomic_list_concat([A,B,C,D],'.',ClientIP),
    %debug(redaktilo(ajaxid),'AjaxID_b ~q',[ClientIP]),
    request_ajax_id(Request,AjaxID),
    %debug(redaktilo(ajaxid),'AjaxID_c ~q ~q',[AjaxID,ClientIP]),
    sub_atom(AjaxID,0,20,_,RedID),
    sub_atom(AjaxID,20,8,_,HexTime),
    sub_atom(AjaxID,28,20,0,HexMac),
    %debug(redaktilo(ajaxid),'AjaxID_d ~q ~q ~q',[RedID,HexTime,HexMac]),
    % is the cookie still valid?
    ajax_id_time_valid(AjaxID),
    % is the hmac hash valid?
    ajax_hmac(RedID,ClientIP,HexTime,HexMac),
    % save in session if already closed
    sqlrevo:email_redid(Retadreso,RedID),
    (http_session_data(retadreso(Retadreso))
     -> true
     ;  http_session_assert(retadreso(Retadreso))
    ).

ajax_id_time_valid(AjaxID) :-
    sub_atom(AjaxID,20,8,_,HexTime), 
    get_time(Now), hex_value(HexTime,Time),
    Valid is Time + 24 * 3600,
    %http_timestamp(Valid,ValidTill),
    Valid > Now.

request_ajax_id(Request,AjaxID) :-
    once((
	% normale AjaxID estu en la kuketo
	member(cookie(Cookies),Request),
	member(redaktilo_ajax=AjaxID,Cookies)
	;
	% permesu AjaxID ankaŭ kiel URL-parametro, ekz. por elprovi la citajho-serchon     
        member(search(Search),Request),
	member(redaktilo_ajax=AjaxID,Search)
    )).

/******************************* helpopredikatoj **********************/

entry_no_cache(_Request) :-
%  http_clean_location_cache,
%  member(path(Path),Request),
%  sub_atom(Path,_,1,0,'/'),
  writeln('Cache-Control: no-cache, no-store,  must-revalidate'),
  writeln('Pragma: no-cache'),
  writeln('Expires: 0'), !.

return_to_url(_Request,Url) :-
%    setting(http:prefix,AppRoot),
%    atom_concat(AppRoot,'/',Url).
%     http_openid:public_url(Request,Url).
	agordo:get_config([
		http_app_root(AppRoot),
		http_app_scheme(Scheme),
		http_app_host(Host),
		http_app_port(Port)
	 ]),
    (scheme_port(Scheme,Port)
    -> format(atom(Url),'~w://~w~w',[Scheme,Host,AppRoot])
    ; format(atom(Url),'~w://~w:~w~w',[Scheme,Host,Port,AppRoot])).

scheme_port(http,80).
scheme_port(https,443).

hex_value(Hex,Val) :-
	atom_codes(Hex,Codes),
	hex_value_(Codes,_,Val).
    
hex_value_([H|T],Shift,Val) :-
    hex_value_(T,Sh,V),
    (H =< 57 -> D is H-48 ; D is H - 87),
    Val is D << Sh \/ V,
    Shift is Sh + 4.

hex_value_([],0,0).
	     
new_ajax_id(Request,AjaxID) :-
    new_ajax_id(Request,_,AjaxID,_).
	   
new_ajax_id(Request,RedId,AjaxID,Time) :-
    % get client information
    %debug(redaktilo(ajaxid),'AjaxID_1 ~q',Request),
    member(peer(ip(A,B,C,D)),Request),
    %debug(redaktilo(ajaxid),'AjaxID_2 ~q ~q',[A,B]),
    atomic_list_concat([A,B,C,D],'.',ClientIP),
    http_session_data(retadreso(Retadreso)),
    sqlrevo:email_redid(Retadreso,RedId),
    debug(redaktilo(ajaxid),'AjaxID_3 ~q ~q',[RedId,Retadreso]),
    % calculate hmac
    get_time(Time), Seconds is floor(Time),
    format(atom(HexTime),'~16r',[Seconds]),
    ajax_hmac(RedId,ClientIP,HexTime,HexMac20),
    atomic_list_concat([RedId,HexTime,HexMac20],'',AjaxID).
    %debug(redaktilo(ajaxid),'AjaxID_6 ~q ~q',[String,AjaxID]),
 

new_ajax_id_cookie(Request,RedID,Cookie) :-
    new_ajax_id(Request,RedID,AjaxID,Time),	
    setting(http:prefix,Prefix),
    Time24 is Time + 240 * 3600,
    http_timestamp(Time24,Expires),
    format(atom(Cookie),'redaktilo_ajax=~w;Expires=~w;Path=~w; Version=1',
	   [AjaxID,Expires,Prefix]).

ajax_hmac(RedId,ClientIP,HexTime,HexMac20) :-
    %debug(redaktilo(ajaxid),'AjaxID_hmac ~q ~q ~q',[RedId,ClientIP,HexTime]),
    atomic_list_concat([RedId,ClientIP,HexTime],String),
    agordo:get_config(ajax_secret,AjaxSecret),
    %debug(redaktilo(ajaxid),'AjaxID_hmac ~q ~q',[String,AjaxSecret]),
    hmac_sha(AjaxSecret,String,HMac,[algorithm(sha256)]),
    hash_atom(HMac,Hex), sub_atom(Hex,0,20,_,HexMac20).

/*
% FIXME: necesas korekti tion, ĉar "*" ne rilatas al la antaŭa signo kiel en regex, sed funkcias kiel sur uniksa komandlinio (dosiernomoj)
% same en sqlrevo
% krome forigu laŭbezone " " (normalize_space) kaj "<" ">" ĉirkaŭ la retadreso - aŭ en JS aŭ tie ĉi....
% krome necesas taŭga eraromesaĝo se la retpoŝtadreso sintakse estas neĝusta (revo_registro1)

check_email(Email) :-
    once((
	wildcard_match('[a-zA-Z_.0-9]*@[a-zA-Z_.0-9]*',Email)
      ;
      throw(invalid_email_param(Email))
	    )).
*/

:- multifile
        http:authenticate/3.

http:authenticate(openid,Request,[User]) :-
    page_auth(Request,User).
http:authenticate(ajaxid,Request,[User]) :-
    ajax_auth(Request,User).
