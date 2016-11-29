print_board(Board, _Size):-
%  print_first_line(Size), nl,
%  print_underscore_line(Size),
  maplist(print_line, Board).

print_first_line(0):-
  write('  ').
print_first_line(Size):-
  NewSize is Size - 1,
  print_first_line(NewSize),
  write(Size), write(' ').

print_underscore_line(Size):-
  write('  '),
  length(L, Size),
  maplist(print_underscore_element, L), nl.

print_underscore_element(_):-
  write('__').

print_line(Line):-
  write('|'),
  maplist(print_number, Line),
  nl.

print_number(0):-
  write(' |').
print_number(Number):-
  write(Number), write('|').
