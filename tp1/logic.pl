create_board(Board):-
  Board = [
  [null, null, null, null, null, null, null, null, null, null, null], %0
  [null, null, null, null, system0, system3, greenNebula, system2, null, null, null], %1
  [null, null, null, blueNebula, system2, system1, blackHole, system1, system1, system1, null], %2
  [null, null, null, system2, system3, system0, system2, system2, wormhole, system3, null], %3
  [null, null, system3, wormhole, system1, redNebula, system1, blueNebula, system1, null, null], %4
  [null, null, system0, system2, system3, system0, system0, system1, system2, null, null], %5
  [null, space, redNebula, system3, greenNebula, system0, system1, blackHole, system1, null, null], %6
  [null, system3, blackHole, greenNebula, system3, system2, system1, system1, null, null, null], %7
  [space, system1, system3, redNebula, wormhole, system0, system1, system1, null, null, null], %8
  [space, space, space, system1, blueNebula, system0, system2, null, null, null, null]]. %9

create_players(Ships, TradeStations, Colonies, HomeSystems, Wormholes, NumPlayers, NumShipsPerPlayer):-
  Ships = [
  [[3,2], [4,2], [5,1]],
  [[6,8], [7,8], [5,9]]
  ],
  TradeStations = [
  [],
  []
  ],
  Colonies = [
  [],
  []
  ],
  HomeSystems = [
  [[4, 1], [5, 1], [3, 2], [4, 2]],
  [[6, 8], [7, 8], [5, 9], [6, 9]]
  ],
  Wormholes = [
  [8,3],[3,4],[4,8]
  ],
  NumPlayers = 2,
  NumShipsPerPlayer = 3.

initialize(Board, Ships, TradeStations, Colonies, HomeSystems, Wormholes, NumPlayers, NumShipsPerPlayer):-
  create_board(Board),
  create_players(Ships, TradeStations, Colonies, HomeSystems, Wormholes, NumPlayers, NumShipsPerPlayer).


game_over(Board, TradeStations, Colonies, HomeSystems, NumPlayers):-
  game_over(Board, TradeStations, Colonies, HomeSystems, NumPlayers, 0, 0, 0).

game_over(_Board, _TradeStations, _Colonies, _HomeSystems, NumPlayers, BestPlayerNo, BestPlayerPoints, NumPlayers):-
  ActualPlayerNo is BestPlayerNo + 1,
  write('Player '), write(ActualPlayerNo), write(' won with '), write(BestPlayerPoints), write(' points!'), nl.

game_over(Board, TradeStations, Colonies, HomeSystems, NumPlayers, PlayerNo, PlayerPoints, CurrentPlayer):-
  calculate_points(Board, TradeStations, Colonies, HomeSystems, CurrentPlayer, NewPlayerPoints),
  NewPlayerNo is CurrentPlayer + 1,
  who_has_max(PlayerNo, PlayerPoints, CurrentPlayer, NewPlayerPoints, BestPlayerNo, BestPlayerPoints),
  game_over(Board, TradeStations, Colonies, HomeSystems, NumPlayers, BestPlayerNo, BestPlayerPoints, NewPlayerNo).


who_has_max(Player1No, Player1Points, _Player2No, Player2Points, BestPlayerNo, BestPlayerPoints):-
  Player1Points > Player2Points,
  BestPlayerNo = Player1No,
  BestPlayerPoints = Player1Points.
who_has_max(_Player1No, _Player1Points, Player2No, Player2Points, Player2No, Player2Points).

