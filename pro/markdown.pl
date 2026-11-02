/* -*- Mode: Prolog -*- */
:- module(markdown,[
    parse_markdown_file/3
]).

:- set_prolog_flag(encoding,utf8).
:- use_module(library(yaml)).


:- multifile yaml:tagged/3.
:- dynamic yaml:tagged/3.

% legu marktekston laŭlinie distingante la kapon de la ĉefa enhavo
parse_markdown_file(FilePath, FrontmatterDict, Body) :-
    setup_call_cleanup(
        open(FilePath, read, Stream, [encoding(utf8)]),
        read_frontmatter_and_body(Stream, FrontmatterDict, Body),
        close(Stream)
    ).

% laŭlinia legado rekonante '---' kiel limo de la kapo
read_frontmatter_and_body(Stream, Frontmatter, Body) :-
    read_line_to_string(Stream, Line1),
    (   Line1 == end_of_file
    ->  % malplena dosiero!?
        Frontmatter = _{}, 
        Body = ""
    ;   normalize_space(string(KapLimo), Line1),
        (   KapLimo == "---"
        ->  % legu ekde la kapkomenco
            collect_fm_lines(Stream, [], FM_Lines),
            atomic_list_concat(FM_Lines, "\n", FM_String),
            %catch(yaml_read(string(FM_String), Frontmatter), _, Frontmatter = _{}),
            %yaml_read(string(FM_String), Frontmatter),
            yaml_read_string(FM_String, Frontmatter), %uzu provizoran pred. dum yaml_read eraras pri UTF-8
            % legu la ceteron kiel ĉefenhavon
            read_string(Stream, _Len, Body)
        ;   % ŝajne la dokumento ne havas kapon, t.e. la unua linio ne estas '---'
            read_string(Stream, _Len, RestBody),
            format(string(Body), '~s\n~s', [Line1, RestBody]),
            Frontmatter = _{}
        )
    ).

% kolektu kap-liniojn (YAML-strukturon) ĝis fina "---" aŭ "..."
collect_fm_lines(Stream, Acc, FM_Lines) :-
    read_line_to_string(Stream, Line),
    (   Line == end_of_file
    ->  FM_Lines = Acc
    ;   normalize_space(string(KapLimo), Line),
        (   (KapLimo == "---" ; KapLimo == "...")
        ->  FM_Lines = Acc
        ;   append(Acc, [Line], NewAcc),
            collect_fm_lines(Stream, NewAcc, FM_Lines)
        )
    ).

% provizora solvo de UTF-8-eraro en yaml_read (2026-11-02)
% (de J. Wielemaker+Claude)
yaml_read_string(String, DOM) :-
    setup_call_cleanup(
        new_memory_file(MF),
        ( setup_call_cleanup(
                open_memory_file(MF, write, Out, [encoding(utf8)]),
                write(Out, String),
                close(Out)),
            setup_call_cleanup(
                open_memory_file(MF, read, In, [encoding(octet)]),
                yaml_read(In, DOM),
                close(In))),
        free_memory_file(MF)).
