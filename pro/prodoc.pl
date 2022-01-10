:- use_module(library(doc_files)).
%:- use_module(library(pldoc/doc_library)).
%:- doc_load_library.

%:- doc_server(4000).
:- portray_text(true).

:- ensure_loaded('tekstanalizo').
:- ensure_loaded('ekzfnt').

save :- doc_save(.,[doc_root('../prodoc'),public_only(false)]).
:- save.


