-module(euler29).
-export([smart/1,brute/1]).

brute([L]) ->
    Max = list_to_integer(L),
    Seq = lists:seq(2,Max),
    length(lists:usort([floor(math:pow(A,B)) || A <- Seq, B <- Seq])).

smart([L]) ->
    N = list_to_integer(L),
    Bases = uniq_bases(N),
    Dups = dups(floor(math:log2(N)), N),
    io:format("Reduced bases: ~p~n", [Bases]),
    io:format("Dups: ~p~n", [Dups]),
    AllDups = lists:sum([lists:nth(I,Dups) || I <- lists:append(Bases)]),
    (N-1)*(N-1) - AllDups.

dups(MaxP, MaxN) ->
    N = lists:seq(2,MaxN),
    Prods = [sets:from_list([P*I || I <- N]) || P <- lists:seq(1,MaxP)],
    Fun = fun (S1, S2) ->
                  {sets:intersection(S1,S2), sets:union(S1,S2)}
          end,
    {L,_} = lists:mapfoldl(Fun,sets:new(),Prods),
    [sets:size(S) || S <- L].

log(N,M) -> floor(math:log(M) / math:log(N)).

uniq_bases(N) -> uniq_bases(lists:seq(2,floor(math:sqrt(N))), N, []).
uniq_bases([], _, L) -> L;
uniq_bases([I|Is], N, L) ->
    Log = log(I,N),
    Pows = lists:seq(1,Log),
    {Vals,_} = lists:mapfoldl(fun (X,Y) -> {Y,X*Y} end, I,
                              lists:duplicate(Log-1,I)),
    uniq_bases(Is -- Vals, N, [Pows|L]).
