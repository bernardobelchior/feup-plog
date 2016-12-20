print_board(Board, Size):-
  maplist(print_line(Size), Board).

print_line(Size, Line):-
  write('|'),
  maplist(print_number(Size), Line),
  nl.

print_number(Size, Number):-
  Number > Size,
  write(' |').
print_number(_, Number):-
  write(Number), write('|').