calculate_points(Board, TradeStations, Colonies, HomeSystems, PlayerNo, NewPlayerPoints):-
  list_get_nth(TradeStations, PlayerNo, PlayerTradeStations),
  list_get_nth(Colonies, PlayerNo, PlayerColonies),
  calculate_control_points(Board, PlayerTradeStations, TradeStationsControlPoints, TSGreenNebulasControlled, TSBlueNebulasControlled, TSRedNebulasControlled),
  calculate_control_points(Board, PlayerColonies, ColoniesControlPoints, CGreenNebulasControlled, CBlueNebulasControlled, CRedNebulasControlled),
  list_delete_nth(TradeStations, PlayerNo, OtherTradeStations),
  list_delete_nth(Colonies, PlayerNo, OtherColonies),
  list_delete_nth(HomeSystems, PlayerNo, OtherHomeSystems),
  calculate_adjacency_points(PlayerTradeStations, OtherTradeStations, OtherColonies, OtherHomeSystems, AdjacencyPoints),
  GreenNebulasControlled is TSGreenNebulasControlled + CGreenNebulasControlled,
  BlueNebulasControlled is TSBlueNebulasControlled + CBlueNebulasControlled,
  RedNebulasControlled is TSRedNebulasControlled + CRedNebulasControlled,
  get_points_from_nebulas(Board, GreenNebulasControlled, GreenNebulaPoints),
  get_points_from_nebulas(Board, BlueNebulasControlled, BlueNebulaPoints),
  get_points_from_nebulas(Board, RedNebulasControlled, RedNebulaPoints),
  NewPlayerPoints is TradeStationsControlPoints + ColoniesControlPoints + AdjacencyPoints + GreenNebulaPoints + BlueNebulaPoints + RedNebulaPoints.

calculate_adjacency_points([], _OtherTradeStations, _OtherColonies, _OtherHomeSystems, 0).

calculate_adjacency_points([TradeStation | Rest], OtherTradeStations, OtherColonies, OtherHomeSystems, AdjacencyPoints):-
  calculate_adjacency_points_for_station(TradeStation, west, OtherTradeStations, OtherColonies, OtherHomeSystems, WPoints),
  calculate_adjacency_points_for_station(TradeStation, northwest, OtherTradeStations, OtherColonies, OtherHomeSystems, NWPoints),
  calculate_adjacency_points_for_station(TradeStation, northeast, OtherTradeStations, OtherColonies, OtherHomeSystems, NEPoints),
  calculate_adjacency_points_for_station(TradeStation, east, OtherTradeStations, OtherColonies, OtherHomeSystems, EPoints),
  calculate_adjacency_points_for_station(TradeStation, southeast, OtherTradeStations, OtherColonies, OtherHomeSystems, SEPoints),
  calculate_adjacency_points_for_station(TradeStation, southwest, OtherTradeStations, OtherColonies, OtherHomeSystems, SWPoints),
  calculate_adjacency_points(Rest, OtherTradeStations, OtherColonies, OtherHomeSystems, NextTSAdjacencyPoints),
  AdjacencyPoints is NextTSAdjacencyPoints + WPoints + NWPoints + NEPoints + EPoints + SEPoints + SWPoints.

calculate_adjacency_points_for_station(TradeStation, Direction, OtherTradeStations, OtherColonies, OtherHomeSystems, DirectionPoints):-
  update_position(TradeStation, Direction, 1, Position),
  position_has_piece_of_any_type(Position, OtherTradeStations, OtherColonies, OtherHomeSystems),
  DirectionPoints = 1.
calculate_adjacency_points_for_station(_TradeStation, _Direction, _OtherTradeStations, _OtherColonies, _OtherHomeSystems, 0).

position_has_piece_of_any_type(Position, TradeStations, Colonies, HomeSystems):-
    position_has_piece_of_type(TradeStations, Position);
    position_has_piece_of_type(Colonies, Position);
    position_has_piece_of_type(HomeSystems, Position).

position_has_piece_of_type([], _Position):- fail.
position_has_piece_of_type([PlayerPieces | OtherPieces], Position):-
  position_has_piece(PlayerPieces, Position);
  position_has_piece_of_type(OtherPieces, Position).

calculate_control_points(_Board, [], 0, 0, 0, 0).
calculate_control_points(Board, [[X, Y] | OtherPieces], ControlPoints, GreenNebulasControlled, BlueNebulasControlled, RedNebulasControlled):-
  list_get_xy(Board, X, Y, Tile),
  get_points_from_tile(Tile, Points, NewGreenNebulasControlled, NewBlueNebulasControlled, NewRedNebulasControlled),
  calculate_control_points(Board, OtherPieces, NewControlPoints, TmpGreenNebulasControlled, TmpBlueNebulasControlled, TmpRedNebulasControlled),
  GreenNebulasControlled is NewGreenNebulasControlled + TmpGreenNebulasControlled,
  BlueNebulasControlled is NewBlueNebulasControlled + TmpBlueNebulasControlled,
  RedNebulasControlled is NewRedNebulasControlled + TmpRedNebulasControlled,
  ControlPoints is NewControlPoints + Points.

