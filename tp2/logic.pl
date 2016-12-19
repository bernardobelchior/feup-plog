:-use_module(library(clpfd)).

% initialize_matrix(+Board, -SolvedBoard).
initialize_matrix([], Size, []).
initialize_matrix([B | Bs], Size, [S | Ss]):-
    initialize_line(B, Size, S),
    initialize_matrix(Bs, Size, Ss).

% initialize_line(BoardLine, SolvedBoardLine).
initialize_line([], _, []).
initialize_line([E | Es], Size, [S | Ss]):-
  MaxNumber is Size * Size,
  S in (E..E) \/ (Size..MaxNumber),
  initialize_line(Es, Size, Ss).


% no_sequential_zeros(+Size, +List).
no_sequential_blacks(_, [_]).
no_sequential_blacks(Size, [E1, E2 | Rest]):-
  E1 #>= Size #=> E2 #< Size,
  no_sequential_blacks(Size, [E2 | Rest]).
no_sequential_blacks(Size, [E1, E2 | Rest]):-
  E2 #>= Size #=> E1 #< Size,
  no_sequential_blacks(Size, [E2 | Rest]).

% solve(+Board, +Size, -SolvedBoard)
solve(Board, Size, SolvedBoard):-
  initialize_matrix(Board, Size, SolvedBoard),

  transpose(SolvedBoard, TransposedBoard),
  %trace,
  %maplist(no_sequential_blacks(Size), SolvedBoard),
  %maplist(no_sequential_blacks(Size), TransposedBoard),
  %notrace,
  maplist(all_distinct, SolvedBoard),
  maplist(all_distinct, TransposedBoard),
  maplist(labeling([]), SolvedBoard).


three_equals_in_a_row([_, _], [_, _]).
three_equals_in_a_row([A, B, C | R], [NewA, NewB, NewC | NewR]):-
  (A #= B #/\
  B #= C #<=> Bool),
  Bool = 1,
  NewA #= 0, NewC #= 0,
  three_equals_in_a_row([B, C | R], [NewB, NewC | NewR]).
three_equals_in_a_row([A | R], [NewA | NewR]):-
  three_equals_in_a_row(R, NewR).
