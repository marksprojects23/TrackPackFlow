%%%-------------------------------------------------------------------
%% @doc tpf_cowboy public API
%% @end
%%%-------------------------------------------------------------------

-module(trackpackflow_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    trackpackflow_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
