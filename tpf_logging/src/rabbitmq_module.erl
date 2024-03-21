
-module(rabbitmq_module).
-export([start_link/0, send_message/1]).
-include_lib("amqp_client/include/amqp_client.hrl").


%% Starting the RabbitMQ module
start_link() ->
    %% Start your RabbitMQ connection
    rabbitmq_connection:start_link(),
    {ok, Pid} = gen_server:start_link({local, ?MODULE}, ?MODULE, [], []),
    Pid.

%% Sending a message to RabbitMQ
send_message(Message) ->
    gen_server:call(?MODULE, {send_message, Message}).

%% Initialization function for RabbitMQ module
% init([]) ->
%     %% Establish connection and channel
%     {ok, Connection} = amqp_connection:start(#amqp_params_network{host = "localhost", username = "trackpackflow", password = "cse481Barney"}),
%     {ok, Channel} = amqp_connection:open_channel(Connection),
%     %% Declare the queue
%     amqp_channel:call(Channel, #'queue.declare'{queue = <<"trackpackflow">>}),
%     {ok, #state{channel = Channel}}.

% %% Handling the message sending request
% handle_call({send_message, Message}, _From, State) ->
%     %% Publish the message to RabbitMQ
%     amqp_channel:call(State#state.channel, #'basic.publish'{exchange = <<"">>, routing_key = <<"trackpackflow">>}, #amqp_msg{payload = Message}),
%     {reply, ok, State}.

% %% Cleanup on termination
% terminate(_Reason, _State) ->
%     ok.
