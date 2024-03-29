%%%-------------------------------------------------------------------
%% @doc tpf_cowboy public API
%% @end
%%%-------------------------------------------------------------------

-module(trackpackflow_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    trackpackflow_sup:start_link().
    %{ok, _Pid} = riakc_pb_socket:start_link("riak01.tpf.markcuizon.com", 8087),
    % package_storer:start(global, realstorer, []),       % starting every kind of gen server per node is impractical
    % location_updater:start(global, realupdater, []),    % change soon
    % package_request:start(global, realrequester, []).

stop(_State) ->
    ok.

%% internal functions
