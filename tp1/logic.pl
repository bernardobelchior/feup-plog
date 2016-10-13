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

initialize(Players):-
  Players = [
  ['P', [1,1]],
  ['T', [3,7]]
  ].

  %ships list, the list is a list of lists which have 2 elements, representing the position of the ships
  ships(Ships):-
    Ships = [].

%Not sure if this works correctly because of PlayerChar = Player.
%Doesn't it assign Player to PlayerChar??
%By: Bernardo Belchior
get_player_position([], Player, Position).
get_player_position([[PlayerChar | Pos] | Others], Player, Position):-
  PlayerChar = Player,
  Position is Pos;
  get_player_position(Others, Player, Position).

%Not
negate(0, Result):-
  Result is 1.
negate(A, Result):-
  Result is 0.

%Checks if a position is equal.
equal_position([X1,Y1], [X2, Y2]):-
  X1 == X2, Y1 == Y2.

%Returns the player in the given position. Fails if no player is found.
get_player_in_position([[PlayerChar, PlayerPosition] | Others], Position, [ReturnChar, ReturnPosition]):-
  equal_position(PlayerPosition, Position),
  ReturnChar = PlayerChar,
  ReturnPosition = PlayerPosition;
  get_player_in_position(Others, Position, [ReturnChar, ReturnPosition]).

%checks if a direction is valid, X and Y are the distances in X and Y that will be traveled
valid_direction(X,Y) :- (X \= 0; Y\=0), ((X \= 0, Y = 0); (X = 0, Y \= 0); (X = -Y)).
