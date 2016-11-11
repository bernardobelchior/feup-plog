:-include('logic.pl').
:-include('list_utils.pl').

start:-
  initialize(Board, Ships, TradeStations, Colonies, NumPlayers, NumShipsPerPlayer),
  play(Board, Ships, TradeStations, Colonies, NumPlayers, NumShipsPerPlayer, NumStations, NumColonies).
  %display_first_line_top(Board, [-4, 0], Ships, 1),

play(Board, Ships, TradeStations, Colonies, NumPlayers, NumShipsPerPlayer, NumStations, NumColonies):-
  play(Board, Ships, TradeStations, Colonies, NumPlayers, NumShipsPerPlayer, NumStations, NumColonies, 0, NewShips, NewTradeStations, NewColonies, NewNumStations, NewNumColonies).
play(Board, Ships, TradeStations, Colonies, NumPlayers, NumShipsPerPlayer, NumStations, NumColonies, CurrentPlayer, NewShips, NewTradeStations, NewColonies, NewNumStations, NewNumColonies):-
  display_board(Board, Ships, TradeStations, Colonies),
  select_ship_movement(Board, Ships, TradeStations, Colonies, NumPlayers, NumShipsPerPlayer, CurrentPlayer, NewShips, NewTradeStations, NewColonies),
  select_ship_action(NewShips, PlayerNo, ShipNo, TradeStations, Colonies, NumStations, NumColonies, NewStations, NewColonies),
  next_player(NumPlayers, CurrentPlayer, NextPlayer),
  play(Board, NewShips, NewTradeStations, NewColonies, NumPlayers, NumShipsPerPlayer, NextPlayer, AnotherShips, AnotherTradeStations, AnotherColonies).

select_ship_movement(Board, Ships, TradeStations, Colonies, NumPlayers, NumShipsPerPlayer, CurrentPlayer, NewShips):-
  trace,
  display_player_info(CurrentPlayer, NumShipsPerPlayer),
  display_ship_selection_menu(NumShipsPerPlayer),
  select_ship(Ships, CurrentPlayer, NumShipsPerPlayer, ShipNo),
  display_ship_direction_info(ShipNo),
  select_ship_direction(Direction),
  display_ship_num_tiles_info,
  select_ship_num_tiles(NumTiles),
  move_ship_if_valid(Board, Ships, CurrentPlayer, ShipNo, Direction, NumTiles, NewShips),!;
  write('The ship cannot move in the selected way.'),
  notrace,
  select_ship_movement(Board, Ships, TradeStations, Colonies, NumPlayers, NumShipsPerPlayer, CurrentPlayer, NewShips).

display_ship_num_tiles_info:-
  write('How many tiles would you like to move in the chosen direction?'), nl.

select_ship_num_tiles(NumTiles):-
  read(ReadNumTiles), get_char(_),
  integer(ReadNumTiles),
  ReadNumTiles > 0,
  NumTiles = ReadNumTiles. %check if valid

display_ship_direction_info(ShipNo):-
  NewShipNo is ShipNo + 1,
  write('Ship '), write(NewShipNo),
  write(' can move in the following directions:'), nl,
  write('1 - Northwest'), nl,
  write('2 - Northeast'), nl,
  write('3 - East'), nl,
  write('4 - Southeast'), nl,
  write('5 - Southwest'), nl,
  write('6 - West'), nl,
  write('Please choose one: ').

select_ship_direction(Direction):-
  read(ReadDirection), get_char(_),
  integer(ReadDirection),
  ReadDirection =< 6,
  ReadDirection > 0,
  number_to_direction(ReadDirection, Direction);
  write('Invalid direction.'), nl,
  fail.

number_to_direction(1, northwest).
number_to_direction(2, northeast).
number_to_direction(3, east).
number_to_direction(4, southeast).
number_to_direction(5, southwest).
number_to_direction(6, west).

display_player_info(PlayerNo, NumShipsPerPlayer):-
  write('It is Player '),
  NewPlayerNo is PlayerNo + 1,
  write(NewPlayerNo),
  write('\'s turn.'), nl,
  write('Select a ship to move, between 1 and '),
  write(NumShipsPerPlayer), write(':'), nl.

select_ship(Ships, CurrentPlayer, NumShipsPerPlayer, ShipNo):-
  read(ChosenShip), get_char(_),
  integer(ChosenShip),
  ChosenShip =< NumShipsPerPlayer,
  ChosenShip > 0,
  ShipNo is ChosenShip - 1;
  write('Invalid ship number. Try again.'), nl,
  fail.

display_ship_selection_menu(NumShipsPerPlayer):-
  display_ship_selection_menu(NumShipsPerPlayer, 1).
display_ship_selection_menu(NumShipsPerPlayer, CurrentShip):-
  CurrentShip > NumShipsPerPlayer;
  write(CurrentShip), write(' - Ship '), write(CurrentShip), nl,
  NextShip is CurrentShip + 1,
  display_ship_selection_menu(NumShipsPerPlayer, NextShip).

display_board(Board, Ships, TradeStations, Colonies):-
    display_board(Board, Ships, TradeStations, Colonies, 1, 0).
display_board([Line], Ships, TradeStations, Colonies, Offset, Y):-
  display_line(Line, [-4, Y], Ships, TradeStations, Colonies, Offset),
  display_last_line(Line, [X, Y], Offset).
display_board([Line | Rest], Ships, TradeStations, Colonies, Offset, Y):-
  display_line(Line, [-4, Y], Ships, TradeStations, Colonies, Offset),
  negate(Offset, NextOffset),
  NextY is Y + 1,
  display_board(Rest, Ships, TradeStations, Colonies, NextOffset, NextY).

