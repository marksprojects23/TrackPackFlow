-module(request_h).
-behaviour(cowboy_handler).

-export([init/2]).

init(Req, State) ->
    {ok, Req_body, _End_req} = cowboy_req:read_body(Req),
    Req2 = cowboy_req:reply(200, #{}, <<"Request Req">>, Req),
    {ok, Req2, State}.