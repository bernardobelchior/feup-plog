start:-
  board(Board),
  display_board(Board, 1).

board(Board):-
  Board = [
  [null, null, null, null, 'O', 'O', 'O', 'O', null, null, null],
  [null, null, null, null, 'O', 'O', 'O', 'X', 'O', 'O', 'O'],
  [null, null, null, 'O', 'O', 'O', 'O', 'O', 'W', 'O', null],
  [null, null, null, 'O', 'W', 'O', 'O', 'O', 'O', 'O', null],
  [null, null, 'O', 'O', 'O', 'O', 'O', 'O', 'O', null, null],
  [null, null, space, 'O', 'O', 'O', 'O', 'O', 'X', 'O', null],
  [null, null, 'O', 'X', 'O', 'O', 'O', 'O', 'O', null, null],
  [null, space, 'O', 'O', 'O', 'W', 'O', 'O', 'O', null, null],
  [null, space, space, space, 'O', 'O', 'O', 'O', null, null, null]].

display_board([], Offset).
display_board([Line | Rest], Offset):-
  space(Offset),
  display_line(Line), nl,
  negate(Offset, NextOffset),
  display_board(Rest, NextOffset).

display_line([]).
display_line([Element | Rest]):-
  write_element(Element),
  write_space_if_not_null(Element),
  display_line(Rest).

negate(0, Result):-
  Result is 1.
negate(A, Result):-
  Result is 0.

write_space_if_not_null(null).
write_space_if_not_null(Element):-
  write(' ').

write_element(null).
write_element(space):-
  write(' ').
write_element(Element):-
  write(Element).

space(0).
space(Count):-
  write(' '),
  C1 is Count - 1,
  space(C1).
