% Mocking our logging system
-module(tpf_logger).
-export([tpf_log/1]).


tpf_log(Msg) ->
    io:format(Msg).