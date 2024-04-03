-module(delivered_h).
-behaviour(cowboy_handler).

-export([init/2]).

init(Req, State) ->
    {ok, Req_body, _End_req} = cowboy_req:read_body(Req),
    Decoded_req_body_map = jiffy:decode(Req_body),
    
    erpc:call('tpf@business.tpf.markcuizon.com', gen_server, call, [{global, realstorer}, {delivering_package, Decoded_req_body_map}, infinity]),
    Req2 = cowboy_req:reply(200, #{}, <<"Deliver_req">>, Req),
    {ok, Req2, State}.
