-module(request_h).
-behaviour(cowboy_handler).

-export([init/2]).

init(Req, State) ->
    % Package_id is in binary
    {ok, Package_id, _End_req} = cowboy_req:read_body(Req),
    % erpc:call('storer@business.tpf.markcuizon.com', data_service, store_package, {storing_package, Package_id, Location_id}),
    erpc:call('storer@business.tpf.markcuizon.com', package_storer, handle_call, {storing_package, Package_id}),
    Req2 = cowboy_req:reply(200, #{}, <<"Request Req">>, Req),
    {ok, Req2, State}.