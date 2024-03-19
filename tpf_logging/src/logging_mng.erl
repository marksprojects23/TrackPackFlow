-module(logging_mng).
-behaviour(gen_event).

%% External exports
-export([init/1, handle_event/2, handle_call/3, handle_info/2, terminate/2, code_change/3]).

%% Initialization function for the event manager
init([]) ->
    {ok, []}.

%% Handling events
handle_event(Event, State) ->
    %% For demonstration: Printing the received event
    io:format("Received event: ~p~n", [Event]),
    {ok, State}.

%% Handling calls
handle_call(_Request, _From, State) ->
    {ok, State}.

%% Handling general info
handle_info(_Info, State) ->
    {ok, State}.

%% Cleanup on termination
terminate(_Reason, _State) ->
    ok.

%% Code change handling
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
