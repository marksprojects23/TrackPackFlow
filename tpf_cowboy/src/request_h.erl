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
    Decoded_req_body_map = jiffy:decode(Req_body),
    Coords_binary = erpc:call('tpf@business.tpf.markcuizon.com', gen_server, call, [{global, realrequester}, {getting_location, Decoded_req_body_map}, infinity]),
    % io:format(Coords_binary),
    case Coords_binary of
        <<"Package doesn't exist yet.">>->Req2 = cowboy_req:reply(500, #{}, <<"Package not found.">>, Req);
        <<"No coords yet">>->Req2 = cowboy_req:reply(500, #{}, <<"Location not yet set.">>, Req);
        _->Req2 = cowboy_req:reply(200, #{}, Coords_binary, Req)
    end,
    % Req2 = cowboy_req:reply(200, #{}, Coords_binary, Req),
    {ok, Req2, State}.

% curl -X POST \
%      -H "Content-Type: text/plain" \
%      -d '18ebb5ce-3b50-4408-9599-934b7a469dd5' \
%      https://cowboy.tpf.markcuizon.com/location_request