get_points_from_tile(null, 0, 0, 0, 0).
get_points_from_tile(space, 0, 0, 0, 0).
get_points_from_tile(wormhole, 0, 0, 0, 0).
get_points_from_tile(blackHole, 0, 0, 0, 0).
get_points_from_tile(system0, 0, 0, 0, 0).
get_points_from_tile(system1, 1, 0, 0, 0).
get_points_from_tile(system2, 2, 0, 0, 0).
get_points_from_tile(system3, 3, 0, 0, 0).
get_points_from_tile(greenNebula, 0, 1, 0, 0).
get_points_from_tile(blueNebula, 0, 0, 1, 0).
get_points_from_tile(redNebula, 0, 0, 0, 1).

get_points_from_nebulas(_Board, 0, 0).
get_points_from_nebulas(_Board, 1, 2).
get_points_from_nebulas(_Board, 2, 5).
get_points_from_nebulas(_Board, _C, 8). %FIXME: Check for all nebulas

get_piece_position(PieceList, PlayerNo, PieceNo, PiecePosition):-
  list_get_xy(PieceList, PieceNo, PlayerNo, PiecePosition).

next_player(NumPlayers, CurrentPlayer, NextPlayer):-
  NextPlayerTmp is CurrentPlayer + 1,
  NextPlayerTmp < NumPlayers,
  NextPlayer = NextPlayerTmp;
  NextPlayer = 0.

%Not
negate(0, Result):-
  Result is 1.
negate(_A, Result):-
  Result is 0.

%Checks if a position is equal.
equal_position([X1,Y1], [X2, Y2]):-
  X1 == X2, Y1 == Y2.

%Gets the player and piece in the specified position
get_player_piece_in_position([PlayerPieces | OtherPlayersPieces], Position, PlayerNo, PieceNo):-
  get_piece_number_in_position(PlayerPieces, Position, PieceNo),
  PlayerNo = 0;
  get_player_piece_in_position(OtherPlayersPieces, Position, NextPlayerNo, PieceNo),
  PlayerNo is NextPlayerNo + 1.

%Gets the piece in the specified position
get_piece_number_in_position([FirstPiecePosition | OtherPieces], Position, PieceNo):-
  equal_position(Position, FirstPiecePosition),
  PieceNo = 0;
  get_piece_number_in_position(OtherPieces, Position, NextPieceNo),
  PieceNo is NextPieceNo + 1.

get_tile_in_position(Board, [X , Y], Tile):-
  list_get_xy(Board, X, Y, Tile).

%checks if a direction is valid, X and Y are the distances in X and Y that will be traveled
valid_direction(X,Y) :- (X \= 0; Y\=0), ((X \= 0, Y = 0); (X = 0, Y \= 0); (X = -Y)).

%is_move_to_wormhole(+ShipPosition, +Direction, +NumTiles, +Wormholes, -InWormhole)
is_move_to_wormhole(ShipPosition, Direction, Wormholes, InWormhole) :-
    update_position(ShipPosition, Direction, 1, NewPosition),
    list_find(Wormholes, NewPosition, 0, InWormhole).

move_ship_if_valid(Board, Ships, TradeStations, Colonies, Wormholes, PlayerNo, ShipNo, ShipPosition, Direction, NumTiles, NewShips):-
  is_move_valid(Board, Ships, TradeStations, Colonies, Wormholes, ShipPosition, Direction, NumTiles, NumTiles),
  move_ship(Ships, ShipPosition, PlayerNo, ShipNo, Direction, NumTiles, NewShips).

move_ship(Ships, ShipPosition, PlayerNo, ShipNo, Direction, NumTiles, NewShips):-
  update_position(ShipPosition, Direction, NumTiles, NewShipPosition),
  list_get_nth(Ships, PlayerNo, PlayerShips),
  list_replace_nth(PlayerShips, ShipNo, NewShipPosition, NewPlayerShips),
  list_replace_nth(Ships, PlayerNo, NewPlayerShips, NewShips).

% TotalNumTiles must be bigger than one in order to allow checking for wormholes
is_direction_valid(Board, Ships, TradeStations, Colonies, Wormholes, Position, Direction):-
  is_move_valid(Board, Ships, TradeStations, Colonies, Wormholes, Position, Direction, 1, 2).

