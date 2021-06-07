/* Expert System in Prolog to chose the bear you want from the various options the system have. It asks you several questions and
 then selects the best beer you can drink */

:- dynamic yes/1, no/1.


/* list of beer items */
% 1
beer(pilsner) :-     is("light-colored"),
                     is("mildly hoppy"),
                     is("somewhat malty"),
                     is("low in alcohol"),
                     nl.
% 2
beer(amberLager) :-  is("amber-colored"),
                     is("moderately hoppy"),
                     is("somewhat malty"),
                     is("moderate in alcohol"),
                     nl.
% 3
beer(paleAle) :-     is("amber-colored"),
                     is("very hoppy"),
                     is("somewhat malty"),
                     is("high in alcohol"),
                     nl.
% 4
beer(porter) :-      is("dark-colored"),
                     is("very hoppy"),
                     is("quite malty"),
                     is("moderate in alcohol"),
                     nl.
% 5
beer(irishStout) :-  is("dark-colored"),
                     is("moderately hoppy"),
                     is("somewhat malty"),
                     is("moderate in alcohol"),
                     nl.
% 6
beer(milkStout) :-   is("dark-colored"),
                     is("mildly hoppy"),
                     is("quite malty"),
                     is("moderate in alcohol"),
                     nl.
% 7
beer(bock) :-        is("dark-colored"),
                     is("mildly hoppy"),
                     is("quite malty"),
                     is("high in alcohol"),
                     nl.
% 8
beer(wheatBeer) :-   is("amber-colored"),
                     is("mildly hoppy"),
                     is("somewhat malty"),
                     is("low in alcohol"),
                     nl.
% 9
beer(brownAle) :-    is("dark-colored"),
                     is("mildly hoppy"),
                     is("quite malty"),
                     is("moderate in alcohol"),
                     nl.
% 10
beer(sourBeer) :-    is("light-colored"),
                     is("moderately hoppy"),
                     is("somewhat malty"),
                     is("sour"),
                     is("high in alcohol"),
                     nl.
% 11
beer(ipa) :-         is("light-colored"),
                     is("very hoppy"),
                     is("somewhat malty"),
                     is("high in alcohol"),
                     nl.
% 12
beer(scottishAle) :- is("amber-colored"),
                     is("mildly hoppy"),
                     is("quite malty"),
                     is("high in alcohol"),
                     nl.
% 13
beer(redAle) :-      is("amber-colored"),
                     is("moderately hoppy"),
                     is("somewhat malty"),
                     is("high in alcohol"),
                     nl.
% 14
beer(dubbel) :-      is("dark-colored"),
                     is("moderately hoppy"),
                     is("not too sweet"),
                     is("moderate in alcohol"),
                     nl.
% 15
beer(belgianGold) :- is("light-colored"),
                     is("very hoppy"),
                     is("not too sweet"),
                     is("high in alcohol"),
                     nl.


/* deassert options in category other than affirmed attribute */
eliminateOthers(_, []).
eliminateOthers(Attribute, [H|T]) :- (dif(H, Attribute) -> assert(no(H)); true),
                                     eliminateOthers(Attribute, T).


/* test if attribute is in this category, call eliminateOthers if so */
eliminateIfMember(Attribute, List) :- member(Attribute, List) ->
                                        eliminateOthers(Attribute, List),
                                        true, !;
                                        false, !.


/* call eliminateIfMember on each category till affirmed attribute matches */
elimination(Attribute) :-
  eliminateIfMember(Attribute,
    ["light-colored", "amber-colored", "dark-colored"]), true;
  eliminateIfMember(Attribute,
    ["mildly hoppy", "moderately hoppy", "very hoppy"]), true;
  eliminateIfMember(Attribute,
    ["not too sweet", "somewhat malty", "quite malty"]), true;
  eliminateIfMember(Attribute,
    ["low in alcohol", "moderate in alcohol", "high in alcohol"]), true.


/* assert & deassert attributes based on user input */
is(Attribute) :-
  ((yes(Attribute) ->
    true, !;
    no(Attribute) ->
    false, !;
    format("Would you like your beer to be ~w?~n", [Attribute]),
    read(Answer),
    (Answer = yes ->
      assert(yes(Attribute)),
      elimination(Attribute),
      true,
      !;
    Answer = no ->
      assert(no(Attribute)), false, !;
    write("Please answer 'yes.' or 'no.'"), nl,
    is(Attribute)))
  ).


/* check if user is ready */
ready :-
  write("Are you ready? "),
  read(X),
  (X = yes ->
    true, !;
  X = no ->
    write("Goodbye."), nl, fail, !;
  write("Please answer 'yes.' or 'no.'"), nl, ready).


/* main menu */
guessBeer :-
  write("I will now ask you questions to find out your favorite beer."), nl,
  ( beer(X),
    write("You should order the "), write(X), write("."), nl,
    checkifRight
  ) ;
  ( write("Sorry, I could not find a beer matching those criteria."), nl,
    write("My creator should have been a more experienced beer drinker!"), nl
  ).


/* prompt user to verify if answer was correct */
checkifRight :-
write("Did I guess correctly?"),
read(yes) -> write("Told you I would!"), nl ;
             write("I hope I can get it next time... "), nl,
             fail.


/* initialization */
begin :- write("Welcome to the Beer Selector..."), nl,
         write("an Expert System to pick the beer you need!"), nl,
         retractall(yes(_)),
         retractall(no(_)),
         ready -> guessBeer,
                  write("Type 'begin.' and press enter to have another go!");
                  fail.
