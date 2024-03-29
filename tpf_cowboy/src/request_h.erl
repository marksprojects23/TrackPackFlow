-module(request_h).
-behaviour(cowboy_handler).

-export([init/2]).

init(Req, State) ->
    %{
    %  "package_id": _
    %}
    {ok, Req_body, _End_req} = cowboy_req:read_body(Req),
    % Decode the JSON. Using option return_maps returns the JSON as an erlang map.
    % Decoded_req_body_map = jiffy:decode(Req_body, [return_maps]),
    % {ok, Package_id} = maps:find(<<"package_id">>, Decoded_req_body_map),
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
    Coords_binary = erpc:call('tpf@business.tpf.markcuizon.com', gen_server, call, [{global, realrequester}, {getting_location, Req_body}, infinity]),
    io:format(Coords_binary),
    Req2 = cowboy_req:reply(200, #{}, Coords_binary, Req),
    {ok, Req2, State}.

% curl -X POST \
%      -H "Content-Type: test/plain" \
%      -d '18ebb5ce-3b50-4408-9599-934b7a469dd5' \
%      https://cowboy.tpf.markcuizon.com/location_request