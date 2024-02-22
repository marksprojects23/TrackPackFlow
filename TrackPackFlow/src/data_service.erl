-module(data_service).

-export([store_package/3, update_location/3, get_location/2]).


store_package(string(Package_id), Pid) ->
    Object = riakc_obj:new(<<"packages">>, list_to_binary(Package_id), 0),
    riack_pb_socket:put(Pid, Object).
store_package(PackageLocation_map, Pid) ->
    Package_id = maps:get("Package_id",PackageLocation_map),
    Location_id = maps:get("Location_id",PackageLocation_map),
    Object = riakc_obj:new(<<"packages">>, list_to_binary(Package_id), list_to_binary(Location_id)),
    riack_pb_socket:put(Pid, Object);


update_location(LocationCoord_map, Pid) ->
    {Location_id,Coords} = maps:take("Location_id", LocationCoord_map),
    Object = riakc_obj:new(<<"locations">>, list_to_binary(Location_id), term_to_binary(Coords)),
    riak_pb_socket:put(Pid, Object).


get_location(Package_id, Pid) ->
    {ok, Package_object} = riakc_pb_socket:get(Pid, <<"packages">>, list_to_binary(Package_id)),
    Location_id_binary = riakc_obj:get_value(Package_object),
    {ok, Location_object} = riakc_pb_socket:get(Pid, <<"locations">>, Location_id_binary),
    binary_to_term(riakc_obj:get_value(Location_object)).
