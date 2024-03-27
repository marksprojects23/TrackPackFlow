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
        #{id => package_request,
          start => {package_request, start, [global, realrequester, []]}},
        % erpc:cast('tpf@business.tpf.markcuizon.com', gen_server, cast, [{global, realupdater}, {updating_location, Location_id, Req_body}]),
        #{id => package_storer,
          start => {package_storer, start, [global, realstorer, []]}},
        #{id => location_updater,
          start => {location_updater, start, [global, realupdater, []]}}
    ],
    {ok, {SupFlags, ChildSpecs}}.

%% internal functions
