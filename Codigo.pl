:- dynamic student/3.

% student(ID, EntryTime, ExitTime)
% ExitTime = 0 -> estudiante aún dentro

% ================= MENU =================

menu :-
    repeat,
    nl,
    write('---- Student Registration System ----'), nl,
    write('1. Check In'), nl,
    write('2. Search Student by ID'), nl,
    write('3. Calculate Time'), nl,
    write('4. List Students'), nl,
    write('5. Check Out'), nl,
    write('6. Exit'), nl,
    write('Choose option: '),
    read(Option),
    process_option(Option),
    Option == 6, !.

process_option(1) :- check_in, !.
process_option(2) :- search_student, !.
process_option(3) :- calculate_time, !.
process_option(4) :- list_students, !.
process_option(5) :- check_out, !.
process_option(6) :- write('Exiting...'), nl, !.
process_option(_) :- write('Invalid option'), nl.

% ================= CHECK IN =================

check_in :-
    write('Student ID: '),
    read(ID),
    ( student(ID, _, Exit), Exit =:= 0 ->
        write('Student already inside.'), nl
    ;
        write('Entry time (minutes since 00:00): '),
        read(Time),
        assertz(student(ID, Time, 0)),
        write('Student checked in.'), nl
    ).

% ================= SEARCH =================

search_student :-
    write('Enter student ID: '),
    read(ID),
    ( student(ID, Entry, Exit) ->
        ( Exit =:= 0 ->
            write('Student is inside.'), nl
        ;
            write('Student already checked out.'), nl
        ),
        write(student(ID, Entry, Exit)), nl
    ;
        write('Student not found.'), nl
    ).

% ================= CALCULATE TIME =================

calculate_time :-
    write('Student ID: '),
    read(ID),
    ( student(ID, Entry, Exit) ->
        ( Exit =:= 0 ->
            write('Student has not checked out yet.'), nl
        ;
            Duration is Exit - Entry,
            write('Time spent (minutes): '),
            write(Duration), nl
        )
    ;
        write('Student not found.'), nl
    ).

% ================= LIST =================

list_students :-
    ( student(_,_,_) ->
        forall(student(ID,E,X),
            (write(student(ID,E,X)), nl))
    ;
        write('No students registered.'), nl
    ).

% ================= CHECK OUT =================

check_out :-
    write('Student ID: '),
    read(ID),
    ( student(ID, Entry, Exit) ->
        ( Exit =:= 0 ->
            write('Exit time (minutes since 00:00): '),
            read(Time),
            retract(student(ID, Entry, 0)),
            assertz(student(ID, Entry, Time)),
            write('Student checked out.'), nl
        ;
            write('Student already checked out.'), nl
        )
    ;
        write('Student not found.'), nl
    ).