%is_move_valid(Board, Position, Direction, NumTiles):-
  %is_move_valid(Board, Position, Direction, NumTiles, NumTiles).
is_move_valid(_Board, _Ships, _TradeStations, _Colonies, _Wormholes, _Position, _Direction, 0, _TotalNumTiles).
is_move_valid(Board, Ships, TradeStations, Colonies, Wormholes, Position, Direction, NumTiles, TotalNumTiles):-
  update_position(Position, Direction, 1, NewPosition),
  get_tile_in_position(Board, NewPosition, Tile), !, % Cut needed in order to prevent backtracking
  is_tile_passable(Tile),
  is_tile_unoccupied(Ships, NewPosition),
  is_tile_unoccupied(TradeStations, NewPosition),
  is_tile_unoccupied(Colonies, NewPosition),
  NewNumTiles is NumTiles - 1,
  is_move_valid(Board, Ships, TradeStations, Colonies, Wormholes, NewPosition, Direction, NewNumTiles, TotalNumTiles).

is_tile_passable(system0).
is_tile_passable(system1).
is_tile_passable(system2).
is_tile_passable(system3).
is_tile_passable(greenNebula).
is_tile_passable(redNebula).
is_tile_passable(blueNebula).

is_tile_unoccupied([], _Position).
is_tile_unoccupied([PlayerPieces | OtherPlayersPieces], Position):-
  position_has_piece(PlayerPieces, Position), !, fail;
  is_tile_unoccupied(OtherPlayersPieces, Position).

position_has_piece([], _Position):- fail.
position_has_piece([Piece | OtherPieces], Position):-
  equal_position(Piece, Position);
  position_has_piece(OtherPieces, Position).

is_ship_movable(Board, Ships, TradeStations, Colonies, Wormholes, Ship):-
  is_direction_valid(Board, Ships, TradeStations, Colonies, Wormholes, Ship, northwest), !,
  is_direction_valid(Board, Ships, TradeStations, Colonies, Wormholes, Ship, northeast), !,
  is_direction_valid(Board, Ships, TradeStations, Colonies, Wormholes, Ship, east), !,
  is_direction_valid(Board, Ships, TradeStations, Colonies, Wormholes, Ship, southeast), !,
  is_direction_valid(Board, Ships, TradeStations, Colonies, Wormholes, Ship, southwest), !,
  is_direction_valid(Board, Ships, TradeStations, Colonies, Wormholes, Ship, west), !.

are_player_ships_movable(_Board, _Ships, _TradeStations, _Colonies, _Wormholes, []).
are_player_ships_movable(Board, Ships, TradeStations, Colonies, Wormholes, [Ship | OtherShips]):-
  is_ship_movable(Board, Ships, TradeStations, Colonies, Wormholes, Ship);
  are_player_ships_movable(Board, Ships, TradeStations, Colonies, Wormholes, OtherShips).

is_game_over(_Board, [], _TradeStations, _Colonies, _Wormholes).
is_game_over(Board, [PlayerShips | OtherShips], [PlayerTradeStations | OtherTradeStations], [PlayerColonies | OtherColonies], Wormholes):-
  are_player_ships_movable(Board, [PlayerShips | OtherShips], [PlayerTradeStations | OtherTradeStations], [PlayerColonies | OtherColonies], Wormholes, PlayerShips),
  not(player_has_trade_stations(PlayerTradeStations)),
  not(player_has_colonies(PlayerColonies)),
  is_game_over(Board, OtherShips, OtherTradeStations, OtherColonies, Wormholes).

not(Execute):-Execute, !, fail.
not(_Execute).

/*Direction
* Northwest - x   y--
* Northeast - x++ y--
* East -      x++ y
* Southeast - x   y++
* Southwest - x-- y++
* West -      x-- y
*/
update_position([X,Y], northwest, NumTiles, NewPosition):-
  NewY is Y - NumTiles,
  NewPosition = [X, NewY].
update_position([X,Y], northeast, NumTiles, NewPosition):-
  NewX is X + NumTiles,
  NewY is Y - NumTiles,
  NewPosition = [NewX, NewY].
update_position([X,Y], east, NumTiles, NewPosition):-
  NewX is X + NumTiles,
  NewPosition = [NewX, Y].
