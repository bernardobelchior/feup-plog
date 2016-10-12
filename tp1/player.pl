initialize(Players):-
  Players = [
  ['P', [1,1]],
  ['T', [3,7]]
  ].

get_position([], Player, Position).
get_position([[PlayerChar | Pos] | Others], Player, Position):-
  PlayerChar = Player,
  Position is Pos;
  get_position(Others, Player, Position).

%ships list, the list is a list of lists which have 2 elements, representing the position of the ships
ships(Ships):-
  Ships = [].

%checks if a direction is valid, X and Y are the distances in X and Y that will be traveled
valid_direction(X,Y) :- (X \= 0; Y\=0), ((X \= 0, Y = 0); (X = 0, Y \= 0); (X = -Y)).
