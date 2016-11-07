:-include('logic.pl').
:-include('list_utils.pl').

start:-
  initialize(Board, Players, NumPlayers),
  play(Board, Players, NumPlayers, 1).
  %display_first_line_top(Board, [-4, 0], Players, 1),

play(Board, Players, NumPlayers, CurrentPlayer):-
  display_board(Board, Players, 1, 0)%,
  %select_ship(Players, CurrentPlayer, ShipNum),
  %select_ship_movement(Board, Players, CurrentPlayer, ShipNum),
  %move_ship(Players, CurrentPlayer, ShipNum),
  %select_action()
  %next_player(NumPlayers, CurrentPlayer, NextPlayer),
  %play(Board, Players, NumPlayers, NextPlayer).
  .

display_board([Line], Players, Offset, Y):-
  display_line(Line, [-4, Y], Players, Offset),
  display_last_line(Line, [X, Y], Players, Offset).
display_board([Line | Rest], Players, Offset, Y):-
  display_line(Line, [-4, Y], Players, Offset),
  negate(Offset, NextOffset),
  NextY is Y + 1,
  display_board(Rest, Players, NextOffset, NextY).

display_line([Element | Rest], [X, Y], Players, Offset):-
  print_offset(Offset, Y), print_first_row([Element | Rest]), nl,
  print_offset(Offset, Y), print_second_row([Element | Rest]), nl,
  print_offset(Offset, Y), print_third_row([Element | Rest], [X,Y], Players), nl,
  print_offset(Offset, Y), print_fourth_row([Element | Rest], [X,Y], Players), nl.
/*
%First line
display_first_line_top([FirstLine | Rest], [X, Y], Players, Offset):-
  print_offset(Offset, Y), print_first_row(FirstLine), nl,
  print_offset(Offset, Y), print_second_row(FirstLine), nl.

%Last Line
display_in_between_line([SecondLine], [X, Y], Players, Offset):-
  print_offset(Offset, Y), print_first_row([Element | Rest]), nl,
  print_offset(Offset, Y), print_second_row([Element | Rest]), nl.
%Other Lines
display_in_between_line([FirstLine, SecondLine | Rest], [X, Y], Players, Offset):-
  print_offset(Offset, Y), print_first_row([Element | Rest]), nl,
  print_offset(Offset, Y), print_second_row([Element | Rest]), nl.
*/
display_last_line(Line, [X, Y], Players, Offset):-
  print_offset(Offset, Y), print_first_row([Element | Rest]), nl,
  print_offset(Offset, Y), print_second_row([Element | Rest]), nl.

print_first_row([]).
print_first_row([null | Rest]):-
  write('         '),
  print_first_row(Rest).
print_first_row([space | Rest]):-
  write('        '),
  print_first_row(Rest).
print_first_row([Element | Rest]):-
  print_triangle_top,
  print_first_row(Rest).

print_second_row([]).
print_second_row([null | Rest]):-
  write('         '),
  print_second_row(Rest).
print_second_row([space | Rest]):-
  write('        '),
  print_second_row(Rest).
print_second_row([Element | Rest]):-
  print_triangle_bottom,
  print_second_row(Rest).

print_third_row([], [X, Y], Players).
print_third_row([Element | Rest], [X, Y], Players):-
  print_element_first_line(Element, [X,Y], Players),
  NextX is X + 1,
  print_third_row(Rest, [NextX, Y], Players).

print_fourth_row([], [X, Y], Players).
print_fourth_row([Element | Rest], [X, Y], Players):-
  print_element_second_line(Element, [X,Y], Players),
  NextX is X + 1,
  print_fourth_row(Rest, [NextX, Y], Players).

print_fifth_row([]).
print_fifth_row([null | Rest]):-
  write('         '),
  print_fifth_row(Rest).
print_fifth_row([Element | Rest]):-
  print_triangle_top,
  print_fifth_row(Rest).

print_sixth_row([]).
  print_sixth_row([null | Rest]):-
  write('         '),
  print_sixth_row(Rest).
print_sixth_row([Element | Rest]):-
  print_triangle_bottom,
  print_sixth_row(Rest).

print_offset(0, Y):-
  Indentation is Y//2,
  space(Indentation).
print_offset(1, Y):-
  Indentation is Y//2,
  space(Indentation),
  write('    ').

/*is_last_visible_element_in_line([]).
is_last_visible_element_in_line([Element | Rest]):-
    is_last_visible_element_in_line(Rest),
    is_not_visible_element(Rest).

is_not_visible_element(space).
is_not_visible_element(null).

%
is_visible_element(system0).
is_visible_element(system1).
is_visible_element(system2).
is_visible_element(system3).
is_visible_element(redNebula).
is_visible_element(greenNebula).
is_visible_element(blueNebula).
is_visible_element(wormhole).
is_visible_element(blackHole).*/


%Debug
test:-
  initialize(Players),
  board(Board),
  list_get_last_line(Board, LastLine),
  write(LastLine).

print_triangle_top:-
  print_triangle_left_top, write(' '),
  print_triangle_right_top.

print_triangle_bottom:-
  print_triangle_left_bottom, write(' '),
  print_triangle_right_bottom.

print_triangle_left_top:-
  write('   /').
print_triangle_right_top:-
  write('\\  ').
print_triangle_left_bottom:-
  write(' /  ').
print_triangle_right_bottom:-
  write('  \\').

space(0).
space(Count):-
  write(' '),
  C1 is Count - 1,
  space(C1).

% WRITE ELEMENTS

print_element_first_line(null, Position, Players):-
  write('         ').

print_element_first_line(space, Position, Players):-
  write('        ').

print_element_first_line(wormhole, Position, Players):-
  write('|Worm H.').

print_element_first_line(blackHole, Position, Players):-
  write('|BlackH.').

print_element_first_line(system0, Position, Players):-
  write('|       ').

print_element_first_line(system1, Position, Players):-
  write('|   *   ').

print_element_first_line(system2, Position, Players):-
  write('|  *  * ').

print_element_first_line(system3, Position, Players):-
  write('| * * * ').

print_element_first_line(blueNebula, Position, Players):-
  write('|~Blue~~').

print_element_first_line(greenNebula, Position, Players):-
  write('|~Green~').

print_element_first_line(redNebula, Position, Players):-
  write('|~~Red~~').


print_element_second_line(null, Position, Players):-
  write('         ').

print_element_second_line(space, Position, Players):-
  write('        ').

print_element_second_line(Element, Position, Players):-
  get_player_ship_in_position(Players, Position, PlayerNo, ShipNo),
  write('| P'),
  write(PlayerNo),
  write(' S'),
  write(ShipNo),
  write(' ');
  write('|       ').