update_position([X,Y], southeast, NumTiles, NewPosition):-
  NewY is Y + NumTiles,
  NewPosition = [X, NewY].
update_position([X,Y], southwest, NumTiles, NewPosition):-
  NewX is X - NumTiles,
  NewY is Y + NumTiles,
  NewPosition = [NewX, NewY].
update_position([X,Y], west, NumTiles, NewPosition):-
  NewX is X - NumTiles,
  NewPosition = [NewX, Y].


valid_action(colony, Player, _TradeStations, Colonies) :-
    list_get_nth(Colonies, Player, PlayerColonies), !,
    player_has_colonies(PlayerColonies), !.

valid_action(tradeStation, Player, TradeStations, _Colonies) :-
    list_get_nth(TradeStations, Player, PlayerTradeStations), !,
    player_has_trade_stations(PlayerTradeStations), !.

valid_action(_Action, _Player, _TradeStations, _Colonies) :-
    write('Player has no buildings of requested type'), fail.

player_has_trade_stations(PlayerTradeStations) :-
    list_length(PlayerTradeStations, NumTradeStations),
    NumTradeStations < 16.

player_has_colonies(PlayerColonies) :-
    list_length(PlayerColonies, NumColonies),
    NumColonies < 4.

perform_action(Ships, PlayerNo, ShipNo, tradeStation, TradeStations, Colonies, NewTradeStations, NewColonies):-
    get_piece_position(Ships, PlayerNo, ShipNo, ShipPosition),
    place_trade_station(PlayerNo, ShipPosition, TradeStations, NewTradeStations),
    NewColonies = Colonies.

perform_action(Ships, PlayerNo, ShipNo, colony, TradeStations, Colonies, NewTradeStations, NewColonies):-
    get_piece_position(Ships, PlayerNo, ShipNo, ShipPosition),
    place_colony(PlayerNo, ShipPosition, Colonies, NewColonies),
    NewTradeStations = TradeStations.

place_trade_station(PlayerNo, ShipPosition, TradeStations, NewTradeStations):-
    list_get_nth(TradeStations, PlayerNo, PlayerTradeStations),
    NewShipPosition = [ShipPosition],
    list_append(PlayerTradeStations, NewShipPosition, NewPlayerTradeStations),
    list_replace_nth(TradeStations,PlayerNo, NewPlayerTradeStations, NewTradeStations).

place_colony(PlayerNo,ShipPosition, Colonies, NewColonies) :-
    list_get_nth(Colonies, PlayerNo, PlayerColonies),
    NewShipPosition = [ShipPosition],
    list_append(PlayerColonies, NewShipPosition, NewPlayerColonies),
    list_replace_nth(Colonies,PlayerNo, NewPlayerColonies, NewColonies).

move_through_wormhole(Board, Ships, TradeStations, Colonies, Wormholes, _NumPlayers, _NumShipsPerPlayer, CurrentPlayer, ShipNo, _ShipPosition, _Direction, NewShips, InWormhole):-
    display_wormhole_exits(Wormholes, NumWormholes, InWormhole),
    select_wormhole_exit(NumWormholes, InWormhole, SelectedOutWormhole),
    number_to_wormhole(Wormholes,SelectedOutWormhole, OutWormhole),
    %trace,
    move_ship(Ships, OutWormhole, CurrentPlayer, ShipNo, west, 0, TmpShips),
    %notrace,
    display_ship_direction_info(ShipNo),
    select_ship_direction(TmpDirection),
    move_ship_if_valid(Board, TmpShips, TradeStations, Colonies, Wormholes, CurrentPlayer, ShipNo, OutWormhole, TmpDirection, 1, NewShips).

move_through_wormhole(Board, Ships, TradeStations, Colonies, Wormholes, NumPlayers, NumShipsPerPlayer, CurrentPlayer, ShipNo, ShipPosition, Direction, NewShips, InWormhole):-
    move_through_wormhole(Board, Ships, TradeStations, Colonies, Wormholes, NumPlayers, NumShipsPerPlayer, CurrentPlayer, ShipNo, ShipPosition, Direction, NewShips, InWormhole).

number_to_wormhole(Wormholes, SelectedOutWormhole, OutWormhole):-
    N is SelectedOutWormhole - 1,
    list_get_nth(Wormholes, N, OutWormhole).
