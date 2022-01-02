-module(euler29).
-export([smart/1,brute/1]).

%% Like APL's scan operator ("\").
scan(Fun, [Hd|Tl]) ->
    scan(Fun,Hd,Tl,[]).
scan(_, X, [], L) ->
    lists:reverse([X|L]);
scan(Fun, X, [Y|L1], L2) ->
    scan(Fun, Fun(X,Y), L1, [X|L2]).

dump(Is, Tbl) ->
    lists:foreach(fun({I,L}) ->
                          Str = [$0 + D || D <- L],
                          io:format("\t~02.B: ~s~n", [I, Str])
                  end, lists:zip(Is, Tbl)).

smart([Max]) ->
    MaxB = list_to_integer(Max),
    %% MaxA = floor(math:sqrt(MaxB)),
    MaxA = floor(math:log(MaxB) / math:log(2)),
    As = lists:seq(2,MaxA),
    Bs = lists:seq(2,MaxB),
    %% NOTE: Squares are not dups! If 2^2 is within range remember 4^1 is not calculated!
    Tbl1 = [[if A >= B -> 0; B rem A /= 0 -> 0; true -> 1 end || B <- Bs]
            || A <- As],
    %% io:format("Tbl1\t~lp~n", [Tbl1]),
    io:format("Tbl1~n", []),
    dump(As, Tbl1),
    Tbl2 = scan(fun(L1, L2) ->
                        lists:zipwith(fun(B1,B2) -> B1 + B2 end, L1, L2)
                end, Tbl1),
    %% io:format("Tbl2\t~lp~n", [Tbl2]),
    io:format("Tbl2~n", []),
    dump(As, Tbl2),
    PowDups = [lists:sum(L) || L <- Tbl2],
    io:format("PowDups\t~lp~n", [PowDups]),
    %% Pows = [floor(math:log(MaxB) / math:log(A)) || A <- As],
    HasPows = lists:seq(2, floor(math:sqrt(MaxB))),
    io:format("HasPows\t~lp~n", [HasPows]),
    Pows = [floor(math:log(MaxB) / math:log(I)) || I <- HasPows],
    io:format("Pows\t~lp~n", [Pows]),
    Dups = [lists:nth(I-1, PowDups) || I <- Pows],
    io:format("Dups\t~lp~n", [Dups]),
    io:format("Answer\t~B~n", [(MaxB-1) * (MaxB-1) - lists:sum(Dups)]).

brute([L]) ->
    Max = list_to_integer(L),
    Seq = lists:seq(2,Max),
    X = length(lists:usort([floor(math:pow(A,B)) || A <- Seq, B <- Seq])),
    io:format("Answer\t~B~n", [X]).
