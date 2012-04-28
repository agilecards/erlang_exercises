-module(read_card).

-export([init/0]).

init() ->
  Pid = serial:start([{open,"/dev/ttyUSB0"}, {speed,9600}]),
  loop(Pid,[]).

loop(Pid,Input) ->
  receive
    {data,<<"\n">>} ->
      Finalinput = lists:reverse(Input),
      S = re:split(Finalinput,
"(T|DT|ST):(ACK|NACK)\s([0-9 ]*)",
[{return,list}]),
      io:format("~s~n",[lists:reverse(Input)]),
      io:format("~p~n",[S]),
      loop(Pid,[]);

    {data, N} when is_binary(N) ->
      Newinput = [binary_to_list(N)|Input],
      loop(Pid,Newinput);

    Error ->
      io:format("error:~p~n",[Error])
  end.

