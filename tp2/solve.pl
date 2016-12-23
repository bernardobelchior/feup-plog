:-use_module(library(clpfd)).

% initialize_matrix(+Board, +Size, -ConstrainedBoard).
initialize_matrix([], _, []).
initialize_matrix([B | Bs], Size, [S | Ss]):-
    initialize_line(B, Size, S),
    initialize_matrix(Bs, Size, Ss).


% initialize_line(+BoardLine, +Size, -ConstrainedLined).
initialize_line([], _, []).
initialize_line([E | Es], Size, [S | Ss]):-
  MaxNumber is Size*Size,
  PlusSize is Size + 1,
  S in (E..E) \/ (PlusSize..MaxNumber),
  initialize_line(Es, Size, Ss).


% no_sequential_blacks(+Size, +List).
no_sequential_blacks(_, [_]).
no_sequential_blacks(Size, [E1, E2 | Rest]):-
  #\ (E1 #> Size #/\ E2 #> Size), % There can't be two consecutive black tiles.
  no_sequential_blacks(Size, [E2 | Rest]).


% three_equals_in_a_row(+Size, +Line)
three_equals_in_a_row(_, [_, _]).
three_equals_in_a_row(Size, [First, Second, Third | Rest]):-
  (First #= Second #/\ Second #= Third)
  #=> (First #> Size #/\ Third #> Size),
  three_equals_in_a_row(Size, [Second, Third | Rest]).

get_element(Board, X, Y, Inputs, [Element | Inputs]):-
  nth1(Y, Board, Row),
  nth1(X, Row, Element).
get_element(_, _, _, Inputs, Inputs).

get_adjacent(Board, X, Y, Adjacent):-
  XPlus1 is X + 1,
  YPlus1 is Y + 1,
  XMinus1 is X - 1,
  YMinus1 is Y - 1,
  get_element(Board, XPlus1, Y, [], Tmp1),
  get_element(Board, X, YPlus1, Tmp1, Tmp2),
  get_element(Board, XMinus1, Y, Tmp2, Tmp3),
  get_element(Board, X, YMinus1, Tmp3, Adjacent).


% count_blacks(+Size, +AdjacentElements, -ListBlacks):-
count_blacks(_, [], []).
count_blacks(Size, [Elem | Rest], [IsBlack | Blacks]):-
  Elem #> Size #<=> IsBlack,
  count_blacks(Size, Rest, Blacks).



%
no_surrounded_tiles(Size, Board):-
  no_surrounded_tiles(Size, Board, 1, 1).

no_surrounded_tiles(Size, Board, X, Y):-
  X is Size + 1,
  NextY is Y + 1,
  no_surrounded_tiles(Size, Board, 1, NextY).
no_surrounded_tiles(Size, _, _, Y):-
  Y is Size + 1.
no_surrounded_tiles(Size, Board, X, Y):-
  get_adjacent(Board, X, Y, Adjacent),
  count_blacks(Size, Adjacent, CountBlacks),
  length(Adjacent, NumAdjacents),
  sum(CountBlacks, #<, NumAdjacents),

  NextX is X + 1,
  no_surrounded_tiles(Size, Board, NextX, Y).



% solve(+Board, +Size, -SolvedBoard)
solve(Board, Size, SolvedBoard):-
  initialize_matrix(Board, Size, SolvedBoard),
  transpose(SolvedBoard, TransposedBoard), !,

  maplist(three_equals_in_a_row(Size), SolvedBoard),
  maplist(three_equals_in_a_row(Size), TransposedBoard),

  maplist(all_distinct, SolvedBoard),
  maplist(all_distinct, TransposedBoard),

  maplist(no_sequential_blacks(Size), SolvedBoard),
  maplist(no_sequential_blacks(Size), TransposedBoard),

  no_surrounded_tiles(Size, SolvedBoard),

  maplist(labeling([]), SolvedBoard).
