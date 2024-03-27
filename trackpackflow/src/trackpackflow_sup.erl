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
        #{id => 'requester@business.tpf.markcuizon.com',
          start => {package_request, start, [global, realrequester, []]}},
        #{id => 'storer@business.tpf.markcuizon.com',
          start => {package_storer, start, [global, realstorer, []]}},
        #{id => 'updater@business.tpf.markcuizon.com',
          start => {location_updater, start, [global, realupdater, []]}}
    ],
    {ok, {SupFlags, ChildSpecs}}.

%% internal functions
