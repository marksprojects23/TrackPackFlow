-module(data_service).

-export([store_package/3, update_location/3, get_location/2, delivered_package/2]).

store_package(Package_id, Location_id, RiakPid)->
    % Package_id = maps:get("Package_id",PackageLocation_map),
    % Location_id = maps:get("Location_id",PackageLocation_map),
    Object = riakc_obj:new(<<"packages">>, Package_id, Location_id),
    riakc_pb_socket:put(RiakPid, Object).

% store_package(Package_id, Pid) when is_list(Package_id), is_pid(Pid), length(Package_id) >= 36->
%     Object = riakc_obj:new(<<"packages">>, list_to_binary(Package_id), 0),
%     riakc_pb_socket:put(Pid, Object);
% store_package("", _,  Pid) when is_pid(Pid)->
%     {fail,empty_package};
% store_package(_, "", Pid) when is_pid(Pid)->
%     {fail, empty_location};
% store_package(Package_id, _, Pid) when is_pid(Pid), is_list(Package_id), length(Package_id) < 36->
%     {fail, package_isnt_UUID};
% % store_package(_, _, Pid) when is_pid(Pid)->
% %     {fail, isnt_string};
% store_package(_, _, _Pid)->
%     io:format("{fail, no_pid}~n"),
%     {fail, no_pid}.

delivered_package(Package_id, RiakPid) ->
    store_package(Package_id, <<"delivered">>, RiakPid).
    
update_location(Location_id, Coords_map, Pid) ->
    % {Location_id,Coords} = maps:take("Location_id", LocationCoord_map),
    % Object = riakc_obj:new(<<"locations">>, list_to_binary(Location_id), term_to_binary(Coords_map)),
    % riakc_pb_socket:put(Pid, Object).
    Object = riakc_obj:new(<<"locations">>, Location_id, Coords_map),
    % {ok, RiakPid} = riakc_pb_socket:start_link("riak01.tpf.markcuizon.com", 8087),
    riakc_pb_socket:put(Pid, Object).

get_location(Package_id, RiakPid) ->
    % {ok, Package_object} = riakc_pb_socket:get(Pid, <<"packages">>, list_to_binary(Package_id)),
    % Location_id_binary = riakc_obj:get_value(Package_object),
    % {ok, Location_object} = riakc_pb_socket:get(Pid, <<"locations">>, Location_id_binary),
    % binary_to_term(riakc_obj:get_value(Location_object)).
    % {ok, {_Atom, _Bucket, _Key, _SomeBinary, [{_Tuple, Location_id}], _Atom1, _Atom2}} = riakc_pb_socket:get(Pid, <<"packages">>, Package_id),
    % {ok, {_Atom3, _Bucket1, _Key1, _SomeBinary1, [{_Tuple1, Coords_map}], _Atom4, _Atom5}} = riakc_pb_socket:get(Pid, <<"locations">>, Location_id),
    % {ok, Pid} = riakc_pb_socket:start_link("riak01.tpf.markcuizon.com", 8087)
    {ok, Package} = riakc_pb_socket:get(RiakPid, <<"packages">>, Package_id),
    
    % case riakc_obj:get_value(Package) == <<0>> of
    %     false->{ok, Location} = riakc_pb_socket:get(Pid, <<"locations">>, riakc_obj:get_value(Package)),
    %     % io:format(riakc_obj:get_value(Location)),
    %     riakc_obj:get_value(Location);  % Implementation according to Diego
    %     true-><<"it's delivered">>
    % end.

    case riakc_obj:get_value(Package) of
        <<"delivered">> -> <<"{lat: 0, long: 0}">>;
        Location_id -> 
            {ok, Location} = riakc_pb_socket:get(RiakPid, <<"locations">>, Location_id),
            riakc_obj:get_value(Location)
        end.
        
    
    % {ok, Location} = riakc_pb_socket:get(Pid, <<"locations">>, riakc_obj:get_value(Package)),
    % riakc_obj:get_value(Location).      % Implementation according to Diego

    % {ok,{riakc_obj,<<"packages">>, <<"3a8b10bb-60f7-4d44-a324-802eb58e6da7">>, <<107,206,97,96,96,96,204,96,202,5,82,60,127,24,188,46,177,107,73,200,64,132,18,...>>,
    % [{{dict,2,16,16,8,80,48, {[],[],[],[],[],[],[],[],[],[],[],[],...}, {{[],[],[],[],[],[],[],[],[],[],...}}}, <<"7af55153-9549-4064-a199-0d50084429a7">>}],
    % undefined,undefined}}
