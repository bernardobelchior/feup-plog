%unidimensional list utilities

list_get_nth([X|Xs],0,X).
list_get_nth([Y|Ys],N,X) :- N1 is N-1, list_get_nth(Ys,N1,X).

list_delete_all([X|Xs],X,Ys) :- list_delete_all(Xs,X,Ys).
list_delete_all([X|Xs],Z,[X|Ys]) :- X \= Z,list_delete_all(Xs,Z,Ys).
list_delete_all([],X,[]).

list_delete_nth([X|Xs],0,Xs).
list_delete_nth([X|Xs],N,[X|Ys]) :- N1 is N-1, list_delete_nth(Xs,N1,Ys).

list_append([],Ys,Ys).
list_append([X|Xs],Ys,[X|Zs]) :- append(Xs,Ys,Zs).

list_slice([X|Xs],0,Xs).
list_slice([X|Xs],N,Zs) :- N1 is N-1, list_slice(Xs,N1,Zs).

list_replace_all([X|Xs],X,Z,[Z|Zs]) :- list_replace_all(Xs,X,Z,Zs).
list_replace_all([X|Xs],Y,Z,[X|Zs]) :- list_replace_all(Xs,Y,Z,Zs).
list_replace_all([],Y,Z,[]).

list_replace_nth([X|Xs],0,Z,[Z|Xs]).
list_replace_nth([X|Xs],N,Z,[X|Zs]) :- N1 is N-1, list_replace_nth(Xs,N1,Z,Zs).

list_length([],0).
list_length([X|Xs],N) :- list_length(Xs,N1), N is N1+1.

%bidimensional list utilities

list_get_xy([L|Ls],X,Y,Z) :- list_get_nth([L|Ls],Y,K), list_get_nth(K,X,Z).

is_empty([]).
