-module(location_h).
-behaviour(cowboy_handler).

-export([init/2]).

init(Req, State) ->
    Req2 = cowboy_req:reply(200, #{}, <<"Location Req">>, Req),
    {ok, Req2, State}.