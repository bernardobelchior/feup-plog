:-use_module(library(random)).
:-use_module(library(clpfd)).
:-use_module(library(lists)).


%
generate_board(_, []).
generate_board(Size, [Line | Rest]):-
  length(Line, Size),
  generate_line(Size, Line),
  generate_board(Size, Rest).

% initialize_line(BoardLine, SolvedBoardLine).
generate_line(_, []).
generate_line(Size, [S | Ss]):-
  PlusSize is Size + 1,
  %random(1, PlusSize, Min),
  %random(Min, PlusSize, Max),
  %S in Min..Max,
  S in 1..Size,
  generate_line(Size, Ss).
/*generate_line(Size, [S | Ss]):-
  random(Number),
  Square is Size*Size,
  Number < 8 / Square,

  random(1, Size, Tile),
  S in (Tile..Tile),
  generate_line(Size, Ss).

generate_line(Size, [S | Ss]):-
  PlusSize is Size + 1,
  random(1, PlusSize, Min),
  random(Min, PlusSize, Max),
  S in Min..Max,
  generate_line(Size, Ss).*/


%
restrict_element(Elem, Row, Column):-
  restrict_element(Elem, Row, Column, BoolRows, BoolCols),
  sum(BoolRows, #=, EqualsInRow),
  sum(BoolCols, #=, EqualsInCol),
  EqualsInCol + EqualsInRow #> 1.

restrict_element([], [], [], []).

restrict_element(Elem, [ElemInRow | ElemsInRow], [ElemInCol | ElemsInCol], [BoolRow | BoolRows], [BoolCol | BoolCols]):-
  ElemInRow #= Elem #=> BoolRow,
  ElemInCol #= Elem #=> BoolCol,
  restrict_element(Elem, ElemsInRow, ElemsInCol, BoolRows, BoolCols).


%
restrict_line(Row, Columns):-
  restrict_line(Row, Row, Columns).

restrict_line([], _, _).

restrict_line([Elem | Rest], Row, [Column | Columns]):-
  fd_size(Elem, DomainSize),
  DomainSize > 1,
  restrict_element(Elem, Row, Column),
  restrict_line(Rest, Row, Columns).

restrict_line([_ | Rest], Row, [_ | Columns]):-
  restrict_line(Rest, Row, Columns).


%
restrict_board([], _).
restrict_board([Row | Rows], Columns):-
  restrict_line(Row, Columns),
  restrict_board(Rows, Columns).




label_matrix([]).
label_matrix([Row | Rows]):-
  labeling([bisect], Row),
  label_matrix(Rows).


%generate_equals()

no_sequential_equals([_]).
no_sequential_equals([E1, E2 | Rest]):-
  E1 #\= E2,
  no_sequential_equals([E2 | Rest]).


randomize_line(_, []).
randomize_line(Size, [Elem | Rest]):-
  random(1, Size, Domain),
  Elem #>= Domain,
  Elem #=< Domain + 1,
  randomize_line(Size, Rest).

generate(Size, Board):-
  length(Board, Size),
  generate_board(Size, Board),
  transpose(Board, Columns),

  maplist(no_sequential_equals, Board),
  maplist(no_sequential_equals, Columns),

  maplist(randomize_line(Size), Board),

  label_matrix(Board).

  %maplist(labeling([maximize()]), Board).
