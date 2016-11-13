main_menu:-
  draw_main_menu,
  select_main_menu_action;
  main_menu.

select_main_menu_action:-
  read(Action),
  Action > 0,
  Action < 8,
  main_menu_go_to_menu(Action).

main_menu_go_to_menu(1):-
  start_game.
%main_menu_go_to_menu(6):-
  %how_to_play_menu.
main_menu_go_to_menu(7).
main_menu_go_to_menu(Action). %temp

how_to_play_menu:-
  draw_how_to_play_menu,
  select_how_to_play_menu_action;
  how_to_play_menu.

select_how_to_play_menu_action:-
  read(Action),
  Action > 0,
  Action < 2,
  how_to_play_menu_go_to_menu(Action).

how_to_play_menu_go_to_menu(1):-
  main_menu.
how_to_play_menu_go_to_menu(Action). %Temp
