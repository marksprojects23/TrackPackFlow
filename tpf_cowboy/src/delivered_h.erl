-module(delivered_h).
-behaviour(cowboy_handler).

-export([init/2]).

init(Req, State) ->
    %{
    %  "package_id": _
    %}
    {ok, Req_body, _End_req} = cowboy_req:read_body(Req),
    erpc:call('tpf@business.tpf.markcuizon.com', gen_server, call, [{global, realstorer}, {delivering_package, Req_body}, infinity]),
    Req2 = cowboy_req:reply(200, #{}, <<"Deliver_req">>, Req),
    {ok, Req2, State}.
