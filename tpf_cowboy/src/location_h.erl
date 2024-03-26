-module(location_h).
-behaviour(cowboy_handler).

-export([init/2]).

init(Req, State) ->
    Req2 = cowboy_req:reply(200, #{}, <<"Location Req">>, Req),
    {ok, Req_body, _End_req} = cowboy_req:read_body(Req),

    Decoded_req_body_map = jiffy:decode(Req_body, [return_maps]),
    {ok, Location_id} = maps:find(<<"location_id">>, Decoded_req_body_map),
    % {ok, Latitude} = maps:find(<<"latitude">>, Decoded_req_body_map),
    % {ok, Longitude} = maps:find(<<"longitude">>, Decoded_req_body_map),

    % cast(Node, Module, Function, Args) -> ok
    erpc:cast('updater@business.tpf.markcuizon.com', gen_server, cast, [{global, realupdater}, {updating_location, Location_id, % #{latitude => Latitude, longitude => Longitude}}]),
    Req_body}]),

    {ok, Req2, State}.