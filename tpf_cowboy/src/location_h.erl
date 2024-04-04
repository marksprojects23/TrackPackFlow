-module(location_h).
-behaviour(cowboy_handler).

-export([init/2]).

init(Req, State) ->
    {ok, Req_body, _End_req} = cowboy_req:read_body(Req),
    Decoded_req_body_map = jiffy:decode(Req_body, [return_maps]),
    case is_map(Decoded_req_body_map) of
        true->
            {ok, Location_id} = maps:find(<<"location_id">>, Decoded_req_body_map),
            erpc:cast('tpf@business.tpf.markcuizon.com', gen_server, cast, [{global, realupdater}, {updating_location, Location_id,
            Req_body}]),
            % Req2 = cowboy_req:reply(200, #{}, <<"Update_req">>, Req),
            % {ok, Req2, State};
            {ok, Req, State};
        _->
            {ok, Req, State}
    end.