
:-include('list_utils.pl').
:-include('player.pl').

start:-
  board(Board),
  display_board(Board, 1, 0).

board(Board):-
  Board = [
  [null, null, null, null, 'O', 'O', 'O', 'O', null, null, null],
  [null, null, null, null, 'O', 'O', 'O', 'X', 'O', 'O', 'O'],
  [null, null, null, 'O', 'O', 'O', 'O', 'O', 'W', 'O', null],
  [null, null, null, 'O', 'W', 'O', 'O', 'O', 'O', 'O', null],
  [null, null, 'O', 'O', 'O', 'O', 'O', 'O', 'O', null, null],
  [null, null, space, 'O', 'O', 'O', 'O', 'O', 'X', 'O', null],
  [null, 'O', 'X', 'O', 'O', 'O', 'O', 'O', null, null, null],
  [null, space, 'O', 'O', 'O', 'W', 'O', 'O', 'O', null, null],
  [space, space, space, 'O', 'O', 'O', 'O', null, null, null, null]].

display_board([], Offset, Y).
display_board([Line | Rest], Offset, Y):-
  space(Offset),
  display_line(Line, [-4, Y]), nl,
  negate(Offset, NextOffset),
  NextY is Y + 1,
  display_board(Rest, NextOffset, NextY).

display_line([], [X, Y]).
display_line([Element | Rest], [X, Y]):-
  write_element(Element, [X, Y]),
  write_space_if_not_null(Element),
  NextX is X+1,
  display_line(Rest, [NextX, Y]).

negate(0, Result):-
  Result is 1.
negate(A, Result):-
  Result is 0.

write_space_if_not_null(null).
write_space_if_not_null(Element):-
  write(' ').

write_element(null, Position).
write_element(space, Position):-
  write(' ').
write_element(Element, Position):-
  players(Players), check_and_display_players(Players, Position);
  write(Element).

check_and_display_players([Player | Rest], Position):-
  player(Player, PlayerPosition),
  equal_position(PlayerPosition, Position),
  write(Player);
  check_and_display_players(Rest, Position).

equal_position([X1,Y1], [X2, Y2]):-
  X1 = X2, Y1 = Y2.

space(0).
space(Count):-
  write(' '),
  C1 is Count - 1,
  space(C1).
