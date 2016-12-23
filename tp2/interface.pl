print_board(Board, Size):-
  Base is floor(log(10, Size)) + 1,

  nl, write('~ Hitori ~'), nl, nl, nl,

  maplist(print_line(Size, Base), Board), !.

print_line(Size, Base, Line):-
  write('|'),
  maplist(print_number(Size, Base), Line),
  nl.

print_number(Size, Base, Number):-
  Number > Size,
  number_codes(Base, NC),
  atom_codes(BaseAtom, NC),
  atom_concat('~', BaseAtom, Tmp),
  atom_concat(Tmp, 'c', Format),
  format(Format, 32),
  write('|').
print_number(_, Base, Number):-
  SpaceBefore is Base - floor(log(10, Number)) - 1,
  number_codes(SpaceBefore, NC),
  atom_codes(SBAtom, NC),
  atom_concat('~', SBAtom, Tmp),
  atom_concat(Tmp, 'c', Format),
  format(Format, 32), write(Number),
  write('|').

print_fd_statistics:-
  fd_statistics(resumptions, Resumptions),
  fd_statistics(entailments, Entailments),
  fd_statistics(prunings, Prunings),
  fd_statistics(backtracks, Backtracks),
  fd_statistics(constraints, Constraints),
  write('Resumptions: '), write(Resumptions), nl,
  write('Entailments: '), write(Entailments), nl,
  write('Prunings: '), write(Prunings), nl,
  write('Backtracks: '), write(Backtracks), nl,
  write('Constraints: '), write(Constraints), nl.
