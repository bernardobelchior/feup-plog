include('list_utils.pl').

start:-
  board(Board, Width),
  display_board(Board, Width).

board(Board, Width):-
  Board = [['A', 'A', 'A'],
          ['A', 'A', 'A', 'A'],
          ['A', 'A', 'A', 'A', 'A'],
          ['A', 'A', 'A', 'A'],
          ['A', 'A', 'A']],
  Width is 5.

display_board([], Width).
display_board([Even | Rest], Width):-
  indent_line(Even, Width),
  display_even_line(Even), nl,
  display_rest(Rest, Width).

display_rest([], Width).
display_rest([Odd | Rest], Width):-
  indent_line(Odd, Width),
  display_odd_line(Odd), nl,
  display_board(Rest, Width).

display_odd_line([]).
display_odd_line([Current | Rest]):-
  write(' '), write(Current),
  display_odd_line(Rest).

display_even_line([]).
display_even_line([Current | Rest]):-
  write(Current), write(' '),
  display_even_line(Rest).

indent_line([Line | Rest], Width):-
  get_line_width([Line | Rest], LineWidth),
  Spaces is round(Width - LineWidth/2),
  space(Spaces).

space(0).
space(Count):-
  write('  '),
  C1 is Count - 1,
  space(C1).

get_line_width([], 0).
get_line_width([Element | Rest], LineWidth):-
  get_line_width(Rest, LineWidth1),
  LineWidth is LineWidth1 + 1.


%get element in x