display_line([Element | Rest], [X, Y], Ships, TradeStations, Colonies, Offset):-
  print_offset(Offset, Y), print_first_row([Element | Rest]), nl,
  print_offset(Offset, Y), print_second_row([Element | Rest]), nl,
  print_offset(Offset, Y), print_third_row([Element | Rest], [X,Y]), nl,
  print_offset(Offset, Y), print_fourth_row([Element | Rest], [X,Y], Ships, TradeStations, Colonies), nl.
/*
%First line
display_first_line_top([FirstLine | Rest], [X, Y], Ships, Offset):-
  print_offset(Offset, Y), print_first_row(FirstLine), nl,
  print_offset(Offset, Y), print_second_row(FirstLine), nl.

%Last Line
display_in_between_line([SecondLine], [X, Y], Ships, Offset):-
  print_offset(Offset, Y), print_first_row([Element | Rest]), nl,
  print_offset(Offset, Y), print_second_row([Element | Rest]), nl.
%Other Lines
display_in_between_line([FirstLine, SecondLine | Rest], [X, Y], Ships, Offset):-
  print_offset(Offset, Y), print_first_row([Element | Rest]), nl,
  print_offset(Offset, Y), print_second_row([Element | Rest]), nl.
*/
display_last_line(Line, [X, Y], Offset):-
  print_offset(Offset, Y), print_first_row([Element | Rest]), nl,
  print_offset(Offset, Y), print_second_row([Element | Rest]), nl.

print_first_row([]).
print_first_row([null | Rest]):-
  %write('         '),
  print_first_row(Rest).
print_first_row([space | Rest]):-
  write('        '),
  print_first_row(Rest).
print_first_row([Element | Rest]):-
  print_triangle_top,
  print_first_row(Rest).

print_second_row([]).
print_second_row([null | Rest]):-
  %write('         '),
  print_second_row(Rest).
print_second_row([space | Rest]):-
  write('        '),
  print_second_row(Rest).
print_second_row([Element | Rest]):-
  print_triangle_bottom,
  print_second_row(Rest).

print_third_row([], [X, Y]).
print_third_row([Element | Rest], [X,Y]):-
  print_element_first_line(Element),
  NextX is X + 1,
  print_third_row(Rest, [NextX, Y]).

print_fourth_row([], [X, Y], Ships, TradeStations, Colonies).
print_fourth_row([Element | Rest], [X, Y], Ships, TradeStations, Colonies):-
  print_element_second_line(Element, [X,Y], Ships, TradeStations, Colonies),
  NextX is X + 1,
  print_fourth_row(Rest, [NextX, Y], Ships, TradeStations, Colonies).

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

print_offset(0, Y).
print_offset(1, Y):-
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
  initialize(Ships),
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

print_element_first_line(null).
  %write('         ').

print_element_first_line(space):-
  write('        ').

print_element_first_line(wormhole):-
  write('|Worm H.').

print_element_first_line(blackHole):-
  write('|BlackH.').

print_element_first_line(system0):-
  write('|       ').

print_element_first_line(system1):-
  write('|   *   ').

print_element_first_line(system2):-
  write('|  *  * ').

print_element_first_line(system3):-
  write('| * * * ').

print_element_first_line(blueNebula):-
  write('|~Blue~~').

print_element_first_line(greenNebula):-
  write('|~Green~').

print_element_first_line(redNebula):-
  write('|~~Red~~').


print_element_second_line(null, Position, Ships, TradeStations, Colonies).
  %write('         ').

print_element_second_line(space, Position, Ships, TradeStations, Colonies):-
  write('        ').

print_element_second_line(Element, Position, Ships, TradeStations, Colonies):-
  get_player_piece_in_position(Ships, Position, PlayerNo, ShipNo),
  NewPlayerNo is PlayerNo + 1,
  NewShipNo is ShipNo + 1,
  write('| P'),
  write(NewPlayerNo),
  write(' S'),
  write(NewShipNo),
  write(' ');
  get_player_piece_in_position(TradeStations, Position, PlayerNo, TradeStationNo),
  NewPlayerNo is PlayerNo + 1,
  NewTradeStationNo is TradeStationNo + 1,
  write('| P'),
  write(NewPlayerNo),
  write(' T'),
  write(NewTradeStationNo),
  write(' ');
  get_player_piece_in_position(Colonies, Position, PlayerNo, ColonyNo),
  NewPlayerNo is PlayerNo + 1,
  NewColonyNo is ColonyNo + 1,
  write('| P'),
  write(NewPlayerNo),
  write(' C'),
  write(NewColonyNo),
  write(' ');
  write('|       ').

select_ship_action(Ships, PlayerNo, ShipNo,TradeStations, Colonies,  RemainingColonies, RemainingStations) :-
  display_action_info,
  select_action(Action),
  valid_action(Action, PlayerNo, RemainingColonies, RemainingStations),!,
  perform_action(Ships, PlayerNo, ShipNo, Action, TradeStations, Colonies, RemainingColonies, RemainingStations).

select_ship_action(Ships, PlayerNo, ShipNo, TradeStations, Colonies,  RemainingColonies, RemainingStations) :-
  select_ship_action(Ships, PlayerNo, ShipNo, TradeStations, Colonies,  RemainingColonies, RemainingStations).


select_action(Action):-
  read(SelectedAction), get_char(_),
  integer(SelectedAction),
  SelectedAction =< 2,
  SelectedAction > 0,
  Action is SelectedAction - 1;
  write('Invalid action. Try again.'), nl,
  fail.

display_action_info:-
  write('Choose action: '),nl,write('1 - Place a trade station.'), nl,write('2 - Place a colony'),nl.
