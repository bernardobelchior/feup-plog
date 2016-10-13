:-include('logic.pl').
:-include('list_utils.pl').
:-include('player.pl').

start:-
  initialize(Players),
  board(Board),
  /*write('   '), nl,
  display_columns(Board, -4), nl*/
  display_board(Board, Players, 1, 0).

/*display_columns([[] | Rest], StartingNumber).
display_columns([[Element | OtherElements] | Rest], StartingNumber):-
  %format('~2d', StartingNumber)
  write(StartingNumber), write(' '),
  NextNumber is StartingNumber + 1,
  display_columns([OtherElements , Rest], NextNumber).*/

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

get_player_char_in_position(Players, Position, Char):-
  get_player_in_position(Players, Position, [Char, PlayerPosition]).


space(0).
space(Count):-
  write(' '),
  C1 is Count - 1,
  space(C1).
