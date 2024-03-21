-module(data_service).

-export([store_package/3, update_location/3, get_location/2, delivered_package/2]).

store_package(Package_id, Location_id, Pid) when length(Package_id) >= 36->
    % Package_id = maps:get("Package_id",PackageLocation_map),
    % Location_id = maps:get("Location_id",PackageLocation_map),
    Object = riakc_obj:new(<<"packages">>, Package_id, Location_id),
    riakc_pb_socket:put(Pid, Object);
% store_package(Package_id, Pid) when is_list(Package_id), is_pid(Pid), length(Package_id) >= 36->
%     Object = riakc_obj:new(<<"packages">>, list_to_binary(Package_id), 0),
%     riakc_pb_socket:put(Pid, Object);
store_package("", _,  Pid) when is_pid(Pid)->
    {fail,empty_package};
store_package(_, "", Pid) when is_pid(Pid)->
    {fail, empty_location};
store_package(Package_id, _, Pid) when is_pid(Pid), is_list(Package_id), length(Package_id) < 36->
     {fail, package_isnt_UUID};
% store_package(_, _, Pid) when is_pid(Pid)->
%     {fail, isnt_string};
store_package(_, _, _Pid)->
    io:format("{fail, no_pid}~n"),
    {fail, no_pid}.


delivered_package("", Pid) when is_pid(Pid)->
    {fail,empty_package};
delivered_package(Package_id, Pid) when is_pid(Pid), is_list(Package_id), length(Package_id) < 36->
     {fail, package_isnt_UUID};
delivered_package(_, Pid) when is_pid(Pid)->
    {fail, isnt_string};
delivered_package(_, _Pid)->
    {fail, no_pid};
delivered_package(Package_id, Pid) ->
    store_package(Package_id, 0, Pid).

% If the location ID is an empty string, return a failure tuple indicating that the location is empty.
update_location("", _, Pid) when is_pid(Pid)->
    {fail,empty_location};
% If the coordinates map is an empty string, return a failure tuple indicating that the coordinates map is empty.
update_location(_, "", Pid) when is_pid(Pid)->
    {fail, empty_coords_map};
% If the location ID is a list and its length is less than 36 (not a UUID), return a failure tuple indicating that the location ID isn't a UUID.
update_location(Location_id, _, Pid) when is_pid(Pid), is_list(Location_id), length(Location_id) < 36->
     {fail, location_isnt_UUID};

% If the location ID or coordinates map is not a string, return a failure tuple indicating that the input isn't a string.
update_location(_, _, Pid) when is_pid(Pid)->
    {fail, isnt_string};
% If the process ID is not a pid, return a failure tuple indicating that there's no process ID.
update_location(_, _, _Pid)->
    {fail, no_pid};
    
% If all checks pass, create a new object with the location ID and coordinates map, and put it in the database.
update_location(Location_id, Coords_map, Pid) ->
    % {Location_id,Coords} = maps:take("Location_id", LocationCoord_map),
    Object = riakc_obj:new(<<"locations">>, list_to_binary(Location_id), term_to_binary(Coords_map)),
    riakc_pb_socket:put(Pid, Object).

get_location("", Pid) when is_pid(Pid)->
    {fail,empty_package};
get_location(Package_id, Pid) when is_pid(Pid), is_list(Package_id), length(Package_id) < 36->
     {fail, package_isnt_UUID};
get_location(_, Pid) when is_pid(Pid)->
    {fail, isnt_string};
get_location(_, _Pid)->
    {fail, no_pid};
get_location(Package_id, Pid) ->
    {ok, Package_object} = riakc_pb_socket:get(Pid, <<"packages">>, list_to_binary(Package_id)),
    Location_id_binary = riakc_obj:get_value(Package_object),
    {ok, Location_object} = riakc_pb_socket:get(Pid, <<"locations">>, Location_id_binary),
    binary_to_term(riakc_obj:get_value(Location_object)).
