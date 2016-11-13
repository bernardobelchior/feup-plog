easy_cpu_select_ship_movement(Board, Ships, TradeStations, Colonies, Wormholes, NumPlayers, NumShipsPerPlayer, CurrentPlayer, NewShips, ShipNo):-
  easy_cpu_select_ship(NumShipsPerPlayer, ShipNo),
  select_ship_direction(Direction),
  get_piece_position(Ships, CurrentPlayer, ShipNo, ShipPosition),
  easy_cpu_do_appropriate_move(Board, Ships, TradeStations, Colonies, Wormholes, NumPlayers, NumShipsPerPlayer, CurrentPlayer, ShipNo, ShipPosition, Direction, NewShips).

 easy_cpu_select_ship_movement(Board, Ships, TradeStations, Colonies, Wormholes, NumPlayers, NumShipsPerPlayer, CurrentPlayer, NewShips, _ShipNo) :-
  easy_cpu_select_ship_movement(Board, Ships, TradeStations, Colonies, Wormholes, NumPlayers, NumShipsPerPlayer, CurrentPlayer, NewShips, _SelectedShipNo).

easy_cpu_select_ship(NumShipsPerPlayer, ShipNo) :-
    random(0,NumShipsPerPlayer,ShipNo).

easy_cpu_do_appropriate_move(Board, Ships, TradeStations, Colonies, Wormholes, NumPlayers, NumShipsPerPlayer, CurrentPlayer, ShipNo, ShipPosition, Direction, NewShips):-
    is_move_to_wormhole(ShipPosition, Direction, Wormholes, InWormhole),
    easy_cpu_move_through_wormhole(Board, Ships, TradeStations, Colonies, Wormholes, NumPlayers, NumShipsPerPlayer, CurrentPlayer, ShipNo, ShipPosition, Direction, NewShips, InWormhole).

easy_cpu_do_appropriate_move(Board, Ships, TradeStations, Colonies, Wormholes, _NumPlayers, _NumShipsPerPlayer, CurrentPlayer, ShipNo, ShipPosition, Direction, NewShips):-
  easy_cpu_select_ship_num_tiles(NumTiles),
  move_ship_if_valid(Board, Ships, TradeStations, Colonies, Wormholes, CurrentPlayer, ShipNo, ShipPosition, Direction, NumTiles, NewShips).

easy_cpu_move_through_wormhole(Board, Ships, TradeStations, Colonies, Wormholes, _NumPlayers, _NumShipsPerPlayer, CurrentPlayer, ShipNo, _ShipPosition, _Direction, NewShips, InWormhole):-
    easy_cpu_select_wormhole_exit(NumWormholes, InWormhole, SelectedOutWormhole),
    number_to_wormhole(Wormholes,SelectedOutWormhole, OutWormhole),
    move_ship(Ships, OutWormhole, CurrentPlayer, ShipNo, west, 0, TmpShips),
    display_ship_direction_info(ShipNo),
    easy_cpu_select_ship_direction(TmpDirection),
    move_ship_if_valid(Board, TmpShips, TradeStations, Colonies, Wormholes, CurrentPlayer, ShipNo, OutWormhole, TmpDirection, 1, NewShips).

move_through_wormhole(Board, Ships, TradeStations, Colonies, Wormholes, NumPlayers, NumShipsPerPlayer, CurrentPlayer, ShipNo, ShipPosition, Direction, NewShips, InWormhole):-
    move_through_wormhole(Board, Ships, TradeStations, Colonies, Wormholes, NumPlayers, NumShipsPerPlayer, CurrentPlayer, ShipNo, ShipPosition, Direction, NewShips, InWormhole).

select_ship_action(Ships, PlayerNo, ShipNo,TradeStations, Colonies,  NewTradeStations, NewColonies) :-
  display_action_info,
  select_action(Action),
  valid_action(Action, PlayerNo, TradeStations, Colonies),!,
  perform_action(Ships, PlayerNo, ShipNo, Action, TradeStations, Colonies, NewTradeStations, NewColonies).

select_ship_action(Ships, PlayerNo, ShipNo, TradeStations, Colonies,  NewTradeStations, NewColonies) :-
  select_ship_action(Ships, PlayerNo, ShipNo, TradeStations, Colonies,  NewTradeStations, NewColonies).
