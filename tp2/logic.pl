:-use_module(library(clpfd)).

% initialize_matrix(+Board, -SolvedBoard).
initialize_matrix([], Size, []).
initialize_matrix([B | Bs], Size, [S | Ss]):-
    initialize_line(B, Size, S),
    initialize_matrix(Bs, Size, Ss).


% initialize_line(BoardLine, SolvedBoardLine).
initialize_line([], _, []).
initialize_line([E | Es], Size, [S | Ss]):-
  MaxNumber #= Size*Size,
  PlusSize #= Size + 1,
  S in (E..E) \/ (PlusSize..MaxNumber),
  initialize_line(Es, Size, Ss).


%%%% Flood matrix %%%%
initialize_flood_matrix(Size, [], []).
initialize_flood_matrix(Size, [BoardRow | BoardRows], [FloodRow | FloodRows]):-
  initialize_flood_line(Size, BoardRow, FloodRow),
  initialize_flood_matrix(Size, BoardRows, FloodRows).


%
initialize_flood_line(_, [], []).
initialize_flood_line(Size, [BoardElem | BoardElems], [FloodElem | FloodElems]):-
  FloodElem in 0..1,
  BoardElem #> Size #=> FloodElem #= 1,
  initialize_flood_line(Size, BoardElems, FloodElems).


%
get_start_position([FirstElem, _ | _], FirstElem):-
  FirstElem #= 1 => .
get_start_position([_, SecondElem | _], SecondElem).

%
start_flood(Size, FloodMatrix):-
  transpose(FloodMatrix, TransposedFloodMatrix),
  %get_start_position(FloodMatrix, Element),
  !,
  flood(Size, FloodMatrix, TransposedFloodMatrix).

%
check_board_division(SolvedBoard, TransposedBoard, Size):-
  initialize_flood_matrix(Size, SolvedBoard, FloodMatrix),

  start_flood(Size, FloodMatrix),

  maplist(labeling([]), FloodMatrix),
  write(FloodMatrix).


% no_sequential_blacks(+Size, +List).
no_sequential_blacks(_, [_]).
no_sequential_blacks(Size, [E1, E2 | Rest]):-
  #\ (E1 #> Size #/\ E2 #> Size), % There can't be two consecutive black tiles.
  no_sequential_blacks(Size, [E2 | Rest]).

% solve(+Board, +Size, -SolvedBoard)
solve(Board, Size, SolvedBoard):-
  initialize_matrix(Board, Size, SolvedBoard),

  transpose(SolvedBoard, TransposedBoard),
  maplist(all_distinct, SolvedBoard),
  maplist(all_distinct, TransposedBoard),
  maplist(no_sequential_blacks(Size), SolvedBoard),
  maplist(no_sequential_blacks(Size), TransposedBoard),
  check_board_division(SolvedBoard, TransposedBoard, Size),
  maplist(labeling([]), SolvedBoard).


three_equals_in_a_row([_, _], [_, _]).
three_equals_in_a_row([A, B, C | R], [NewA, NewB, NewC | NewR]):-
  (A #= B #/\
  B #= C #<=> Bool),
  Bool = 1,
  NewA #= 0, NewC #= 0,
  three_equals_in_a_row([B, C | R], [NewB, NewC | NewR]).
three_equals_in_a_row([A | R], [NewA | NewR]):-
  three_equals_in_a_row(R, NewR).
