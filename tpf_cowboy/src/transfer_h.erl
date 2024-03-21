-module(transfer_h).
-behaviour(cowboy_handler).

-export([init/2]).

init(Req, State) ->
    %{
    %  "package_id": _,
    %  "location_id": _
    %}
    {ok, Req_body, _End_req} = cowboy_req:read_body(Req),
    % Decode the JSON. Using option return_maps returns the JSON as an erlang map.
    Decoded_req_body_map = jiffy:decode(Req_body, [return_maps]),
    {ok, Location_id} = maps:find(<<"location_id">>, Decoded_req_body_map),
    {ok, Package_id} = maps:find(<<"package_id">>, Decoded_req_body_map),
    io:format(Package_id),
    SelfPid = self(),
    erpc:call('storer@business.tpf.markcuizon.com', gen_server, call, [{global, realstorer}, [{storing_package, Package_id, Location_id}, SelfPid, SelfPid], infinity]),
    % erpc:call({realstorer, 'storer@business.tpf.markcuizon.com'}, data_service, store_package, [Package_id, Location_id, SelfPid]),
    %io:format(A),
    % erpc:call('package_request@business.tpf.markcuizon.com', package_storer, handle_call, {storing_package, Package_id, Location_id}),
    Req2 = cowboy_req:reply(200, #{}, <<"Transfer_req">>, Req),
    {ok, Req2, State}.
