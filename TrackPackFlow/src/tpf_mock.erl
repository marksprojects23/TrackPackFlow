%% @author Lee Barney
%% @copyright 2022 Lee Barney licensed under the <a>
%%        rel="license"
%%        href="http://creativecommons.org/licenses/by/4.0/"
%%        target="_blank">
%%        Creative Commons Attribution 4.0 International License</a>
%%
%%
-module(tpf_mock).
-behaviour(gen_server).


%% API
-export([start/0,start/3,stop/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).


%%%===================================================================
%%% API
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Starts the server assuming there is only one server started for 
%% this module. The server is registered locally with the registered
%% name being the name of the module.
%%
%% @end
%%--------------------------------------------------------------------
-spec start() -> {ok, pid()} | ignore | {error, term()}.
start() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).
%%--------------------------------------------------------------------
%% @doc
%% Starts a server using this module and registers the server using
%% the name given.
%% Registration_type can be local or global.
%%
%% Args is a list containing any data to be passed to the gen_server's
%% init function.
%%
%% @end
%%--------------------------------------------------------------------
-spec start(atom(),atom(),atom()) -> {ok, pid()} | ignore | {error, term()}.
start(Registration_type,Name,Args) ->
    gen_server:start_link({Registration_type, Name}, ?MODULE, Args, []).


%%--------------------------------------------------------------------
%% @doc
%% Stops the server gracefully
%%
%% @end
%%--------------------------------------------------------------------
-spec stop() -> {ok}|{error, term()}.
stop() -> gen_server:call(?MODULE, stop).

%% Any other API functions go here.

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Initializes the server
%%
%% @end
%%--------------------------------------------------------------------
-spec init(term()) -> {ok, term()}|{ok, term(), number()}|ignore |{stop, term()}.
init([]) ->
        {ok,replace_up}.
%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling call messages
%%
%% @end
%%--------------------------------------------------------------------
-spec handle_call(Request::term(), From::pid(), State::term()) ->
                                  {reply, term(), term()} |
                                  {reply, term(), term(), integer()} |
                                  {noreply, term()} |
                                  {noreply, term(), integer()} |
                                  {stop, term(), term(), integer()} | 
                                  {stop, term(), term()}.
handle_call({storing_package, Package_id, Location_id}, _From, Db_PID) ->
        case lists:any(fun(A)->A=="" end,[Package_id,Location_id]) of
            true ->
                {reply,{fail,empty_key},Db_PID};
            _ ->
                {reply,data_service:store_package(Package_id, Location_id, Db_PID),Db_PID}
        end;

handle_call({delivering_package,Package_id}, _From, Db_PID) ->
        case Package_id =:= ("") of
            true ->
                {reply,{fail,empty_key},Db_PID};
            _ ->
                {reply,data_service:delivered_package(Package_id, Db_PID),Db_PID}
        end;

handle_call({getting_location,Package_id}, _From, Db_PID) ->
        case Package_id =:= ("") of
            true ->
                {reply,{fail,empty_key},Db_PID};
            _ ->
                {reply,data_service:get_location(Package_id,Db_PID),Db_PID}
        end;
handle_call(stop, _From, _State) ->
        {stop,normal,
                replace_stopped,
          down}. %% setting the server's internal state to down

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling cast messages
%%
%% @end
%%--------------------------------------------------------------------
-spec handle_cast(Msg::term(), State::term()) -> {noreply, term()} |
                                  {noreply, term(), integer()} |
                                  {stop, term(), term()}.

handle_cast({updating_location, Data}, Pid) -> 
    data_service:update_location(Data, Pid),
    {noreply, Pid};

handle_cast(_Msg, State) ->
    {noreply, State}.


    
%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling all non call/cast messages
%%
%% @end
-spec handle_info(Info::term(), State::term()) -> {noreply, term()} |
                                   {noreply, term(), integer()} |
                                   {stop, term(), term()}.
handle_info(_Info, State) ->
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_server terminates
%% with Reason. The return value is ignored.
%%
%% @end
%%--------------------------------------------------------------------
-spec terminate(Reason::term(), term()) -> term().
terminate(_Reason, _State) ->
    ok.
    
%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%%
%% @end
%%--------------------------------------------------------------------
-spec code_change(term(), term(), term()) -> {ok, term()}.
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
    
