%%%-------------------------------------------------------------------
%% @doc TrackPackFlow public API
%% @end
%%%-------------------------------------------------------------------

-module(TrackPackFlow_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    TrackPackFlow_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
