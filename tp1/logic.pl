create_board(Board):-
  Board = [
  [null, null, null, null, null, null, null, null, null, null, null],
  [null, null, null, null, system0, system3, greenNebula, system2, null, null, null],
  [null, null, null, blueNebula, system2, system1, blackHole, system1, system1, system1, null],
  [null, null, null, system2, system3, system0, system2, system2, wormhole, system3, null],
  [null, null, system3, wormhole, system1, redNebula, system1, blueNebula, system1, null, null],
  [null, null, system0, system2, system3, system0, system0, system1, system2, null, null],
  [null, space, redNebula, system3, greenNebula, system0, system1, blackHole, system1, null, null],
  [null, system3, blackHole, greenNebula, system3, system2, system1, system1, null, null, null],
  [space, system1, system3, redNebula, wormhole, system0, system1, system1, null, null, null],
  [space, space, space, system1, blueNebula, system0, system2, null, null, null, null]].

create_players(Ships, TradeStations, Colonies, NumPlayers, NumShipsPerPlayer):-
  Ships = [
  [[4,2], [5,2], [5,1]],
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
  NumPlayers = 2,
  NumShipsPerPlayer = 3.

initialize(Board, Ships, TradeStations, Colonies, NumPlayers, NumShipsPerPlayer):-
  create_board(Board),
  create_players(Ships, TradeStations, Colonies, NumPlayers, NumShipsPerPlayer).

get_piece_position(PieceList, PlayerNo, PieceNo, PiecePosition):-
  list_get_xy(PieceList, PieceNo, PlayerNo, PiecePosition).

next_player(NumPlayers, CurrentPlayer, NextPlayer):-
  NextPlayerTmp is CurrentPlayer + 1,
  CurrentPlayer < NumPlayers,
  NextPlayer = NextPlayerTmp;
  NextPlayer = 0.

%Not
negate(0, Result):-
  Result is 1.
negate(A, Result):-
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

move_ship_if_valid(Board, Ships, TradeStations, Colonies, PlayerNo, ShipNo, Direction, NumTiles, NewShips):-
  get_piece_position(Ships, PlayerNo, ShipNo, ShipPosition), !, %Needed in order to prevent backtracking
  is_move_valid(Board, Ships, TradeStations, Colonies, ShipPosition, Direction, NumTiles, NumTiles),
  move_ship(Ships, ShipPosition, PlayerNo, ShipNo, Direction, NumTiles, NewShips).

move_ship(Ships, ShipPosition, PlayerNo, ShipNo, Direction, NumTiles, NewShips):-
  update_position(ShipPosition, Direction, NumTiles, NewShipPosition),
  list_get_nth(Ships, PlayerNo, PlayerShips),
  list_replace_nth(PlayerShips, ShipNo, NewShipPosition, NewPlayerShips),
  list_replace_nth(Ships, PlayerNo, NewPlayerShips, NewShips).

% TotalNumTiles must be bigger than one in order to allow checking for wormholes
is_direction_valid(Board, Ships, TradeStations, Colonies, Position, Direction):-
  is_move_valid(Board, Ships, TradeStations, Colonies, Position, Direction, 1, 2).

%is_move_valid(Board, Position, Direction, NumTiles):-
  %is_move_valid(Board, Position, Direction, NumTiles, NumTiles).
is_move_valid(Board, Ships, TradeStations, Colonies, Position, Direction, 0, TotalNumTiles).
is_move_valid(Board, Ships, TradeStations, Colonies, Position, Direction, NumTiles, TotalNumTiles):-
  update_position(Position, Direction, 1, NewPosition),
  get_tile_in_position(Board, NewPosition, Tile), !, % Cut needed in order to prevent backtracking
  is_tile_passable(Tile),
  is_tile_unoccupied(Ships, NewPosition),
  is_tile_unoccupied(TradeStations, NewPosition),
  is_tile_unoccupied(Colonies, NewPosition),
  NewNumTiles is NumTiles - 1,
  is_move_valid(Board, Ships, TradeStations, Colonies, NewPosition, Direction, NewNumTiles, TotalNumTiles).

is_tile_passable(system0).
is_tile_passable(system1).
is_tile_passable(system2).
is_tile_passable(system3).
is_tile_passable(greenNebula).
is_tile_passable(redNebula).
is_tile_passable(blueNebula).
% FIXME: Currently wormhole are impassable, but they are passable if they meet
% certain requirements
%is_tile_passable(wormhole, Position, Direction, TotalNumTiles):-
  %TotalNumTiles is 1,

is_tile_unoccupied([], Position).
is_tile_unoccupied([PlayerPieces | OtherPlayersPieces], Position):-
  position_has_piece(PlayerPieces, Position), !, fail;
  is_tile_unoccupied(OtherPlayersPieces, Position).

position_has_piece([], Position):- fail.
position_has_piece([Piece | OtherPieces], Position):-
  equal_position(Piece, Position);
  position_has_piece(OtherPieces, Position).

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
