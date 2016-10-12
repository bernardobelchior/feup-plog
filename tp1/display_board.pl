
:-include('list_utils.pl').
:-include('player.pl').

start:-
  initialize(Players),
  board(Board),
  display_board(Board, Players, 1, 0).

board(Board):-
  Board = [
  [null, null, null, null, '0', '3', 'G', '2', null, null, null],
  [null, null, null, null, 'B', '2', '1', 'X', '1', '1', '1'],
  [null, null, null, '2', '3', '0', '2', '2', 'W', '3', null],
  [null, null, null, '3', 'W', '1', 'R', '1', 'B', '1', null],
  [null, null, '0', '2', '3', '0', '0', '1', '2', null, null],
  [null, null, space, 'R', '3', 'G', '0', '1', 'X', '1', null],
  [null, '3', 'X', 'G', '3', '2', '1', '1', null, null, null],
  [null, space, '1', '3', 'R', 'W', '0', '1', '1', null, null],
  [space, space, space, '1', 'B', '0', '2', null, null, null, null]].

display_board([], Players, Offset, Y).
display_board([Line | Rest], Players, Offset, Y):-
  space(Offset),
  display_line(Line, [-4, Y], Players), nl,
  negate(Offset, NextOffset),
  NextY is Y + 1,
  display_board(Rest, Players, NextOffset, NextY).

display_line([], [X, Y], Players).
display_line([Element | Rest], [X, Y], Players):-
  write_element(Element, [X, Y], Players),
  write_space_if_not_null(Element),
  NextX is X+1,
  display_line(Rest, [NextX, Y], Players).

negate(0, Result):-
  Result is 1.
negate(A, Result):-
  Result is 0.

write_space_if_not_null(null).
write_space_if_not_null(Element):-
  write(' ').

write_element(null, Position, Players).
write_element(space, Position, Players):-
  write(' ').
write_element(Element, Position, Players):-
  get_player_char_in_position(Players, Position, Char),
  write(Char);
  write(Element).

get_player_char_in_position([[PlayerChar | [PlayerPosition]] | Others], Position, Char):-
  equal_position(PlayerPosition, Position),
  Char = PlayerChar;
  get_player_char_in_position(Others, Position, Char).

equal_position([X1,Y1], [X2, Y2]):-
  X1 = X2, Y1 = Y2.

space(0).
space(Count):-
  write(' '),
  C1 is Count - 1,
  space(C1).
