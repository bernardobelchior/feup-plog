:-use_module(library(clpfd)).

% initialize_matrix(-Size, -Board)
initialize_matrix(Size, Board):-
  initialize_matrix(Size, Size, Board).
initialize_matrix(Size, 1, []).
initialize_matrix(Size, TmpSize, Board):-
  NewSize is TmpSize - 1,
  initialize_matrix(Size, NewSize, NewBoard),
  initialize_line(Size, Line),
  append(NewBoard, [Line], Board).

initialize_line(Size, Line):-
  length(Line, Size),
  domain(Line, 0, Size).

create_values([Size], Size).
create_values([Value | Rest], Size):-
  NewSize is Size - 1,
  create_values(Rest, NewSize),
  Value is Size.

set_value(1, Value, Value-1).

set_cardinality(Size, _, List):-
  length(Values, Size),
  create_values(Values, Size),
  length(Count, Size),
  maplist(set_value(1), Values, Count),
  global_cardinality(Values, Count).

% solve(+Board, +Size, -SolvedBoard)
solve(Board, Size, SolvedBoard):-
  initialize_matrix(Size, SolvedBoard),

  maplist(set_cardinality(Size), SolvedBoard, SolvedBoard),
  transpose(SolvedBoard, TransposedBoard),
  maplist(set_cardinality(Size), TransposedBoard, TransposedBoard),
%trace,
  %maplist(three_equals_in_a_row, Board, SolvedBoard),

%  no_duplicate_number_in_line(Board),
  %transpose(Board, TransposedBoard),
  %no_duplicate_number_in_line(TransposedBoard),

  labeling([], SolvedBoard).



%no_duplicate_number_in_line([Line, Rest]):-


three_equals_in_a_row([_, _], [_, _]).
three_equals_in_a_row([A, B, C | R], [NewA, NewB, NewC | NewR]):-
  (A #= B #/\
  B #= C #<=> Bool),
  Bool = 1,
  NewA #= 0, NewC #= 0,
  three_equals_in_a_row([B, C | R], [NewB, NewC | NewR]).
three_equals_in_a_row([A | R], [NewA | NewR]):-
  three_equals_in_a_row(R, NewR).
