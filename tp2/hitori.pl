:-use_module(library(lists)).
:-include('interface.pl').
:-include('logic.pl').

board(Board, Size):-
Board = [
    [ 4, 8, 1, 6, 3, 2, 5, 7 ],
    [ 3, 6, 7, 2, 1, 6, 5, 4 ],
    [ 2, 3, 4, 8, 2, 8, 6, 1 ],
    [ 4, 1, 6, 5, 7, 7, 3, 5 ],
    [ 7, 2, 3, 1, 8, 5, 1, 2 ],
    [ 3, 5, 6, 7, 3, 1, 8, 4 ],
    [ 6, 4, 2, 3, 5, 4, 7, 8 ],
    [ 8, 7, 1, 4, 2, 3, 5, 6 ]
  ],
  Size = 8.

/*board(Board, Size):-
  Board = [
    [3, 5, 5, 1, 6, 3],
    [1, 6, 1, 2, 6, 3],
    [2, 3, 6, 1, 4, 5],
    [1, 1, 1, 5, 6, 2],
    [5, 2, 4, 6, 3, 1],
    [1, 2, 3, 5, 5, 5]
  ],
  Size = 6.*/

test:-
  board(Board, Size),
  solve(Board, Size, SolvedBoard),
  print_board(SolvedBoard, Size).
