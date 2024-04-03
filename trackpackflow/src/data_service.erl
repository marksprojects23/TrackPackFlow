-module(data_service).

-export([store_package/3, update_location/3, get_location/2, delivered_package/2]).

store_package(Package_id, Location_id, RiakPid)->
    Object = riakc_obj:new(<<"packages">>, Package_id, Location_id),
    case riakc_pb_socket:get(RiakPid, <<"locations">>, Location_id) of
        {ok, _}->
            riakc_pb_socket:put(RiakPid, Object);
        _->
            Object2 = riakc_obj:new(<<"locations">>, Location_id, <<"No coords yet">>),
            riakc_pb_socket:put(RiakPid, Object2),
            riakc_pb_socket:put(RiakPid, Object)
    end.


delivered_package(Package_id, RiakPid) ->
    store_package(Package_id, <<"delivered">>, RiakPid).
    
update_location(Location_id, Coords_map, Pid) ->
    Object = riakc_obj:new(<<"locations">>, Location_id, Coords_map),
    
    riakc_pb_socket:put(Pid, Object).

get_location(Package_id, RiakPid) ->
    case riakc_pb_socket:get(RiakPid, <<"packages">>, Package_id) of
        {error,notfound}->
            <<"Package doesn't exist yet.">>;
        {ok, Package}->

    case riakc_obj:get_value(Package) of
        <<"delivered">> -> <<"{'location_id': 'delivered', 'lat': 0, 'long': 0}">>;
        Location_id -> 
            {ok, Location} = riakc_pb_socket:get(RiakPid, <<"locations">>, Location_id),
            riakc_obj:get_value(Location)
    end
    end.
        
