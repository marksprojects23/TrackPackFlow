%%%-------------------------------------------------------------------
%% @doc TrackPackFlow public API
%% @end
%%%-------------------------------------------------------------------

-module(tpf_cowboy_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_Type, _Args) ->
    Dispatch = cowboy_router:compile([
        {'_', [
            {"/", default_page_h, []}
            % {"/logn", log_in_h, []}, % this is an example on adding more pages to ur web app.
            % {"/test", hello_h, []}
        ]}
    ]),

	PrivDir = code:priv_dir(tpf_cowboy),
	%tls stands for transport layer security
        {ok,_} = cowboy:start_tls(https_listener, [
                  		{port, 8080},
				{certfile, PrivDir ++ "fullchain.pem"},
				{keyfile, PrivDir ++ "privkey.pem"}
              		], #{env => #{dispatch => Dispatch}}),
	tpf_cowboy_sup:start_link().
stop(_State) ->
    ok.

%% internal functions





% -behaviour(application).

% -export([start/2, stop/1]).

% start(_StartType, _StartArgs) ->
%     Dispatch = cowboy_router:compile([
%             {'_', [
%                 % {"/", default_page_h, []},
%                 % {"/logn", log_in_h, []}, % this is an example on adding more pages to ur web app.
%                 {"/test", hello_h, []}
%             ]}
%         ]),
%         cowboy:start_clear(
%             my_http_listener,
%             [{port, 8087}],
%             #{env => #{dispatch => Dispatch}}
%         ),
%     trackpackflow_sup:start_link().

% stop(_State) ->
%     ok.

% %% internal functions