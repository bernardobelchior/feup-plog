:-use_module(library(random)).
:-use_module(library(clpfd)).
:-use_module(library(lists)).


%
generate_board(_, [], []).
generate_board(Size, [RLine | RRest], [Line | Rest]):-
  length(Line, Size),
  generate_line(Size, RLine, RLine, Line),
  generate_board(Size, RRest, Rest).

% initialize_line(BoardLine, SolvedBoardLine).
generate_line(_, _, [], []).
generate_line(Size, RLine, [R | Rs], [S | Ss]):-
  random(Probability),
  Probability < 0.2,
  random(0, Size, Position),
  nth0(Position, RLine, Equal),
  Equal \= R,
  S #= Equal,
  generate_line(Size, RLine, Rs, Ss).

generate_line(Size, RLine, [R | Rs], [S | Ss]):-
  S #= R,
  generate_line(Size, RLine, Rs, Ss).



generate_random_element(_, []).
generate_random_element(Size, [Element | Rest]):-
  random(0, Size, Domain),
  Element is Domain + 1,
  generate_random_element(Size, Rest).



generate_random_board(_, []).
generate_random_board(Size, [Row | Rows]):-
  length(Row, Size),
  generate_random_element(Size, Row),
  generate_random_board(Size, Rows).



constraint_line([_, _], [_, _]).
constraint_line([UpLeft, MidLeft, DownLeft | LeftRest], [UpRight, MidRight, DownRight | RightRest]):-
  #\ (UpLeft #= MidRight #/\  UpRight #= MidLeft #/\
  MidLeft #= DownRight #/\ MidRight #= DownLeft),

  constraint_line([MidLeft , DownLeft | LeftRest], [MidRight , DownRight | RightRest]).



constraint_impossible_boards([_]).
constraint_impossible_boards([FirstLine, SecondLine | Rest]):-
  constraint_line(FirstLine, SecondLine),
  constraint_impossible_boards([SecondLine | Rest]).



generate(Size, Board):-
  length(RandomBoard, Size),
  generate_random_board(Size, RandomBoard),

  length(Board, Size),
  generate_board(Size, RandomBoard, Board),
  transpose(Board, Columns),

  constraint_impossible_boards(Board),
  constraint_impossible_boards(Columns),

  maplist(labeling([]), Board).
