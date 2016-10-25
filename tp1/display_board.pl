:-include('logic.pl').
:-include('list_utils.pl').

start:-
  initialize(Players),
  board(Board),
  /*write('   '), nl,
  display_columns(Board, -4), nl*/
  display_board(Board, Players, 1, 0).

display_board([], Players, Offset, Y):-
  print_offset_triangle(Offset), print_first_row([Element | Rest]), nl,
  print_offset_triangle(Offset), print_second_row([Element | Rest]), nl.
display_board([Line | Rest], Players, Offset, Y):-
  display_line(Line, [-4, Y], Players, Offset),
  negate(Offset, NextOffset),
  NextY is Y + 1,
  /*is_empty(Rest),
  print_offset(Offset), print_first_row([Element]), nl,
  print_offset(Offset), print_second_row([Element]), nl;*/
  display_board(Rest, Players, NextOffset, NextY).

display_line([Element | Rest], [X, Y], Players, Offset):-
  print_offset_triangle(Offset), print_first_row([Element | Rest]), nl,
  print_offset_triangle(Offset), print_second_row([Element | Rest]), nl,
  print_offset_center(Offset), print_third_row([Element | Rest], [X,Y], Players), nl,
  print_offset_center(Offset), print_fourth_row([Element | Rest], [X,Y], Players), nl.
%  print_offset(Offset), print_fifth_row([Element | Rest]), nl,
%  print_offset(Offset), print_sixth_row([Element | Rest]).

print_first_row([]).
print_first_row([null | Rest]):-
  write('         '),
  print_first_row(Rest).
print_first_row([Element | Rest]):-
  print_triangle_top,
  print_first_row(Rest).

print_second_row([]).
print_second_row([null | Rest]):-
  write('         '),
  print_second_row(Rest).
print_second_row([Element | Rest]):-
  print_triangle_bottom,
  print_second_row(Rest).

print_third_row([], [X, Y], Players).
print_third_row([null | Rest], [X, Y], Players):-
  write('         '),
  print_third_row(Rest, [X, Y], Players).
print_third_row([Element | Rest], [X, Y], Players):-
  print_element_first_line(Element, [X,Y], Players),
  print_third_row(Rest, [X, Y], Players).

print_fourth_row([], [X, Y], Players).
print_fourth_row([null | Rest], [X, Y], Players):-
  write('         '),
print_fourth_row(Rest, [X, Y], Players).
print_fourth_row([Element | Rest], [X, Y], Players):-
  print_element_second_line(Element, [X,Y], Players),
  print_fourth_row(Rest, [X, Y], Players).

print_fifth_row([]).
print_fifth_row([null | Rest]):-
  write('         '),
  print_fifth_row(Rest).
print_fifth_row([Element | Rest]):-
  print_triangle_top,
  print_fifth_row(Rest).

print_sixth_row([]).
  print_sixth_row([null | Rest]):-
  write('         '),
  print_sixth_row(Rest).
print_sixth_row([Element | Rest]):-
  print_triangle_bottom,
  print_sixth_row(Rest).

print_offset_triangle(0).
print_offset_triangle(1):-
  write('    ').

print_offset_center(0).
print_offset_center(1):-
  write('    ').


%Debug
test:-
  print_triangle_top, nl,
  print_triangle_bottom, nl,
  print_element_first_line(wormhole, [], []), nl,
  print_element_second_line(wormhole, [], []), nl,
  write(' '), print_triangle_right_top, print_triangle_top, nl,
  write(' '), print_triangle_right_bottom, print_triangle_bottom.

print_triangle_top:-
  print_triangle_left_top, write(' '),
  print_triangle_right_top.

print_triangle_bottom:-
  print_triangle_left_bottom, write(' '),
  print_triangle_right_bottom.

print_triangle_left_top:-
  write('   /').
print_triangle_right_top:-
  write('\\  ').
print_triangle_left_bottom:-
  write(' /  ').
print_triangle_right_bottom:-
  write('  \\').

space(0).
space(Count):-
  write(' '),
  C1 is Count - 1,
  space(C1).

% WRITE ELEMENTS

  print_element_first_line(null, Position, Players):-
    write('         ').
  print_element_second_line(null, Position, Players):-
    write('         ').

  print_element_first_line(space, Position, Players):-
    write('|       ').
  print_element_second_line(space, Position, Players):-
    write('|       ').

  print_element_first_line(wormhole, Position, Players):-
    write('| Worm  ').
  print_element_second_line(wormhole, Position, Players):-
    write('| Hole  ').

  print_element_first_line(blackHole, Position, Players):-
    write('| Black ').
  print_element_second_line(blackHole, Position, Players):-
    write('| Hole  ').

    print_element_first_line(system0, Position, Players):-
      write('|       ').
    print_element_second_line(system0, Position, Players):-
      write('|       ').

      print_element_first_line(system1, Position, Players):-
        write('|   *   ').
      print_element_second_line(system1, Position, Players):-
        write('|       ').

        print_element_first_line(system2, Position, Players):-
          write('|  *  * ').
        print_element_second_line(system2, Position, Players):-
          write('|       ').

          print_element_first_line(system3, Position, Players):-
            write('| * * * ').
          print_element_second_line(system3, Position, Players):-
            write('|       ').

            print_element_first_line(blueNebula, Position, Players):-
              write('|~Blue~~').
            print_element_second_line(blueNebula, Position, Players):-
              write('|       ').

print_element_first_line(greenNebula, Position, Players):-
  write('|~Green~').
print_element_second_line(greenNebula, Position, Players):-
  write('|       ').

print_element_first_line(redNebula, Position, Players):-
  write('|~~Red~~').
print_element_second_line(redNebula, Position, Players):-
  write('|       ').
