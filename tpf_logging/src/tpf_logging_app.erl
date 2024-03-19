%%%-------------------------------------------------------------------
%% @doc tpf_logging public API
%% @end
%%%-------------------------------------------------------------------

-module(tpf_logging_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    tpf_logging_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
