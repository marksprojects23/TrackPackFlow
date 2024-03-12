-module(hello_h).
-behaviour(cowboy_handler).

-export([init/2]).

init(Req, State) ->
    Req2 = cowboy_req:reply(200, #{}, <<"Hello, World!">>, Req),
    io:format("test print~n"),
    {ok, Req2, State}.
