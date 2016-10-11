start:-
  board(Board),
  display_board(Board, 0).


board(Board):-
  Board = [
  ['', '', '', '', 'O', 'O', 'O', 'O', '', '', '', ''],
  ['', '', '', '', 'O', 'O', 'X', 'O', 'O', 'O', 'O', ''],
  ['', '', '', 'O', 'O', 'O', 'O', 'O', 'O', 'W', 'O', ''],
  ['', '', '', 'O', 'O', 'O', 'O', 'O', 'O', 'O', 'O', ''],
  ['', '', 'O', 'O', 'O', 'O', 'O', 'O', 'O', 'O', 'O', ''],
  ['', '', '', 'O', 'O', 'O', 'O', 'O', 'O', 'O', 'X', ''],
  ['', '', 'O', 'O', 'O', 'X', 'O', 'O', 'O', 'O', ' ', ''],
  ['', '', 'O', 'O', 'O', 'O', 'O', 'O', 'W', 'O', 'O', ''],
  ['', '', '', '', '', 'O', 'O', 'O', 'O', '', '', '']
  ].

/*board(Board):-
  Board = [
          ['O', 'O', 'O', 'O', ' ', ' ', ' ', ' '],
          ['O', 'O', 'O', 'X', 'O', 'O', 'O', ''],
          ['O', 'O', 'O', 'O', 'O', 'W', 'O', ' '],
          ['O', 'W', 'O', 'O', 'O', 'O', 'O', ' '],
          ['O', 'O', 'O', 'O', 'O', 'O', 'O', ' '],
          [' ', 'O', 'O', 'O', 'O', 'O', 'X', 'O'],
          ['O', 'X', 'O', 'O', 'O', 'O', 'O', ' '],
          [' ', 'O', 'O', 'O', 'W', 'O', 'O', 'O'],
          [' ', ' ', ' ', 'O', 'O', 'O', 'O', ' ']].*/

display_board([], Offset).
display_board([Even | Rest], Offset):-
  /*indent_line(Even, Width),*/
  space(Offset),
  display_even_line(Even), nl,
  display_rest(Rest, Offset).

display_rest([], Offset).
display_rest([Odd | Rest], Offset):-
  /*indent_line(Odd, Width),*/
  space(Offset),
  display_odd_line(Odd), nl,
  Offset1 is Offset+1,
  display_board(Rest, Offset1).

display_odd_line([]).
display_odd_line([Current | Rest]):-
  write(Current), write(' '),
  display_odd_line(Rest).

display_even_line([]).
display_even_line([Current | Rest]):-
  write(' '), write(Current),
  display_even_line(Rest).

  space(0).
  space(Count):-
    write('  '),
    C1 is Count - 1,
  space(C1).

/*indent_line([Line | Rest], Width):-
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
  LineWidth is LineWidth1 + 1.*/
