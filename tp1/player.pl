
%players
player(P).
player(T).
player(V).
player(Z).

%ships list, the list is a list of lists which have 2 elements, representing the position of the ships
list(ships).

%checks if a direction is valid, X and Y are the distances in X and Y that will be traveled
valid_direction(X,Y) :- (X \= 0; Y\=0), ((X \= 0, Y = 0); (X = 0, Y \= 0); (X = -Y)).
