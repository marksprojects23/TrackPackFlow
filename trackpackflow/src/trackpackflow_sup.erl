%%%-------------------------------------------------------------------
%% @doc TrackPackFlow top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(trackpackflow_sup).

-behaviour(supervisor).

-export([start_link/0]).

-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%% sup_flags() = #{strategy => strategy(),         % optional
%%                 intensity => non_neg_integer(), % optional
%%                 period => pos_integer()}        % optional
%% child_spec() = #{id => child_id(),       % mandatory
%%                  start => mfargs(),      % mandatory
%%                  restart => restart(),   % optional
%%                  shutdown => shutdown(), % optional
%%                  type => worker(),       % optional
%%                  modules => modules()}   % optional
init([]) ->
    SupFlags = #{strategy => one_for_one,
                 intensity => 0,
                 period => 1},
                 % Node names: requester, storer, updater
    ChildSpecs = [
        #{id => requester,
          start => {package_request, start_link, []}},
        #{id => storer,
          start => {package_storer, start_link, []}},
        #{id => updater,
          start => {location_updater, start_link, []}}
    ],
    {ok, {SupFlags, ChildSpecs}}.

%% internal functions