%%%===================================================================
%%% Internal functions
%%%===================================================================



-ifdef(EUNIT).
%%
%% Unit tests go here. 
%%
-include_lib("eunit/include/eunit.hrl").


tpf_test_() ->
    {setup,
     fun() -> %this setup fun is run once befor the tests are run. If you want setup and teardown to run for each test, change {setup to {foreach
        meck:new(data_service),
        % meck:expect(data_service, store_package, fun("",Pid) -> {fail, empty_key} end),
        meck:expect(data_service, store_package, fun(Package_id, Location_id, some_Db_PID) when is_list(Package_id), is_list(Location_id), length(Package_id) >= 36 -> worked;
                                                    (Package_id, Location_id, some_Db_PID) when is_list(Package_id), is_list(Location_id)->{fail, package_isnt_UUID};
                                                    (_, _, some_Db_PID)->{fail, isnt_string};
                                                    (_, _, _)->{fail, no_pid}
                                                     end),
        meck:expect(data_service, update_location, fun(Location_id, Coords_map, Pid) -> worked end),
        meck:expect(data_service, get_location, fun(Package_id, Pid) -> worked end),
        meck:expect(data_service, delivered_package, fun(Package_id, Pid) -> worked end)

        % Mock Logging
        % meck:new(logger),
        % meck:expect(logger, info, fun(Msg) -> io:format("Mocked logger info: ~p~n", [Msg]) end),
        % meck:expect(logger, error, fun(Msg) -> io:format("Mocked logger error: ~p~n", [Msg]) end)
     end,
     fun(_) ->%This is the teardown fun. Notice it takes one, ignored in this example, parameter.
        meck:unload(data_service)
        % meck:unload(logger)
     end,
    [%This is the list of tests to be generated and run.
        ?_assertEqual({reply,worked,some_Db_PID},                   % Putting package in facility
                            tpf_mock:handle_call({storing_package, "5d5ced29-c984-4d9d-9a0d-b77d4f53210b", "Warehouse13"}, some_from_pid, some_Db_PID)
                            ),
                            
        ?_assertEqual({reply,{fail,empty_key},some_Db_PID},         % Fail (empty_package) test
                            tpf_mock:handle_call({storing_package, "", "Warehouse11"}, some_from_pid, some_Db_PID)
                            ),

        ?_assertEqual({reply,{fail,empty_key},some_Db_PID},         % Fail (empty_location) test
                            tpf_mock:handle_call({storing_package, "5d5ced29-c984-4d9d-9a0d-b77d4f53210b", ""}, some_from_pid, some_Db_PID)
                            ),

        ?_assertEqual({reply,{fail,package_isnt_UUID},some_Db_PID}, % Fail (package_isnt_UUID) test
                            tpf_mock:handle_call({storing_package, "non-UUID package", "Warehouse47"}, some_from_pid, some_Db_PID)
                            ),
        
        ?_assertEqual({reply,{fail,isnt_string},some_Db_PID},       % Fail (isnt_string) test
                            tpf_mock:handle_call({storing_package, 4, 7}, some_from_pid, some_Db_PID)
                            ),
        
        ?_assertEqual({reply,{fail,no_pid},1234},                   % Fail (no_pid) test
                            tpf_mock:handle_call({storing_package, "5d5ced29-c984-4d9d-9a0d-b77d4f53210b", "Warehouse13"}, some_from_pid, 1234)
                            ),
                            
        ?_assertEqual({reply,worked,some_Db_PID},                   % Delivering package
                            tpf_mock:handle_call({delivering_package, "5d5ced29-c984-4d9d-9a0d-b77d4f53210b"}, some_from_pid, some_Db_PID)
                            ),

        ?_assertEqual({noreply,some_Db_PID},                        % Updating coords of a transit vehicle
                            tpf_mock:handle_cast({updating_location, "Truck2", #{latitude => 40.741895, longitude => -73.989308}}, some_Db_PID)
                            ),

        ?_assertEqual({reply,worked,some_Db_PID},                   % Customer requests package location coords
                            tpf_mock:handle_call({getting_location, "5d5ced29-c984-4d9d-9a0d-b77d4f53210b"}, some_from_pid, some_Db_PID)
                            )
                                                    
    ]}.
    
-endif.
