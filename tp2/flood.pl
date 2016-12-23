sum_matrix([], []).
sum_matrix([Row | Rows], [Sum | Sums]):-
  sum(Row, #=, Sum),
  sum_matrix(Rows, Sums).

restrict_divisions(Board, Size, [FloodRow | FloodRows]):-
  element(StartX, FloodRow, 0),
  flood([FloodRow | FloodRows], Size, StartX),
  sum_matrix([FloodRow | FloodRows], RowsSum),
  sum(RowsSum, #=, Sum),
  Sum #= Size.


flood(FMatrix, Size, StartX):-
  Propagate #= 1,
  flood(FMatrix, Size, StartX, 1, Propagate).

flood(_, _, 0, _, _).
flood(_, _, _, 0, _).
flood(_, _, X, _, _):- X is Size + 1.
flood(_, _, _, Y, _):- Y is Size + 1.

flood(FMatrix, Size, X, Y, 1):-
  element(Y, FloodMatrix, Row),
  element(X, Row, Elem),

  (#\ Elem) #/\ Propagate #<=> NextPropagate,
  Elem #= Propagate,

  XPlus1 #= X + 1,
  YPlus1 #= Y + 1,
  XMinus1 #= X - 1,
  YMinus1 #= Y - 1,

  flood(FMatrix, XPlus1, Y, NextPropagate),
  flood(FMatrix, X, YPlus1, NextPropagate),
  flood(FMatrix, XMinus1, Y, NextPropagate),
  flood(FMatrix, X, YMinus1, NextPropagate).
