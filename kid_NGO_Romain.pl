/* 
Use start. to launch the script. 
At the end of the script, we use undo to erase the previous found solution, 
otherwise we cannot start a new activity.
*/
start :- guess(Activity),
      write('I know what you did today! Today you '),
      write(Activity),
      write('? '),
      nl,
      undo.

/* 
All the activities done by the kids, once it is found, do not backtrack.
Whenever the fact is verified, "!" keeps prolog from doing backtracking, 
that means prolog is not going to go back in the tree to find more solutions if none are found.
 */
guess(played) :- played, !.
guess(drew) :- drew, !.
guess(ate) :- ate, !.
guess(learned) :- learned, !.
guess(saw) :- saw, !.
/* Whenever prolog cannot find the answer */
guess(unknown).

/* 
All the activities (predicate) and their definition(fact), whenever a fact is unique to a predicate, the fact is called with check, 
when it is not, we define the fact separately (see bellow for more explanation).
*/
played :- numbers, check(had_fun_with_toys).
played :- check(had_fun_with_sand), !.
drew :- nature, fruit. 
drew :- check(used_lots_of_colors), !.
ate :- fruit , check(ingested_meat). 
ate :- check(ingested_vegetables), !.
learned :- numbers, animal.
learned :- check(tried_to_read), !.
saw :- nature, animal.
saw :- check(witnessed_human_construction), !.

/* 
The difference between these facts and the one above is because these facts are shared among multiple predicate. 
*/
numbers :- check(tried_to_count).
nature :- check(tried_to_imitate_nature).
fruit :- check(had_or_saw_natural_food).
animal :- check(learned_more_about_living_beings).

/* 
write() is used to display a message, read() to get an answer from the user. nl isused for a "newline"
the "if block" works the following: if the answer is "yes" or "y" then prolog binds the rule and assert it, 
else if the answer is anything besides "yes or "y", then no is asserted and it fails, fail is an instruction that forces prolog to backtrack
*/
ask(Question) :-
    write('Today, you: '),
    write(Question),
    write('? '),
    read(Response),
    nl,
    ( (Response == yes ; Response == y)
      ->
       assert(yes(Question)) ;
       assert(no(Question)), fail).

/* 
Here we set yes and no to dynamic. 
Setting a predicate to dynamic informs prolog that these predicate might change during the execution of the program.
If we do not do this, assert (or retract()) cannot be used.
*/
:- dynamic yes/1,no/1.

/* if yes then always succeed, else if no then always fail else ask again */
check(S) :-
   (yes(S) -> true ; (no(S) -> fail ; ask(S))).

/* 
undo is used for clearing the found solution, if we do not clear it, 
everytime we restart the script, the script will be stuck at the last solution found.
 */
undo :- retract(yes(_)),fail. 
undo :- retract(no(_)),fail.
undo.