% Mocking our logging system
-module(logger).
-export([log/1]).


log(Msg) ->
    io:format(Msg).