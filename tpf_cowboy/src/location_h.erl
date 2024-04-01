-module(location_h).
-behaviour(cowboy_handler).

-export([init/2]).

init(Req, State) ->
    {ok, Req_body, _End_req} = cowboy_req:read_body(Req),
    Decoded_req_body_map = jiffy:decode(Req_body, [return_maps]),
    case is_map(Decoded_req_body_map) of
        true->
            {ok, Location_id} = maps:find(<<"location_id">>, Decoded_req_body_map),
            % {ok, Latitude} = maps:find(<<"latitude">>, Decoded_req_body_map),
            % {ok, Longitude} = maps:find(<<"longitude">>, Decoded_req_body_map),
            Test = fun(A) ->
                if
                    is_atom(A) -> 
                        io:format("An atom was passed:~n");
                    is_binary(A) ->
                        io:format("A binary was passed:~n");
                    is_list(A) ->
                        io:format("A list was passed (possibly a string):~n");
                    true -> 
                        io:format("Whatever passed is of another type:~n")
            end end,
            Test(Req_body),
            io:format(Req_body),
            io:format("~n"),
            % cast(Node, Module, Function, Args) -> ok
            erpc:cast('tpf@business.tpf.markcuizon.com', gen_server, cast, [{global, realupdater}, {updating_location, Location_id, % #{latitude => Latitude, longitude => Longitude}}]),
            Req_body}]),
            % Req2 = cowboy_req:reply(200, #{}, <<"Location Req">>, Req),
            {ok, Req, State};
        _->
            {ok, Req, State}
    end.